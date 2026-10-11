<?php

declare(strict_types=1);

namespace Reachead\Laravel;

use InvalidArgumentException;

final class EmailMessage
{
    public function __construct(
        public readonly string $from,
        public readonly string $to,
        public readonly string $subject,
        public readonly string $html,
        public readonly ?string $text = null,
        /** @var list<array{filename: string, content: string, content_type?: string, content_id?: string}> */
        public readonly array $attachments = [],
        public readonly ?string $fromName = null,
        public readonly ?string $idempotencyKey = null,
    ) {
        self::assertEmail($from, 'from');
        self::assertEmail($to, 'to');

        if (trim($subject) === '') {
            throw new InvalidArgumentException('subject is required.');
        }

        if (trim($html) === '') {
            throw new InvalidArgumentException('html is required.');
        }

        self::assertAttachments($attachments);
        if ($fromName !== null && (preg_match_all('/./us', $fromName) > 120 || preg_match('/[\x00-\x1f\x7f-\x9f\x{2028}\x{2029}]/u', $fromName))) {
            throw new InvalidArgumentException('from_name must be at most 120 characters with no control characters.');
        }
        if ($idempotencyKey !== null && !preg_match('/^[\x21-\x7e]{1,200}$/', $idempotencyKey)) {
            throw new InvalidArgumentException('idempotency_key must contain 1-200 visible ASCII characters.');
        }
    }

    /**
     * @param array{from?: mixed, to?: mixed, subject?: mixed, html?: mixed, text?: mixed, attachments?: mixed} $data
     */
    public static function fromArray(array $data): self
    {
        foreach (['from', 'to', 'subject', 'html'] as $field) {
            if (!isset($data[$field]) || !is_string($data[$field])) {
                throw new InvalidArgumentException(sprintf('%s is required and must be a string.', $field));
            }
        }

        if (isset($data['text']) && !is_string($data['text'])) {
            throw new InvalidArgumentException('text must be a string when provided.');
        }
        if (isset($data['from_name']) && !is_string($data['from_name'])) {
            throw new InvalidArgumentException('from_name must be a string when provided.');
        }
        if (isset($data['idempotency_key']) && !is_string($data['idempotency_key'])) {
            throw new InvalidArgumentException('idempotency_key must be a string when provided.');
        }

        if (isset($data['attachments']) && !is_array($data['attachments'])) {
            throw new InvalidArgumentException('attachments must be an array when provided.');
        }

        return new self(
            trim($data['from']),
            trim($data['to']),
            trim($data['subject']),
            $data['html'],
            isset($data['text']) ? $data['text'] : null,
            isset($data['attachments']) ? array_values($data['attachments']) : [],
            $data['from_name'] ?? null,
            $data['idempotency_key'] ?? null,
        );
    }

    /**
     * @return array{from: string, to: string, subject: string, html: string, text?: string, attachments?: list<array{filename: string, content: string, content_type?: string, content_id?: string}>}
     */
    public function toArray(): array
    {
        $payload = [
            'from' => $this->from,
            'to' => $this->to,
            'subject' => $this->subject,
            'html' => $this->html,
        ];

        if ($this->text !== null) {
            $payload['text'] = $this->text;
        }
        if ($this->fromName !== null) {
            $payload['from_name'] = $this->fromName;
        }

        if ($this->attachments !== []) {
            $payload['attachments'] = $this->attachments;
        }

        return $payload;
    }

    private static function assertEmail(string $value, string $field): void
    {
        if (!preg_match('/^[^\s@]+@[^\s@]+\.[^\s@]+$/', $value)) {
            throw new InvalidArgumentException(sprintf('%s must be a valid email address.', $field));
        }
    }

    /**
     * @param array<mixed> $attachments
     */
    private static function assertAttachments(array $attachments): void
    {
        foreach ($attachments as $index => $attachment) {
            $label = sprintf('attachments.%d', $index);
            if (!is_array($attachment)) {
                throw new InvalidArgumentException($label.' must be an array.');
            }

            foreach (['filename', 'content'] as $field) {
                if (!isset($attachment[$field]) || !is_string($attachment[$field]) || trim($attachment[$field]) === '') {
                    throw new InvalidArgumentException(sprintf('%s.%s is required and must be a non-empty string.', $label, $field));
                }
            }

            if (base64_decode($attachment['content'], true) === false) {
                throw new InvalidArgumentException($label.'.content must be valid base64.');
            }

            foreach (['content_type', 'content_id'] as $field) {
                if (isset($attachment[$field]) && (!is_string($attachment[$field]) || trim($attachment[$field]) === '')) {
                    throw new InvalidArgumentException(sprintf('%s.%s must be a non-empty string when provided.', $label, $field));
                }
            }

            if (isset($attachment['content_id']) && strlen($attachment['content_id']) > 127) {
                throw new InvalidArgumentException($label.'.content_id must be fewer than 128 characters.');
            }
        }
    }
}
