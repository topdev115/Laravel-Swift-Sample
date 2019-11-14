<?php

use Illuminate\Database\Seeder;
use Faker\Factory as Faker;

use App\Main;

class MainSeeder extends Seeder
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
            $newData = new Main([
                'text_field1'   => $faker->firstName,
                'text_field2'   => $faker->lastName,
                'text_field3'   => $faker->email,
                'text_field4'   => $faker->password,
                'text_field5'   => $faker->phoneNumber,
                'text_field6'   => $faker->date('Y-m-d', 'now'),
                'text_field7'   => $faker->ipv4,
                'text_field8'   => $faker->address,
                'text_field9'   => $faker->creditCardType,
                'text_field10'   => $faker->creditCardNumber,
                'text_field11'   => $faker->uuid,
                'image_field1'   => $faker->image('public/storage/images', 200, 150, 'food', true),
                'image_field2'   => $faker->image('public/storage/images', 200, 150, 'city', true)
            ]);

            $newData->save();
        }
    }
}
