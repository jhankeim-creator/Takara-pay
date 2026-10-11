<?php

declare(strict_types=1);

namespace Reachead\Laravel\Transport;

use Reachead\Laravel\ReacheadClient;
use Symfony\Component\Mailer\Exception\TransportException;
use Symfony\Component\Mailer\SentMessage;
use Symfony\Component\Mailer\Transport\AbstractTransport;
use Symfony\Component\Mime\Email;
use Symfony\Component\Mime\Message;
use Symfony\Component\Mime\MessageConverter;
use Throwable;

final class ReacheadTransport extends AbstractTransport
{
    public function __construct(private readonly ReacheadClient $client)
    {
        parent::__construct();
    }

    protected function doSend(SentMessage $message): void
    {
        $original = $message->getOriginalMessage();
        if (!$original instanceof Message) {
            throw new TransportException('Reachead can only send MIME email messages.');
        }

        $email = MessageConverter::toEmail($original);

        $from = $email->getFrom()[0] ?? $message->getEnvelope()->getSender();
        $recipients = $message->getEnvelope()->getRecipients();
        $subject = $email->getSubject() ?? '';
        $text = $email->getTextBody();
        $html = $this->htmlBody($email);
        $attachments = $this->attachments($email);
        $emailIds = [];

        foreach ($recipients as $recipient) {
            try {
                $response = $this->client->send([
                    'from' => $from->getAddress(),
                    'from_name' => $from->getName() !== '' ? $from->getName() : null,
                    'to' => $recipient->getAddress(),
                    'subject' => $subject,
                    'html' => $html,
                    'text' => $text,
                    'attachments' => $attachments,
                ]);
            } catch (Throwable $exception) {
                throw new TransportException(sprintf(
                    'Reachead failed to send email to %s: %s',
                    $recipient->getAddress(),
                    $exception->getMessage(),
                ), 0, $exception);
            }

            $emailIds[] = $response->id;
        }

        if ($emailIds !== []) {
            $message->setMessageId($emailIds[0]);
            $message->appendDebug('Reachead email IDs: '.implode(', ', $emailIds));
        }
    }

    public function __toString(): string
    {
        return 'reachead+api';
    }

    /**
     * Convert Symfony attachment parts into the Reachead API payload. Symfony
     * represents embedded images as inline DataPart attachments with a CID,
     * so this supports Laravel attach(), attachData(), and embed() uniformly.
     *
     * @return list<array{filename: string, content: string, content_type: string, content_id?: string}>
     */
    private function attachments(Email $email): array
    {
        $result = [];

        foreach ($email->getAttachments() as $index => $attachment) {
            $body = $attachment->getBody();
            if (!is_string($body)) {
                throw new TransportException(sprintf(
                    'Reachead could not read attachment %d.',
                    $index + 1,
                ));
            }

            $filename = $attachment->getFilename();
            if (!is_string($filename) || trim($filename) === '') {
                $filename = sprintf('attachment-%d.bin', $index + 1);
            }

            $item = [
                'filename' => $filename,
                'content' => base64_encode($body),
                'content_type' => $attachment->getContentType(),
            ];

            if ($attachment->getDisposition() === 'inline' && $attachment->hasContentId()) {
                $item['content_id'] = trim($attachment->getContentId(), '<>');
            }

            $result[] = $item;
        }

        return $result;
    }

    private function htmlBody(Email $email): string
    {
        $html = $email->getHtmlBody();
        if (is_string($html) && trim($html) !== '') {
            return $html;
        }

        $text = $email->getTextBody();
        if (!is_string($text) || trim($text) === '') {
            throw new TransportException('The email must contain an HTML or plain-text body.');
        }

        return nl2br(htmlspecialchars($text, ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8'), false);
    }
}
