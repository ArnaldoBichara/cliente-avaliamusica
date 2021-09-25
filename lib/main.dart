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
  bool _boolCurteAMusica = false;
  void _botaoCurteAcionado() {
    setState(() {
      if (_boolCurteAMusica) {
        _boolCurteAMusica = false;
      } else {
        _boolCurteAMusica = true;
      }
    });
  }

  bool _boolNaoCurteAMusica = false;
  void _botaoNaoCurteAcionado() {
    setState(() {
      if (_boolNaoCurteAMusica) {
        _boolNaoCurteAMusica = false;
      } else {
        _boolNaoCurteAMusica = true;
      }
    });
  }

  bool _boolIndiferenteAMusica = false;
  void _botaoIndiferenteAcionado() {
    setState(() {
      if (_boolIndiferenteAMusica) {
        _boolIndiferenteAMusica = false;
      } else {
        _boolIndiferenteAMusica = true;
      }
    });
  }

  bool _boolAvaliarMus = false;
  void _botaoAvaliarMusAcionado() {
    setState(() {
      if (_boolAvaliarMus) {
        _boolAvaliarMus = false;
      } else {
        _boolAvaliarMus = true;
      }
    });
  }

  bool _boolGetStats = false;
  void _botaoEstatsAcionado() {
    setState(() {
      if (_boolGetStats) {
        _boolGetStats = false;
      } else {
        _boolGetStats = true;
      }
    });
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
        _buildButtonColumn1(color, Icons.add, 'Nova Avaliação'),
        _buildButtonColumn1(color, Icons.query_stats, 'Estatísticas'),
      ],
    );
    Widget regiaoNomeDaMusica = Container(
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
                const Text(
                  'Milton Nascimento :> Clube da Esquina',
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
                const Text(
                  'Muito bem!!!!',
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
            regiaoNomeDaMusica,
            regiaoDosBotoesDeEscolha,
            regiaoMsgResultado,
          ],
        ),
      ),
    );
  }
}

Column _buildButtonColumn1(Color color, IconData icon, String label) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(icon, color: color),
      Container(
        margin: const EdgeInsets.only(top: 8, bottom: 8),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: color,
          ),
        ),
      ),
    ],
  );
}
