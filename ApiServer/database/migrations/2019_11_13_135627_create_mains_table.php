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
            $table->string('text_field1', 255)->nullable();
            $table->string('text_field2', 255)->nullable();
            $table->string('text_field3', 255)->nullable();
            $table->string('text_field4', 255)->nullable();
            $table->string('text_field5', 255)->nullable();
            $table->string('text_field6', 255)->nullable();
            $table->string('text_field7', 255)->nullable();
            $table->string('text_field8', 255)->nullable();
            $table->string('text_field9', 255)->nullable();
            $table->string('text_field10', 255)->nullable();
            $table->string('text_field11', 255)->nullable();
            $table->string('image_field1', 255)->nullable();
            $table->string('image_field2', 255)->nullable();
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
