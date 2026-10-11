

<nav class="navbar-wrapper">
    <div class="dashboard-title-part">
        <div class="left">
            <div class="icon">
                <button class="sidebar-menu-bar">
                    <i class="fas fa-exchange-alt"></i>
                </button>
            </div>

            @yield('breadcrumb')
        </div>
        <div class="right">
            <!-- Dark Mode Toggle -->
            <div class="dark-light header-version-bar" title="Version">
                <i class="las la-sun"></i>
                <i class="las la-moon" style="display: none;"></i>
            </div>
            <div class="language-select">
                @php
                    $session_lan = session('local')??get_default_language_code();
                @endphp

                <select class="nice-select langSel" name="lang_switcher" id="">
                    @foreach($__languages as $item)
                        <option value="{{$item->code}}" @if( $session_lan == $item->code) selected  @endif>{{ $item->name }}</option>
                    @endforeach
                </select>
            </div>
            <div class="header-notification-wrapper">

                <button class="notification-icon">
                    <i class="las la-bell"></i>
                </button>
                <div class="notification-wrapper">
                    <div class="notification-header">
                        <h5 class="title">{{ __("notification") }}</h5>
                    </div>
                    <ul class="notification-list">
                        @foreach (get_user_notifications() ?? [] as $item)
                        <li>
                            <div class="thumb">
                                <img src="{{ auth()->user()->userImage }}" alt="user" />
                            </div>
                            <div class="content">
                                <div class="title-area">
                                    <h5 class="title">{{ __($item->message->title) }}</h5>
                                    <span class="time">{{ $item->created_at->diffForHumans() }}</span>
                                </div>
                                <span class="sub-title">{{ $item->message->message ?? "" }}</span>
                            </div>
                        </li>
                        @endforeach
                    </ul>
                </div>
            </div>
            <div class="header-user-wrapper">
                <div class="header-user-thumb">
                    <a href="{{ setRoute('user.profile.index') }}"><img src="{{ auth()->user()->userImage }}" alt="client" /></a>
                </div>
            </div>
        </div>
    </div>
</nav>


