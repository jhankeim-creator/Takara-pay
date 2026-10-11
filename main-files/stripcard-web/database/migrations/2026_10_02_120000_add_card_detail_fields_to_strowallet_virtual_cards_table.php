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
        Schema::table('strowallet_virtual_cards', function (Blueprint $table) {
            $table->string('card_holder_name')->nullable()->after('card_name');
            $table->string('address')->nullable()->after('customer_email');
            $table->string('city')->nullable()->after('address');
            $table->string('state')->nullable()->after('city');
            $table->string('postal')->nullable()->after('state');
            $table->string('country')->nullable()->after('postal');
            $table->text('card_number_url')->nullable()->after('country');
            $table->text('cvv_url')->nullable()->after('card_number_url');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('strowallet_virtual_cards', function (Blueprint $table) {
            $table->dropColumn([
                'card_holder_name',
                'address',
                'city',
                'state',
                'postal',
                'country',
                'card_number_url',
                'cvv_url',
            ]);
        });
    }
};
