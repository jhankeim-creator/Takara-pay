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
                    <div class=" d-flex justify-content-center">
                        <h4 class="text-center">
                            {{ __("Please review the customer details carefully. Update only the fields that need to be changed.") }}
                        </h4>
                    </div>
                    <div class="d-flex justify-content-center">
                          <h4>{{ __("Current Status") }}: <span class="{{  $customer->status == 'active' ? 'badge badge--success' : 'badge badge--warning'}}">{{ strtoupper($customer->status) }}</span> </h4>
                    </div>
                    <div class="dash-payment-body">
                        <div class=" mt-20 ">
                            <form class="card-form row" action="{{ route('user.sudo.virtual.card.update.customer') }}" method="POST" enctype="multipart/form-data">
                                @csrf
                                @method("PUT")

                                <div class="col-12">
                                    <div class="row">
                                        <div class="col-xl-6 col-lg-6 form-group">
                                            @include('admin.components.form.input', [
                                                'label' => __("first Name") . "<span class='text--base'>*</span>",
                                                'placeholder'   => __("enter First Name"),
                                                'name'          => "first_name",
                                                'value'         => $customer->individual->firstName
                                            ])
                                        </div>
                                        <div class="col-xl-6 col-lg-6 form-group">
                                            @include('admin.components.form.input', [
                                                'label'         => __("last Name"). "<span class='text--base'>*</span>",
                                                'placeholder'   => __("enter Last Name"),
                                                'name'          => "last_name",
                                                'value'         => $customer->individual->lastName
                                            ])
                                        </div>
                                        <div class="col-xl-6 col-lg-6 form-group">
                                            <label>{{ __("Date Of Birth") }} <span class="text--base">*</span></label>
                                            <div class="input-group">
                                                <input type="date" class="form--control" required placeholder="{{__("enter date Of Birth")}}" name="date_of_birth" value="{{ \Carbon\Carbon::parse($customer->individual->dob)->format('Y-m-d') }}">
                                            </div>
                                        </div>
                                        <div class="col-xl-6 col-lg-6 form-group">
                                            <label>{{ __("Identity Type") }} <span class="text--base">*</span></label>
                                            <select class="form--control" name="identity_type" required>
                                                <option  disabled selected value="null" >{{ __('Choose One') }}</option>
                                                <option  value="BVN" {{ $customer->individual->identity->type ==  "BVN" ? 'selected' : '' }}>{{ __("Bank Verification Number") }}</option>
                                                <option  value="NIN" {{$customer->individual->identity->type ==  "NIN" ? 'selected' : ''}}>{{ __("National Identification Number") }}</option>
                                                <option  value="TIN" {{$customer->individual->identity->type ==  "TIN" ? 'selected' : '' }}>{{ __("Taxpayer identification numbers") }}</option>
                                            </select>
                                        </div>
                                        <div class="col-xl-6 col-lg-6 form-group">
                                            <label>{{ __("Identity Number") }} <span class="text--base">*</span></label>
                                            <div class="input-group">
                                                <input type="number" class="form--control" required placeholder="{{__("Enter Identity Number")}}" name="identity_number" value="{{ old('identity_number', $customer->individual->identity->number ?? '') }}">
                                            </div>
                                        </div>
                                        <div class="col-xl-6 col-lg-6 form-group">
                                            <label>{{ __("Phone") }}<span class="text--base">*</span></label>
                                            <div class="input-group">
                                                <input type="text" class="form--control prepend" required placeholder="{{ __('enter Phone Number') }}" name="phone_number" value="{{ old('phone_number',$customer->phoneNumber) }}" />
                                            </div>
                                        </div>

                                        <div class="col-xl-6 col-lg-6 form-group">
                                            <label>{{ __("Address Line 1") }} <span class="text--base">*</span></label>
                                            <input type="text" class="form--control" required
                                                name="line1"
                                                placeholder="{{ __('Enter Address Line 1') }}"
                                                value="{{ old('line1', $customer->billingAddress->line1 ?? '') }}">
                                        </div>
                                        <div class="col-xl-6 col-lg-6 form-group">
                                            <label>{{ __("Address Line 2") }}</label>
                                            <input type="text" class="form--control"
                                                name="line2"
                                                placeholder="{{ __('Enter Address Line 2') }}"
                                                value="{{ old('line2', $customer->billingAddress->line2 ?? '') }}">
                                        </div>

                                        <div class="col-xl-6 col-lg-6 form-group">
                                            <label>{{ __("City") }} <span class="text--base">*</span></label>
                                            <input type="text" class="form--control" required
                                                name="city"
                                                placeholder="{{ __('Enter City') }}"
                                                value="{{ old('city', $customer->billingAddress->city ?? '') }}">
                                        </div>

                                        <div class="col-xl-6 col-lg-6 form-group">
                                            <label>{{ __("State") }} <span class="text--base">*</span></label>
                                            <input type="text" class="form--control" required
                                                name="state"
                                                placeholder="{{ __('Enter State') }}"
                                                value="{{ old('state', $customer->billingAddress->state ?? '') }}">
                                        </div>

                                        <div class="col-xl-6 col-lg-6 form-group">
                                            <label>{{ __("Select Country") }} <span class="text--base">*</span></label>
                                            <select class="form--control select2-basic" name="country" required>
                                                <option  disabled selected value="null" >{{ __('Choose One') }}</option>
                                                @foreach(get_all_countries() ?? [] as $key => $country)
                                                    <option  value="{{ $country->name }}" {{ $customer->billingAddress->country ==  $country->name  ? 'selected' : ''}}>{{ $country->name }}</option>
                                                @endforeach

                                            </select>
                                        </div>

                                        <div class="col-xl-6 col-lg-6 form-group">
                                            <label>{{ __("Postal Code") }} <span class="text--base">*</span></label>
                                            <input type="text" class="form--control" required
                                                name="postal_code"
                                                placeholder="{{ __('Enter Postal Code') }}"
                                                value="{{ old('postal_code', $customer->billingAddress->postalCode ?? '') }}">
                                        </div>

                                        <div class="col-xl-6 col-lg-6 form-group">
                                            @include('admin.components.form.input-file',[
                                                'label'             => __("ID Card(Front Side)"),
                                                'name'              => "id_image_front",
                                                'class'             => "file-holder",
                                                'old_files_path'    => files_asset_path('sudo-kyc-images'),
                                                'old_files'         => $customer_kyc->id_image_front ?? '',
                                            ])
                                        </div>

                                        <div class="col-xl-6 col-lg-6 form-group">
                                            @include('admin.components.form.input-file',[
                                                'label'             => __("ID Card(Back Side))"),
                                                'name'              => "id_image_back",
                                                'class'             => "file-holder",
                                                'old_files_path'    => files_asset_path('sudo-kyc-images'),
                                                'old_files'         => $customer_kyc->id_image_back ?? '',
                                            ])
                                        </div>

                                        <div class="col-xl-12 col-lg-12 form-group">
                                            @include('admin.components.form.input-file',[
                                                'label'             => __("Address Verification"),
                                                'name'              => "address_verification",
                                                'class'             => "file-holder",
                                                'old_files_path'    => files_asset_path('sudo-kyc-images'),
                                                'old_files'         => $customer_kyc->address_verification ?? '',
                                            ])
                                        </div>

                                        <div class="col-xl-12 col-lg-12">
                                            <button type="submit" class="btn--base w-100 btn-loading buyBtn">{{ __("Update") }} <i class="las la-user-edit ms-1"></i></button>
                                        </div>


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
    $(document).ready(function () {

        function previewImage(input, previewId) {
            if (input.files && input.files[0]) {
                let reader = new FileReader();

                reader.onload = function (e) {
                    $(previewId).attr('src', e.target.result).show();
                }

                reader.readAsDataURL(input.files[0]);
            }
        }

        $('#idFrontInput').on('change', function () {
            previewImage(this, '#preview-id-front');
        });

        $('#idBackInput').on('change', function () {
            previewImage(this, '#preview-id-back');
        });

        $('#addressInput').on('change', function () {
            previewImage(this, '#preview-address');
        });

    });
</script>

@endpush
