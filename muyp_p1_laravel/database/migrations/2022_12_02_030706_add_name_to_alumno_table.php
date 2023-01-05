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
        Schema::table('alumno', function (Blueprint $table) {
            $table->string('nom_al')->nullable();
            $table->string('ap_al')->nullable();
            $table->string('am_al')->nullable();
            $table->integer('edad')->nullable();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::table('alumno', function (Blueprint $table) {
            $table->dropColumn('nom_al');
            $table->dropColumn('ap_al');
            $table->dropColumn('am_al');
            $table->dropColumn('edad');
        });
    }
};
