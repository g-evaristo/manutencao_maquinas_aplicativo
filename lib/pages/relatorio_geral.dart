import 'package:flutter/material.dart';

class RelatorioGeralPage extends StatelessWidget {
  const RelatorioGeralPage({super.key});

  final List<Map<String, dynamic>> indicadores = const [
    {
      'titulo': 'Máquinas',
      'valor': '5',
      'icone': Icons.precision_manufacturing_outlined,
    },
    {
      'titulo': 'Manutenções agendadas',
      'valor': '2',
      'icone': Icons.calendar_month_outlined,
    },
    {
      'titulo': 'Manutenções realizadas',
      'valor': '2',
      'icone': Icons.task_alt_outlined,
    },
    {
      'titulo': 'Máquinas em manutenção',
      'valor': '1',
      'icone': Icons.build_circle_outlined,
    },
  ];

  final List<Map<String, String>> atividades = const [
    {
      'titulo': 'Substituição da resistência',
      'descricao': 'Seladora Industrial • Em andamento',
    },
    {
      'titulo': 'Ajuste da correia',
      'descricao': 'Esteira Transportadora • Agendada',
    },
    {
      'titulo': 'Calibração dos sensores',
      'descricao': 'Scanner Industrial • Agendada',
    },
  ];

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF454A4D);
    const backgroundColor = Color(0xFFC8C7C2);
    const surfaceColor = Color(0xFFF5F4F1);
    const textColor = Color(0xFF292D2F);
    const secondaryTextColor = Color(0xFF686B6C);
    const borderColor = Color(0xFFA8A7A2);
    const headingColor = Color(0xFFD7D6D1);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        surfaceTintColor: primaryColor,
        foregroundColor: Colors.white,
        title: const Text(
          'Relatório Geral',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.dashboard_outlined,
                      color: primaryColor,
                      size: 30,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Visão geral da manutenção',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  'Acompanhe os principais indicadores do ambiente industrial.',
                  style: TextStyle(
                    color: secondaryTextColor,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 24),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: indicadores.length,
                  gridDelegate:
                      const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 300,
                    mainAxisExtent: 165,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemBuilder: (context, index) {
                    final item = indicadores[index];

                    return Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: surfaceColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: borderColor,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x26000000),
                            blurRadius: 12,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              item['icone'],
                              color: backgroundColor,
                              size: 27,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            item['valor'],
                            style: const TextStyle(
                              color: textColor,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item['titulo'],
                            style: const TextStyle(
                              color: secondaryTextColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 32),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: borderColor,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x26000000),
                        blurRadius: 14,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.history_outlined,
                            color: primaryColor,
                            size: 26,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Atividades recentes',
                            style: TextStyle(
                              color: textColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      ...atividades.map((atividade) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: headingColor,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  color: headingColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.handyman_outlined,
                                  color: primaryColor,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      atividade['titulo']!,
                                      style: const TextStyle(
                                        color: textColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      atividade['descricao']!,
                                      style: const TextStyle(
                                        color: secondaryTextColor,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.chevron_right,
                                color: secondaryTextColor,
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}