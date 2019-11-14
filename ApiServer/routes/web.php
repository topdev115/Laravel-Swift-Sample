<?php

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

Route::get('/', function () {
    return view('welcome');
});

Route::post('api/check-code', 'RestAPIController@postCode');
Route::get('api/home-data', 'RestAPIController@getHomeInfo');
Route::get('api/serv-data', 'RestAPIController@getServInfo');
Route::get('api/ab-data', 'RestAPIController@getABInfo');