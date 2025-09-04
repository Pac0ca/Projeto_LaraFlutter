<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\DenunciaController;
use App\Http\Controllers\MapaController;
use App\Http\Controllers\AuthController;

Route::post('/mapa', [MapaController::class, 'store']);
Route::get('/mapa', [MapaController::class, 'index']);
Route::post('/denuncias', [DenunciaController::class, 'store']);
Route::get('/denuncias', [DenunciaController::class, 'index']);
Route::post('/login', [AuthController::class, 'login']);