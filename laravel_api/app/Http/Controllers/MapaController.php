<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Mapa;

class MapaController extends Controller
{
    public function store(Request $request)
    {
        $request->validate([
            'latitude' => 'required|numeric',
            'longitude' => 'required|numeric',
        ]);

        return Mapa::create([
            'latitude' => $request->latitude,
            'longitude' => $request->longitude,
        ]);
    }

    public function index()
    {
        return Mapa::all();
    }
}
