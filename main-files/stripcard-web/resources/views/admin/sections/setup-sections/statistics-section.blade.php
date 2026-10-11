@php
    $default_lang_code = language_const()::NOT_REMOVABLE;
@endphp
@extends('admin.layouts.master')

@push('css')
    <style>
        .fileholder {
            min-height: 374px !important;
        }

        .fileholder-files-view-wrp.accept-single-file .fileholder-single-file-view,.fileholder-files-view-wrp.fileholder-perview-single .fileholder-single-file-view{
            height: 330px !important;
        }
    </style>
@endpush

@section('page-title')
    @include('admin.components.page-title',['title' => __($page_title)])
@endsection

@section('breadcrumb')
    @include('admin.components.breadcrumb',['breadcrumbs' => [
        [
            'name'  => __("Dashboard"),
            'url'   => setRoute("admin.dashboard"),
        ]
    ], 'active' => __("Setup Section")])
@endsection

@section('content')
    <div class="custom-card">
        <div class="card-header">
            <h6 class="title">{{ __($page_title) }}</h6>
        </div>
        <div class="card-body">
            <form class="card-form" action="{{ setRoute('admin.setup.sections.section.update',$slug) }}" method="POST" enctype="multipart/form-data">
                @csrf
                <div class="row justify-content-center mb-10-none">
                    <div class="col-xl-4 col-lg-4 form-group">
                        @include('admin.components.form.input-file',[
                            'label'             => __("Image"),
                            'name'              => "image",
                            'class'             => "file-holder",
                            'old_files_path'    => files_asset_path("site-section"),
                            'old_files'         => $data->value->images->image ?? "",
                        ])
                    </div>
                    <div class="col-xl-8 col-lg-8">
                        <div class="product-tab">
                            <nav>
                                <div class="nav nav-tabs" id="nav-tab" role="tablist">
                                    <button class="nav-link @if (get_default_language_code() == language_const()::NOT_REMOVABLE) active @endif" id="english-tab" data-bs-toggle="tab" data-bs-target="#english" type="button" role="tab" aria-controls="english" aria-selected="false">English</button>
                                    @foreach ($languages as $item)
                                        <button class="nav-link @if (get_default_language_code() == $item->code) active @endif" id="{{$item->name}}-tab" data-bs-toggle="tab" data-bs-target="#{{$item->name}}" type="button" role="tab" aria-controls="{{ $item->name }}" aria-selected="true">{{ $item->name }}</button>
                                    @endforeach

                                </div>
                            </nav>
                            <div class="tab-content" id="nav-tabContent">
                                <div class="tab-pane @if (get_default_language_code() == language_const()::NOT_REMOVABLE) fade show active @endif" id="english" role="tabpanel" aria-labelledby="english-tab">
                                    <div class="form-group">
                                        @include('admin.components.form.input',[
                                            'label'     =>__( "Title")."*",
                                            'name'      => $default_lang_code . "_title",
                                            'value'     => old($default_lang_code . "_title",$data->value->language->$default_lang_code->title ?? "")
                                        ])
                                    </div>
                                    <div class="form-group">
                                        @include('admin.components.form.input',[
                                            'label'     => __("TSub Title")."*",
                                            'name'      => $default_lang_code . "_sub_title",
                                            'value'     => old($default_lang_code . "_sub_title",$data->value->language->$default_lang_code->sub_title ?? "")
                                        ])
                                    </div>
                                    <div class="form-group">
                                        @include('admin.components.form.textarea',[
                                            'label'     => __("Details")."*",
                                            'name'      => $default_lang_code . "_details",
                                            'value'     => old($default_lang_code . "_details",$data->value->language->$default_lang_code->details ?? "")
                                        ])
                                    </div>
                                    <div class="form-group">
                                        @include('admin.components.form.input',[
                                            'label'     => __("Total Users")."*",
                                            'name'      => $default_lang_code . "_total_users",
                                            'value'     => old($default_lang_code . "_total_users",$data->value->language->$default_lang_code->total_users ?? "")
                                        ])
                                    </div>
                                    <div class="form-group">
                                        @include('admin.components.form.input',[
                                            'label'     => __("Happy Users")."*",
                                            'name'      => $default_lang_code . "_happy_users",
                                            'value'     => old($default_lang_code . "_happy_users",$data->value->language->$default_lang_code->happy_users ?? "")
                                        ])
                                    </div>
                                    <div class="form-group">
                                        @include('admin.components.form.input',[
                                            'label'     => __("Total Service")."*",
                                            'name'      => $default_lang_code . "_total_service",
                                            'value'     => old($default_lang_code . "_total_service",$data->value->language->$default_lang_code->total_service ?? "")
                                        ])
                                    </div>
                                    <div class="form-group">
                                        @include('admin.components.form.input',[
                                            'label'     =>__( "Transaction Title")."*",
                                            'name'      => $default_lang_code . "_transaction_title",
                                            'value'     => old($default_lang_code . "_transaction_title",$data->value->language->$default_lang_code->transaction_title ?? "")
                                        ])
                                    </div>
                                    <div class="form-group">
                                        @include('admin.components.form.textarea',[
                                            'label'     =>__( "Transaction Details")."*",
                                            'name'      => $default_lang_code . "_transaction_details",
                                            'value'     => old($default_lang_code . "_transaction_details",$data->value->language->$default_lang_code->transaction_details ?? "")
                                        ])
                                    </div>

                                </div>

                                @foreach ($languages as $item)
                                    @php
                                        $lang_code = $item->code;
                                    @endphp


                                    <div class="tab-pane @if (get_default_language_code() == $item->code) fade show active @endif" id="{{ $item->name }}" role="tabpanel" aria-labelledby="english-tab">
                                        <div class="form-group">
                                            @include('admin.components.form.input',[
                                                'label'     => __("title")."*",
                                                'name'      => $lang_code . "_title",
                                                'value'     => old($lang_code . "_title",$data->value->language->$lang_code->title ?? "")
                                            ])
                                        </div>
                                        <div class="form-group">
                                            @include('admin.components.form.input',[
                                                'label'     =>__( "TSub Title")."*",
                                                'name'      => $lang_code . "_sub_title",
                                                'value'     => old($lang_code . "_sub_title",$data->value->language->$lang_code->sub_title ?? "")
                                            ])
                                        </div>
                                        <div class="form-group">
                                            @include('admin.components.form.textarea',[
                                                'label'     => __("Details")."*",
                                                'name'      => $lang_code . "_details",
                                                'value'     => old($lang_code . "_details",$data->value->language->$lang_code->details ?? "")
                                            ])
                                        </div>
                                        <div class="form-group">
                                            @include('admin.components.form.input',[
                                                'label'     => __("Total Users")."*",
                                                'name'      => $item->code . "_total_users",
                                                'value'     => old($item->code . "_total_users",$data->value->language->$lang_code->total_users ?? "")
                                            ])
                                        </div>
                                        <div class="form-group">
                                            @include('admin.components.form.input',[
                                                'label'     => __("Happy Users")."*",
                                                'name'      => $item->code . "_happy_users",
                                                'value'     => old($item->code . "_happy_users",$data->value->language->$lang_code->happy_users ?? "")
                                            ])
                                        </div>
                                        <div class="form-group">
                                            @include('admin.components.form.input',[
                                                'label'     => __("Total Service")."*",
                                                'name'      => $item->code . "_total_service",
                                                'value'     => old($item->code . "_total_service",$data->value->language->$lang_code->total_service ?? "")
                                            ])
                                        </div>
                                        <div class="form-group">
                                            @include('admin.components.form.input',[
                                                'label'     =>__( "Transaction Title")."*",
                                                'name'      => $lang_code . "_transaction_title",
                                                'value'     => old($lang_code . "_transaction_title",$data->value->language->$lang_code->transaction_title ?? "")
                                            ])
                                        </div>
                                        <div class="form-group">
                                            @include('admin.components.form.textarea',[
                                                'label'     =>__( "Transaction Details")."*",
                                                'name'      => $lang_code . "_transaction_details",
                                                'value'     => old($lang_code . "_transaction_details",$data->value->language->$lang_code->transaction_details ?? "")
                                            ])
                                        </div>

                                    </div>
                                @endforeach
                            </div>
                        </div>
                    </div>
                    <div class="col-xl-12 col-lg-12 form-group">
                        @include('admin.components.button.form-btn',[
                            'class'         => "w-100 btn-loading",
                            'text'          => __("Submit"),
                            'permission'    => "admin.setup.sections.section.update"
                        ])
                    </div>
                </div>
            </form>
        </div>
    </div>
@endsection

@push('script')

@endpush
