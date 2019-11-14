<?php

use Illuminate\Database\Seeder;
use Faker\Factory as Faker;

use App\AB;

class ABSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        $faker = Faker::create();

        for ($i = 0; $i < 6; $i++) {
            $newData = new AB([
                'text_field1'   => $faker->sentence,
                'text_field2'   => $faker->date('Y-m-d', 'now'),
                'image_field1'   => $faker->image('public/storage/images', 200, 150, 'cats', true)
            ]);

            $newData->save();
        }
    }
}
