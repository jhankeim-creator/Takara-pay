<?php

namespace Database\Seeders\Update;

use Exception;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\File;

class VersionUpdateSeeder extends Seeder
{
    /**
     * Seed the application's database.
     *
     * @return void
     */
    public function run()
    {

        //version Update Seeders
        $this->call([
            AppSettingsSeeder::class,
            BasicSettingsSeeder::class,
            VirtualApiSeeder::class,
        ]);
    }


}
