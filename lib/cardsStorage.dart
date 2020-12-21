
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'cards.dart';

class CardsStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    print(directory.path);
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/data.txt');
  }

  Future<File> writeContent() async {
    final file = await _localFile;

    // Write the file.
    return file.writeAsString(cards.toString());
  }

  Future<String> readContent() async {
    try {
      final file = await _localFile;

      // Read the file.
      String contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return Error.
      return 'Error';
    }
  }

}