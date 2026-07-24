import 'package:flutter/material.dart';

class RelatorioMaquinasPage extends StatefulWidget {
  const RelatorioMaquinasPage({super.key});

  @override
  State<RelatorioMaquinasPage> createState() =>
      _RelatorioMaquinasPageState();
}

class _RelatorioMaquinasPageState extends State<RelatorioMaquinasPage> {
  final ScrollController horizontalController = ScrollController();

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
          'Relatório de Máquinas',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Container(
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
                      Icons.precision_manufacturing_outlined,
                      color: primaryColor,
                      size: 30,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Máquinas cadastradas',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  'Consulte as informações das máquinas e seus responsáveis.',
                  style: TextStyle(
                    color: secondaryTextColor,
                  ),
                ),
                const SizedBox(height: 24),
                Scrollbar(
                  controller: horizontalController,
                  thumbVisibility: true,
                  trackVisibility: true,
                  scrollbarOrientation: ScrollbarOrientation.bottom,
                  child: SingleChildScrollView(
                    controller: horizontalController,
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(
                        headingColor,
                      ),
                      dataRowColor: WidgetStateProperty.all(
                        Colors.white,
                      ),
                      headingTextStyle: const TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                      ),
                      dataTextStyle: const TextStyle(
                        color: textColor,
                      ),
                      border: TableBorder.all(
                        color: borderColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      columns: const [
                        DataColumn(
                          label: Text('ID'),
                        ),
                        DataColumn(
                          label: Text('Nome'),
                        ),
                        DataColumn(
                          label: Text('Código'),
                        ),
                        DataColumn(
                          label: Text('Descrição'),
                        ),
                        DataColumn(
                          label: Text('Modelo'),
                        ),
                        DataColumn(
                          label: Text('Fabricante'),
                        ),
                        DataColumn(
                          label: Text('Data de aquisição'),
                        ),
                        DataColumn(
                          label: Text('Status'),
                        ),
                        DataColumn(
                          label: Text('Setor'),
                        ),
                        DataColumn(
                          label: Text('Responsável'),
                        ),
                      ],
                      rows: const [
                        DataRow(
                          cells: [
                            DataCell(Text('')),
                            DataCell(Text('')),
                            DataCell(Text('')),
                            DataCell(Text('')),
                            DataCell(Text('')),
                            DataCell(Text('')),
                            DataCell(Text('')),
                            DataCell(Text('')),
                            DataCell(Text('')),
                            DataCell(Text('')),
                          ],
                        ),
                      ],
                    ),
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