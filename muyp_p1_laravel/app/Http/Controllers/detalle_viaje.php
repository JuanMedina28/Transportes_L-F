<?php

namespace App\Http\Controllers;

use App\Models\m_conductor;
use App\Models\m_detalle_viaje;
use App\Models\m_paradas;
use App\Models\m_user;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;

class detalle_viaje extends Controller
{
    
    public function lista_paradas()
    {
        $user =m_conductor::where('id_us', Auth::user()->id)->first();
        if($user){
        $lparadas = DB::table('detalle_viaje')
            ->join("paradas", "paradas.id_dv", "=", "detalle_viaje.id")
            ->join("alumno", "alumno.id", "=", "paradas.id_alm")
            ->select('alumno.*', 'paradas.*')
            ->where('paradas.status', 1)
            ->where('detalle_viaje.status', 1)
            ->where('detalle_viaje.id_conductor', $user->id)
            ->orderBy('paradas.s_abordo')
            ->get();
        return $lparadas;
        }else{
            return 'error';
        }

    }

    public function lista_detalle()
    {
        $user =m_conductor::where('id_us', Auth::user()->id)->first();

        if($user){
        $ldv = DB::table('detalle_viaje')
            ->join("ruta", "ruta.id", "=", "detalle_viaje.id_ruta")
            ->select('detalle_viaje.*', 'ruta.*')
            ->where('detalle_viaje.id_conductor', $user->id)
            ->orderBy('detalle_viaje.status')
            ->get();
        return $ldv;
        }else{
            return 'error';
        }

    }

    public function dpasajero(Request $request)
    {
        $user =m_conductor::where('id_us', Auth::user()->id)->first();

        if($user){
        $lparadas = DB::table('detalle_viaje')
            ->join("paradas", "paradas.id_dv", "=", "detalle_viaje.id")
            ->join("alumno", "alumno.id", "=", "paradas.id_alm")
            ->select('alumno.*', 'paradas.*')
            ->where('paradas.status', 1)
            ->where('detalle_viaje.id', $request->id_v)
            ->where('alumno.id', $request->id_alm)
            ->get();
        return $lparadas;
        }else{
            return 'error';
        }
    }

    public function vs_parada()
    {
        $user =m_conductor::where('id_us', Auth::user()->id)->first();

        if($user){
            $lparadas = DB::table('detalle_viaje')
            ->join("paradas", "paradas.id_dv", "=", "detalle_viaje.id")
            ->join("alumno", "alumno.id", "=", "paradas.id_alm")
            ->select('alumno.*', 'paradas.*')
            ->where('paradas.s_abordo', 2)
            ->where('detalle_viaje.status', 1)
            ->where('detalle_viaje.id', 1)
            ->orderBy('paradas.orden')
            ->first();

        return $lparadas;
        }else{
            return 'error';
        }

    }

    public function ver_viaje()
    {
        $user =m_conductor::where('id_us', Auth::user()->id)->first();

        if($user){
        $lconductor = DB::table('detalle_viaje')
            ->join("conductor", "conductor.id", "=", "detalle_viaje.id_conductor")
            ->join("users", "users.id", "=", "conductor.id_us")
            ->join("unidad", "unidad.id", "=", "detalle_viaje.id_unidad")
            ->join("ruta", "ruta.id", "=", "detalle_viaje.id_ruta")
            ->select('conductor.*', 'unidad.*', 'ruta.*', 'users.*')
            ->where('detalle_viaje.status', 1)
            ->where('detalle_viaje.id_conductor', $user->id)
            ->get();
        return $lconductor;
        }else{
            return 'error';
        }

    }

    public function conductor()
    {
        $user =m_conductor::where('id_us', Auth::user()->id)->first();
        
        if($user){
        $lconductor = DB::table('unidad')
            ->join("conductor", "conductor.id", "=", "unidad.id_conductor")
            ->join("users", "users.id", "=", "conductor.id_us")
            ->select('conductor.*', 'unidad.*','users.*')
            ->where('unidad.status', 1)
            ->where('unidad.id_conductor', $user->id)
            ->get();
        return $lconductor;
        }else{
            return 'error';
        }

    }

