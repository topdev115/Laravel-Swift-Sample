<?php

use Illuminate\Database\Seeder;
use Faker\Factory as Faker;

use App\Link;

class LinkSeeder extends Seeder
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
            $newData = new Link([
                'text_field1'   => $faker->domainName,
                'text_field2'   => $faker->url
            ]);

            $newData->save();
        }
    }
}
