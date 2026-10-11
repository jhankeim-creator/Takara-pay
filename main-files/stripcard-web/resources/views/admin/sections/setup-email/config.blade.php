@extends('admin.layouts.master')

@push('css')

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
    ], 'active' => __("Setup Email")])
@endsection

@section('content')
    @php
        $selected_method = old('method',$email_config->method ?? "smtp");
    @endphp
    <div class="custom-card">
        <div class="card-header">
            <h6 class="title">{{ __("Email Method") }}</h6>
        </div>
        <div class="card-body">
            <form class="card-form" method="POST" action="{{ setRoute('admin.setup.email.config.update') }}">
                @csrf
                @method("PUT")
                <div class="row mb-10-none">
                    <div class="col-xl-12 col-lg-12">
                        <div class="row align-items-end">
                            <div class="col-xl-10 col-lg-10 form-group">
                                <label>{{ __("Email Send Method") }}*</label>
                                <select class="form--control nice-select" name="method">
                                    <option disabled>{{ __("Select Method") }}</option>
                                    <option value="smtp" @selected($selected_method == "smtp")>SMTP</option>
                                    <option value="reachead" @selected($selected_method == "reachead")>{{ __("Reachead") }}</option>
                                </select>
                                @error("method")
                                    <span class="invalid-feedback d-block" role="alert">
                                        <strong>{{ $message }}</strong>
                                    </span>
                                @enderror
                            </div>
                            <div class="col-xl-2 col-lg-2 form-group">
                                <!-- Open Modal For Test Email Send -->
                                @include('admin.components.link.custom',[
                                    'class'         => "btn--base modal-btn w-100",
                                    'href'          => "#test-mail",
                                    'text'          => __("Send Mail"),
                                    'permission'    => "admin.setup.email.test.mail.send",
                                ])
                            </div>
                        </div>
                    </div>

                    <div class="col-12 input-fields smtp-fields" @if ($selected_method != "smtp") style="display: none" @endif>
                        <div class="row">
                            <div class="col-xl-5 col-lg-5 form-group">
                                @include('admin.components.form.input',[
                                    'label'     =>__( "Host")."*",
                                    'name'      => 'host',
                                    'value'     => old('host',$email_config->host ?? ""),
                                ])
                            </div>
                            <div class="col-xl-5 col-lg-5 form-group">
                                @include('admin.components.form.input',[
                                    'label'     => __("Port")."*",
                                    'name'      => 'port',
                                    'type'      => 'number',
                                    'value'     => old('port',$email_config->port ?? ""),
                                ])
                            </div>
                            <div class="col-xl-2 col-lg-2 form-group">
                                @include('admin.components.form.switcher',[
                                    'label'     => __("Encryption")."*",
                                    'name'      => 'encryption',
                                    'options'   => ['SSL' => "ssl",'TLS' => "tls"],
                                    'value'     => old('encryption',$email_config->encryption ?? ""),
                                ])
                            </div>
                            <div class="col-xl-4 col-lg-4 form-group">
                                @include('admin.components.form.input',[
                                    'label'     => __("Username")."*",
                                    'name'      => 'username',
                                    'value'     => old('username',$email_config->username ?? ""),
                                ])
                            </div>
                            <div class="col-xl-4 col-lg-4 form-group">
                                @include('admin.components.form.input',[
                                    'label'     => __("From Address")."*",
                                    'name'      => 'from_address',
                                    'value'     => old('from_address',$email_config->from_address ?? ""),
                                ])
                            </div>
                            <div class="col-xl-4 col-lg-4 form-group">
                                @include('admin.components.form.email-input-password',[
                                    'label'         => __('password').'*',
                                    'placeholder'   => 'Password' ,
                                    'name'          => 'password',
                                    'value'         => old('password',$email_config->password ?? ""),
                                ])
                            </div>
                        </div>
                    </div>

                    <div class="col-12 input-fields reachead-fields" @if ($selected_method != "reachead") style="display: none" @endif>
                        <div class="row">
                            <div class="col-xl-6 col-lg-6 form-group">
                                @include('admin.components.form.input',[
                                    'label'         => __("From Address")."*",
                                    'placeholder'   => __("From Address"),
                                    'name'          => 'reachead_from_address',
                                    'value'         => old('reachead_from_address',$email_config->from_address ?? ""),
                                ])
                            </div>
                            <div class="col-xl-6 col-lg-6 form-group">
                                @include('admin.components.form.email-input-password',[
                                    'label'         => __("Api Key")."*",
                                    'placeholder'   => __("Api Key"),
                                    'name'          => 'reachead_api_key',
                                    'value'         => old('reachead_api_key',$email_config->api_key ?? ""),
                                ])
                            </div>
                        </div>
                    </div>

                    <div class="col-xl-12 col-lg-12 form-group">
                        @include('admin.components.button.form-btn',[
                            'class'         => "w-100 btn-loading",
                            'text'          => __("Update"),
                            'permission'    => "admin.setup.email.config.update",
                        ])
                    </div>
                </div>
            </form>
        </div>
    </div>

    {{-- Test mail send modal --}}
    @include('admin.components.modals.send-text-mail')

@endsection

@push('script')
    <script>
        $("select[name=method]").change(function(){
            $(".input-fields").hide();
            $("."+$(this).val()+"-fields").show();
        });
    </script>
@endpush
