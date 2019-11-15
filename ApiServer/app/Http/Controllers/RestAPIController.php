<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\{ClientCode, Main, Serv, Link, AB, LogRequest};

class RestAPIController extends Controller
{

    public function postLogRequest(Request $request) {
        try {
            $code = $request->input('code');
            $ip_address = $request->input('ip_address');
            $ios_version = $request->input('ios_version');

            $valid_code = ClientCode::where('code', '=', $code)->first();

            if ($valid_code != null) {
                $result = $valid_code->status ? "active" : "inactive";
            } else {
                $result = "invalid_code";
            }

            $now = \Carbon\Carbon::now();
            $newLogRequest = new LogRequest([
                'code'   => $code,
                'ip_address'   => $ip_address,
                'ios_version'   => $ios_version,
                'result'   => $result,
                'date'   => $now->toDateString(),
                'time'   => $now->toTimeString()
            ]);

            $newLogRequest->save();

            $response['status'] = true;
            $response['code'] = $code;
            $response['result'] = $result;

        } catch (\Exception $e) {
            $response['status'] = false;
            $response['message'] = $e->getMessage(); //"Server Error";
        }
        
        return response()->json($response);
    }

    public function getInfo(Request $request)
    {
        try {
            $code = $request->input('code');

            $valid_code = ClientCode::where('code', '=', $code)->first();
            if ($valid_code != null) {
                $main = Main::where('code_id', '=', $valid_code->id)->first();
                if ($main != null) {
                    $serv = Serv::where('main_id', '=', $main->id)->get();
                    $link = Link::where('main_id', '=', $main->id)->get();
                    $ab = AB::where('main_id', '=', $main->id)->get();

                    $response['status'] = true;
                    $response['main'] = $main;
                    $response['serv'] = $serv;
                    $response['link'] = $link;
                    $response['ab'] = $ab;
                } else {
                    $response['status'] = false;
                    $response['message'] = "Unable to get information";
                }
            } else {
                $response['status'] = false;
                $response['message'] = "Unable to get information";
            }
        } catch (\Exception $e) {
            $response['status'] = false;
            $response['message'] = $e->getMessage(); //"Server Error";
        }

        return response()->json($response);
    }
}