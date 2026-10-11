# Reachead PHP and Laravel SDK

The official Laravel mail transport and PHP client for the Reachead Developer API. The package auto-discovers its service provider, adds the `reachead` mailer to Laravel at runtime, validates messages before sending, and turns API failures into typed exceptions. The transport preserves Laravel's sender display name and HTML/text alternatives; attachments and CID inline images are supported.

## Install

Reachead hosts a Composer repository with the SDK release:

```bash
composer config repositories.reachead composer https://reachead.com/composer
composer require reachead/laravel-sdk:^1.5
```

## Laravel mail transport

Choose any one of the configuration approaches below. Your existing `MAIL_FROM_ADDRESS` must be an active sending address in Reachead.

### Configure in `config/mail.php`

The transport reads its API key and related options directly from the selected Laravel mailer:

```php
'default' => env('MAIL_MAILER', 'reachead'),

'mailers' => [
    // ...
    'reachead' => [
        'transport' => 'reachead',
        'key' => env('REACHEAD_API_KEY'),
        'base_url' => 'https://api.reachead.com', // optional
        'timeout' => 15,                          // optional
        'connect_timeout' => 5,                   // optional
    ],
],
```

`api_key` is also accepted as an alias for `key`. The key value can come from any Laravel configuration source, but do not commit a live API key to source control.

### Configure in published `config/reachead.php`

Publish the package configuration:

```bash
php artisan vendor:publish --tag=reachead-config
```

Then configure it directly:

```php
return [
    'api_key' => env('REACHEAD_API_KEY'),
    'base_url' => 'https://api.reachead.com',
    'timeout' => 15,
    'connect_timeout' => 5,
];
```

The package automatically adds the `reachead` mailer when no entry exists in `config/mail.php`.

### Minimal environment configuration

The original automatic setup remains supported:

```dotenv
MAIL_MAILER=reachead
REACHEAD_API_KEY=rhk_your_api_key
```

`Mail`, mailables, queued mail, and mail notifications then use Reachead normally:

```php
use Illuminate\Support\Facades\Mail;

Mail::to('customer@example.com')->send(new OrderReceipt($order));
```

Laravel attachments work with the normal mailable API and are encoded automatically:

```php
use Illuminate\Mail\Mailables\Attachment;

public function attachments(): array
{
    return [
        Attachment::fromPath(storage_path('app/invoices/receipt.pdf'))
            ->as('receipt.pdf')
            ->withMime('application/pdf'),
    ];
}
```

Images embedded from a Blade mail view are sent as CID inline attachments:

```blade
<img src="{{ $message->embed(public_path('images/logo.png')) }}" alt="Company logo">
```

Configuration precedence is: selected `mail.mailers.reachead` values first, followed by `config/reachead.php`, followed by SDK defaults. This applies to `key`/`api_key`, `base_url`, `timeout`, and `connect_timeout`.

## Direct SDK client

The facade remains available when you want to call the Reachead client directly instead of using Laravel's mailables:

```php
use Reachead\Laravel\Facades\Reachead;

$result = Reachead::send([
    'from' => 'hello@yourdomain.com',
    'from_name' => 'Your Company',
    'to' => 'customer@example.com',
    'subject' => 'Your receipt',
    'html' => '<p>Thanks for your order.</p>',
    'text' => 'Thanks for your order.',
    'idempotency_key' => 'receipt-order-123',
    'attachments' => [[
        'filename' => 'receipt.pdf',
        'content' => base64_encode(file_get_contents($receiptPath)),
        'content_type' => 'application/pdf',
    ]],
]);

echo $result->id;
```

Dependency injection works as well:

```php
use Reachead\Laravel\EmailMessage;
use Reachead\Laravel\ReacheadClient;

final class SendReceipt
{
    public function __construct(private ReacheadClient $reachead)
    {
    }

    public function __invoke(): string
    {
        return $this->reachead->send(new EmailMessage(
            from: 'hello@yourdomain.com',
            to: 'customer@example.com',
            subject: 'Your receipt',
            html: '<p>Thanks for your order.</p>',
        ))->id;
    }
}
```

## Plain PHP

The same package can be used outside a Laravel application:

```php
use Reachead\Laravel\ReacheadClient;

$client = ReacheadClient::make('rhk_your_api_key');
$result = $client->send([
    'from' => 'hello@yourdomain.com',
    'to' => 'customer@example.com',
    'subject' => 'Your receipt',
    'html' => '<p>Thanks for your order.</p>',
]);
```

## Error handling

```php
use Reachead\Laravel\Exceptions\AuthenticationException;
use Reachead\Laravel\Exceptions\RateLimitException;
use Reachead\Laravel\Exceptions\ReacheadException;

try {
    $result = Reachead::send($message);
} catch (RateLimitException $exception) {
    $retryAfter = $exception->retryAfterSeconds;
} catch (AuthenticationException $exception) {
    // The API key is missing, invalid, or revoked.
} catch (ReacheadException $exception) {
    report($exception);
}
```

The SDK maps API responses to `AuthenticationException` (401), `PermissionException` (403), `ValidationException` (400/422), `RateLimitException` (429), and `ServerException` (5xx). Connection failures throw `TransportException`.

The SDK does not automatically retry email sends. Set `idempotency_key` to a stable value for one logical message before retrying a failed connection; the SDK sends it as the `Idempotency-Key` header. The same key and request return the same Reachead message ID; a different request with the same key returns 409. A successful response means accepted by the sending provider, not delivered.

The sender must remain a verified address. Optional `from_name` overrides the portal label for that address; when omitted, the portal label is used. Laravel's `Address` display name is forwarded as `from_name`. HTML and text are passed separately as MIME alternatives; provide a readable `text` body for clients that do not display HTML. The `id` response field remains the provider ID on successful sends; `message_id` is the stable Reachead tracking ID. Query `GET https://api.reachead.com/v1/email/messages/{message_id}` with a Bearer API key to reconcile queued, sent, delivered, deferred, bounced, complained, and failed statuses. Provider webhooks update this record; your application polls this endpoint rather than receiving callbacks from Reachead.

## Configuration reference

| Laravel config key | Default | Purpose |
| --- | --- | --- |
| `mail.default` | application's current mailer | Set to `reachead` to select the transport |
| `mail.mailers.reachead.key` | `reachead.api_key` | API key created in the Reachead portal |
| `mail.mailers.reachead.api_key` | `reachead.api_key` | Alias for `key` |
| `mail.mailers.reachead.base_url` | `reachead.base_url` | Override for local or private environments |
| `mail.mailers.reachead.timeout` | `reachead.timeout`, then `15` | Total request timeout in seconds |
| `mail.mailers.reachead.connect_timeout` | `reachead.connect_timeout`, then `5` | Connection timeout in seconds |

`from` must be an active sending address on the Reachead account. Each call sends to one recipient and counts against the account's normal Developer API quota.

The automatic mail transport sends every Laravel envelope recipient through one API call, converting plain-text-only messages to safe HTML when needed. Laravel `attach()`, `attachData()`, mailable attachments, and Blade `$message->embed()` images are supported. Attachments are limited to 40 MB total per email. Executable and script file types are rejected by the API; CID inline content must be a safe image type.

The legacy `https://reachead.com/api/v1/email/send` endpoint remains active for existing integrations. New integrations and the default SDK configuration use `https://api.reachead.com/v1/email/send`.

## Development

```bash
composer install
composer test
composer validate --strict
```
