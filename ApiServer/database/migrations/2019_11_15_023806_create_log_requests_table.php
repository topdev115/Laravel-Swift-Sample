<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateLogRequestsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('log_requests', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->string('code', 4)->nullable();
            $table->string('ip_address', 64)->nullable();
            $table->string('ios_version', 32)->nullable();
            $table->string('result', 16)->nullable();
            $table->string('time', 32);
            $table->string('date', 32);
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
        Schema::dropIfExists('log_requests');
    }
}
