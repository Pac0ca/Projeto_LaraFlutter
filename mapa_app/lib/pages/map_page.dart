import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mapa_app/pages/denuncia_page.dart';


class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final List<Marker> _marcadores = [];

  void _adicionarMarcador(LatLng ponto) {
    setState(() {
      _marcadores.add(
        Marker(
  point: ponto,
  width: 40,
  height: 40,
  child: const Icon(Icons.location_on, color: Colors.red),
),

      );
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DenunciaPage(
          latitude: ponto.latitude,
          longitude: ponto.longitude,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mapa de Infraestrutura')),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(-2.9083, -41.7754),
          zoom: 13,
          onTap: (tapPosition, latLng) => _adicionarMarcador(latLng),
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: const ['a', 'b', 'c'],
          ),
          MarkerLayer(markers: _marcadores),
        ],
      ),
    );
  }
}
