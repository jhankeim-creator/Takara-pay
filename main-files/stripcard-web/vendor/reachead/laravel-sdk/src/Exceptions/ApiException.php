<?php

declare(strict_types=1);

namespace Reachead\Laravel\Exceptions;

class ApiException extends ReacheadException
{
    /**
     * @param array<string, mixed> $response
     */
    public function __construct(
        string $message,
        public readonly int $statusCode,
        public readonly array $response = [],
        public readonly ?int $retryAfterSeconds = null,
    ) {
        parent::__construct($message, $statusCode);
    }
}
