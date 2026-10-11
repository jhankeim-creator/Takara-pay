<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Admin\Subscriber;
use App\Http\Helpers\Response;
use Exception;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Notification;
use App\Notifications\User\SendMail;

class SubscriberController extends Controller
{
    public function index()
    {
        $page_title = __("Subscriber Section");
        $data = Subscriber::orderBy('id',"DESC")->paginate(20);

        return view('admin.sections.subscribers.index',compact(
            'page_title',
            'data',
        ));
    }
    public function delete(Request $request) {
        $validated = Validator::make($request->all(),[
            'target'        => 'required|integer',
        ],[
            'target.exists'     => __("Selected Subscriber Is Invalid!"),
        ])->validate();

        try{
            $data = Subscriber::find($validated['target']);
            $data->delete();
        }catch(Exception $e) {
            return back()->with(['error' => [__("Something went wrong! Please try again")]]);
        }
        return back()->with(['success' => [__("Deleted successfully!")]]);
    }
    public function search(Request $request) {
        $validator = Validator::make($request->all(),[
            'text'  => 'required|string',
        ]);

        if($validator->fails()) {
            $error = ['error' => $validator->errors()];
            return Response::error($error,null,400);
        }

        $validated = $validator->validate();
        $data = Subscriber::search($validated['text'])->select()->limit(10)->get();
        return view('admin.components.search.subscribers-search',compact(
            'data',
        ));
    }
    public function sendMail(Request $request) {
          $validator = Validator::make($request->all(),[
            'subject'       => "required|string|max:250",
            'message'       => "required|string|max:2000",
        ]);
        if($validator->fails()) {
            return back()->withErrors($validator)->withInput()->with('modal','send-email');
        }
        $data = Subscriber::get();


        try{
            Notification::send($data,new SendMail((object) $request->all()));
        }catch(Exception $e) {
            return back()->with(['error' => [__("Something went wrong! Please try again")]]);
        }

        return back()->with(['success' => [__("Email successfully sended")]]);

    }
}
