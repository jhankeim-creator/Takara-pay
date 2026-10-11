

<div class="col-lg-6 col-md-8 pb-30">
    <div class="deposit-form">
        <div class="form-title text-center">
            <h3 class="title">{{ __($page_title) }}</h3>
        </div>
        <div class="row justify-content-center">
            <form class="card-form row g-4" action="{{ route('user.cardyfie.virtual.card.buy') }}" method="POST">
                @csrf
                <div class="col-lg-12">
                    <div class="form-group">
                        <label>{{ __("Card Holder's Name") }}<span>*</span></label>
                        <input type="text" class="form--control" placeholder="{{ __("Enter Card Holder's Name") }}" name="name_on_card" value="{{ old('name_on_card',$card_customer->first_name.' '.$card_customer->last_name) }}" required>
                    </div>
                    <div class="form-group">
                        <label>{{ __("Card Tier") }} <span class="text--base">*</span></label>
                        <select class="form--control nice-select" name="card_tier" required>
                            {{-- <option  disabled selected value="null" >{{ __('Choose One') }}</option> --}}
                            <option value="universal">{{ __("Universal") }}</option>
                            <option value="platinum">{{ __("Platinum") }}</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>{{ __("Card Type") }} <span class="text--base">*</span></label>
                        <select class="form--control nice-select" name="card_type" required>
                            {{-- <option  disabled selected value="null" >{{ __('Choose One') }}</option> --}}
                            <option value="visa">{{ __("Visa") }}</option>
                            <option value="mastercard">{{ __("Mastercard") }}</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>{{ __("Card Currency") }} <span class="text--base">*</span></label>
                        <select class="form--control nice-select" name="currency" required>
                            {{-- <option  disabled selected value="null" >{{ __('Choose One') }}</option> --}}
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
                <span>{{ __("Card Type") }}</span>
            </div>
            <div class="preview-content">
                <p class="p-card-type">--</p>
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
                <span>{{ __("Total Charge") }}</span> <span class="text--base card_tier_preview"></span>
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

</div>
