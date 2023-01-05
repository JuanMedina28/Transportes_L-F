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
        Schema::table('users', function (Blueprint $table) {
            $table->string('apaterno', 50)->nullable();
            $table->string('amaterno',50)->nullable();
            $table->string('status')->nullable();
            $table->string('tipo')->nullable();
            $table->string('numero')->nullable();
            $table->string('calleyn')->nullable();
            $table->string('municipio')->nullable();
            $table->integer('cp')->nullable();
            $table->string('estado')->nullable();


        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::table('users', function (Blueprint $table) {
            $table->dropColumn('apaterno');
            $table->dropColumn('amaterno');
            $table->dropColumn('status');
            $table->dropColumn('tipo');
            $table->dropColumn('numero');
            $table->dropColumn('calleyn');
            $table->dropColumn('municipio');
            $table->dropColumn('cp');
            $table->dropColumn('estado');
        });
    }
};
