<?php

namespace Database\Seeders\Admin;

use App\Models\VirtualCardApi;
use Illuminate\Database\Seeder;

class VirtualApiSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        $virtual_card_apis = array(
            array('id' => '1','admin_id' => '1','card_details' => '<p>This card is property of StripCard, Wonderland. Misuse is criminal offense. If found, please return to StripCard or to the nearest bank.</p>','config' => '{"flutterwave_secret_key":"FLWSECK_TEST-SANDBOXDEMOKEY-X","flutterwave_secret_hash":"AYxcfvgbhnj@34","flutterwave_url":"https:\\/\\/api.flutterwave.com\\/v3","sudo_api_key":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2NGI2NWExZmZjM2I2NDM5ZjdkNTZjYzIiLCJlbWFpbEFkZHJlc3MiOiJ1c2VyQGFwcGRldnMubmV0IiwianRpIjoiNjlmMzAxMmI5ZTMxZWE5MWVlYjljOWZiIiwibWVtYmVyc2hpcCI6eyJfaWQiOiI2NGI2NWExZmZjM2I2NDM5ZjdkNTZjYzUiLCJidXNpbmVzcyI6eyJfaWQiOiI2NGI2NWExZmZjM2I2NDM5ZjdkNTZjYzAiLCJuYW1lIjoiQXBwZGV2c1giLCJpc0FwcHJvdmVkIjpmYWxzZX0sInVzZXIiOiI2NGI2NWExZmZjM2I2NDM5ZjdkNTZjYzIiLCJyb2xlIjoiQVBJS2V5In0sImlhdCI6MTc3NzUzMzIyNywiZXhwIjoxODA5MDkwODI3fQ.3CBRA0Ul43dzMJtEu7P5JZ2fVjUfHXaar-J425Kvra8","sudo_vault_id":"tntbuyt0v9u","sudo_url":"https:\\/\\/api.sandbox.sudo.cards","sudo_mode":"sandbox","stripe_public_key":"pk_test_51NjGM4K6kUt0AggqD10PfWJcB8NxJmDhDptSqXPpX2d4Xcj7KtXxIrw1zRgK4jI5SIm9ZB7JIhmeYjcTkF7eL8pc00TgiPUGg5","stripe_secret_key":"sk_test_51NjGM4K6kUt0Aggqfejd1Xiixa6HEjQXJNljEwt9QQPOTWoyylaIAhccSBGxWBnvDGw0fptTvGWXJ5kBO7tdpLNG00v5cWHt96","stripe_url":"https:\\/\\/api.stripe.com\\/v1","stripe_mode":"sandbox","strowallet_public_key":"8184e33328538b1357c33b52a8c3e400af4aa243","strowallet_secret_key":"AOC963E385FORPRRCXQJ698C1Q953B","strowallet_url":"https:\\/\\/ziiropay.com\\/api\\/bitvcard\\/","strowallet_mode":"sandbox","cardyfie_public_key":"pub_J1qG2F3TruAgEs8iFz8UMZ7OzUKYEmzddmMTAqg6hcKtdyza1ts1MppVr9ZueOxzy8evCpnEVCM25wwH15m7dzamR2YsHc3QBVpljU9iPKGotcn6Fi47z9yO","cardyfie_secret_key":"sec_AG1QlxddzeNFnvNXCThs1efomqk8dZb3t38XUyda3lSCXdnQdXMyC8rPhHoJhCDEQ5VVeQUzwEiB791NNbnzxGns9D2gSwlgSCYYmj7D3VSeXUhEVqvOVrnF","cardyfie_sandbox_url":"https:\\/\\/core.cardyfie.com\\/api\\/sandbox\\/v1","cardyfie_production_url":"https:\\/\\/core.cardyfie.com\\/api\\/production\\/v1","cardyfie_webhook_secret":"w_sec_7pnoxCxldJNE8Sqzog5nacg5MdKeA7cut59KUqVgzH4AqPfwaUNelcgYl7dPJQf8RJZk8jouADH4SY8Z7BaCCQOTn8UPG23cd46T1YZlRbgWjgHARYq1V4el","cardyfie_universal_card_issues_fee":"3.0000","cardyfie_platinum_card_issues_fee":"5.0000","cardyfie_card_deposit_fixed_fee":"1.0000","cardyfie_card_deposit_percent_fee":"1.0000","cardyfie_card_withdraw_fixed_fee":"1.0000","cardyfie_card_withdraw_percent_fee":"1.0000","cardyfie_card_maintenance_fixed_fee":"0.0000","cardyfie_min_limit":"5.0000","cardyfie_max_limit":"500.0000","cardyfie_daily_limit":"3000.0000","cardyfie_monthly_limit":"6000.0000","cardyfie_mode":"sandbox","name":"strowallet"}','created_at' => '2026-10-02 11:27:43','updated_at' => '2026-10-02 19:01:08','image' => 'seeder/virtual-card.webp','card_limit' => '3')
        );

        VirtualCardApi::insert($virtual_card_apis);
    }
}
