<?php

declare(strict_types=1);

namespace Reachead\Laravel\Facades;

use Illuminate\Support\Facades\Facade;
use Reachead\Laravel\EmailMessage;
use Reachead\Laravel\ReacheadClient;
use Reachead\Laravel\SendEmailResponse;

/**
 * @method static SendEmailResponse send(EmailMessage|array $message)
 * @method static SendEmailResponse sendEmail(EmailMessage|array $message)
 *
 * @see ReacheadClient
 */
final class Reachead extends Facade
{
    protected static function getFacadeAccessor(): string
    {
        return ReacheadClient::class;
    }
}
