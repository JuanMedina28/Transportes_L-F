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
        Schema::create('paradas', function (Blueprint $table) {
            $table->id();
            $table->integer('status');
            $table->string('latitud');
            $table->string('longitud');
            $table->bigInteger('id_alm');
            $table->foreign('id_alm')->references('id')->on('alumno');
            $table->bigInteger('id_dv');
            $table->foreign('id_dv')->references('id')->on('detalle_viaje');
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
        Schema::dropIfExists('paradas');
    }
};
