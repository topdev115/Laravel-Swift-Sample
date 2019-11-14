<?php

use Illuminate\Database\Seeder;
use Faker\Factory as Faker;

use App\Code;

class CodeSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        $faker = Faker::create();

        for ($i = 0; $i < 10; $i++) {
            $newData = new Code([
                'code'   => $faker->numberBetween(1000, 9999)
            ]);

            $newData->save();
        }
    }
}
