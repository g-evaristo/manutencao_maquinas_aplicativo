import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class EditarMaquinaPage extends StatefulWidget {
  final Map<String, dynamic> maquina;

  const EditarMaquinaPage({
    super.key,
    required this.maquina,
  });

  @override
  State<EditarMaquinaPage> createState() => _EditarMaquinaPageState();
}

class _EditarMaquinaPageState extends State<EditarMaquinaPage> {
  final formKey = GlobalKey<FormState>();

  late final TextEditingController nomeController;
  late final TextEditingController codigoController;
  late final TextEditingController descricaoController;
  late final TextEditingController modeloController;
  late final TextEditingController fabricanteController;
  late final TextEditingController dataAquisicaoController;

  String? statusMaquina;
  String? setorSelecionado;
  String? funcionarioSelecionado;

  final statusMaquinas = [
    'ATIVA',
    'INATIVA',
    'EM_MANUTENCAO',
  ];

  // Lista de setores recebida da API.
  List<Map<String, dynamic>> setores = [];

  // Lista de funcionários recebida da API.
  List<Map<String, dynamic>> funcionarios = [];

  bool salvando = false;

  // Controla o carregamento dos dados usados nos campos de seleção.
  bool carregandoDados = true;

  // Armazena uma possível mensagem de erro no carregamento.
  String? erroCarregamento;

  @override
  void initState() {
    super.initState();

    // Inicializa os campos com os dados da máquina selecionada.
    nomeController = TextEditingController(
      text: widget.maquina['MAQUINA_NOME']?.toString() ?? '',
    );

    codigoController = TextEditingController(
      text: widget.maquina['MAQUINA_CODIGO']?.toString() ?? '',
    );

    descricaoController = TextEditingController(
      text: widget.maquina['MAQUINA_DESCRICAO']?.toString() ?? '',
    );

    modeloController = TextEditingController(
      text: widget.maquina['MAQUINA_MODELO']?.toString() ?? '',
    );

    fabricanteController = TextEditingController(
      text: widget.maquina['MAQUINA_FABRICANTE']?.toString() ?? '',
    );

    dataAquisicaoController = TextEditingController(
      text: widget.maquina['MAQUINA_DATA_AQUISICAO']?.toString() ?? '',
    );

    // Recupera os valores atuais dos campos de seleção.
    statusMaquina =
        widget.maquina['MAQUINA_STATUS']?.toString();

    setorSelecionado =
        widget.maquina['FK_SETOR_ID']?.toString() ??
        widget.maquina['SETOR_ID']?.toString();

    funcionarioSelecionado =
        widget.maquina['FK_FUNCIONARIO_ID']?.toString() ??
        widget.maquina['FUNCIONARIO_ID']?.toString();

    // Carrega os setores e funcionários disponíveis.
    carregarDados();
  }

