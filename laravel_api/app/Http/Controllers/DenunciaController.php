<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class DenunciaController extends Controller
{
    public function store(Request $request)
    {
        $request->validate([
            'latitude' => 'required|numeric',
            'longitude' => 'required|numeric',
            'tipo_problema' => 'required|string|max:255',
            'descricao' => 'required|string',
            'imagem' => 'nullable|image|max:5120', 
        ]);

        $dados = $request->only(['latitude', 'longitude', 'tipo_problema', 'descricao']);

        if ($request->hasFile('imagem')) {
            $caminho = $request->file('imagem')->store('denuncias', 'public');
            $dados['imagem'] = $caminho;
        }

        

        return response()->json([
            'mensagem' => 'Denúncia recebida com sucesso!',
            'dados' => $dados,
        ], 201);
    }
}
