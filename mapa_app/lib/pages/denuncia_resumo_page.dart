import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mapa_app/pages/home_page.dart';

class DenunciaResumoPage extends StatelessWidget {
  final double latitude;
  final double longitude;
  final String tipoProblema;
  final String descricao;
  final File? imagem;        
  final Uint8List? imagemWeb;

  const DenunciaResumoPage({
    Key? key,
    required this.latitude,
    required this.longitude,
    required this.tipoProblema,
    required this.descricao,
    this.imagem,
    this.imagemWeb,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget? imagemWidget;

    if (kIsWeb && imagemWeb != null) {
      imagemWidget = Image.memory(imagemWeb!, fit: BoxFit.cover);
    } else if (!kIsWeb && imagem != null) {
      imagemWidget = Image.file(imagem!, fit: BoxFit.cover);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resumo da Denúncia'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildCard(
              icon: Icons.report_problem,
              title: 'Tipo de Problema',
              content: tipoProblema,
            ),
            _buildCard(
              icon: Icons.description,
              title: 'Descrição',
              content: descricao,
            ),
            _buildCard(
              icon: Icons.location_on,
              title: 'Localização',
              content: 'Lat: ${latitude.toStringAsFixed(5)}, Lng: ${longitude.toStringAsFixed(5)}',
            ),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 3,
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.image, color: Colors.deepPurple),
                        SizedBox(width: 8),
                        Text('Imagem', style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (imagemWidget != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: SizedBox(
                          height: 200,
                          width: double.infinity,
                          child: imagemWidget,
                        ),
                      )
                    else
                      const Text(
                        'Nenhuma imagem fornecida',
                        style: TextStyle(color: Colors.grey),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          height: 50,
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const HomePage()),
                (route) => false,
              );
            },
            child: const Text(
              'Voltar para a Página Inicial',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.deepPurple),
                const SizedBox(width: 8),
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            Text(content),
           
          ],
          
        ),
        
      ),
      
    );
   
  }
  
}

