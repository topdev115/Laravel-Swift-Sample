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
            $table->string('firstName', 255)->nullable();
            $table->string('lastName', 255)->nullable();
            $table->string('email')->nullable();
            $table->string('phoneNumber', 255)->nullable();
            $table->string('birthday', 255)->nullable();
            $table->string('country', 255)->nullable();
            $table->string('address', 255)->nullable();
            $table->string('company', 255)->nullable();
            $table->string('url', 255)->nullable();
            $table->string('creditCardType', 255)->nullable();
            $table->string('creditCardNumber', 255)->nullable();
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
