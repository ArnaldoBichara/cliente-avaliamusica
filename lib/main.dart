import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

Future<Musica> fetchPredicao() async {
  var uri = Uri.parse('http://localhost:5001/predicao');
  final response = await get(uri, headers: <String, String>{
    "Content-Type": "application/json; charset=UTF-8",
  });
  if (response.statusCode == 200) {
    return Musica.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Falha ao buscar uma interpretação');
  }
}

class Musica {
  final String interpretacao;
  final String tipo;
  Musica({
    required this.interpretacao,
    required this.tipo,
  });
  factory Musica.fromJson(Map<String, dynamic> json) {
    return Musica(
      interpretacao: json['interpretacao'],
      tipo: json['tipo'],
    );
  }
}

enum Status {
  predicaoNaoIniciada,
  predicaoSolicitada,
  predicaoConcluida,
  predicaoConcluidaECurtida,
  predicaoConcluidaENaoCurtida,
  predicaoConcluidaEIndiferente,
}
void main() {
  runApp(const MyApp());
}

Column _buildButtonColumn(String texto, Color cor, bool botaoEstaSelecionado,
    IconData iconeSelec, IconData iconeNaoSelec, var funcaoAChamar) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      IconButton(
        icon: (botaoEstaSelecionado ? Icon(iconeSelec) : Icon(iconeNaoSelec)),
        color: cor,
        onPressed: funcaoAChamar,
      ),
      Text(
        texto,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: cor,
        ),
      ),
      //),
    ],
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _musicaEmAvaliacao = '';
  String mensagem = '';

  var _estado = Status.predicaoNaoIniciada;
  bool _boolCurteAMusica = false;
  bool _boolNaoCurteAMusica = false;
  bool _boolIndiferenteAMusica = false;
  final bool _boolMusEmAvaliacao = true;
  final bool _boolGetStats = true;

  void callAPIPredicao() {
    fetchPredicao().then((musica) {
      setState(() {
        _estado = Status.predicaoConcluida;
        _musicaEmAvaliacao = musica.interpretacao.toString();
      });
    }, onError: (error) {
      setState(() {
        _estado = Status.predicaoConcluida;
        _musicaEmAvaliacao = error.toString();
      });
    });
  }

  void _botaoAvaliarMusAcionado() {
    setState(() {
      if (_estado == Status.predicaoNaoIniciada) {
        _boolCurteAMusica = false;
        _boolNaoCurteAMusica = false;
        _boolIndiferenteAMusica = false;
        _estado = Status.predicaoSolicitada;
        callAPIPredicao();
      }
    });
  }

  widgetMusicaouProgressIndicator() {
    if (_estado == Status.predicaoNaoIniciada) {
      return const Text(' ');
    } else {
      if (_estado == Status.predicaoSolicitada) {
        return const CircularProgressIndicator();
      } else {
        return Container(
          margin: const EdgeInsets.all(2.0),
          padding: const EdgeInsets.all(5.0),
          decoration:
              BoxDecoration(border: Border.all(color: Colors.blueAccent)),
          child: SelectableText(
            _musicaEmAvaliacao,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.cyan,
            ),
          ),
        );
      }
    }
  }

  void _botaoCurteAcionado() {
    setState(() {
      if (_estado == Status.predicaoConcluida) {
        _estado = Status.predicaoConcluidaECurtida;
        _boolCurteAMusica = true;
        _boolNaoCurteAMusica = false;
        _boolIndiferenteAMusica = false;
        apiSetGostoUserA();
      }
    });
  }

  void _botaoNaoCurteAcionado() {
    setState(() {
      if (_estado == Status.predicaoConcluida) {
        _estado = Status.predicaoConcluidaENaoCurtida;
        _boolCurteAMusica = false;
        _boolNaoCurteAMusica = true;
        _boolIndiferenteAMusica = false;
        apiSetGostoUserA();
      }
    });
  }

  void _botaoIndiferenteAcionado() {
    setState(() {
      if (_estado == Status.predicaoConcluida) {
        _estado = Status.predicaoConcluidaEIndiferente;
        _boolCurteAMusica = false;
        _boolNaoCurteAMusica = false;
        _boolIndiferenteAMusica = true;
        apiSetGostoUserA();
      }
    });
  }

  void _botaoEstatsAcionado() {
    setState(() {
      mensagem = getEstats();
    });
  }

  apiSetGostoUserA() {
    mensagem = "Gosto setado para " + _estado.toString();
    _estado = Status.predicaoNaoIniciada;
  }

  int _contador2 = 0;
  String getEstats() {
    _contador2++;
    return "Estatísticas saindo do forno: " + _contador2.toString();
  }

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).primaryColor;
    Widget regiaoDoTitulo = Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 2),
            child: const Text(
              'Ciência de Dados para análise de Gosto Musical',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
    Widget regiaomusicaSendoAvaliada = Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: const Text(
                    'Música a Avaliar : ',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                widgetMusicaouProgressIndicator(),
              ],
            ),
          ),
        ],
      ),
    );
    Widget regiaoMsgExplicativa = const Padding(
      padding: EdgeInsets.all(24),
      child: Text(
        'Vamos avaliar uma música? Clique em ‘Nova Avaliação’ e eu '
        'te passo uma música. Aí você me conta se gosta ou não e eu '
        'te falo minha avaliação, ok?',
        softWrap: true,
      ),
    );
    Widget regiaoDosBotoesDeEscolha = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildButtonColumn('Curto!', Colors.greenAccent, _boolCurteAMusica,
            Icons.favorite, Icons.favorite_border, _botaoCurteAcionado),
        _buildButtonColumn('Não Curto', Colors.redAccent, _boolNaoCurteAMusica,
            Icons.favorite, Icons.favorite_border, _botaoNaoCurteAcionado),
        _buildButtonColumn('Indiferente', Colors.brown, _boolIndiferenteAMusica,
            Icons.favorite, Icons.favorite_border, _botaoIndiferenteAcionado),
      ],
    );
    Widget regiaoDosBotoesDeAcao = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildButtonColumn('Nova Avaliação', color, _boolMusEmAvaliacao,
            Icons.add, Icons.add, _botaoAvaliarMusAcionado),
        _buildButtonColumn('Estatísticas', color, _boolGetStats,
            Icons.query_stats, Icons.query_stats, _botaoEstatsAcionado),
      ],
    );
    Widget regiaoMsgResultado = Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: const Text(
                    'Resultado:',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  mensagem,
                ),
              ],
            ),
          ),
        ],
      ),
    );

    return MaterialApp(
      title: 'Avalia Música',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        primaryColor: Colors.cyan,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Avalia Música'),
        ),
        body: Column(
          children: [
            regiaoDoTitulo,
            regiaoMsgExplicativa,
            regiaoDosBotoesDeAcao,
            regiaomusicaSendoAvaliada,
            regiaoDosBotoesDeEscolha,
            regiaoMsgResultado,
          ],
        ),
      ),
    );
  }
}
