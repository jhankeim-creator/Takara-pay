<?php

declare(strict_types=1);

namespace Reachead\Laravel;

use Illuminate\Http\Client\ConnectionException;
use Illuminate\Http\Client\Factory;
use Illuminate\Http\Client\Response;
use InvalidArgumentException;
use Reachead\Laravel\Exceptions\ApiException;
use Reachead\Laravel\Exceptions\AuthenticationException;
use Reachead\Laravel\Exceptions\PermissionException;
use Reachead\Laravel\Exceptions\RateLimitException;
use Reachead\Laravel\Exceptions\ServerException;
use Reachead\Laravel\Exceptions\TransportException;
use Reachead\Laravel\Exceptions\UnexpectedResponseException;
use Reachead\Laravel\Exceptions\ValidationException;

final class ReacheadClient
{
    public const VERSION = '1.5.0';
    public const DEFAULT_BASE_URL = 'https://api.reachead.com';

    public function __construct(
        private readonly Factory $http,
        private readonly string $apiKey,
        private readonly string $baseUrl = self::DEFAULT_BASE_URL,
        private readonly int $timeout = 15,
        private readonly int $connectTimeout = 5,
    ) {
        if (!str_starts_with($apiKey, 'rhk_')) {
            throw new InvalidArgumentException('A valid Reachead API key is required.');
        }

        if (!filter_var($baseUrl, FILTER_VALIDATE_URL)) {
            throw new InvalidArgumentException('A valid Reachead base URL is required.');
        }

        if ($timeout < 1 || $connectTimeout < 1) {
            throw new InvalidArgumentException('HTTP timeouts must be positive integers.');
        }
    }

    public static function make(
        string $apiKey,
        string $baseUrl = self::DEFAULT_BASE_URL,
        int $timeout = 15,
        int $connectTimeout = 5,
    ): self {
        return new self(new Factory(), $apiKey, $baseUrl, $timeout, $connectTimeout);
    }

    /**
     * Send one transactional email.
     *
     * @param EmailMessage|array{from?: mixed, to?: mixed, subject?: mixed, html?: mixed, text?: mixed, attachments?: mixed} $message
     */
    public function send(EmailMessage|array $message): SendEmailResponse
    {
        return $this->sendEmail($message);
    }

    /**
     * @param EmailMessage|array{from?: mixed, to?: mixed, subject?: mixed, html?: mixed, text?: mixed, attachments?: mixed} $message
     */
    public function sendEmail(EmailMessage|array $message): SendEmailResponse
    {
        $email = is_array($message) ? EmailMessage::fromArray($message) : $message;

        try {
            $response = $this->http
                ->acceptJson()
                ->asJson()
                ->withToken($this->apiKey)
                ->withHeaders(array_filter([
                    'User-Agent' => 'reachead-laravel/'.self::VERSION,
                    'Idempotency-Key' => $email->idempotencyKey,
                ], static fn ($value) => $value !== null))
                ->timeout($this->timeout)
                ->connectTimeout($this->connectTimeout)
                ->post($this->sendEmailUrl(), $email->toArray());
        } catch (ConnectionException $exception) {
            throw new TransportException(
                'Could not connect to the Reachead API: '.$exception->getMessage(),
                previous: $exception,
            );
        }

        if (!$response->successful()) {
            throw $this->exceptionFor($response);
        }

        $id = $response->json('data.id');
        if (!is_string($id) || $id === '') {
            throw new UnexpectedResponseException('The Reachead API returned a success response without an email id.');
        }

        $messageId = $response->json('data.message_id');
        $status = $response->json('data.status');
        return new SendEmailResponse(
            $id,
            is_string($messageId) && $messageId !== '' ? $messageId : null,
            is_string($status) && $status !== '' ? $status : null,
        );
    }

    private function sendEmailUrl(): string
    {
        $baseUrl = rtrim($this->baseUrl, '/');
        $host = strtolower((string) parse_url($baseUrl, PHP_URL_HOST));
        $path = rtrim((string) parse_url($baseUrl, PHP_URL_PATH), '/');

        if ($path === '/v1' || str_ends_with($path, '/api/v1')) {
            return $baseUrl.'/email/send';
        }

        // The dedicated hostname uses the cleaner /v1 prefix. Custom and
        // local application origins keep the pre-1.2 /api/v1 convention so
        // existing REACHEAD_BASE_URL overrides continue to work unchanged.
        if ($host === 'api.reachead.com') {
            return $baseUrl.'/v1/email/send';
        }

        return $baseUrl.'/api/v1/email/send';
    }

    private function exceptionFor(Response $response): ApiException
    {
        $payload = $response->json();
        $payload = is_array($payload) ? $payload : [];
        $message = isset($payload['error']) && is_string($payload['error'])
            ? $payload['error']
            : sprintf('Reachead API request failed with HTTP %d.', $response->status());
        $retryAfter = $response->header('Retry-After');
        $retryAfterSeconds = is_string($retryAfter) && ctype_digit($retryAfter)
            ? (int) $retryAfter
            : (isset($payload['retryAfterSec']) && is_numeric($payload['retryAfterSec'])
                ? (int) $payload['retryAfterSec']
                : null);

        $arguments = [$message, $response->status(), $payload, $retryAfterSeconds];

        return match (true) {
            $response->status() === 401 => new AuthenticationException(...$arguments),
            $response->status() === 403 => new PermissionException(...$arguments),
            $response->status() === 400, $response->status() === 422 => new ValidationException(...$arguments),
            $response->status() === 429 => new RateLimitException(...$arguments),
            $response->serverError() => new ServerException(...$arguments),
            default => new ApiException(...$arguments),
        };
    }
}
