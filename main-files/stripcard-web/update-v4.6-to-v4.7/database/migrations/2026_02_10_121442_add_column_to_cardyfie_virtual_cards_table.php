<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::table('cardyfie_virtual_cards', function (Blueprint $table) {
            $table->string('wallet_otp')->after('env')->nullable();
            $table->string('wallet_otp_expiry')->after('env')->nullable();
            $table->string('payment_otp')->after('env')->nullable();
            $table->string('payment_expiry')->after('env')->nullable();
            $table->string('cvv')->after('env')->nullable();
            $table->string('real_pan')->after('env')->nullable();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('cardyfie_virtual_cards', function (Blueprint $table) {
            $table->dropColumn(['wallet_otp','wallet_otp_expiry','payment_otp','payment_expiry','cvv','real_pan']);
        });
    }
};
