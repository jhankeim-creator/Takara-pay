<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('setup_page_has_sections', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('setup_page_id');
            $table->unsignedBigInteger('site_section_id');
            $table->integer('position');
            $table->boolean('status')->default(true);
            $table->timestamps();

            $table->foreign('setup_page_id')->references('id')->on('setup_pages')->onDelete('cascade')->onUpdate('cascade');
            $table->foreign('site_section_id')->references('id')->on('site_sections')->onDelete('cascade')->onUpdate('cascade');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('setup_page_has_sections');
    }
};
