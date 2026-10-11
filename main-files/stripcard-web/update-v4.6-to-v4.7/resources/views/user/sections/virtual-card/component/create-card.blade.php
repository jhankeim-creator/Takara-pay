

<div class="col-lg-6 col-md-8 pb-30">
    <div class="deposit-form">
        <div class="form-title text-center">
            <h3 class="title">{{ __($page_title) }}</h3>
        </div>
        <div class="row justify-content-center">
            <form class="card-form row g-4" action="{{ route('user.virtual.card.create') }}" method="POST">
             @csrf

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
                                    data-name="{{ $item->country }}" {{ $item->currency_code == get_default_currency_code() ? 'selected' : '' }}>{{ $item->currency_code }}</option>
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
