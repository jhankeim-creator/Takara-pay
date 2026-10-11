<?php

declare(strict_types=1);

return [
    'api_key' => env('REACHEAD_API_KEY'),

    'base_url' => env('REACHEAD_BASE_URL', 'https://api.reachead.com'),

    'timeout' => (int) env('REACHEAD_TIMEOUT', 15),

    'connect_timeout' => (int) env('REACHEAD_CONNECT_TIMEOUT', 5),
];
