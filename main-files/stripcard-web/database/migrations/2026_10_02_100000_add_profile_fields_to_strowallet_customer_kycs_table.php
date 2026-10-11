<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('strowallet_customer_kycs', function (Blueprint $table) {
            $table->string('account_purpose', 100)->nullable()->after('phone');
            $table->string('employment_status', 100)->nullable()->after('account_purpose');
            $table->string('occupation', 100)->nullable()->after('employment_status');
        });
    }

    public function down(): void
    {
        Schema::table('strowallet_customer_kycs', function (Blueprint $table) {
            $table->dropColumn(['account_purpose', 'employment_status', 'occupation']);
        });
    }
};
