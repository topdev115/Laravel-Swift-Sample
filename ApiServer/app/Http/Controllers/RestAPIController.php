<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Main;
use App\Serv;
use App\Link;
use App\AB;
use App\Code;

class RestAPIController extends Controller
{
    public function postCode(Request $request)
    {
        $code = $request->input('code');
        try {
            $valid_code = Code::where('code', '=', $code)->first();
            if ($valid_code != null) {
                $response['checked'] = true;
                $response['status'] = true;
            } else {
                $response['checked'] = false;
                $response['status'] = true;
            }
        } catch (\Exception $e) {
            $response['status'] = false;
            $response['message'] = $e->getMessage();
        }
        
        return response()->json($response);
    }

    public function getHomeInfo(Request $request)
    {
        try {
            $response['main'] = Main::all();
            $response['link'] = Link::all();
            $response['status'] = true;
        } catch (\Exception $e) {
            $response['status'] = false;
            $response['message'] = "Unable to get information";
        }

        return response()->json($response);
    }

    public function getServInfo(Request $request)
    {
        try {
            $response['data'] = Serv::all();
            $response['status'] = true;
        } catch (\Exception $e) {
            $response['status'] = false;
            $response['message'] = "Unable to get information";
        }

        return response()->json($response);
    }

    public function getABInfo(Request $request)
    {
        try {
            $response['data'] = AB::all();
            $response['status'] = true;
        } catch (\Exception $e) {
            $response['status'] = false;
            $response['message'] = "Unable to get information";
        }
        
        return response()->json($response);
    }
}
