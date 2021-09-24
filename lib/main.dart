import 'package:flutter/material.dart';

void main() {
  runApp(const AvaliaMusica());
}

class AvaliaMusica extends StatelessWidget {
  const AvaliaMusica({Key? key}) : super(key: key);

  // This widget is the root of your application.
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
        _buildButtonColumn(Colors.greenAccent, Icons.favorite, 'Gosto'),
        _buildButtonColumn(
            Colors.redAccent, Icons.favorite_border, 'Não Gosto'),
        _buildButtonColumn(color, Icons.flutter_dash, 'Indiferente'),
      ],
    );
    Widget regiaoDosBotoesDeAcao = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildButtonColumn(color, Icons.add, 'Nova Avaliação'),
        _buildButtonColumn(color, Icons.query_stats, 'Estatísticas'),
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

Column _buildButtonColumn(Color color, IconData icon, String label) {
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

class MinhaHomePage extends StatefulWidget {
  const MinhaHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MinhaHomePage> createState() => _MinhaHomePageState();
}

class _MinhaHomePageState extends State<MinhaHomePage> {
  int _counter = 0;
  String linha1 = "minha primeira linha:";
  String linha2 = "minha segunda linha:";

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MinhaHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              linha1,
            ),
            Text(
              linha2,
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
