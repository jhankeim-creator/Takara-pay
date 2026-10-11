<?php

declare(strict_types=1);

namespace Reachead\Laravel\Laravel;

use Illuminate\Http\Client\Factory;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\ServiceProvider;
use InvalidArgumentException;
use Reachead\Laravel\ReacheadClient;
use Reachead\Laravel\Transport\ReacheadTransport;

final class ReacheadServiceProvider extends ServiceProvider
{
    public function register(): void
    {
        $configPath = dirname(__DIR__, 2).'/config/reachead.php';
        $this->mergeConfigFrom($configPath, 'reachead');

        // Register the mailer definition in memory so applications only need
        // MAIL_MAILER=reachead. Existing application overrides are preserved.
        $mailConfig = $this->app['config'];
        $existingMailer = $mailConfig->get('mail.mailers.reachead', []);
        $existingMailer = is_array($existingMailer) ? $existingMailer : [];
        $mailConfig->set('mail.mailers.reachead', array_replace(
            ['transport' => 'reachead'],
            $existingMailer,
        ));

        $this->app->singleton(ReacheadClient::class, function ($app): ReacheadClient {
            $mailerConfig = $app['config']->get('mail.mailers.reachead', []);

            return $this->makeClient(is_array($mailerConfig) ? $mailerConfig : []);
        });

        $this->app->alias(ReacheadClient::class, 'reachead');
    }

    public function boot(): void
    {
        Mail::extend('reachead', function (array $config = []): ReacheadTransport {
            return new ReacheadTransport($this->makeClient($config));
        });

        $this->publishes([
            dirname(__DIR__, 2).'/config/reachead.php' => config_path('reachead.php'),
        ], 'reachead-config');
    }

    /**
     * Build a client for a specific Laravel mailer. Values declared on the
     * mailer override the package configuration; published config/reachead.php
     * remains the fallback for omitted options and direct client resolution.
     *
     * @param array<string, mixed> $mailerConfig
     */
    private function makeClient(array $mailerConfig = []): ReacheadClient
    {
        $packageConfig = $this->app['config']->get('reachead', []);
        $packageConfig = is_array($packageConfig) ? $packageConfig : [];

        $apiKey = $this->firstNonEmptyString([
            $mailerConfig['key'] ?? null,
            $mailerConfig['api_key'] ?? null,
            $packageConfig['api_key'] ?? null,
            $packageConfig['key'] ?? null,
        ]);

        if ($apiKey === null) {
            throw new InvalidArgumentException(
                'Reachead API key is not configured. Set mail.mailers.reachead.key or reachead.api_key.',
            );
        }

        $baseUrl = $this->firstNonEmptyString([
            $mailerConfig['base_url'] ?? null,
            $packageConfig['base_url'] ?? null,
        ]) ?? ReacheadClient::DEFAULT_BASE_URL;

        return new ReacheadClient(
            $this->app->make(Factory::class),
            $apiKey,
            $baseUrl,
            (int) $this->firstConfiguredValue($mailerConfig, $packageConfig, 'timeout', 15),
            (int) $this->firstConfiguredValue($mailerConfig, $packageConfig, 'connect_timeout', 5),
        );
    }

    /** @param list<mixed> $values */
    private function firstNonEmptyString(array $values): ?string
    {
        foreach ($values as $value) {
            if (is_string($value) && trim($value) !== '') {
                return trim($value);
            }
        }

        return null;
    }

    /**
     * @param array<string, mixed> $mailerConfig
     * @param array<string, mixed> $packageConfig
     */
    private function firstConfiguredValue(
        array $mailerConfig,
        array $packageConfig,
        string $key,
        mixed $default,
    ): mixed {
        if (array_key_exists($key, $mailerConfig) && $mailerConfig[$key] !== null && $mailerConfig[$key] !== '') {
            return $mailerConfig[$key];
        }

        if (array_key_exists($key, $packageConfig) && $packageConfig[$key] !== null && $packageConfig[$key] !== '') {
            return $packageConfig[$key];
        }

        return $default;
    }
}
