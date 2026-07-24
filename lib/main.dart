import 'package:flutter/material.dart';
import 'login.dart';

void main() {
  runApp(const AplicativoManutencaoIndustrial());
}

class AplicativoManutencaoIndustrial extends StatelessWidget {
  const AplicativoManutencaoIndustrial({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestão de Manutenção Industrial',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFC8C7C2),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF1F3F4),
      ),
      home: const PaginaLogin(),
    );
  }
}