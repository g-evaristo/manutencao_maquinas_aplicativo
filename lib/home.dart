
import 'package:flutter/material.dart';
import 'login.dart';
import 'pages/cadastro_funcionarios.dart';
import 'pages/cadastro_maquinas.dart';
import 'pages/cadastro_manutencoes.dart';
import 'pages/cadastro_setores.dart';
import 'pages/relatorio_funcionarios.dart';
import 'pages/relatorio_maquinas.dart';
import 'pages/relatorio_manutencoes.dart';
import 'pages/relatorio_setores.dart';
import 'pages/relatorio_geral.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const primaryColor = Color(0xFF454A4D);
  static const backgroundColor = Color(0xFFC8C7C2);
  static const surfaceColor = Color(0xFFF5F4F1);
  static const textColor = Color(0xFF292D2F);
  static const secondaryTextColor = Color(0xFF686B6C);
  static const borderColor = Color(0xFFA8A7A2);
  static const accentColor = Color(0xFF73787A);

  @override
  Widget build(BuildContext context) {
    final cadastros = [
      HomeOption(
        title: 'Máquinas',
        icon: Icons.precision_manufacturing_outlined,
        page: (_) => const CadastroMaquinasPage(),
      ),
      HomeOption(
        title: 'Manutenções',
        icon: Icons.build_circle_outlined,
        page: (_) => const CadastroManutencoesPage(),
      ),
      HomeOption(
        title: 'Funcionários',
        icon: Icons.engineering_outlined,
        page: (_) => const CadastroFuncionariosPage(),
      ),
      HomeOption(
        title: 'Setores',
        icon: Icons.factory_outlined,
        page: (_) => const CadastroSetoresPage(),
      ),
    ];

    final relatorios = [
      HomeOption(
        title: 'Máquinas',
        icon: Icons.precision_manufacturing_outlined,
        page: (_) => const RelatorioMaquinasPage(),
      ),
      HomeOption(
        title: 'Manutenções',
        icon: Icons.build_circle_outlined,
        page: (_) => const RelatorioManutencoesPage(),
      ),
      HomeOption(
        title: 'Funcionários',
        icon: Icons.engineering_outlined,
        page: (_) => const RelatorioFuncionariosPage(),
      ),
      HomeOption(
        title: 'Setores',
        icon: Icons.factory_outlined,
        page: (_) => const RelatorioSetoresPage(),
      ),
      HomeOption(
        title: 'Visão geral',
        icon: Icons.monitor_heart_outlined,
        page: (_) => const RelatorioGeralPage(),
      ),
    ];

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        surfaceTintColor: primaryColor,
        title: const Row(
          children: [
            Icon(
              Icons.settings_suggest_outlined,
              color: Colors.white,
            ),
            SizedBox(width: 12),
            Text(
              'Manutenção Industrial',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const PaginaLogin(),
                ),
              );
            },
            tooltip: 'Sair',
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Painel de manutenção',
              style: TextStyle(
                color: textColor,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Gerencie máquinas, setores e atividades de manutenção',
              style: TextStyle(
                color: secondaryTextColor,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 32),
            const SectionTitle(
              title: 'Relatórios e monitoramento',
              icon: Icons.analytics_outlined,
            ),
            const SizedBox(height: 16),
            OptionsGrid(options: relatorios),
            const SizedBox(height: 32),
            const SectionTitle(
              title: 'Cadastros',
              icon: Icons.edit_document,
            ),
            const SizedBox(height: 16),
            OptionsGrid(options: cadastros),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class HomeOption {
  final String title;
  final IconData icon;
  final WidgetBuilder page;

  const HomeOption({
    required this.title,
    required this.icon,
    required this.page,
  });
}

class SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;

  const SectionTitle({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: HomePage.primaryColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 22,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            color: HomePage.textColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class OptionsGrid extends StatelessWidget {
  final List<HomeOption> options;

  const OptionsGrid({
    super.key,
    required this.options,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth > 900
            ? 4
            : constraints.maxWidth > 600
                ? 2
                : 1;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: options.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: columns == 1 ? 3 : 1.8,
          ),
          itemBuilder: (context, index) {
            return OptionCard(option: options[index]);
          },
        );
      },
    );
  }
}

class OptionCard extends StatelessWidget {
  final HomeOption option;

  const OptionCard({
    super.key,
    required this.option,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: option.page,
          ),
        );
      },
      child: Ink(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: HomePage.surfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: HomePage.borderColor,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x26000000),
              blurRadius: 12,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: HomePage.primaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                option.icon,
                color: HomePage.backgroundColor,
                size: 29,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                option.title,
                style: const TextStyle(
                  color: HomePage.textColor,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: HomePage.backgroundColor,
                borderRadius: BorderRadius.circular(9),
              ),
              child: const Icon(
                Icons.arrow_forward_ios,
                color: HomePage.primaryColor,
                size: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}