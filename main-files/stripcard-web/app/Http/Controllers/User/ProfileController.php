<?php

namespace App\Http\Controllers\User;

use Exception;
use Illuminate\Support\Arr;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use Illuminate\Validation\Rules\Password;
use App\Providers\Admin\BasicSettingsProvider;
use Illuminate\Validation\ValidationException;

class ProfileController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        $page_title = __("My Profile");
        $user = auth()->user();
        return view('user.sections.profile.index',compact("page_title","user"));
    }
    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request)
    {
        $user = auth()->user();
        $validated = Validator::make($request->all(),[
            'firstname'     => "required|string|max:60",
            'lastname'      => "required|string|max:60",
            'country'       => "nullable|string|max:50",
            'phone_code'    => "nullable|string|max:20",
            'phone'         => "nullable|string|max:20",
            'state'         => "nullable|string|max:50",
            'city'          => "nullable|string|max:50",
            'zip_code'      => "nullable|numeric",
            'address'       => "nullable|string|max:250",
            'image'         => "nullable|image|mimes:jpg,png,svg,webp|max:10240",
        ])->validate();

        $validated['mobile']        = isset($validated['phone']) ? remove_speacial_char($validated['phone']) : null;
        $validated['mobile_code']   = isset($validated['phone_code']) ? remove_speacial_char($validated['phone_code']) : null;
        $complete_phone             = isset($validated['phone_code']) ? $validated['mobile_code'] . $validated['mobile'] : null;
        $validated['full_mobile']   = $complete_phone ?? null;
        $validated                  = Arr::except($validated,['agree','phone_code','phone']);
        $validated['address']       = [
            'country'   =>$validated['country']??"",
            'state'     => $validated['state'] ?? "",
            'city'      => $validated['city'] ?? "",
            'zip'       => $validated['zip_code'] ?? "",
            'address'   => $validated['address'] ?? "",
        ];

        if($request->hasFile("image")) {
            if($user->image == 'default.png'){
                $oldImage = null;
            }else{
                $oldImage = $user->image;
            }
            $image = upload_file($validated['image'],'user-profile',$oldImage);
            $upload_image = upload_files_from_path_dynamic([$image['dev_path']],'user-profile');
            delete_file($image['dev_path']);
            $validated['image']     = $upload_image;
        }

        try{
            auth()->user()->update($validated);
        }catch(Exception $e) {
            return back()->with(['error' => [__("Something Went Wrong! Please Try Again")]]);
        }

        return back()->with(['success' => [__('Profile successfully updated!')]]);
    }
    public function changePassword()
    {
        $page_title = __("Change Password");
        return view('user.sections.profile.password',compact("page_title"));
    }

    public function passwordUpdate(Request $request) {

        $basic_settings = BasicSettingsProvider::get();
        $passowrd_rule = "required|string|min:6|confirmed";
        if($basic_settings->secure_password) {
            $passowrd_rule = ["required",Password::min(8)->letters()->mixedCase()->numbers()->symbols()->uncompromised(),"confirmed"];
        }

        $request->validate([
            'current_password'      => "required|string",
            'password'              => $passowrd_rule,
        ]);

        if(!Hash::check($request->current_password,auth()->user()->password)) {
            throw ValidationException::withMessages([
                'current_password'      => __('Current password didn\'t match'),
            ]);
        }

        try{
            auth()->user()->update([
                'password'  => Hash::make($request->password),
            ]);
        }catch(Exception $e) {
            return back()->with(['error' => [__("Something Went Wrong! Please Try Again")]]);
        }

        return back()->with(['success' => [__('Password successfully updated!')]]);

    }
}