    public function abordo(Request $request)
    {
        $lparadas = DB::table('detalle_viaje')
            ->join("paradas", "paradas.id_dv", "=", "detalle_viaje.id")
            ->join("alumno", "alumno.id", "=", "paradas.id_alm")
            ->select('alumno.*', 'paradas.*')
            ->where('paradas.s_abordo', 2)
            ->where('detalle_viaje.status', 1)
            ->where('detalle_viaje.id', $request->id_dv)
            ->orderBy('paradas.orden')
            ->first();

         if($lparadas){
            $mp = m_paradas::where('id',$lparadas->id)->first();
                $mp->s_abordo=1;
                $mp->save();

                $als = m_paradas::where('id_alm',$request->id_alm)->first();
                if($als){
                $als->s_abordo=3;
                $als->save();    
                return 'Todo salio bien';
             }

         } else{
            $als = m_paradas::where('id_alm',$request->id_alm)->first();
            if($als){
            $als->s_abordo=3;
            $als->save();    
            return 'Todo salio xd';
         }
        }  

    }

    public function ver(Request $request)
    {$ver_par = DB::table('detalle_viaje')
        ->join("paradas", "paradas.id_dv", "=", "detalle_viaje.id")
        ->select('paradas.*')
        ->where('paradas.s_abordo', 3)
        ->where('detalle_viaje.status', 1)
        ->where('detalle_viaje.id', $request->id_dv)
        ->orderBy('paradas.orden')
        ->first();

        if($ver_par){
        return $ver_par;
        }else{return 'todo salio mal';}
    }

    public function finalizar(Request $request)
    {
        $lparadas = DB::table('detalle_viaje')
        ->join("paradas", "paradas.id_dv", "=", "detalle_viaje.id")
        ->join("alumno", "alumno.id", "=", "paradas.id_alm")
        ->select('alumno.*', 'paradas.*')
        ->where('paradas.s_abordo', 3)
        ->where('detalle_viaje.status', 1)
        ->where('detalle_viaje.id', $request->id_dv)
        ->orderBy('paradas.orden')
        ->first();
        if($lparadas){

            $als = m_paradas::where('id_alm',$request->id_alm)->first();
            if($als){
                $als->s_abordo=4;
                $als->save();    
                
            }
           /* $ver_par = DB::table('detalle_viaje')
        ->join("paradas", "paradas.id_dv", "=", "detalle_viaje.id")
        ->select('paradas.*')
        ->where('paradas.s_abordo', 3)
        ->where('detalle_viaje.status', 1)
        ->where('detalle_viaje.id', $request->id_dv)
        ->orderBy('paradas.orden')
        ->first();

            if($ver_par){
                $dv = m_detalle_viaje::where('id',$request->id_dv)->first();
                $dv->status=3;
                $dv->save();    
                $al = m_paradas::where('id_dv',$request->id_dv)->get();
                if($al){
                    foreach ($al as $alu) {
                        $alu->status = 2;
                        $alu->save();
                    }
                    return 'venta terminada';
                }
                
            }else{
                return 'Todo salio bien';
            }*/
            return 'Todo salio bien';


        }else{
            return 'algo salio mal ';
        }
    }


    public function sendNotification()
    {
        $url = 'https://fcm.googleapis.com/fcm/send';

        //$FcmToken = User::whereNotNull('device_token')->pluck('device_token')->all();
        $FcmToken = 'eV936YDLREi62WDgqE5Qo_:APA91bHaYjieIfZ1Ep2kvAE1On1YITVdSTTrMK0D7N1i3V4sZaPQIIjAI1VEwAxr4lq3hHk9qaw8VEb6FLMn9KzBRo2WHB9x-L4rkBVZeHsLSkuP8YS_8JBYJVaX1PW40Y-bbOWlzSYp';
            
        $serverKey = 'AAAAh0zMwoo:APA91bEcolUGVpH85XbT_5EeFkfcOWSEjmqx2Ts4FzkfLwxzlcNmGs-OR1ZWfU2dKNuWH7NJCXU_WlFd-kA7VfqELBYitzi4dzIzrMBAo1qcKSDH2zz7vtEo_UVllfY9FMf-DvgXyk2t'; // ADD SERVER KEY HERE PROVIDED BY FCM
       
        $noti = array("title" => 'Siguiente Parada',"body" => 'Hola a todos', );
        $data = array(
            "to" => $FcmToken,
            "notification" => $noti,
            'priority'=>'high'
            );
        $encodedData = json_encode($data);
    
        $headers = [
            'Authorization:key=' .$serverKey,
            'Content-Type: application/json',
        ];
    
        $ch = curl_init();
        
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, 0);
        curl_setopt($ch, CURLOPT_HTTP_VERSION, CURL_HTTP_VERSION_1_1);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
        curl_setopt($ch, CURLOPT_POSTFIELDS, $encodedData);
        // Execute post
        $result = curl_exec($ch);
        if ($result === FALSE) {
            die('Curl failed: ' . curl_error($ch));
        }        
        // Close connection
        curl_close($ch);
        // FCM response
        dd($result);
    }

   

}
