<div class="custom-card mb-10">
    <div class="card-header">
        <h6 class="title">{{ __($title) ?? "" }}</h6>
    </div>
    <div class="card-body">
        <form class="card-form" method="POST" action="{{ $route ?? "" }}">
            @csrf
            @method("PUT")

            <input type="hidden" value="{{ $item->slug }}" name="slug">
                 @php
                    if($item->slug == 'virtual_card' || $item->slug == 'virtual_card_withdraw'){
                        $colLg = 'col-xl-6';
                        $colXl = 'col-lg-6';
                    }else{
                        $colLg = 'col-xl-6';
                        $colXl = 'col-lg-6';
                    }
                @endphp
            <div class="row">
                <div class="col-xl-6 col-lg-4 mb-10">
                    <div class="custom-inner-card">
                        <div class="card-inner-header">
                            <h5 class="title">{{ __("Charges") }}</h5>
                        </div>
                        <div class="card-inner-body">
                            <div class="row">
                                <div class="col-xxl-12 col-xl-6 col-lg-6 form-group">
                                    <label>{{ __("Fixed Charge") }}*</label>
                                    <div class="input-group">
                                        <input type="text" class="form--control number-input" value="{{ old($data->slug.'_fixed_charge',get_amount($data->fixed_charge,null,get_wallet_precision())) }}" name="{{$data->slug}}_fixed_charge">
                                        <span class="input-group-text">{{ get_default_currency_code($default_currency) }}</span>
                                    </div>
                                </div>
                                <div class="col-xxl-12 col-xl-6 col-lg-6 form-group">
                                    <label>{{ __("Percent Charge") }}*</label>
                                    <div class="input-group">
                                        <input type="text" class="form--control number-input" value="{{ old($data->slug.'_percent_charge',get_amount($data->percent_charge,null,get_wallet_precision())) }}" name="{{$data->slug}}_percent_charge">
                                        <span class="input-group-text">%</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-xl-6 col-lg-4 mb-10">
                    <div class="custom-inner-card">
                        <div class="card-inner-header">
                            <h5 class="title">{{ __("Range") }}</h5>
                        </div>
                        <div class="card-inner-body">
                            <div class="row">
                                <div class="col-xxl-12 col-xl-6 col-lg-6  form-group">
                                    <label>{{ __("Minimum Amount") }}</label>
                                    <div class="input-group">
                                        <input type="text" class="form--control number-input" value="{{ old($data->slug.'_min_limit',get_amount($data->min_limit,null,get_wallet_precision())) }}" name="{{$data->slug}}_min_limit">
                                        <span class="input-group-text">{{ get_default_currency_code($default_currency) }}</span>
                                    </div>
                                </div>
                                <div class="col-xxl-12 col-xl-6 col-lg-6 form-group">
                                    <label>{{ __("Maximum Amount") }}</label>
                                    <div class="input-group">
                                        <input type="text" class="form--control number-input" value="{{ old($data->slug.'_max_limit',get_amount($data->max_limit,null,get_wallet_precision())) }}" name="{{$data->slug}}_max_limit">
                                        <span class="input-group-text">{{ get_default_currency_code($default_currency) }}</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-xl-12 col-lg-12 mb-10">
                    <div class="custom-inner-card">
                        <div class="card-inner-header">
                            <h5 class="title">{{ __("limit") }} <span class="small text--base">({{ __("Execute if the value is greater than zero") }})</span></h5>
                        </div>
                        <div class="card-inner-body">
                            <div class="row">
                                <div class="col-xxl-12 col-xl-6 col-lg-6 form-group">
                                    <label>{{ __("Daily Limit") }}*</label>
                                    <div class="input-group">
                                        <input type="text" class="form--control number-input" value="{{ old($data->slug.'_daily_limit',get_amount($data->daily_limit,null,get_wallet_precision())) }}" name="{{$data->slug}}_daily_limit">
                                        <span class="input-group-text">{{ get_default_currency_code($default_currency) }}</span>
                                    </div>
                                </div>
                                <div class="col-xxl-12 col-xl-6 col-lg-6 form-group">
                                    <label>{{ __("Monthly Limit") }}* </label>
                                    <div class="input-group">
                                        <input type="text" class="form--control number-input" value="{{ old($data->slug.'_monthly_limit',get_amount($data->monthly_limit,null,get_wallet_precision())) }}" name="{{$data->slug}}_monthly_limit">
                                        <span class="input-group-text">{{ get_default_currency_code($default_currency) }}</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
            <div class="row mb-10-none">
                <div class="col-xl-12 col-lg-12 form-group">
                    @include('admin.components.button.form-btn',[
                        'text'          => __("Update"),
                        'class'         => "w-100 btn-loading",
                        'permission'    => "admin.trx.settings.charges.update",
                    ])
                </div>
            </div>
        </form>
    </div>
</div>
