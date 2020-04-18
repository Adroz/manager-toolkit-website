import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class DocumentPage extends StatelessWidget {
  const DocumentPage({Key key, this.documentTitle, this.documentPath})
      : super(key: key);

  final String documentTitle;
  final String documentPath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(documentTitle),
      ),
      body: Center(
        child: FutureBuilder<String>(
          future: DefaultAssetBundle.of(context)
              .loadString(Uri.decodeComponent(documentPath)),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.hasData) {
              return Markdown(
                data: snapshot.data,
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            // By default, show a loading spinner.
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
