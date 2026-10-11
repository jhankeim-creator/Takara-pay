

<div class="col-lg-6 col-md-8 pb-30">
    <div class="deposit-form">
        <div class="form-title text-center">
            <h3 class="title">{{ __($page_title) }}</h3>
        </div>
        <div class="row justify-content-center">
            <form class="card-form row g-4" action="{{ route('user.sudo.virtual.card.create') }}" method="POST" enctype="multipart/form-data">
             @csrf
                @if($extra_fields_status == true)
                    <div class="col-12">
                        <div class="row">
                            <div class="col-xl-6 col-lg-6 form-group">
                                <label>{{ __("Date Of Birth") }} <span class="text--base">*</span></label>
                                <div class="input-group">
                                    <input type="date" class="form--control" required placeholder="{{__("Enter Date Of Birth")}}" name="date_of_birth" value="{{ old("date_of_birth") }}">
                                </div>
                            </div>
                            <div class="col-xl-6 col-lg-6 form-group">
                                <label>{{ __("Identity Type") }} <span class="text--base">*</span></label>
                                <select class="form--control" name="identity_type" required>
                                    <option  disabled selected value="null" >{{ __('Choose One') }}</option>
                                    <option  value="BVN">{{ __("Bank Verification Number") }}</option>
                                    <option  value="NIN">{{ __("National Identification Number") }}</option>
                                    <option  value="TIN">{{ __("Taxpayer identification numbers") }}</option>
                                </select>
                            </div>
                            <div class="col-xl-6 col-lg-6 form-group">
                                <label>{{ __("Identity Number") }} <span class="text--base">*</span></label>
                                <div class="input-group">
                                    <input type="number" class="form--control" required placeholder="{{__("Enter Identity Number")}}" name="identity_number" value="{{ old("identity_number") }}">
                                </div>
                            </div>
                            <div class="col-xl-6 col-lg-6 form-group">
                                <label>{{ __("Phone") }}<span class="text--base">*</span></label>
                                <div class="input-group">
                                    <input type="text" class="form--control prepend" required placeholder="{{ __('Enter Phone') }}" name="phone_number" value="{{ old('phone_number',auth()->user()->full_mobile) }}" />
                                </div>
                            </div>

                             <div class="col-xl-6 col-lg-6 form-group">
                                @include('admin.components.form.input-file', [
                                    'label'         => __("ID Card(Front Side)")." "."<span class='text--base'>*</span>",
                                    'name'          => "id_image_front",
                                    'class'         => "form--control file-holder",
                                    'label_class'         => "mw-100"
                                ])
                            </div>


                            <div class="col-xl-6 col-lg-6 form-group">
                                @include('admin.components.form.input-file', [
                                    'label'         => __("ID Card(Back Side)")." "."<span class='text--base'>*</span>",
                                    'name'          => "id_image_back",
                                    'class'         => "form--control file-holder",
                                    'label_class'         => "mw-100"
                                ])
                            </div>
                            <div class="col-xl-12 col-lg-12 form-group">
                                @include('admin.components.form.input-file', [
                                    'label'         => __("Address Verification")." "."<span class='text--base'>* (" . __("Optional") . ")</span>",
                                    'name'          => "address_verification",
                                    'class'         => "form--control file-holder",
                                    'label_class'         => "mw-100"
                                ])
                            </div>
                        </div>
                    </div>
                @endif
                <div class="col-lg-12">
                    <div class="form-group">
                        <label>{{__("Card Amount")}}<span>*</span></label>
                        <input type="number" class="form--control card_amount" id="card_amount" required placeholder="{{ __("Enter Amount") }}" name="card_amount" value="{{ old("card_amount") }}">
                            <select class="currency nice-select" name="currency">
                                @foreach ($supported_currency as $item)
                                <option value="{{ $item->currency_code }}"
                                    data-code="{{ $item->currency_code }}"
                                    data-symbol="{{ $item->symbol }}"
                                    data-rate="{{ $item->rate }}"
                                    data-wallet="{{ $item->id }}"
                                    data-currency-id="{{ $item->id }}"
                                    data-name="{{ $item->country }}">{{ $item->currency_code }}</option>
                                @endforeach
                            </select>
                    </div>

                     <div class="col-xl-12 col-lg-12 form-group">
                        <label>{{ __("Card Brand") }} <span class="text--base">*</span></label>
                        <select class="form--control" name="card_brand" required>
                            <option  disabled selected value="null" >{{ __('Choose One') }}</option>
                            <option  value="MasterCard">{{ __("MasterCard") }}</option>
                            <option  value="Visa">{{ __("Visa") }}</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>{{ __("From Wallet") }} <span class="text--base">*</span></label>
                        <select class="form--control select2-auto-tokenize" name="from_currency">
                            @foreach ($from_wallets as $item)
                            <option value="{{ $item->currency->code }}"
                                data-code="{{ $item->currency->code }}"
                                data-symbol="{{ $item->currency->symbol }}"
                                data-rate="{{ $item->currency->rate }}"
                                data-type="{{ $item->currency->type }}"
                                data-balance="{{ $item->balance }}"
                                data-wallet="{{ $item->id }}"
                                data-currency-id="{{ $item->currency->id }}"
                                data-name="{{ $item->currency->country }}">{{ucwords($item->currency->name) ."( ".get_amount($item->balance,$item->currency->code,get_wallet_precision())." )"}}</option>
                            @endforeach
                        </select>
                        <div class="note-area mt-10">
                            <code class="d-block fees-show">--</code>
                            <code class="d-block">{{ __("Available Balance") }} {{ authWalletBalance() }} {{ get_default_currency_code() }}</code>
                        </div>
                    </div>

                    <div class="button pt-3">
                        <button type="submit" class="btn btn--base w-100 btn-loading buyBtn">{{ __("Confirm") }}</button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>
