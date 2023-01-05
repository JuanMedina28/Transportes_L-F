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
        Schema::create('detalle_viaje', function (Blueprint $table) {
            $table->id();
            $table->integer('status');
            $table->integer('capacidad');
            $table->string('fecha');
            $table->string('hora_inicio');
            $table->string('hora_termino');
            $table->bigInteger('id_ruta');
            $table->foreign('id_ruta')->references('id')->on('ruta');            
            $table->bigInteger('id_unidad');
            $table->foreign('id_unidad')->references('id')->on('unidad');
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
        Schema::dropIfExists('detalle_viaje');
    }
};
