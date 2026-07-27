import 'package:flutter/material.dart';
import 'dart:convert'; // Importar pacote para converter dados JSON
import 'package:http/http.dart'as http; // Importar pacote para realizar requisições HTTP

class CadastroMaquinasPage extends StatefulWidget {
  const CadastroMaquinasPage({super.key});

  @override
  State<CadastroMaquinasPage> createState() => _CadastroMaquinasPageState();
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

  // Indica se os dados estão sendo enviados para a API.
  bool salvando = false;

  // Indica se os setores e funcionários estão sendo carregados.
  bool carregandoDados = true;

  // Armazena uma possível mensagem de erro ao carregar os dados.
  String? erroCarregamento;

  // Busca os setores e funcionários quando a página é aberta.
  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  // Busca os setores e funcionários na API.
  Future<void> carregarDados() async {
    setState(() {
      carregandoDados = true;
      erroCarregamento = null;
    });

    try {
      // Executa as duas requisições ao mesmo tempo.
      final resultados = await Future.wait([
        buscarSetores(),
        buscarFuncionarios(),
      ]);

      setState(() {
        setores = resultados[0];
        funcionarios = resultados[1];
      });
    } catch (e) {
      setState(() {
        erroCarregamento = 'Erro ao carregar os dados: $e';
      });
    } finally {
      setState(() {
        carregandoDados = false;
      });
    }
  }

  // Busca a lista de setores na API.
  Future<List<Map<String, dynamic>>> buscarSetores() async {
    // Faz uma requisição HTTP do tipo GET para a API.
    final response = await http.get(
      Uri.parse(
        'http://gabriel_evarist/manutencao_maquinas_api/public/api/setores',
      ),
      headers: {
        'Accept': 'application/json',
      },
    );

    // Verifica se a requisição foi realizada com sucesso.
    if (response.statusCode != 200) {
      throw Exception('Erro ${response.statusCode} ao buscar setores');
    }

    // Converte a resposta da API para JSON.
    final resultado = jsonDecode(response.body);

    // Obtém diretamente a lista armazenada na propriedade "dados".
    final List<dynamic> dados = resultado['dados'];

    // Converte os itens para uma lista de mapas.
    return dados
        .map(
          (item) => Map<String, dynamic>.from(item),
        )
        .toList();
  }

  // Busca a lista de funcionários na API.
  Future<List<Map<String, dynamic>>> buscarFuncionarios() async {
    // Faz uma requisição HTTP do tipo GET para a API.
    final response = await http.get(
      Uri.parse(
        'http://gabriel_evarist/manutencao_maquinas_api/public/api/funcionarios',
      ),
      headers: {
        'Accept': 'application/json',
      },
    );

    // Verifica se a requisição foi realizada com sucesso.
    if (response.statusCode != 200) {
      throw Exception(
        'Erro ${response.statusCode} ao buscar funcionários',
      );
    }

    // Converte a resposta da API para JSON.
    final resultado = jsonDecode(response.body);

    // Obtém diretamente a lista armazenada na propriedade "dados".
    final List<dynamic> dados = resultado['dados'];

    // Converte os itens para uma lista de mapas.
    return dados
        .map(
          (item) => Map<String, dynamic>.from(item),
        )
        .toList();
  }

  Future<void> salvar() async {
    // Verifica se os campos do formulário são válidos.
    if (!formKey.currentState!.validate()) {
      return;
    }

    // Monta o JSON com os dados da máquina a ser cadastrada.
    final dadosMaquina = {
      'NOME': nomeController.text.trim(),
      'CODIGO': codigoController.text.trim(),
      'DESCRICAO': descricaoController.text.trim(),
      'MODELO': modeloController.text.trim(),
      'FABRICANTE': fabricanteController.text.trim(),
      'DATA_AQUISICAO': dataAquisicaoController.text.trim(),
      'STATUS': statusMaquina,
      'FK_SETOR_ID': setorSelecionado,
      'FK_FUNCIONARIO_ID': funcionarioSelecionado,
    };

    // Indica que os dados estão sendo enviados para a API.
    setState(() {
      salvando = true;
    });

    try {
      // Faz uma requisição HTTP do tipo POST para a API.
      final response = await http.post(
        Uri.parse(
          'http://gabriel_evarist/manutencao_maquinas_api/public/api/maquinas',
        ),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        // Envia o corpo da requisição como JSON.
        body: jsonEncode(dadosMaquina),
      );

      // Converte a resposta da API para JSON.
      final resultado = response.body.isNotEmpty
          ? jsonDecode(response.body)
          : <String, dynamic>{};

      // Verifica se o cadastro foi realizado com sucesso.
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Exibe uma mensagem de sucesso.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              resultado['message'] ??
                  resultado['mensagem'] ??
                  'Máquina cadastrada com sucesso',
            ),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // Exibe a mensagem de erro retornada pela API.
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
      // Exibe uma mensagem caso ocorra erro de conexão.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao acessar a API: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      // Indica que o envio foi finalizado.
      setState(() {
        salvando = false;
      });
    }
  }

  Future<void> selecionarData() async {
    final data = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    // monta a data como yyyy-mm-dd
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
            constraints:
                const BoxConstraints(maxWidth: 700),
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
                      controller:
                          dataAquisicaoController,
                      readOnly: true,
                      onTap: selecionarData,
                      decoration: campoDecoracao(
                        label: 'Data de aquisição',
                        icon:
                            Icons.calendar_month_outlined,
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
                        icon:
                            Icons.monitor_heart_outlined,
                      ),
                      items:
                          statusMaquinas.map((status) {
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
                    DropdownButtonFormField<String>(
                      value: setorSelecionado,
                      decoration: campoDecoracao(
                        label: 'Setor',
                        icon: Icons.apartment_outlined,
                      ),
                      items: setores.map((setor) {
                        return DropdownMenuItem<String>(
                          value: setor['SETOR_ID'].toString(),
                          child: Text(setor['SETOR_NOME']),
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
                    DropdownButtonFormField<String>(
                      value: funcionarioSelecionado,
                      decoration: campoDecoracao(
                        label:
                            'Funcionário responsável',
                        icon:
                            Icons.engineering_outlined,
                      ),
                      items:
                          funcionarios.map((funcionario) {
                        return DropdownMenuItem<String>(
                          value: funcionario['FUNCIONARIO_ID'].toString(),
                          child: Text(funcionario['FUNCIONARIO_NOME']),
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