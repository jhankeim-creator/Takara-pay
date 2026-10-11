<?php

namespace App\Constants;

class GlobalConst {
    const USER_PASS_RESEND_TIME_MINUTE = "1";
    const USER_VERIFY_RESEND_TIME_MINUTE = 1;


    const SUCCESS = true;

    const USER      = "USER";
    const ADMIN = "ADMIN";

    const ACTIVE = true;
    const BANNED = false;
    const DEFAULT_TOKEN_EXP_SEC = 3600;

    const VERIFIED = 1;
    const APPROVED = 1;
    const PENDING = 2;
    const REJECTED = 3;
    const DEFAULT = 0;
    const UNVERIFIED = 0;
    const SETUP_PAGE = 'SETUP_PAGE';
    const USEFUL_LINKS = 'USEFUL_LINKS';

    const LIVE = 'live';
    const SANDBOX = 'sandbox';
    const ENV_SANDBOX           = "sandbox";
    const ENV_PRODUCTION        = "production";
    const SYSTEM_MAINTENANCE       = "system-maintenance";
    const CURRENCY_LAYER       = "CURRENCY-LAYER";

    const CARD_UNDER_STATUS     = "unreview kyc";
    const CARD_LOW_KYC_STATUS   = "low kyc";
    const CARD_HIGH_KYC_STATUS  = "high kyc";

    const TERMINATED            = 'virtualcard.transaction.declined.terminated';
    const CROSSBORDER           = 'virtualcard.transaction.crossborder';
    const DECLINED              = 'virtualcard.transaction.declined';

    //cardyfie

    const CARD_CUSTOMER_APPROVED_STATUS = "APPROVED";
    const CARD_CUSTOMER_PENDING_STATUS  = "PENDING";
    const CARD_CUSTOMER_REJECTED_STATUS = "REJECTED";


    const CARD_PROCESSING_STATUS = "PROCESSING";
    const CARD_ENABLED_STATUS = "ENABLED";
    const CARD_FREEZE_STATUS  = "FREEZE";
    const CARD_CLOSED_STATUS = "CLOSED";

    const UNIVERSAL_TIER = "universal";
    const PLATINUM_TIER = "platinum";

    const APP  = "APP";
    const WEB  = "WEB";
}
