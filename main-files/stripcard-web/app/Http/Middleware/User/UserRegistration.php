<?php

namespace App\Http\Middleware\User;

use App\Http\Helpers\Response;
use App\Providers\Admin\BasicSettingsProvider;
use Closure;
use Illuminate\Http\Request;

class UserRegistration
{
    /**
     * Handle an incoming request.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \Closure(\Illuminate\Http\Request): (\Illuminate\Http\Response|\Illuminate\Http\RedirectResponse)  $next
     * @return \Illuminate\Http\Response|\Illuminate\Http\RedirectResponse
     */
    public function handle(Request $request, Closure $next)
    {
        $basic_settings = BasicSettingsProvider::get();
        if($basic_settings->user_registration === true) {
            return $next($request);
        }

    }
}
