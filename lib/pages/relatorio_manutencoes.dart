import 'package:flutter/material.dart';

class RelatorioManutencoesPage extends StatelessWidget {
  const RelatorioManutencoesPage({super.key});

  static const primaryColor = Color(0xFF454A4D);
  static const backgroundColor = Color(0xFFC8C7C2);
  static const surfaceColor = Color(0xFFF5F4F1);
  static const textColor = Color(0xFF292D2F);
  static const secondaryTextColor = Color(0xFF686B6C);
  static const borderColor = Color(0xFFA8A7A2);
  static const accentColor = Color(0xFF73787A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        surfaceTintColor: primaryColor,
        foregroundColor: Colors.white,
        title: const Text(
          'Relatório de Manutenções',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}