  // Busca simultaneamente os setores e funcionários na API.
  Future<void> carregarDados() async {
    setState(() {
      carregandoDados = true;
      erroCarregamento = null;
    });

    try {
      final resultados = await Future.wait([
        buscarSetores(),
        buscarFuncionarios(),
      ]);

      if (!mounted) {
        return;
      }

      setState(() {
        setores = resultados[0];
        funcionarios = resultados[1];

        // Mantém o valor apenas se ele existir na lista retornada pela API.
        setorSelecionado = validarValorSelecionado(
          setorSelecionado,
          setores,
          'SETOR_ID',
        );

        funcionarioSelecionado = validarValorSelecionado(
          funcionarioSelecionado,
          funcionarios,
          'FUNCIONARIO_ID',
        );
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        erroCarregamento = 'Erro ao carregar os dados: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          carregandoDados = false;
        });
      }
    }
  }

  // Verifica se o valor atual existe entre os dados retornados pela API.
  String? validarValorSelecionado(
    String? valor,
    List<Map<String, dynamic>> itens,
    String campoId,
  ) {
    if (valor == null) {
      return null;
    }

    final valorExiste = itens.any(
      (item) => item[campoId]?.toString() == valor,
    );

    return valorExiste ? valor : null;
  }

  // Busca os setores cadastrados na API.
  Future<List<Map<String, dynamic>>> buscarSetores() async {
    final response = await http.get(
      Uri.parse(
        'http://gabriel_evarist/manutencao_maquinas_api/public/api/setores',
      ),
      headers: {
        'Accept': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Erro ${response.statusCode} ao buscar setores',
      );
    }

    final resultado = jsonDecode(response.body);
    final List<dynamic> dados = resultado['dados'];

    return dados
        .map(
          (item) => Map<String, dynamic>.from(item),
        )
        .toList();
  }

  // Busca os funcionários cadastrados na API.
  Future<List<Map<String, dynamic>>> buscarFuncionarios() async {
    final response = await http.get(
      Uri.parse(
        'http://gabriel_evarist/manutencao_maquinas_api/public/api/funcionarios',
      ),
      headers: {
        'Accept': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Erro ${response.statusCode} ao buscar funcionários',
      );
    }

    final resultado = jsonDecode(response.body);
    final List<dynamic> dados = resultado['dados'];

    return dados
        .map(
          (item) => Map<String, dynamic>.from(item),
        )
        .toList();
  }

  Future<void> editarMaquina() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    // Cria o JSON com todos os campos utilizados no cadastro de máquinas.
    final dadosMaquina = {
      'MAQUINA_NOME': nomeController.text.trim(),
      'MAQUINA_CODIGO': codigoController.text.trim(),
      'MAQUINA_DESCRICAO': descricaoController.text.trim(),
      'MAQUINA_MODELO': modeloController.text.trim(),
      'MAQUINA_FABRICANTE': fabricanteController.text.trim(),
      'MAQUINA_DATA_AQUISICAO':
          dataAquisicaoController.text.trim(),
      'MAQUINA_STATUS': statusMaquina,
      'FK_SETOR_ID': setorSelecionado,
      'FK_FUNCIONARIO_ID': funcionarioSelecionado,
    };

    setState(() {
      salvando = true;
    });

    try {
      // Obtém o identificador da máquina recebida pela página.
      final id =
          widget.maquina['MAQUINA_ID'] ??
          widget.maquina['ID'];

      if (id == null) {
        throw Exception(
          'O identificador da máquina não foi informado',
        );
      }

      // Envia os novos dados utilizando uma requisição PUT.
      final response = await http.put(
        Uri.parse(
          'http://gabriel_evarist/manutencao_maquinas_api/public/api/maquinas/$id',
        ),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(dadosMaquina),
      );

      // Evita erro quando a API retorna o código 204 sem conteúdo.
      final dynamic respostaJson =
          response.body.trim().isNotEmpty
          ? jsonDecode(response.body)
          : <String, dynamic>{};

      final resultado = respostaJson is Map<String, dynamic>
          ? respostaJson
          : <String, dynamic>{};

      if (!mounted) {
        return;
      }

      if (response.statusCode == 200 ||
          response.statusCode == 204) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              resultado['message'] ??
                  resultado['mensagem'] ??
                  'Máquina atualizada com sucesso',
            ),
            backgroundColor: Colors.green,
          ),
        );

        // Retorna true para atualizar a página de relatório.
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              resultado['message'] ??
                  resultado['mensagem'] ??
                  'Erro ${response.statusCode}: ${response.body}',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao acessar a API: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          salvando = false;
        });
      }
    }
  }

  // Abre o calendário utilizando a data atual da máquina como referência.
  Future<void> selecionarData() async {
    final dataAtual =
        DateTime.tryParse(dataAquisicaoController.text) ??
        DateTime.now();

    final data = await showDatePicker(
      context: context,
      initialDate: dataAtual,
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
  void dispose() {
    // Libera os controladores quando a página é fechada.
    nomeController.dispose();
    codigoController.dispose();
    descricaoController.dispose();
    modeloController.dispose();
    fabricanteController.dispose();
    dataAquisicaoController.dispose();
    super.dispose();
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
          'Editar Máquina',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: carregandoDados
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : erroCarregamento != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      erroCarregamento!,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: carregarDados,
                      icon: const Icon(Icons.refresh),
                      label: const Text('TENTAR NOVAMENTE'),
                    ),
                  ],
                ),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 700,
                  ),
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
                        crossAxisAlignment:
                            CrossAxisAlignment.stretch,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons
                                    .precision_manufacturing_outlined,
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
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Atualize as informações de identificação e localização da máquina.',
                            style: TextStyle(
                              color: secondaryTextColor,
                            ),
                          ),
                          const SizedBox(height: 28),
                          TextFormField(
                            controller: nomeController,
                            maxLength: 200,
                            enabled: !salvando,
                            decoration: campoDecoracao(
                              label: 'Nome da máquina',
                              icon: Icons
                                  .precision_manufacturing_outlined,
                            ),
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty) {
                                return 'Informe o nome da máquina';
                              }

                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: codigoController,
                            maxLength: 100,
                            enabled: !salvando,
                            decoration: campoDecoracao(
                              label: 'Código da máquina',
                              icon: Icons.qr_code_outlined,
                            ),
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty) {
                                return 'Informe o código da máquina';
                              }

                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller:
                                descricaoController,
                            maxLength: 255,
                            maxLines: 3,
                            enabled: !salvando,
                            decoration: campoDecoracao(
                              label: 'Descrição',
                              icon:
                                  Icons.description_outlined,
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: modeloController,
                            maxLength: 150,
                            enabled: !salvando,
                            decoration: campoDecoracao(
                              label: 'Modelo',
                              icon: Icons.category_outlined,
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller:
                                fabricanteController,
                            maxLength: 150,
                            enabled: !salvando,
                            decoration: campoDecoracao(
                              label: 'Fabricante',
                              icon: Icons.factory_outlined,
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller:
                                dataAquisicaoController,
                            readOnly: true,
                            enabled: !salvando,
                            onTap: selecionarData,
                            decoration: campoDecoracao(
                              label: 'Data de aquisição',
                              icon: Icons
                                  .calendar_month_outlined,
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
                              icon: Icons
                                  .monitor_heart_outlined,
                            ),
                            items: statusMaquinas.map((
                              status,
                            ) {
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
                            onChanged: salvando
                                ? null
                                : (value) {
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
                          DropdownButtonFormField<String>(
                            value: setorSelecionado,
                            decoration: campoDecoracao(
                              label: 'Setor',
                              icon:
                                  Icons.apartment_outlined,
                            ),
                            items: setores.map((setor) {
                              return DropdownMenuItem<
                                String
                              >(
                                value: setor['SETOR_ID']
                                    .toString(),
                                child: Text(
                                  setor['SETOR_NOME']
                                          ?.toString() ??
                                      '',
                                ),
                              );
                            }).toList(),
                            onChanged: salvando
                                ? null
                                : (value) {
                                    setState(() {
                                      setorSelecionado =
                                          value;
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
                          DropdownButtonFormField<String>(
                            value:
                                funcionarioSelecionado,
                            decoration: campoDecoracao(
                              label:
                                  'Funcionário responsável',
                              icon: Icons
                                  .engineering_outlined,
                            ),
                            items: funcionarios.map((
                              funcionario,
                            ) {
                              return DropdownMenuItem<
                                String
                              >(
                                value:
                                    funcionario['FUNCIONARIO_ID']
                                        .toString(),
                                child: Text(
                                  funcionario['FUNCIONARIO_NOME']
                                          ?.toString() ??
                                      '',
                                ),
                              );
                            }).toList(),
                            onChanged: salvando
                                ? null
                                : (value) {
                                    setState(() {
                                      funcionarioSelecionado =
                                          value;
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
                              onPressed: salvando
                                  ? null
                                  : editarMaquina,
                              style: FilledButton.styleFrom(
                                backgroundColor:
                                    primaryColor,
                                foregroundColor:
                                    Colors.white,
                                shape:
                                    RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(
                                            12,
                                          ),
                                    ),
                              ),
                              icon: salvando
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child:
                                          CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color:
                                                Colors.white,
                                          ),
                                    )
                                  : const Icon(
                                      Icons.save_outlined,
                                    ),
                              label: Text(
                                salvando
                                    ? 'ATUALIZANDO...'
                                    : 'ATUALIZAR MÁQUINA',
                                style: const TextStyle(
                                  fontWeight:
                                      FontWeight.bold,
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