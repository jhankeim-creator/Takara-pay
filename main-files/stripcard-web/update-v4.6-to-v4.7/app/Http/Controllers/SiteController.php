<?php

namespace App\Http\Controllers;

use Exception;
use App\Models\Blog;
use App\Models\Contact;
use App\Models\BlogCategory;
use Illuminate\Http\Request;
use App\Http\Helpers\Response;
use App\Models\Admin\Language;
use App\Models\Admin\SetupPage;
use App\Models\Admin\Subscriber;
use App\Constants\ExtensionConst;
use App\Models\Admin\BasicSettings;
use Illuminate\Support\Facades\Validator;
use App\Providers\Admin\ExtensionProvider;

class SiteController extends Controller
{
    public function home(){
        $basic_settings = BasicSettings::first();
        $my_card_page_url = get_virtual_card_url(activeCardSystem())['create_page'];
        $page_title = $basic_settings->site_title??"Home";

        $page_section       = SetupPage::where('slug','home')->with(['sections' => function($q){
            $q->where('status',true);
        }])->first();

        return view('frontend.index',compact('page_title','my_card_page_url','page_section'));
    }

    public function about(){
        $page_title = "About";

        $page_section       = SetupPage::where('slug','about')->with(['sections' => function($q){
            $q->where('status',true);
        }])->first();

        return view('frontend.about',compact('page_title','page_section'));
    }
    public function services(){
        $page_title = "Services";

        $page_section       = SetupPage::where('slug','services')->with(['sections' => function($q){
            $q->where('status',true);
        }])->first();

        return view('frontend.services',compact('page_title','page_section'));
    }
    public function blog(){
        $page_title = "Announcements";
        $page_section       = SetupPage::where('slug','announcement')->with(['sections' => function($q){
            $q->where('status',true);
        }])->first();
        return view('frontend.blogs',compact('page_title','page_section'));
    }
    public function blogDetails($id,$slug){
        $page_title = "Announcement Details";
        $categories = BlogCategory::active()->latest()->get();
        $blog = Blog::where('id',$id)->where('slug',$slug)->first();
        $recentPost = Blog::active()->where('id',"!=",$id)->latest()->limit(3)->get();
        return view('frontend.blogDetails',compact('page_title','blog','recentPost','categories'));
    }
    public function blogByCategory($id,$slug){
        $categories = BlogCategory::active()->latest()->get();
        $category = BlogCategory::findOrfail($id);
        $page_title = __("Category").'-'.' '. $category->name;
        $blogs = Blog::active()->where('category_id',$category->id)->latest()->paginate(8);
        $recentPost = Blog::active()->latest()->limit(3)->get();
        return view('frontend.blogByCategory',compact('page_title','blogs','category','categories','recentPost'));
    }
    public function contact(){
        $page_title = "Contact";
        $page_section       = SetupPage::where('slug','contact')->with(['sections' => function($q){
            $q->where('status',true);
        }])->first();
        return view('frontend.contact',compact('page_title','page_section'));
    }
    public function contactStore(Request $request){
        $extension = ExtensionProvider::get()->where('slug', ExtensionConst::GOOGLE_RECAPTCHA_SLUG)->first();
        $captcha_rules = "nullable";
        if($extension && $extension->status == true) {
            $captcha_rules = 'required|string|g_recaptcha_verify';
        }
        if($request->ajax()){
            $validator = Validator::make($request->all(), [
                'name'    => 'required|string',
                'email'   => 'required|email',
                'mobile'  => 'required',
                'subject' => 'required|string',
                'message' => 'required|string',
                'g-recaptcha-response'  => $captcha_rules
            ]);

            if($validator->stopOnFirstFailure()->fails()){
                $error = ['errors' => $validator->errors()];
                return Response::error($error, null, 500);
            }

            $validated =  $validator->validated();

            try {
                Contact::create($validated);
            } catch (\Exception $th) {
                $error = ['error' => __('Something went wrong! Please try again')];
                return Response::error($error, null, 500);
            }

            $success = ['success' => ['Your message submited!']];
            return Response::success($success,null,200);
        }
    }

    public function changeLanguage($lang = null)
    {
        $language = Language::where('code', $lang)->first();
        session()->put('local', $lang);
        return redirect()->back();
    }
    public function usefulPage($slug){
        $default = selectedLang();
        $system_default  = "en";

        $page = SetupPage::where('slug', $slug)->where('status', 1)->first();

        if(empty($page)){
            abort(404);
        }
        $page_title = $page->title->language->$default->title ?? $page->title->language->$system_default->title;

        return view('frontend.policy_pages',compact('page_title','page','default','system_default'));
    }

    public function cookieAccept(){
        session()->put('cookie_accepted',true);
        return response()->json(__('Cookie allow successfully'));
    }
    public function cookieDecline(){
        session()->put('cookie_decline',true);
        return response()->json(__('Cookie decline successfully'));
    }

    public function subscribeSubmit(Request $request){
        $extension = ExtensionProvider::get()->where('slug', ExtensionConst::GOOGLE_RECAPTCHA_SLUG)->first();
        $captcha_rules = "nullable";
        if($extension && $extension->status == true) {
            $captcha_rules = 'required|string|g_recaptcha_verify';
        }
        $validator = Validator::make($request->all(),[
            'email'                 => 'required|email|unique:subscribers',
            'g-recaptcha-response'  => $captcha_rules
        ]);
        if($validator->fails()) {
            return back()->withErrors($validator)->withInput();
        }
        $in['email'] = $request->email;
        try{
            Subscriber::create($in);
            return redirect()->back()->with(['success' => [__('Your subscription has been successfully submitted!')]]);
        }catch(Exception $e){
            return back()->with(['error' => [$e->getMessage()]]);
        }
    }
}
