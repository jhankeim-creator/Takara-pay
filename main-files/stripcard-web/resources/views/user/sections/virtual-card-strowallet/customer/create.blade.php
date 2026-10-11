@extends('user.layouts.master')

@section('breadcrumb')
    @include('user.components.breadcrumb',['breadcrumbs' => [
        [
            'name'  => __("Dashboard"),
            'url'   => setRoute("user.dashboard"),
        ]
    ], 'active' => __(@$page_title)])
@endsection

@section('content')
<div class="body-wrapper">
    <div class="row justify-content-center">
        <div class="col-xl-8">
            <div class="dash-payment-item-wrapper">
                <div class="dash-payment-item active">
                    <div class="text-center">
                       <h4 class="text-muted">{{ __("A cardholder is required before creating a card. Please create a cardholder first.") }}</h4>
                    </div>
                    <div class="dash-payment-body">
                        <div class=" mt-20 ">
                             <form class="card-form row g-4" action="{{ route('user.strowallet.virtual.card.store.customer') }}" method="POST" enctype="multipart/form-data">
                                @csrf

                                <div class="col-lg-12">
                                    <div class="form-group">
                                        <label>{{ __("Name") }}<span>*</span></label>
                                        <input type="text" class="form--control" placeholder="{{ __("enter Name") }}" name="name" value="{{ old('name', $user->fullname ?? "") }}" required>
                                    </div>
                                </div>

                                <div class="col-lg-6">
                                    <div class="form-group">
                                        <label>{{ __("first Name") }}<span>*</span></label>
                                        <input type="text" class="form--control" placeholder="{{ __("enter First Name") }}" name="first_name" value="{{ old('first_name', $user->firstname ?? "") }}" required>
                                    </div>
                                </div>

                                <div class="col-lg-6">
                                    <div class="form-group">
                                        <label>{{ __("last Name") }}<span>*</span></label>
                                        <input type="text" class="form--control" placeholder="{{ __("enter Last Name") }}" name="last_name" value="{{ old('last_name', $user->lastname) }}" required>
                                    </div>
                                </div>

                                <div class="col-lg-6">
                                    <div class="form-group">
                                        <label>{{ __("Date Of Birth") }}<span>*</span></label>
                                        <input type="date" class="form--control" required placeholder="{{__("Enter Date Of Birth")}}" name="dob" value="{{ old("dob") }}">
                                    </div>
                                </div>

                                <div class="col-lg-6">
                                    <div class="form-group">
                                        <label>{{ __("ID Type") }}<span>*</span></label>
                                        <select class="form--control nice-select" name="id_type" required>
                                            <option value="">{{ __("Select ID Type") }}</option>
                                            <option value="national_id" {{ old('id_type') == 'national_id' ? 'selected' : '' }}>{{ __("National ID") }}</option>
                                            <option value="passport" {{ old('id_type') == 'passport' ? 'selected' : '' }}>{{ __("Passport") }}</option>
                                            <option value="drivers_license" {{ old('id_type') == 'drivers_license' ? 'selected' : '' }}>{{ __("Driver's License") }}</option>
                                            <option value="bvn" {{ old('id_type') == 'bvn' ? 'selected' : '' }}>{{ __("BVN") }}</option>
                                            <option value="nin" {{ old('id_type') == 'nin' ? 'selected' : '' }}>{{ __("NIN") }}</option>
                                            <option value="vnin" {{ old('id_type') == 'vnin' ? 'selected' : '' }}>{{ __("VNIN") }}</option>
                                            <option value="voters_card" {{ old('id_type') == 'voters_card' ? 'selected' : '' }}>{{ __("Voters Card") }}</option>
                                            <option value="ghana_card" {{ old('id_type') == 'ghana_card' ? 'selected' : '' }}>{{ __("Ghana Card") }}</option>
                                        </select>
                                    </div>
                                </div>

                                <div class="col-lg-6">
                                    <div class="form-group">
                                        <label>{{ __("ID Number") }}<span>*</span></label>
                                        <input type="text" class="form--control" placeholder="{{ __("Enter ID Number") }}" name="id_number" value="{{ old('id_number') }}" required>
                                    </div>
                                </div>

                                <div class="col-lg-6">
                                    <div class="form-group">
                                        <label>{{ __("Email") }}<span>*</span></label>
                                        <input type="email" class="form--control" placeholder="{{ __("enter Email Address") }}" name="email" value="{{ old('email', auth()->user()->email) }}" required>
                                    </div>
                                </div>

                                <div class="col-lg-6">
                                    <div class="form-group">
                                        <label>{{ __("Address Line 1") }}<span>*</span></label>
                                        <input type="text" class="form--control" placeholder="{{ __("Enter Address") }}" name="line1" value="{{ old('line1', $user->address->address ?? "") }}" required>
                                    </div>
                                </div>

                                <div class="col-lg-6">
                                    <div class="form-group">
                                        <label>{{ __("City") }}<span>*</span></label>
                                        <input type="text" class="form--control" placeholder="{{ __("Enter City") }}" name="city" value="{{ old('city', $user->address->city ?? "") }}" required>
                                    </div>
                                </div>

                                <div class="col-lg-6">
                                    <div class="form-group">
                                        <label>{{ __("State") }}<span>*</span></label>
                                        <input type="text" class="form--control" placeholder="{{ __("Enter State") }}" name="state" value="{{ old('state', $user->address->state ?? "") }}" required>
                                    </div>
                                </div>

                                <div class="col-lg-6">
                                    <div class="form-group">
                                        <label>{{ __("Zip/Postal") }}<span>*</span></label>
                                        <input type="text" class="form--control" placeholder="{{ __("Enter Zip Code") }}" name="postal_code" value="{{ old('postal_code',$user->address->zip ?? "") }}" required>
                                    </div>
                                </div>


                                @php
                                    $user_country = $user->address->country?? ""
                                @endphp

                                <div class="col-lg-6">
                                    <div class="form-group">
                                        <label>{{ __("Country") }}<span>*</span></label>
                                        <select name="country"class="form-control select2-auto-tokenize country-select select2-basic trx-type-select">
                                            <option value="" disabled selected>{{ __("Select Country") }}</option>
                                            @foreach (get_all_countries() ?? [] as $country)
                                                <option value="{{ $country->iso3 }}" {{ $user_country == $country->name ? 'selected' : '' }} data-mobile-code="{{  $country->mobile_code }}">{{ $country->name }}</option>
                                            @endforeach
                                        </select>
                                    </div>
                                </div>

                                <div class="col-lg-6">
                                    <div class="form-group">
                                        <label>{{ __("Account Purpose") }}<span>*</span></label>
                                        <select class="form--control nice-select" name="account_purpose" required>
                                            <option value="">{{ __("Select Account Purpose") }}</option>
                                            @foreach (\App\Models\StrowalletCustomerKyc::ACCOUNT_PURPOSES as $value => $text)
                                                <option value="{{ $value }}" {{ old('account_purpose') == $value ? 'selected' : '' }}>{{ __($text) }}</option>
                                            @endforeach
                                        </select>
                                    </div>
                                </div>

                                <div class="col-lg-6">
                                    <div class="form-group">
                                        <label>{{ __("Employment Status") }}<span>*</span></label>
                                        <select class="form--control nice-select" name="employment_status" required>
                                            <option value="">{{ __("Select Employment Status") }}</option>
                                            @foreach (\App\Models\StrowalletCustomerKyc::EMPLOYMENT_STATUSES as $value => $text)
                                                <option value="{{ $value }}" {{ old('employment_status') == $value ? 'selected' : '' }}>{{ __($text) }}</option>
                                            @endforeach
                                        </select>
                                    </div>
                                </div>

                                <div class="col-lg-6">
                                    <div class="form-group">
                                        <label>{{ __("Occupation") }}<span>*</span></label>
                                        <select class="form--control nice-select" name="occupation" required>
                                            <option value="">{{ __("Select Occupation") }}</option>
                                            @foreach (\App\Models\StrowalletCustomerKyc::OCCUPATIONS as $value => $text)
                                                <option value="{{ $value }}" {{ old('occupation') == $value ? 'selected' : '' }}>{{ __($text) }}</option>
                                            @endforeach
                                        </select>
                                    </div>
                                </div>

                                <div class="col-lg-6">
                                    <div class="form-group">
                                        <label>{{ __("Phone") }}<span>*</span></label>
                                        <div class="input-group">
                                            <div class="input-group-text phone-code">+{{ auth()->user()->mobile_code }}
                                            </div>
                                            <input class="phone-code" type="hidden" name="phone_code"
                                                value="{{ auth()->user()->mobile_code }}" />
                                            <input type="text" class="form--control"
                                                placeholder="{{ __('enter Phone Number') }}" name="phone"
                                                value="{{ old('phone', auth()->user()->mobile) }}"
                                                >
                                        </div>
                                    </div>
                                </div>
                                <div class="col-xl-12 col-lg-12 form-group">
                                    <label>{{ __("ID Image") }}</label>
                                    <input type="file" class="file-holder" name="id_image" id="fileUpload" data-height="130" accept="image/*" data-max_size="20" data-file_limit="15">
                                </div>


                                <div class="col-lg-12">
                                    <div class="button pt-3">
                                        <button type="submit" class="btn btn--base w-100 btn-loading buyBtn">{{ __("Confirm") }}</button>
                                    </div>
                                </div>
                            </form>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
@endsection

@push('script')
    <script>
        $(document).ready(function() {
            $("select[name=country]").change(function() {
                var phoneCode = $("select[name=country] :selected").attr("data-mobile-code");
                placePhoneCode(phoneCode);
            });

        });

    </script>
@endpush
