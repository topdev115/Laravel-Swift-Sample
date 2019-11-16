<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateMainsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('mains', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->integer('code_id');
            $table->string('first_name', 255)->nullable();
            $table->string('last_name', 255)->nullable();
            $table->string('email')->nullable();
            $table->string('phone_number', 255)->nullable();
            $table->string('birthday', 255)->nullable();
            $table->string('country', 255)->nullable();
            $table->string('address', 255)->nullable();
            $table->string('company', 255)->nullable();
            $table->string('url', 255)->nullable();
            $table->string('credit_card_type', 255)->nullable();
            $table->string('credit_card_number', 255)->nullable();
            $table->string('picture1', 255)->nullable();
            $table->string('picture2', 255)->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('mains');
    }
}
