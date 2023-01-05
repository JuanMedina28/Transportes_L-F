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
        Schema::create('destino', function (Blueprint $table) {
            $table->id();
            $table->integer('status');
            $table->bigInteger('id_ins');
            $table->foreign('id_ins')->references('id')->on('instituciones');
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
        Schema::dropIfExists('destino');
    }
};
