<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class LogRequest extends Model
{
    protected $fillable = ['code', 'ip_address', 'ios_version', 'result', 'date', 'time'];
}