<div class="col-lg-6 col-md-4">
    <div class="deposit-form">
        <div class="form-title text-center pb-4">
            <h3 class="title">{{ __("preview") }}</h3>
        </div>
        <div class="preview-item d-flex justify-content-between">
            <div class="preview-content">
                <span>{{ __("Card Amount") }}</span>
            </div>
            <div class="preview-content">
                <p class="request-amount">--</p>
            </div>
        </div>

        <div class="preview-item d-flex justify-content-between">
            <div class="preview-content">
                <span>{{ __("Exchange Rate") }}</span>
            </div>
            <div class="preview-content">
                <p class="exchange-rate">--</p>
            </div>
        </div>

        <div class="preview-item d-flex justify-content-between">
            <div class="preview-content">
                <span>{{ __("Total Charge") }}</span>
            </div>
            <div class="preview-content">
                <p class="fees">--</p>
            </div>
        </div>

        <div class="preview-item d-flex justify-content-between">
            <div class="preview-content">
                <span>{{__("Total Payable Amount")}}</span>
            </div>
            <div class="preview-content">
                <p class="payable-total">--</p>
            </div>
        </div>

    </div>
    {{-- limit section  --}}
    <div class="deposit-form my-3">
        <div class="form-title text-center pb-4">
            <h3 class="title">{{__("Limit Information")}}</h3>
        </div>
        <div class="preview-item d-flex justify-content-between">
            <div class="preview-content">
                <span>{{ __("Transaction Limit") }}</span>
            </div>
            <div class="preview-content">
                <span class="limit-show">--</span>
            </div>
        </div>
        @if ($cardCharge->daily_limit > 0)
            <div class="preview-item d-flex justify-content-between">
                <div class="preview-content">
                    <span>{{ __("Daily Limit") }}</span>
                </div>
                <div class="preview-content">
                    <span class="limit-daily">--</span>
                </div>
            </div>
            <div class="preview-item d-flex justify-content-between">
                <div class="preview-content">
                    <span>{{ __("Remaining Daily Limit") }}</span>
                </div>
                <div class="preview-content">
                    <span class="daily-remaining">--</span>
                </div>
            </div>
        @endif
        @if ($cardCharge->monthly_limit > 0)
            <div class="preview-item d-flex justify-content-between">
                <div class="preview-content">
                    <span>{{ __("Monthly Limit") }}</span>
                </div>
                <div class="preview-content">
                    <span class="limit-monthly">--</span>
                </div>
            </div>
            <div class="preview-item d-flex justify-content-between">
                <div class="preview-content">
                    <span>{{ __("Remaining Monthly Limit") }}</span>
                </div>
                <div class="preview-content">
                    <span class="monthly-remaining">--</span>
                </div>
            </div>
        @endif

    </div>
</div>
