import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class TestWidget extends StatefulWidget {
  const TestWidget({super.key});

  @override
  State<TestWidget> createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  Future<String?> uploadAssetToFirebase(String key, String assetPath) async {
    try {
      // Convert asset to File
      File file = await assetToFile(assetPath);

      // Upload File to Firebase Storage
      String? downloadURL = await uploadFileToFirebase(key, file);

      // Delete the temporary file
      await file.delete();

      return downloadURL;
    } catch (e) {
      print('Error uploading asset: $e');
      return null;
    }
  }

  Future<File> assetToFile(String assetPath) async {
    ByteData data = await rootBundle.load(assetPath);
    List<int> bytes = data.buffer.asUint8List();

    String tempDir = (await getTemporaryDirectory()).path;
    File tempFile = File('$tempDir/${assetPath.split('/').last}');
    await tempFile.writeAsBytes(bytes, flush: true);

    return tempFile;
  }

  Future<String?> uploadFileToFirebase(String key, File file) async {
    try {
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('helpers3/manAndMcs/$key.png');

      await ref.putFile(file);

      String downloadURL = await ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error uploading file: $e');
      return null;
    }
  }

  var imageForEquipment = {
    'Backhoe': 'assets/ikons/manAndMcs/backhoe.png',
    'Billhook': 'assets/ikons/manAndMcs/billhook.png',
    'Car': 'assets/ikons/manAndMcs/car.png',
    'Combine harvester': 'assets/ikons/manAndMcs/combine-harvester.png',
    'Electric scooter': 'assets/ikons/manAndMcs/electric-scooter.png',
    'Equipment': 'assets/ikons/manAndMcs/equipment.png',
    'Fan': 'assets/ikons/manAndMcs/fan.png',
    'Gardening tools': 'assets/ikons/manAndMcs/gardening-tools.png',
    'Loader': 'assets/ikons/manAndMcs/loader.png',
    'Plow': 'assets/ikons/manAndMcs/plow.png',
    'Scooter': 'assets/ikons/manAndMcs/scooter.png',
    'Shredder': 'assets/ikons/manAndMcs/shredder.png',
    'Tractor': 'assets/ikons/manAndMcs/tractor.png',
  };

  var downloadLinks = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Widget'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text('Test Widget'),
          // Text(downloadLinks.toString()),
          ElevatedButton(
              onPressed: () => print(downloadLinks), child: Text('scam')),
          ElevatedButton(
            onPressed: () async {
              // String key = 'Beetroot';
              // String assetPath = 'assets/ikons/fruitsAndVeg/beetroot.png';
              // String? downloadURL = await uploadAssetToFirebase(key, assetPath);
              // print('Download URL for $key: $downloadURL');

              imageForEquipment.forEach(
                (key, value) async {
                  // print(key);
                  // print(value);
                  String? downloadURL = await uploadAssetToFirebase(key, value);
                  print(key);
                  print(downloadURL);
                  downloadLinks[key] = downloadURL;
                },
              );

              print(downloadLinks);
            },
            child: const Text('Back'),
          ),
        ],
      ),
    );
  }
}
