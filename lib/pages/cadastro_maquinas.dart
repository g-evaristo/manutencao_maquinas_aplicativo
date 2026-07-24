import 'package:flutter/material.dart';

class CadastroMaquinasPage extends StatefulWidget {
  const CadastroMaquinasPage({super.key});

  @override
  State<CadastroMaquinasPage> createState() =>
      _CadastroMaquinasPageState();
}

class _CadastroMaquinasPageState extends State<CadastroMaquinasPage> {
  final formKey = GlobalKey<FormState>();

  final nomeController = TextEditingController();
  final codigoController = TextEditingController();
  final descricaoController = TextEditingController();
  final modeloController = TextEditingController();
  final fabricanteController = TextEditingController();
  final dataAquisicaoController = TextEditingController();

  String? statusMaquina;
  int? setorSelecionado;
  int? funcionarioSelecionado;

  final statusMaquinas = [
    'ATIVA',
    'INATIVA',
    'EM_MANUTENCAO',
  ];

  final setores = [
    {'id': 1, 'nome': 'Produção'},
    {'id': 2, 'nome': 'Montagem'},
    {'id': 3, 'nome': 'Embalagem'},
    {'id': 4, 'nome': 'Qualidade'},
    {'id': 5, 'nome': 'Expedição'},
  ];

  final funcionarios = [
    {'id': 1, 'nome': 'Carlos Oliveira'},
    {'id': 2, 'nome': 'Mariana Santos'},
    {'id': 3, 'nome': 'João Pereira'},
    {'id': 4, 'nome': 'Fernanda Lima'},
    {'id': 5, 'nome': 'Ricardo Almeida'},
  ];

  void salvar() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
    }
  }

  Future<void> selecionarData() async {
    final data = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (data != null) {
      dataAquisicaoController.text =
          '${data.year.toString().padLeft(4, '0')}-'
          '${data.month.toString().padLeft(2, '0')}-'
          '${data.day.toString().padLeft(2, '0')}';
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF454A4D);
    const backgroundColor = Color(0xFFC8C7C2);
    const surfaceColor = Color(0xFFF5F4F1);
    const textColor = Color(0xFF292D2F);
    const secondaryTextColor = Color(0xFF686B6C);
    const borderColor = Color(0xFFA8A7A2);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        surfaceTintColor: primaryColor,
        foregroundColor: Colors.white,
        title: const Text(
          'Cadastro de Máquinas',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Container(
              padding: const EdgeInsets.all(28),
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
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
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
                            'Dados da máquina',
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
                      'Preencha as informações de identificação e localização da máquina.',
                      style: TextStyle(
                        color: secondaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 28),
                    TextFormField(
                      controller: nomeController,
                      maxLength: 200,
                      decoration: campoDecoracao(
                        label: 'Nome da máquina',
                        icon: Icons.precision_manufacturing_outlined,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Informe o nome da máquina';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: codigoController,
                      maxLength: 100,
                      decoration: campoDecoracao(
                        label: 'Código da máquina',
                        icon: Icons.qr_code_outlined,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Informe o código da máquina';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: descricaoController,
                      maxLength: 255,
                      maxLines: 3,
                      decoration: campoDecoracao(
                        label: 'Descrição',
                        icon: Icons.description_outlined,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: modeloController,
                      maxLength: 150,
                      decoration: campoDecoracao(
                        label: 'Modelo',
                        icon: Icons.category_outlined,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: fabricanteController,
                      maxLength: 150,
                      decoration: campoDecoracao(
                        label: 'Fabricante',
                        icon: Icons.factory_outlined,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: dataAquisicaoController,
                      readOnly: true,
                      onTap: selecionarData,
                      decoration: campoDecoracao(
                        label: 'Data de aquisição',
                        icon: Icons.calendar_month_outlined,
                      ).copyWith(
                        suffixIcon: const Icon(
                          Icons.date_range_outlined,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: statusMaquina,
                      decoration: campoDecoracao(
                        label: 'Status da máquina',
                        icon: Icons.monitor_heart_outlined,
                      ),
                      items: statusMaquinas.map((status) {
                        return DropdownMenuItem(
                          value: status,
                          child: Text(
                            status == 'EM_MANUTENCAO'
                                ? 'Em manutenção'
                                : status == 'ATIVA'
                                    ? 'Ativa'
                                    : 'Inativa',
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          statusMaquina = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Selecione o status da máquina';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<int>(
                      value: setorSelecionado,
                      decoration: campoDecoracao(
                        label: 'Setor',
                        icon: Icons.apartment_outlined,
                      ),
                      items: setores.map((setor) {
                        return DropdownMenuItem<int>(
                          value: setor['id'] as int,
                          child: Text(setor['nome'] as String),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          setorSelecionado = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Selecione o setor';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<int>(
                      value: funcionarioSelecionado,
                      decoration: campoDecoracao(
                        label: 'Funcionário responsável',
                        icon: Icons.engineering_outlined,
                      ),
                      items: funcionarios.map((funcionario) {
                        return DropdownMenuItem<int>(
                          value: funcionario['id'] as int,
                          child: Text(
                            funcionario['nome'] as String,
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          funcionarioSelecionado = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Selecione o funcionário responsável';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      height: 52,
                      child: FilledButton.icon(
                        onPressed: salvar,
                        style: FilledButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.save_outlined),
                        label: const Text(
                          'SALVAR MÁQUINA',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration campoDecoracao({
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFFA8A7A2),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFF454A4D),
          width: 2,
        ),
      ),
    );
  }
}