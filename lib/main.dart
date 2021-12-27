import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

String musicaEmAvaliacao = '';
String predicaoDaMusica = '';
String gostoDoUserA = '';

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

const url = 'http://192.168.15.156:5001/';
Future<Musica> getPredicao() async {
  var uri = Uri.parse(url + 'predicao/');
  final response = await get(uri, headers: <String, String>{
    "Content-Type": "application/json; charset=UTF-8",
  });
  if (response.statusCode == 200) {
    return Musica.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Falha ao buscar uma interpretação');
  }
}

// Future<Estats> getEstats() async {
//   var uri = Uri.parse(url + 'stats/');
//   final response = await get(uri, headers: <String, String>{
//     "Content-Type": "application/json; charset=UTF-8",
//   });
//   if (response.statusCode == 200) {
//     return Estats.fromJson(jsonDecode(response.body));
//   } else {
//     throw Exception('Falha ao buscar estatísticas');
//   }
// }

Future<Estats> enviaGostoMusical() async {
  var uri = Uri.parse(url + 'predicao/');
  final response = await post(
    uri,
    headers: <String, String>{
      "Content-Type": "application/json; charset=UTF-8",
    },
    body: jsonEncode(<String, String>{
      'gostoReal': gostoDoUserA,
      'predicao': predicaoDaMusica,
    }),
  );
  if ((response.statusCode == 200) || (response.statusCode == 201)) {
    return Estats.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Falha ao enviar gosto musical');
  }
}

class Estats {
  final String texto;
  Estats({
    required this.texto,
  });
  factory Estats.fromJson(Map<String, dynamic> json) {
    return Estats(texto: json['texto']);
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
  String campoDeMensagem = '';
  String campoDeEstats = '';
  var _estado = Status.predicaoNaoIniciada;
  bool _boolCurteAMusica = false;
  bool _boolNaoCurteAMusica = false;
//  bool _boolIndiferenteAMusica = false;
  final bool _boolMusEmAvaliacao = true;
  final bool _boolZeraStats = true;

  void callAPIPredicao() {
    getPredicao().then((musica) {
      setState(() {
        _estado = Status.predicaoConcluida;
        musicaEmAvaliacao = musica.interpretacao.toString();
        predicaoDaMusica = musica.tipo;
      });
    }, onError: (error) {
      setState(() {
        _estado = Status.predicaoNaoIniciada;
        musicaEmAvaliacao = error.toString();
      });
    });
  }

  void _botaoAvaliarMusAcionado() {
    setState(() {
//      if (_estado == Status.predicaoNaoIniciada) {
      _boolCurteAMusica = false;
      _boolNaoCurteAMusica = false;
//        _boolIndiferenteAMusica = false;
      _estado = Status.predicaoSolicitada;
      callAPIPredicao();
//      }
    });
  }

  void _botaoZeraEstatsAcionado() {
    //   setState(() {
    //     getEstats();
    //   });
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
            musicaEmAvaliacao,
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
        gostoDoUserA = 'Curte';
        _boolCurteAMusica = true;
        _boolNaoCurteAMusica = false;
//        _boolIndiferenteAMusica = false;
        trataGostoUserA();
      }
    });
  }

  void _botaoNaoCurteAcionado() {
    setState(() {
      if (_estado == Status.predicaoConcluida) {
        _estado = Status.predicaoConcluidaENaoCurtida;
        gostoDoUserA = 'NaoCurte';
        _boolCurteAMusica = false;
        _boolNaoCurteAMusica = true;
//        _boolIndiferenteAMusica = false;
        trataGostoUserA();
      }
    });
  }

//   void _botaoIndiferenteAcionado() {
//     setState(() {
//       if (_estado == Status.predicaoConcluida) {
//         _estado = Status.predicaoConcluidaEIndiferente;
//         gostoDoUserA = 'Indiferente';
//         _boolCurteAMusica = false;
//         _boolNaoCurteAMusica = false;
//         _boolIndiferenteAMusica = true;
//         trataGostoUserA();
//       }
//     });
//   }

  trataGostoUserA() {
    enviaGostoMusical().then((estats) {
      setState(() {
        campoDeEstats = estats.texto.toString();
        if (_boolCurteAMusica == true) {
          if (predicaoDaMusica == 'Curte') {
            campoDeMensagem =
                "Legal que você gostou! Avalia Música também curte " +
                    musicaEmAvaliacao;
          } else {
            campoDeMensagem =
                "Puxa, você gosta? Eu esperava que não curtisse " +
                    musicaEmAvaliacao;
          }
        } else if (_boolNaoCurteAMusica == true) {
          if (predicaoDaMusica == 'Curte') {
            campoDeMensagem =
                "Puxa, você não gosta? Eu esperava que você curtisse  " +
                    musicaEmAvaliacao;
          } else {
            campoDeMensagem =
                "Pois é! Avalia Música também não curte " + musicaEmAvaliacao;
          }
        } else {
          if (predicaoDaMusica == 'Curte') {
            campoDeMensagem =
                "Interessante... Pra você essa música é indiferente. Avalia Música curte " +
                    musicaEmAvaliacao;
          } else {
            campoDeMensagem =
                "Interessante... Pra você essa música é indiferente. Avalia Música não curte " +
                    musicaEmAvaliacao;
          }
        }
      });
    }, onError: (error) {
      setState(() {
        campoDeMensagem = error.toString();
        campoDeEstats = error.toString();
      });
    });
    // simula botão de estats sendo acionado
    _estado = Status.predicaoNaoIniciada;
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
        'Utiliza Sistema de Recomendação por Colaboração e por Análise de Conteúdo\n\n'
        'Clique em ‘Nova Avaliação’ e eu te passo uma nova música.\n'
        'Aí você me conta se curte ou não e te passo minha avaliação',
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
        // _buildButtonColumn('Indiferente', Colors.brown, _boolIndiferenteAMusica,
        //     Icons.favorite, Icons.favorite_border, _botaoIndiferenteAcionado),
      ],
    );
    Widget regiaoDosBotoesDeAcao = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildButtonColumn('Nova Avaliação', color, _boolMusEmAvaliacao,
            Icons.add, Icons.add, _botaoAvaliarMusAcionado),
        _buildButtonColumn('Zera Estatísticas', color, _boolZeraStats,
            Icons.query_stats, Icons.query_stats, _botaoZeraEstatsAcionado),
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
                  campoDeMensagem,
                ),
                Container(
                  padding: const EdgeInsets.only(bottom: 8, top: 8),
                  child: Text(
                    campoDeEstats,
                  ),
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
          title: const Text('Avalia Música do Spotify como Usuário A'),
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
