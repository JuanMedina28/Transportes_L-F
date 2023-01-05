<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('unidad', function (Blueprint $table) {
            $table->id();
            $table->string('modelo');
            $table->string('color');
            $table->string('placas');
            $table->integer('capacidad');
            $table->string('status');
            $table->bigInteger('id_conductor');
            $table->foreign('id_conductor')->references('id')->on('conductor');
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
        Schema::dropIfExists('unidad');
    }
};
