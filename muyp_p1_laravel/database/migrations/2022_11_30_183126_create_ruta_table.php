<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up()
    {
        Schema::create('ruta', function (Blueprint $table) {
            $table->id();
            $table->string('nom_ruta');
            $table->string('destino');
            $table->string('punto_partida');
            $table->timestamps();
        });
    }

    public function down()
    {
        Schema::dropIfExists('ruta');
    }
};
