import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hotfix/hotfix.dart';
import 'package:path_provider/path_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hotfix Example',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _text = '按下FAB尝试热更新\n';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Hotfix Example')),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Text(_text),
      ),
      floatingActionButton: Builder(builder: (_) {
        return FloatingActionButton(
          onPressed: _hotfix,
          child: Icon(Icons.update),
        );
      }),
    );
  }

  void _hotfix() async {
    try {
      Uri uri = Uri.https('rbq.cx', '/bundle.zip');
      String path = (await getTemporaryDirectory()).path;
      File dist = File('$path/bundle.zip');
      if (dist.existsSync()) {
        Hotfix.exec(dist);
        setState(() => _text += 'Finished, please restart application.\n');
        dist.deleteSync();
        return;
      }
      HttpClient client = HttpClient();
      HttpClientRequest request = await client.getUrl(uri);
      HttpClientResponse response = await request.close();
      setState(() => _text += 'Downloading ${uri.toString()}.\n');
      await response.pipe(dist.openWrite());
      await Hotfix.exec(dist);
      setState(() => _text += 'Finished, please restart application.\n');
      dist.deleteSync();
    } catch (err) {
      setState(() => _text += '${err.toString()}\n');
    }
  }
}
