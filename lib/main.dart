import 'package:flutter/material.dart';

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

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Avalia Música',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: const MyHomePage(title: 'Avalia Música'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String musicaSendoAvaliada = '';
  String estatisticas = '';

  bool _boolCurteAMusica = false;
  bool _boolNaoCurteAMusica = false;
  bool _boolIndiferenteAMusica = false;

  void _botaoCurteAcionado() {
    setState(() {
      _boolCurteAMusica = true;
      _boolNaoCurteAMusica = false;
      _boolIndiferenteAMusica = false;
    });
  }

  final bool _boolMusEmAvaliacao = true;
  void _botaoAvaliarMusAcionado() {
    setState(() {
      executarAPIdeAvaliacaoMusical();
    });
  }

  void _botaoNaoCurteAcionado() {
    setState(() {
      _boolCurteAMusica = false;
      _boolNaoCurteAMusica = true;
      _boolIndiferenteAMusica = false;
    });
  }

  void _botaoIndiferenteAcionado() {
    setState(() {
      _boolCurteAMusica = false;
      _boolNaoCurteAMusica = false;
      _boolIndiferenteAMusica = true;
    });
  }

  final bool _boolGetStats = true;
  void _botaoEstatsAcionado() {
    setState(() {
      estatisticas = getEstats();
    });
  }

  int _contador = 0;
  void executarAPIdeAvaliacaoMusical() {
    _contador++;
    musicaSendoAvaliada = 'Mais uma do Milton ' + _contador.toString();
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
                    'Música a Avaliar',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  musicaSendoAvaliada,
                ),
              ],
            ),
          ),
        ],
      ),
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
                  estatisticas,
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
