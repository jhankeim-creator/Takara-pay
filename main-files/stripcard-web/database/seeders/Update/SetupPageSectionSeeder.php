<?php

namespace Database\Seeders\Update;

use App\Models\Admin\SetupPageHasSection;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class SetupPageSectionSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        /* `TAKARA PAY`.`setup_page_has_sections` */
        $setup_page_has_sections = [
            ['id' => '1', 'setup_page_id' => '1', 'site_section_id' => '2', 'position' => '1', 'status' => '1', 'created_at' => '2025-09-01 10:04:17', 'updated_at' => '2025-09-01 10:04:17'],
            ['id' => '2', 'setup_page_id' => '1', 'site_section_id' => '3', 'position' => '7', 'status' => '0', 'created_at' => '2025-09-01 10:04:17', 'updated_at' => '2025-09-01 10:12:33'],
            ['id' => '3', 'setup_page_id' => '1', 'site_section_id' => '4', 'position' => '8', 'status' => '0', 'created_at' => '2025-09-01 10:04:17', 'updated_at' => '2025-09-01 10:12:33'],
            ['id' => '4', 'setup_page_id' => '1', 'site_section_id' => '7', 'position' => '9', 'status' => '0', 'created_at' => '2025-09-01 10:04:17', 'updated_at' => '2025-09-01 10:12:33'],
            ['id' => '5', 'setup_page_id' => '1', 'site_section_id' => '8', 'position' => '4', 'status' => '1', 'created_at' => '2025-09-01 10:04:17', 'updated_at' => '2025-09-01 10:12:33'],
            ['id' => '6', 'setup_page_id' => '1', 'site_section_id' => '9', 'position' => '2', 'status' => '1', 'created_at' => '2025-09-01 10:04:17', 'updated_at' => '2025-09-01 10:12:33'],
            ['id' => '7', 'setup_page_id' => '1', 'site_section_id' => '5', 'position' => '10', 'status' => '0', 'created_at' => '2025-09-01 10:04:17', 'updated_at' => '2025-09-01 10:12:33'],
            ['id' => '8', 'setup_page_id' => '1', 'site_section_id' => '10', 'position' => '11', 'status' => '0', 'created_at' => '2025-09-01 10:04:17', 'updated_at' => '2025-09-01 10:12:33'],
            ['id' => '9', 'setup_page_id' => '1', 'site_section_id' => '11', 'position' => '12', 'status' => '0', 'created_at' => '2025-09-01 10:04:17', 'updated_at' => '2025-09-01 10:12:33'],
            ['id' => '10', 'setup_page_id' => '1', 'site_section_id' => '12', 'position' => '5', 'status' => '1', 'created_at' => '2025-09-01 10:04:17', 'updated_at' => '2025-09-01 10:12:33'],
            ['id' => '11', 'setup_page_id' => '1', 'site_section_id' => '13', 'position' => '6', 'status' => '1', 'created_at' => '2025-09-01 10:04:17', 'updated_at' => '2025-09-01 10:12:33'],
            ['id' => '12', 'setup_page_id' => '1', 'site_section_id' => '14', 'position' => '3', 'status' => '1', 'created_at' => '2025-09-01 10:04:17', 'updated_at' => '2025-09-01 10:12:33'],
            ['id' => '13', 'setup_page_id' => '1', 'site_section_id' => '15', 'position' => '13', 'status' => '0', 'created_at' => '2025-09-01 10:04:17', 'updated_at' => '2025-09-01 10:12:33'],
            ['id' => '14', 'setup_page_id' => '2', 'site_section_id' => '3', 'position' => '1', 'status' => '1', 'created_at' => '2025-09-01 10:15:32', 'updated_at' => '2025-09-01 10:15:32'],
            ['id' => '15', 'setup_page_id' => '2', 'site_section_id' => '4', 'position' => '2', 'status' => '1', 'created_at' => '2025-09-01 10:15:32', 'updated_at' => '2025-09-01 10:15:32'],
            ['id' => '16', 'setup_page_id' => '2', 'site_section_id' => '15', 'position' => '3', 'status' => '1', 'created_at' => '2025-09-01 10:15:32', 'updated_at' => '2025-09-01 10:15:32'],
            ['id' => '17', 'setup_page_id' => '2', 'site_section_id' => '2', 'position' => '4', 'status' => '0', 'created_at' => '2025-09-01 10:15:32', 'updated_at' => '2025-09-01 10:15:32'],
            ['id' => '18', 'setup_page_id' => '2', 'site_section_id' => '5', 'position' => '5', 'status' => '0', 'created_at' => '2025-09-01 10:15:32', 'updated_at' => '2025-09-01 10:15:32'],
            ['id' => '19', 'setup_page_id' => '2', 'site_section_id' => '7', 'position' => '6', 'status' => '0', 'created_at' => '2025-09-01 10:15:32', 'updated_at' => '2025-09-01 10:15:32'],
            ['id' => '20', 'setup_page_id' => '2', 'site_section_id' => '8', 'position' => '7', 'status' => '0', 'created_at' => '2025-09-01 10:15:32', 'updated_at' => '2025-09-01 10:15:32'],
            ['id' => '21', 'setup_page_id' => '2', 'site_section_id' => '9', 'position' => '8', 'status' => '0', 'created_at' => '2025-09-01 10:15:32', 'updated_at' => '2025-09-01 10:15:32'],
            ['id' => '22', 'setup_page_id' => '2', 'site_section_id' => '10', 'position' => '9', 'status' => '0', 'created_at' => '2025-09-01 10:15:32', 'updated_at' => '2025-09-01 10:15:32'],
            ['id' => '23', 'setup_page_id' => '2', 'site_section_id' => '11', 'position' => '10', 'status' => '0', 'created_at' => '2025-09-01 10:15:32', 'updated_at' => '2025-09-01 10:15:32'],
            ['id' => '24', 'setup_page_id' => '2', 'site_section_id' => '12', 'position' => '11', 'status' => '0', 'created_at' => '2025-09-01 10:15:32', 'updated_at' => '2025-09-01 10:15:32'],
            ['id' => '25', 'setup_page_id' => '2', 'site_section_id' => '13', 'position' => '12', 'status' => '0', 'created_at' => '2025-09-01 10:15:32', 'updated_at' => '2025-09-01 10:15:32'],
            ['id' => '26', 'setup_page_id' => '2', 'site_section_id' => '14', 'position' => '13', 'status' => '0', 'created_at' => '2025-09-01 10:15:32', 'updated_at' => '2025-09-01 10:15:32'],
            ['id' => '27', 'setup_page_id' => '3', 'site_section_id' => '2', 'position' => '2', 'status' => '0', 'created_at' => '2025-09-01 10:16:12', 'updated_at' => '2025-09-01 10:18:28'],
            ['id' => '28', 'setup_page_id' => '3', 'site_section_id' => '9', 'position' => '1', 'status' => '1', 'created_at' => '2025-09-01 10:16:12', 'updated_at' => '2025-09-01 10:18:28'],
            ['id' => '29', 'setup_page_id' => '3', 'site_section_id' => '3', 'position' => '3', 'status' => '0', 'created_at' => '2025-09-01 10:16:12', 'updated_at' => '2025-09-01 10:16:12'],
            ['id' => '30', 'setup_page_id' => '3', 'site_section_id' => '4', 'position' => '4', 'status' => '0', 'created_at' => '2025-09-01 10:16:12', 'updated_at' => '2025-09-01 10:16:12'],
            ['id' => '31', 'setup_page_id' => '3', 'site_section_id' => '5', 'position' => '5', 'status' => '0', 'created_at' => '2025-09-01 10:16:12', 'updated_at' => '2025-09-01 10:16:12'],
            ['id' => '32', 'setup_page_id' => '3', 'site_section_id' => '7', 'position' => '6', 'status' => '0', 'created_at' => '2025-09-01 10:16:12', 'updated_at' => '2025-09-01 10:16:12'],
            ['id' => '33', 'setup_page_id' => '3', 'site_section_id' => '8', 'position' => '7', 'status' => '0', 'created_at' => '2025-09-01 10:16:12', 'updated_at' => '2025-09-01 10:16:12'],
            ['id' => '34', 'setup_page_id' => '3', 'site_section_id' => '10', 'position' => '8', 'status' => '0', 'created_at' => '2025-09-01 10:16:12', 'updated_at' => '2025-09-01 10:16:12'],
            ['id' => '35', 'setup_page_id' => '3', 'site_section_id' => '11', 'position' => '9', 'status' => '0', 'created_at' => '2025-09-01 10:16:12', 'updated_at' => '2025-09-01 10:16:12'],
            ['id' => '36', 'setup_page_id' => '3', 'site_section_id' => '12', 'position' => '10', 'status' => '0', 'created_at' => '2025-09-01 10:16:12', 'updated_at' => '2025-09-01 10:16:12'],
            ['id' => '37', 'setup_page_id' => '3', 'site_section_id' => '13', 'position' => '11', 'status' => '0', 'created_at' => '2025-09-01 10:16:12', 'updated_at' => '2025-09-01 10:16:12'],
            ['id' => '38', 'setup_page_id' => '3', 'site_section_id' => '14', 'position' => '12', 'status' => '0', 'created_at' => '2025-09-01 10:16:13', 'updated_at' => '2025-09-01 10:16:13'],
            ['id' => '39', 'setup_page_id' => '3', 'site_section_id' => '15', 'position' => '13', 'status' => '0', 'created_at' => '2025-09-01 10:16:13', 'updated_at' => '2025-09-01 10:16:13'],
            ['id' => '40', 'setup_page_id' => '4', 'site_section_id' => '11', 'position' => '1', 'status' => '1', 'created_at' => '2025-09-01 10:16:58', 'updated_at' => '2025-09-01 10:16:58'],
            ['id' => '41', 'setup_page_id' => '4', 'site_section_id' => '2', 'position' => '2', 'status' => '0', 'created_at' => '2025-09-01 10:16:58', 'updated_at' => '2025-09-01 10:16:58'],
            ['id' => '42', 'setup_page_id' => '4', 'site_section_id' => '3', 'position' => '3', 'status' => '0', 'created_at' => '2025-09-01 10:16:58', 'updated_at' => '2025-09-01 10:16:58'],
            ['id' => '43', 'setup_page_id' => '4', 'site_section_id' => '4', 'position' => '4', 'status' => '0', 'created_at' => '2025-09-01 10:16:58', 'updated_at' => '2025-09-01 10:16:58'],
            ['id' => '44', 'setup_page_id' => '4', 'site_section_id' => '5', 'position' => '5', 'status' => '0', 'created_at' => '2025-09-01 10:16:58', 'updated_at' => '2025-09-01 10:16:58'],
            ['id' => '45', 'setup_page_id' => '4', 'site_section_id' => '7', 'position' => '6', 'status' => '0', 'created_at' => '2025-09-01 10:16:58', 'updated_at' => '2025-09-01 10:16:58'],
            ['id' => '46', 'setup_page_id' => '4', 'site_section_id' => '8', 'position' => '7', 'status' => '0', 'created_at' => '2025-09-01 10:16:58', 'updated_at' => '2025-09-01 10:16:58'],
            ['id' => '47', 'setup_page_id' => '4', 'site_section_id' => '9', 'position' => '8', 'status' => '0', 'created_at' => '2025-09-01 10:16:59', 'updated_at' => '2025-09-01 10:16:59'],
            ['id' => '48', 'setup_page_id' => '4', 'site_section_id' => '10', 'position' => '9', 'status' => '0', 'created_at' => '2025-09-01 10:16:59', 'updated_at' => '2025-09-01 10:16:59'],
            ['id' => '49', 'setup_page_id' => '4', 'site_section_id' => '12', 'position' => '10', 'status' => '0', 'created_at' => '2025-09-01 10:16:59', 'updated_at' => '2025-09-01 10:16:59'],
            ['id' => '50', 'setup_page_id' => '4', 'site_section_id' => '13', 'position' => '11', 'status' => '0', 'created_at' => '2025-09-01 10:16:59', 'updated_at' => '2025-09-01 10:16:59'],
            ['id' => '51', 'setup_page_id' => '4', 'site_section_id' => '14', 'position' => '12', 'status' => '0', 'created_at' => '2025-09-01 10:16:59', 'updated_at' => '2025-09-01 10:16:59'],
            ['id' => '52', 'setup_page_id' => '4', 'site_section_id' => '15', 'position' => '13', 'status' => '0', 'created_at' => '2025-09-01 10:16:59', 'updated_at' => '2025-09-01 10:16:59'],
            ['id' => '53', 'setup_page_id' => '5', 'site_section_id' => '5', 'position' => '1', 'status' => '1', 'created_at' => '2025-09-01 10:17:13', 'updated_at' => '2025-09-01 10:17:13'],
            ['id' => '54', 'setup_page_id' => '5', 'site_section_id' => '2', 'position' => '2', 'status' => '0', 'created_at' => '2025-09-01 10:17:13', 'updated_at' => '2025-09-01 10:17:13'],
            ['id' => '55', 'setup_page_id' => '5', 'site_section_id' => '3', 'position' => '3', 'status' => '0', 'created_at' => '2025-09-01 10:17:13', 'updated_at' => '2025-09-01 10:17:13'],
            ['id' => '56', 'setup_page_id' => '5', 'site_section_id' => '4', 'position' => '4', 'status' => '0', 'created_at' => '2025-09-01 10:17:13', 'updated_at' => '2025-09-01 10:17:13'],
            ['id' => '57', 'setup_page_id' => '5', 'site_section_id' => '7', 'position' => '5', 'status' => '0', 'created_at' => '2025-09-01 10:17:13', 'updated_at' => '2025-09-01 10:17:13'],
            ['id' => '58', 'setup_page_id' => '5', 'site_section_id' => '8', 'position' => '6', 'status' => '0', 'created_at' => '2025-09-01 10:17:13', 'updated_at' => '2025-09-01 10:17:13'],
            ['id' => '59', 'setup_page_id' => '5', 'site_section_id' => '9', 'position' => '7', 'status' => '0', 'created_at' => '2025-09-01 10:17:13', 'updated_at' => '2025-09-01 10:17:13'],
            ['id' => '60', 'setup_page_id' => '5', 'site_section_id' => '10', 'position' => '8', 'status' => '0', 'created_at' => '2025-09-01 10:17:13', 'updated_at' => '2025-09-01 10:17:13'],
            ['id' => '61', 'setup_page_id' => '5', 'site_section_id' => '11', 'position' => '9', 'status' => '0', 'created_at' => '2025-09-01 10:17:13', 'updated_at' => '2025-09-01 10:17:13'],
            ['id' => '62', 'setup_page_id' => '5', 'site_section_id' => '12', 'position' => '10', 'status' => '0', 'created_at' => '2025-09-01 10:17:13', 'updated_at' => '2025-09-01 10:17:13'],
            ['id' => '63', 'setup_page_id' => '5', 'site_section_id' => '13', 'position' => '11', 'status' => '0', 'created_at' => '2025-09-01 10:17:13', 'updated_at' => '2025-09-01 10:17:13'],
            ['id' => '64', 'setup_page_id' => '5', 'site_section_id' => '14', 'position' => '12', 'status' => '0', 'created_at' => '2025-09-01 10:17:13', 'updated_at' => '2025-09-01 10:17:13'],
            ['id' => '65', 'setup_page_id' => '5', 'site_section_id' => '15', 'position' => '13', 'status' => '0', 'created_at' => '2025-09-01 10:17:13', 'updated_at' => '2025-09-01 10:17:13'],
        ];

        SetupPageHasSection::upsert($setup_page_has_sections,['id']);

    }
}
