@extends('user.layouts.master')

@section('breadcrumb')
    @include('user.components.breadcrumb',['breadcrumbs' => [
        [
            'name'  => __("Dashboard"),
            'url'   => setRoute("user.dashboard"),
        ]
    ], 'active' => __("Dashboard")])
@endsection

@section('content')
<div class="body-wrapper">
    <div class="dashboard-area mt-10">
        <div class="dashboard-header-wrapper">
            <h3 class="title">{{ __("Welcome Back") }}, <span>{{ @$user->fullname }}</span></h3>
        </div>
        @if(module_access('virtual-card',$module)->status)
         <!-- Dashboard Card -->
        <div class="row justify-content-center">
            <div class="col-xxl-6 col-xl-8 col-lg-10 col-md-12 col-sm-12 mb-40">
                <div class="dashboard-card-content">
                    <div class="virtualCard-slider-wrapper">
                        <div class="virtualCard-slider">

                            <div class="swiper-wrapper">

                                @if ($totalCards  < $card_limit || $card_limit == 0)
                                    @include('user.components.cards.remaining.index')
                                @endif

                                @if(virtual_card_system('flutterwave') == "flutterwave")
                                    @include("user.components.cards.flutterwave.index",[
                                        'data'  => $active_virtual_cards_data ?? []
                                    ])
                                @elseif(virtual_card_system('sudo') == "sudo")
                                    @include("user.components.cards.sudo.index",[
                                        'data'  => $active_virtual_cards_data ?? []
                                    ])
                                @elseif(virtual_card_system('stripe') == "stripe")
                                    @include("user.components.cards.stripe.index",[
                                        'data'  => $active_virtual_cards_data ?? []
                                    ])
                                @elseif(virtual_card_system('strowallet') == "strowallet")
                                    @include("user.components.cards.strowallet.index",[
                                        'data'  => $active_virtual_cards_data ?? []
                                    ])
                                @elseif(virtual_card_system('cardyfie') == "cardyfie")
                                    @include("user.components.cards.cardyfie.index",[
                                        'data'  => $active_virtual_cards_data ?? []
                                    ])
                                @endif

                            </div>
                            <div class="slider-nav-area">
                                <div class="slider-prev slider-nav mt-4">
                                    <i class="las la-angle-left"></i>
                                </div>
                                <div class="slider-next slider-nav mt-4">
                                    <i class="las la-angle-right"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        @endif

        <div class="dashboard-item-area">
            <div class="row mb-20-none">
                <div class="col-xxl-3 col-xl-4 col-lg-4 col-md-6 col-sm-6 mb-20">
                    <div class="dashbord-item">
                        <div class="dashboard-content">
                            <span class="sub-title">{{__("Current Balance")}}</span>
                            <h4 class="title">{{ @$baseCurrency->symbol }}{{ authWalletBalance() }}</h4>
                        </div>
                        <div class="dashboard-icon">
                            <i class="las la-dollar-sign"></i>
                        </div>
                    </div>
                </div>
                <div class="col-xxl-3 col-xl-4 col-lg-4 col-md-6 col-sm-6 mb-20">
                    <div class="dashbord-item">
                        <div class="dashboard-content">
                            <span class="sub-title">{{ __("Total Add Money") }}</span>
                            <h4 class="title">{{ @$baseCurrency->symbol }}{{ getAmount($totalAddMoney ?? 0,get_wallet_precision()) }}</h4>
                        </div>
                        <div class="dashboard-icon">
                            <i class="menu-icon las la-cloud-upload-alt"></i>
                        </div>
                    </div>
                </div>
                <div class="col-xxl-3 col-xl-4 col-lg-4 col-md-6 col-sm-6 mb-20">
                    <div class="dashbord-item">
                        <div class="dashboard-content">
                            <span class="sub-title">{{ __("Total Transactions") }}</span>
                            <h4 class="title">{{ @$baseCurrency->symbol }}{{ getAmount($totalTransactions ?? 0,get_wallet_precision()) }}</h4>
                        </div>
                        <div class="dashboard-icon">
                            <i class="menu-icon las la-dollar-sign"></i>
                        </div>
                    </div>
                </div>
                <div class="col-xxl-3 col-xl-4 col-lg-4 col-md-6 col-sm-6 mb-20">
                    <div class="dashbord-item">
                        <div class="dashboard-content">
                            <span class="sub-title">{{ __("Active Tickets") }}</span>
                            <h4 class="title">{{ @$active_tickets }}</h4>
                        </div>
                        <div class="dashboard-icon">
                            <i class="menu-icon las la-recycle"></i>
                        </div>
                    </div>
                </div>
                <div class="col-xxl-3 col-xl-4 col-lg-4 col-md-6 col-sm-6 mb-20">
                    <div class="dashbord-item">
                        <div class="dashboard-content">
                            <span class="sub-title">{{ __("Active Card") }}</span>
                            <h4 class="title">{{ @$virtualCards }}</h4>
                        </div>
                        <div class="dashboard-icon">
                            <i class="menu-icon fas fa-credit-card"></i>
                        </div>
                    </div>
                </div>
                <div class="col-xxl-3 col-xl-4 col-lg-4 col-md-6 col-sm-6 mb-20">
                    <div class="dashbord-item">
                        <div class="dashboard-content">
                            <span class="sub-title">{{ __("Total Gift Cards") }}</span>
                            <h4 class="title">{{ $totalGiftCards }}</h4>
                        </div>
                        <div class="dashboard-icon">
                            <i class="menu-icon las la-credit-card"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="dashboard-list-area mt-60">
        <div class="dashboard-header-wrapper">
            <h4 class="title">{{ __("Latest Transactions") }}</h4>
            <div class="dashboard-btn-wrapper">
                <div class="dashboard-btn">
                    <a href="{{ setRoute('user.transactions.index','virtual-card') }}" class="btn--base">{{__("View More")}}</a>
                </div>
            </div>
        </div>
    </div>
    <div class="dashboard-list-wrapper">
        @include('user.components.transaction-log',compact("transactions"))
    </div>

</div>
@endsection
@push('script')
<script>
    var swiper = new Swiper(".virtualCard-slider", {
            slidesPerView: 1,
            spaceBetween: 60,
            loop: true,
            navigation: {
                nextEl: '.slider-next',
                prevEl: '.slider-prev',
            },
            speed: 1000,
            breakpoints: {
                1199: {
                    slidesPerView: 1,
                },
                991: {
                    slidesPerView: 1,
                },
                767: {
                    slidesPerView: 1,
                },
                575: {
                    slidesPerView: 1,
                },
            }
        });

</script>

@endpush
