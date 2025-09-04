import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:mapa_app/pages/home_page.dart';
import 'package:mapa_app/pages/denuncia_resumo_page.dart';


class DenunciaPage extends StatefulWidget {
  final double latitude;
  final double longitude;

  const DenunciaPage({
    Key? key,
    required this.latitude,
    required this.longitude,
  }) : super(key: key);

  @override
  State<DenunciaPage> createState() => _DenunciaPageState();
}

class _DenunciaPageState extends State<DenunciaPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descricaoController = TextEditingController();
  File? _imagemFile;
  Uint8List? _imagemBytes; // Para web
  final ImagePicker _picker = ImagePicker();

  String? _tipoProblema;
  final List<String> _tiposDeProblema = [
    'Buraco na via',
    'Falta de sinalização',
    'Semáforo quebrado',
    'Iluminação pública apagada',
    'Acúmulo de lixo',
    'Calçada danificada',
    'Alagamento constante',
    'Esgoto a céu aberto',
    'Poda de árvores necessária',
    'Obstrução de via',
    'Fiação exposta',
    'Ponto de ônibus danificado',
    'Outros',
  ];

  @override
  void initState() {
    super.initState();
    _tipoProblema = _tiposDeProblema.first;
  }

  Future<void> _selecionarImagem() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _imagemBytes = bytes;
        });
      } else {
        setState(() {
          _imagemFile = File(pickedFile.path);
        });
      }
    }
  }

  Future<bool> enviarDenuncia({
    required double latitude,
    required double longitude,
    required String tipoProblema,
    required String descricao,
    File? imagem,
  }) async {
    final uri = Uri.parse('http://127.0.0.1:8000/api/denuncias');

    var request = http.MultipartRequest('POST', uri);
    request.fields['latitude'] = latitude.toString();
    request.fields['longitude'] = longitude.toString();
    request.fields['tipo_problema'] = tipoProblema;
    request.fields['descricao'] = descricao;

    if (!kIsWeb && imagem != null) {
      request.files.add(await http.MultipartFile.fromPath('imagem', imagem.path));
    }

    try {
      var response = await request.send();
      if (response.statusCode == 201) {
        return true;
      } else {
        print('Erro ao enviar denúncia: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Erro ao enviar denúncia: $e');
      return false;
    }
  }

  void _enviarDenuncia() async {
    if (_formKey.currentState!.validate()) {
      bool sucesso = await enviarDenuncia(
        latitude: widget.latitude,
        longitude: widget.longitude,
        tipoProblema: _tipoProblema!,
        descricao: _descricaoController.text,
        imagem: _imagemFile,
      );

      if (sucesso) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Denúncia enviada com sucesso!')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => DenunciaResumoPage(
              latitude: widget.latitude,
              longitude: widget.longitude,
              tipoProblema: _tipoProblema!,
              descricao: _descricaoController.text,
              imagem: _imagemFile,
              imagemWeb: _imagemBytes,
    ),
  ),
);



      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Falha ao enviar denúncia.')),
        );
      }
    }
  }

  @override
  void dispose() {
    _descricaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Denúncia'),
        backgroundColor: Colors.deepPurple,
        elevation: 3,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              Text(
                'Localização: (${widget.latitude.toStringAsFixed(5)}, ${widget.longitude.toStringAsFixed(5)})',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 24),

              DropdownButtonFormField<String>(
                value: _tipoProblema,
                items: _tiposDeProblema.map((tipo) {
                  return DropdownMenuItem(
                    value: tipo,
                    child: Text(tipo),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _tipoProblema = value),
                decoration: InputDecoration(
                  labelText: 'Tipo de problema',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.deepPurple.shade50,
                  prefixIcon: const Icon(Icons.report_problem, color: Colors.deepPurple),
                ),
                validator: (value) =>
                    value == null ? 'Selecione um tipo de problema' : null,
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: _descricaoController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Descrição do problema',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.deepPurple.shade50,
                  prefixIcon: const Icon(Icons.description, color: Colors.deepPurple),
                  alignLabelWithHint: true,
                ),
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'Por favor, descreva o problema' : null,
              ),

              const SizedBox(height: 20),

              (_imagemFile == null && _imagemBytes == null)
                  ? ElevatedButton.icon(
                      onPressed: _selecionarImagem,
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Selecionar imagem', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    )
                  : Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: kIsWeb
                              ? Image.memory(_imagemBytes!, height: 160, fit: BoxFit.cover)
                              : Image.file(_imagemFile!, height: 160, fit: BoxFit.cover),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _imagemFile = null;
                              _imagemBytes = null;
                            });
                          },
                          child: const Text('Remover imagem'),
                        ),
                      ],
                    ),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: _enviarDenuncia,
                child: const Text(
                  'Enviar denúncia',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const HomePage()),
                    (route) => false,
                  );
                },
                child: const Text('Voltar para Início'),
                
              ),
              Text(
                    '© 2025 InfraestruturaEmFalta - Todos os direitos reservados',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.deepPurple.shade300,
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
