<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateABSTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('ab_s', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->integer('main_id');
            $table->string('text_field1', 255)->nullable();
            $table->string('text_field2', 255)->nullable();
            $table->string('image_field1', 255)->nullable();
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
        Schema::dropIfExists('ab_s');
    }
}
