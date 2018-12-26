import 'dart:io';
import 'package:archive/archive.dart';
import 'package:path_provider/path_provider.dart';

class Hotfix {
  static Future<void> exec(File bundle) async {
    if (!Platform.isAndroid) throw UnimplementedError();
    Archive archive = ZipDecoder().decodeBytes(bundle.readAsBytesSync());
    for (ArchiveFile file in archive) {
      String path = (await getApplicationDocumentsDirectory()).path;
      if (file.isFile) {
        File dist = File('$path/${file.name}');
        if (dist.existsSync()) dist.deleteSync();
        dist..createSync(recursive: true)..writeAsBytesSync(file.content);
      } else {
        Directory('$path/${file.name}').createSync(recursive: true);
      }
    }
  }
}