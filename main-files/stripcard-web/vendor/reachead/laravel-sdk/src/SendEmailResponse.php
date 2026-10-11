<?php

declare(strict_types=1);

namespace Reachead\Laravel;

final class SendEmailResponse
{
    public function __construct(
        public readonly string $id,
        public readonly ?string $messageId = null,
        public readonly ?string $status = null,
    )
    {
    }

    /** @return array{id: string, message_id?: string, status?: string} */
    public function toArray(): array
    {
        return array_filter([
            'id' => $this->id,
            'message_id' => $this->messageId,
            'status' => $this->status,
        ], static fn ($value) => $value !== null);
    }
}
