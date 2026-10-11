<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('strowallet_customer_kycs', function (Blueprint $table) {
            $table->string('reference')->nullable()->after('occupation');
            $table->string('customer_id')->nullable()->after('reference');
            $table->string('kyc_status', 50)->nullable()->after('customer_id');
            $table->text('completion_link')->nullable()->after('kyc_status');
            $table->string('mode', 20)->nullable()->after('completion_link');
        });
    }

    public function down(): void
    {
        Schema::table('strowallet_customer_kycs', function (Blueprint $table) {
            $table->dropColumn(['reference', 'customer_id', 'kyc_status', 'completion_link', 'mode']);
        });
    }
};
