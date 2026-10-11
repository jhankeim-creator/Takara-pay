<?php

use Stripe\Stripe;
use Stripe\Account;
use Stripe\Transfer;
use Stripe\Treasury;
use Stripe\Issuing\Card;
use Stripe\Issuing\Cardholder;
use Illuminate\Support\Facades\Route;
use Illuminate\Support\Facades\Config;
use App\Http\Controllers\SiteController;
use net\authorize\api\contract\v1 as AnetAPI;
use App\Http\Controllers\User\AddMoneyController;
use net\authorize\api\controller as AnetController;
use App\Http\Controllers\Api\User\AddMoneyController as UserAddMoneyController;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

//landing page
Route::controller(SiteController::class)->middleware(['frontend.mode'])->group(function(){
    Route::get('/','home')->name('index');
    Route::get('about','about')->name('about');
    Route::get('services','services')->name('services');
    Route::get('announcement','blog')->name('announcement');
    Route::get('announcement/details/{id}/{slug}','blogDetails')->name('blog.details');
    Route::get('announcement/by/category/{id}/{slug}','blogByCategory')->name('blog.by.category');
    Route::get('contact','contact')->name('contact');
    Route::post('contact/store','contactStore')->name('contact.store');
    Route::get('change/{lang?}','changeLanguage')->name('lang');
    Route::get('page/{slug}','usefulPage')->name('useful.link');
    Route::get('cookie/accept','cookieAccept')->name('cookie.accept');
    Route::get('cookie/decline','cookieDecline')->name('cookie.decline');
    Route::post('subscribe','subscribeSubmit')->name('subscribe.submit');
});

//for sslcommerz callback urls(web)
Route::controller(AddMoneyController::class)->prefix("add-money")->name("add.money.")->group(function(){
    //sslcommerz
    Route::post('sslcommerz/success','sllCommerzSuccess')->name('ssl.success');
    Route::post('sslcommerz/fail','sllCommerzFails')->name('ssl.fail');
    Route::post('sslcommerz/cancel','sllCommerzCancel')->name('ssl.cancel');
    Route::post("/callback/response/{gateway}",'callback')->name('payment.callback')->withoutMiddleware(['web','auth','verification.guard','user.google.two.factor']);
});
//for sslcommerz callback urls(api)
Route::controller(UserAddMoneyController::class)->prefix("api-add-money")->name("api.add.money.")->group(function(){
    //sslcommerz
    Route::post('sslcommerz/success','sllCommerzSuccess')->name('ssl.success');
    Route::post('sslcommerz/fail','sllCommerzFails')->name('ssl.fail');
    Route::post('sslcommerz/cancel','sllCommerzCancel')->name('ssl.cancel');
});
