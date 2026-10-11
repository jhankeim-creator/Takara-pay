<?php

namespace App\Constants;

class SiteSectionConst{
    const AUTH_SECTION = "Auth Section";
    const APP_SECTION           = "App Section";
    const HOME_BANNER           = "Home Banner";
    const ABOUT_SECTION         = "About Section";
    const OUR_FEATURE           = "Our Features";
    const WORK_SECTION          = "Work Section";
    const SERVICE_SECTION       = "Service Section";
    const CHOOSE_US_SECTION     = "Choose Us Section";
    const TESTIMONIAL_SECTION   = "Testimonials Section";
    const FAQ_SECTION           = "FAQ Section";
    const START_SECTION         = "START Section";
    const CONTACT_SECTION       = "Contact";
    const FOOTER_SECTION        = "Footer Section";
    const BLOG_SECTION          = "Blog Section";
    const STATISTICS_SECTION    = "Statistics Section";


    const NOT_DISPLAY_COOKIE_SECTION     = "site_cookie";
    const NOT_DISPLAY_AUTH_SECTION       = "auth-section";
    const NOT_DISPLAY_FOOTER_SECTION     = "footer-section";

    public static function notDisplaySections(): array{
        return [
            self::NOT_DISPLAY_COOKIE_SECTION,
            self::NOT_DISPLAY_AUTH_SECTION,
            self::NOT_DISPLAY_FOOTER_SECTION
        ];
    }

}

