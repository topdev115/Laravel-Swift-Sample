<?php

use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     *
     * @return void
     */
    public function run()
    {
        $this->call([
            CodeSeeder::class,
            MainSeeder::class,
            ServsSeeder::class,
            LinkSeeder::class,
            ABSeeder::class
        ]);

        //$this->command->info('Seed successfully.');
    }
}
