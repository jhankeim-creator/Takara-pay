<?php

namespace Database\Seeders\Update;

use App\Models\Admin\TransactionSetting;
use Illuminate\Database\Seeder;

class TransactionSettingSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        $transaction_settings = array(
            array('admin_id' => '1','slug' => 'withdraw_card','title' => 'Card Withdraw Charges','fixed_charge' => '1.00','percent_charge' => '1.00','min_limit' => '2.00','max_limit' => '10000.00','monthly_limit' => '10000.00','daily_limit' => '1000.00','status' => '1','created_at' => now(),'updated_at' => now()),
        );
        TransactionSetting::upsert($transaction_settings,['slug'],['title']);
    }
}
