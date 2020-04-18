import 'dart:convert';
import 'dart:html';
import 'package:flutter/material.dart';
import 'package:manager_toolkit_website/document_page.dart';

const String _basePath = 'lib/docs/';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Engineering Manager Toolbox',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainPage(title: 'Toolbox'),
    );
  }
}

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Future<String> toolboxText;
  Future<List<String>> toolboxDocs;

  Future<String> loadAsset() async {
    return await DefaultAssetBundle.of(context)
        .loadString('lib/docs/Toolbox.md');
  }

  Future<List<String>> _getToolboxFiles() async {
    final String manifestContent =
        await DefaultAssetBundle.of(context).loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap =
        json.decode(manifestContent) as Map<String, dynamic>;

    return manifestMap.keys
        .where((String key) => key.contains(_basePath))
        .where((String key) => key.contains('.md'))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    toolboxText = loadAsset();
    toolboxDocs = _getToolboxFiles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: Drawer(
        child: FutureBuilder<List<String>>(
          future: toolboxDocs,
          builder:
              (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
            if (snapshot == null ||
                (snapshot.connectionState == ConnectionState.none &&
                    snapshot.hasData == false)) {
              return Container();
            } else {
              return ListView.builder(
                itemCount: snapshot.data?.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  final String titleText = Uri.decodeComponent(snapshot
                      .data[index]
                      .replaceFirst(RegExp(RegExp.escape(_basePath)), '')
                      .replaceAll('.md', ''));
                  return Center(
                    child: ListTile(
                      title: Text(titleText),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.of(context).push<dynamic>(
                          MaterialPageRoute<dynamic>(
                            builder: (BuildContext context) => DocumentPage(
                              documentTitle: titleText,
                              documentPath: snapshot.data[index],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
      body: Container(),
    );
  }
}
