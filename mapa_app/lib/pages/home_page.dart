import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mapa_app/pages/login_page.dart';
import 'package:mapa_app/pages/map_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: isLoggedIn(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        bool loggedIn = snapshot.data!;
        return Scaffold(
          backgroundColor: Colors.deepPurple.shade50,
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
            
                  Text(
                    'InfraestruturaEmFalta',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple.shade900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'IEF',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.deepPurple.shade700,
                      letterSpacing: 5,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Texto dentro do card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.deepPurple.shade100.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Text(
                      'Você já viu um buraco perigoso na rua? Ou um semáforo quebrado?\n'
                      "O 'InfraestruturaEmFalta' é um app feito pra isso: denunciar problemas de infraestrutura urbana.\n"
                      'Basta marcar o local no mapa, escrever o que está errado e, se quiser, enviar uma foto. '
                      'A gente transforma reclamações em melhorias.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: Colors.deepPurple.shade900,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Botão estilizado
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => loggedIn ? const MapPage() : const LoginPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        elevation: 6,
                        shadowColor: Colors.deepPurpleAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        loggedIn ? 'Ir para o Mapa' : 'Login',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 50),

                  // Rodapé
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
      },
    );
  }
}
