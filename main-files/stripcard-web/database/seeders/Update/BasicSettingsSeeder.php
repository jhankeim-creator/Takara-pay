<?php

namespace Database\Seeders\Update;

use Exception;
use Illuminate\Database\Seeder;
use App\Models\Admin\BasicSettings;

class BasicSettingsSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        $data = [
            'web_version'  => "4.7.0",
        ];

        $basicSettings = BasicSettings::first();
        $basicSettings->update($data);

        // update language values
        try{
            update_project_localization_data();
        }catch(Exception $e) {
            logger()->error('Error updating localization data: ' . $e->getMessage());
            // handle error
        }

    }
}