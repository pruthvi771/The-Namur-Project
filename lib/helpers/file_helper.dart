import 'dart:convert';
import 'dart:io';

class FileHelper {
  static String getBase64FormateFile(String path) {
    File file = File(path);
    //
    List<int> fileInByte = file.readAsBytesSync();
    String fileInBase64 = base64Encode(fileInByte);
    return fileInBase64;
  }
}
