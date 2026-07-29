import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Importar pacote http para fazer requisições HTTP
import 'dart:convert';

import 'package:manutencao_maquinas/pages/editar_maquina.dart'; // Importar pacote json para decodificar respostas JSON

class RelatorioMaquinasPage extends StatefulWidget {
  const RelatorioMaquinasPage({super.key});

  @override
  State<RelatorioMaquinasPage> createState() =>
      _RelatorioMaquinasPageState();
}

class _RelatorioMaquinasPageState extends State<RelatorioMaquinasPage> {
  final ScrollController horizontalController = ScrollController();

  // Cria uma lista que armazenará as máquinas retornadas pela API
  List<dynamic> maquinas = [];

  // Indica se os dados ainda estão sendo carregados
  bool carregando = true;

  // Armazena uma possível mensagem de erro.
  String? erro;

  @override
  void initState() {
    super.initState();
    // Chama a função que consulta as máquinas assim que a página é aberta.
    consultarMaquinas();
  }

  Future<void> consultarMaquinas() async {
    try {
      // Faz uma requisição HTTP do tipo GET para a API.
      final response = await http.get(
        // Converte o endereço da API para um objeto Uri.
        Uri.parse(
          'http://gabriel_evarist/manutencao_maquinas_api/public/api/maquinas',
        ),
        headers: {
          'Accept': 'application/json',
        },
      );

      // Converte o texto JSON recebido em um objeto Dart.
      final resultado = jsonDecode(response.body);

      // Verifica se a requisição foi concluída com sucesso.
      if (response.statusCode == 200) {
        // Atualiza o estado da tela.
        setState(() {
          // Armazena os dados retornados pela API.
          // Caso dados seja nulo, utiliza uma lista vazia.
          maquinas = resultado['dados'] ?? [];
          carregando = false;
        });
      } else {
        // Executa quando a API responde, mas retorna um código de erro.
        setState(() {
          // Armazena a mensagem enviada pela API.
          // Caso ela não exista, usa uma mensagem padrão.
          erro = resultado['message'] ?? 'Erro ao consultar máquinas';
          carregando = false;
        });
      }
    } catch (e) {
      setState(() {
        erro = 'Erro: $e';
        carregando = false;
      });
    }
  }

  // Cria uma função assíncrona responsável por excluir um máquina pela API.
  Future<void> excluirMaquina(dynamic maquinaId) async {
    try {
      // Envia uma requisição HTTP do tipo DELETE para a API.
      final response = await http.delete(
        // Monta a URL incluindo o ID da máquina que será excluído.
        Uri.parse(
          'http://gabriel_evarist/manutencao_maquinas_api/public/api/maquinas/$maquinaId',
        ),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      // Converte a resposta em um JSON
      final resultado = response.body.isNotEmpty
          ? jsonDecode(response.body)
          : null;

      // Verifica se a exclusão foi concluída com sucesso.
      if (response.statusCode == 200 || response.statusCode == 204) {
        // Exibe uma mensagem informando que a máquina foi excluída.
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Máquina excluído com sucesso'),
          ),
        );

        await consultarMaquinas(); // Atualiza a lista de máquinas após a exclusão.
      } else {
        // Exibe a mensagem de erro retornada pela API.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              // Usa a mensagem da API ou uma mensagem padrão.
              resultado?['message'] ?? 'Erro ao excluir máquina',
            ),
          ),
        );
      }
    } catch (e) {
      // Exibe uma mensagem caso ocorra erro ao acessar a API.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao acessar API: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF454A4D);
    const backgroundColor = Color(0xFFC8C7C2);
    const borderColor = Color(0xFFA8A7A2);
    const headingColor = Color(0xFFD7D6D1);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        title: const Text('Relatório de Máquinas'),

        // Adiciona um botão de atualização na barra de navegação.
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                carregando = true;
                erro = null;
              });

              consultarMaquinas();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body:
          // Verifica se os dados ainda estão sendo carregados.
          // Se sim, exibe um indicador de progresso.
          carregando
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : erro != null
                  ? Center(
                      child: Text(
                        erro!,
                        style: const TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(24),
                      child: Scrollbar(
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
                            border: TableBorder.all(
                              color: borderColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            columns: const [
                              DataColumn(
                                label: Text(
                                  'ID',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Nome',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Código',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Descrição',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Modelo',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Fabricante',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Data de aquisição',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Status',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Setor',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Responsável',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              // Nova coluna para ações, como editar ou excluir um máquina.
                              DataColumn(
                                label: Text(
                                  'Ações',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],

                            // Cria uma lista de linhas da tabela a partir da lista de máquinas.
                            rows: maquinas.map<DataRow>((maquina) {
                              return DataRow(
                                cells: [
                                  DataCell(
                                    Text(
                                      maquina['MAQUINA_ID'].toString(),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      maquina['MAQUINA_NOME'].toString(),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      maquina['MAQUINA_CODIGO'].toString(),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      maquina['MAQUINA_DESCRICAO'].toString(),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      maquina['MAQUINA_MODELO'].toString(),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      maquina['MAQUINA_FABRICANTE'].toString(),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      maquina['MAQUINA_DATA_AQUISICAO']
                                          .toString(),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      maquina['MAQUINA_STATUS'].toString(),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      maquina['SETOR_NOME'].toString(),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      maquina['FUNCIONARIO_NOME'].toString(),
                                    ),
                                  ),
                                  // Nova célula para ações, como editar ou excluir um máquina.
                                  DataCell(
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit),
                                          // Função assíncrona que será executada quando o botão de editar for pressionado.
                                          onPressed: () async {
                                            // Lógica para editar o máquina
                                            // Salva máquina em uma variável para uso posterior na função de edição.
                                            final atualizado = await Navigator.push<bool>(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => EditarMaquinaPage(
                                                  maquina: Map<String, dynamic>.from(maquina),
                                                ),
                                              ),
                                            );

                                            if (atualizado == true) {
                                              await consultarMaquinas();
                                            }
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete, color: Colors.red),
                                          // Função assíncrona que será executada quando o botão de excluir for pressionado.
                                          onPressed: () async {
                                            // Lógica para excluir o máquina
                                            // Salva o ID do máquina em uma variável para uso posterior na função de exclusão.
                                            final id = maquina['MAQUINA_ID'];

                                            // Exibe um diálogo de confirmação antes de excluir o máquina.
                                            final confirmar = await showDialog<bool>(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text('Excluir máquina'),
                                                  content: Text(
                                                    'Deseja excluir a máquina ${maquina['NOME']}?',
                                                  ),
                                                  actions: [
                                                    // Botão de cancelar que fecha o diálogo e retorna false.  
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context, false);
                                                      },
                                                      child: const Text('Cancelar'),
                                                    ),
                                                    // Botão de excluir que fecha o diálogo e retorna true.
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.pop(context, true);
                                                      },
                                                      child: const Text('Excluir'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                            
                                            // Se o usuário confirmar a exclusão, chama a função excluirMaquina passando o ID da máquina.
                                            if (confirmar == true) {
                                              await excluirMaquina(id);
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
    );
  }
}