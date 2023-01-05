<?php

use App\Http\Controllers\detalle_viaje;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Route;

/*
| *****************************************Usuario de Pruebas***************************************
| User: JMedina
| Email: jonny.medina.2806@gmail.com
| Password: Soiber72
|
*/

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});

Route::get('paradas/lista',
    [detalle_viaje::class,'lista_paradas']  
)->middleware("auth:api");

Route::post('paradas/abordo',
    [detalle_viaje::class,'abordo']  
)->middleware("auth:api");

Route::post('paradas/finalizar',
    [detalle_viaje::class,'finalizar']  
)->middleware("auth:api");

Route::get('detalle_v/conductor',
    [detalle_viaje::class,'ver_viaje']  
)->middleware("auth:api");

Route::get('detalle_v/dconductor',
    [detalle_viaje::class,'conductor']  
)->middleware("auth:api");

Route::get('detalle_v/ldv',
    [detalle_viaje::class,'lista_detalle']  
)->middleware("auth:api");

Route::post('detalle_v/ver',
    [detalle_viaje::class,'ver']  
)->middleware("auth:api");

Route::post('detalle_v/datos_pasajero',
    [detalle_viaje::class,'dpasajero']  
)->middleware("auth:api");

Route::get('detalle_v/vs_parada',
    [detalle_viaje::class,'vs_parada']  
)->middleware("auth:api");


Route::get('noti',
    [detalle_viaje::class,'sendNotification']  
)->middleware("auth:api");



Route::post('login', function (Request $request){

    if(Auth::attempt (['email' => $request->email, 'password' => $request->password])){
    
    $user = Auth::user();
    
    $arr = array('acceso' => "Ok", 'error' =>"", 
    'token' => $user->createToken('MyApp')-> accessToken, 'tipo' => $user->tipo);
    
    return json_encode($arr);
    
    } else{
    
    $arr = array('acceso' => "", 'error' => "No existe el usuario o contraseña", 
    'token' => "");
    
    return json_encode($arr);
    }
});

