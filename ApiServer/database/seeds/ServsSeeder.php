<?php

use Illuminate\Database\Seeder;
use Faker\Factory as Faker;

use App\Serv;

class ServsSeeder extends Seeder
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
            $newData = new Serv([
                'text_field1'   => $faker->ipv4,
                'text_field2'   => $faker->domainName,
                'text_field3'   => $faker->date('Y-m-d', 'now'),
                'image_field1'   => $faker->image('public/storage/images', 200, 150, 'business', true)
            ]);

            $newData->save();
        }
    }
}
