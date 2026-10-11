<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Admin\BasicSettings;
use App\Notifications\Admin\SendTestMail;
use Exception;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Notification;

class SetupEmailController extends Controller
{

    /**
     * Displpay The Email Configuration Page
     *
     * @return view
     */
    public function configuration() {
        $page_title = __("Email Method");
        $email_config = BasicSettings::first()->mail_config;
        return view('admin.sections.setup-email.config',compact(
            'page_title',
            'email_config',
        ));
    }


    /**
     * Display The Email Default Template Page
     *
     * @return view
     */
    public function defaultTemplate() {
        $page_title = __("Default Template");
        return view('admin.sections.setup-email.default-template',compact(
            'page_title',
        ));
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request)
    {

        $validator = Validator::make($request->all(),[
            'method'                => 'required|string|in:smtp,reachead|max:20',
            'host'                  => 'required_if:method,smtp|nullable|string|max:255',
            'port'                  => 'required_if:method,smtp|nullable|numeric',
            'encryption'            => 'required_if:method,smtp|nullable|string|in:ssl,tls,auto|max:15',
            'username'              => 'required_if:method,smtp|nullable|string|max:60',
            'from_address'          => 'required_if:method,smtp|nullable|string|max:100',
            'password'              => 'required_if:method,smtp|nullable|string|max:60',

            'reachead_from_address' => 'required_if:method,reachead|nullable|string|max:250',
            'reachead_api_key'      => 'required_if:method,reachead|nullable|string|max:250',
        ]);

        $validated = $validator->validate();

        $basic_settings = BasicSettings::first();
        if(!$basic_settings) {
            return back()->with(['error' => [__("Basic settings not found!")]]);
        }

        // Make object of email template
        if($validated['method'] == 'reachead') {
            $data = [
                'method'            => $validated['method'],
                'from_address'      => $validated['reachead_from_address'] ?? false,
                'api_key'           => $validated['reachead_api_key'] ?? false,
                'app_name'          => $basic_settings['site_name'] ?? config('app.name'),
            ];
        }else {
            $data = [
                'method'            => $validated['method'],
                'host'              => $validated['host'] ?? false,
                'port'              => $validated['port'] ?? false,
                'encryption'        => $validated['encryption'] ?? false,
                'username'          => $validated['username'] ?? false,
                'password'          => $validated['password'] ?? false,
                'from_address'      => $validated['from_address'] ?? false,
                'app_name'          => $basic_settings['site_name'] ?? config('app.name'),
            ];
        }

        try{
            $basic_settings->update([
                'mail_config'       => $data,
            ]);
        }catch(Exception $e) {
            return back()->with(['error' => [__("Something went wrong! Please try again")]]);
        }

        $env_modify_keys = [
            "MAIL_MAILER"       => $data['method'],
            "MAIL_HOST"         => $data['host'] ?? '',
            "MAIL_PORT"         => $data['port'] ?? '',
            "MAIL_USERNAME"     => $data['username'] ?? '',
            "MAIL_PASSWORD"     => $data['password'] ?? '',
            "MAIL_ENCRYPTION"   => $data['encryption'] ?? '',
            "MAIL_FROM_ADDRESS" => $data['from_address'] ?? '',
            "MAIL_FROM_NAME"    => $data['app_name'],
            "REACHEAD_API_KEY"  => $data['api_key'] ?? '',
        ];


        try{
            modifyEnv($env_modify_keys);
        }catch(Exception $e) {
            return back()->with(['error' => [__("Something went wrong! Please try again")]]);
        }

        return back()->with(['success' => [__("Information updated successfully!")]]);
    }


    public function sendTestMail(Request $request) {
        $validator = Validator::make($request->all(),[
            'email'         => 'required|string|email',
        ]);

        $validated = $validator->validate();

        try{
            Notification::route('mail',$validated['email'])->notify(new SendTestMail());
        }catch(Exception $e) {
            return back()->with(['error' => [__("Something went wrong! Please try again")]]);
        }
        return back()->with(['success' => [__("Email send successfully!")]]);
    }
}
