<?php

use Illuminate\Database\Seeder;
use Faker\Factory as Faker;

use App\{ClientCode, Main, Serv, Link, AB};

class DBSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        $faker = Faker::create();

        $image_count = 20;
        $image_category = array("cats", "city", "food");
        $image_path = array();
        for ($i = 0; $i < $image_count; $i++) {
            $image_path[] = $faker->image('public/storage/images', 200, 150, $image_category[rand(0,2)], true);
        }

        for ($i = 0; $i < 10; $i++) {
            $newCode = new ClientCode([
                'code'   => $faker->numberBetween(1000, 9999),
                'status'   => $faker->boolean,
                'field1'   => $faker->word,
                'field2'   => $faker->sentence,
                'field3'   => $faker->text(150)
            ]);

            $newCode->save();
            $newCodeId = $newCode->id;

            $newMain = new Main([
                'code_id'   => $newCodeId,
                'firstName'   => $faker->firstName,
                'lastName'   => $faker->lastName,
                'email'   => $faker->email,
                'phoneNumber'   => $faker->phoneNumber,
                'birthday'   => $faker->date('Y-m-d', 'now'),
                'country'   => $faker->country,
                'address'   => $faker->address,
                'company'   => $faker->company,
                'url'   => $faker->url,
                'creditCardType'   => $faker->creditCardType,
                'creditCardNumber'   => $faker->creditCardNumber,
                'picture1'   => $image_path[rand(0, $image_count - 1)],
                'picture2'   => $image_path[rand(0, $image_count - 1)]
            ]);

            $newMain->save();
            $newMainId = $newMain->id;

            for ($j = 0; $j < rand(3, 7); $j++) {
                $newServ = new Serv([
                    'main_id'   => $newMainId,
                    'text_field1'   => $faker->ipv4,
                    'text_field2'   => $faker->domainName,
                    'text_field3'   => $faker->date('Y-m-d', 'now'),
                    'image_field1'   => $image_path[rand(0, $image_count - 1)]
                ]);

                $newServ->save();
            }

            for ($j = 0; $j < rand(3, 7); $j++) {
                $newLink = new Link([
                    'main_id'   => $newMainId,
                    'text_field1'   => $faker->domainName,
                    'text_field2'   => $faker->url
                ]);

                $newLink->save();
            }

            for ($j = 0; $j < rand(3, 7); $j++) {
                $newAB = new AB([
                    'main_id'   => $newMainId,
                    'text_field1'   => $faker->sentence,
                    'text_field2'   => $faker->date('Y-m-d', 'now'),
                    'image_field1'   => $image_path[rand(0, $image_count - 1)]
                ]);

                $newAB->save();
            }

            $this->command->info('Code' . ($i+1) . ' seeded successfully.');
        }
    }
}
