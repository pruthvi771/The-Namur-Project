import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:uuid/uuid.dart';
import 'package:active_ecommerce_flutter/utils/globaladdress.dart';
import 'package:active_ecommerce_flutter/utils/location_repository.dart';
import 'package:active_ecommerce_flutter/features/auth/services/auth_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  final List<String> items = [
    'A_Item1',
    'A_Item2',
    'A_Item3',
    'A_Item4',
    'B_Item1',
    'B_Item2',
    'B_Item3',
    'B_Item4',
  ];

  String? selectedValue;
  final TextEditingController textEditingController = TextEditingController();

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
          .child('helpers3/weather/$key.png');

      await ref.putFile(file);

      String downloadURL = await ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error uploading file: $e');
      return null;
    }
  }

  Map<int, String> weatherCodeToImage = {
    1000:
        'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2Fweather%2Fsunny.jpeg?alt=media&token=2c118847-5f01-449d-8161-527aab1a9fc9',
    1003:
        'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2Fweather%2Fpartly%20cloudy.jpeg?alt=media&token=dcc1740b-ae28-45ac-8755-4312608481c5',
    1006:
        'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2Fweather%2Fcloudy.jpeg?alt=media&token=92ca3992-9ce8-4698-b120-6d12d1379355',
    1009:
        'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2Fweather%2Fcloudy.jpeg?alt=media&token=92ca3992-9ce8-4698-b120-6d12d1379355',
    1030:
        'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2Fweather%2Fhumid.jpeg?alt=media&token=4506f86b-dd58-4003-8ea8-6602139b9f46',
    1063:
        'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2Fweather%2Frainy.jpeg?alt=media&token=8a991c5d-0474-4d0b-b684-a355411ad032',
    1066:
        'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2Fweather%2Fhumid.jpeg?alt=media&token=4506f86b-dd58-4003-8ea8-6602139b9f46',
    1069:
        'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2Fweather%2Fhumid.jpeg?alt=media&token=4506f86b-dd58-4003-8ea8-6602139b9f46',
    1072:
        'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2Fweather%2Fstorm%20level%20windy.jpeg?alt=media&token=2e49f6a7-a020-4057-a458-398c066ced17',
    1114:
        'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2Fweather%2Fwindy%202.jpeg?alt=media&token=c1aea7a3-9101-42c2-b877-148e27a6a716',
    1117:
        'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2Fweather%2Fwindy%202.jpeg?alt=media&token=c1aea7a3-9101-42c2-b877-148e27a6a716',
    1135:
        'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2Fweather%2Fpartly%20cloudy.jpeg?alt=media&token=dcc1740b-ae28-45ac-8755-4312608481c5',
    1147:
        'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2Fweather%2Fpartly%20cloudy.jpeg?alt=media&token=dcc1740b-ae28-45ac-8755-4312608481c5',
    1150:
        'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2Fweather%2Fraining.png?alt=media&token=ecd6b0cf-165b-4dd1-ac0a-d4b0e2d7eded',
    1153:
        'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2Fweather%2Fraining.png?alt=media&token=ecd6b0cf-165b-4dd1-ac0a-d4b0e2d7eded',
    1168:
        'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2Fweather%2Fraining.png?alt=media&token=ecd6b0cf-165b-4dd1-ac0a-d4b0e2d7eded',
    1171:
        'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2Fweather%2Fraining.png?alt=media&token=ecd6b0cf-165b-4dd1-ac0a-d4b0e2d7eded',
    1180:
        'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2Fweather%2Frainy.jpeg?alt=media&token=8a991c5d-0474-4d0b-b684-a355411ad032',
    1183:
        'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2Fweather%2Frainy.jpeg?alt=media&token=8a991c5d-0474-4d0b-b684-a355411ad032',
    1186:
        'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2Fweather%2Frainy.jpeg?alt=media&token=8a991c5d-0474-4d0b-b684-a355411ad032',
    1189:
        'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2Fweather%2Frainy.jpeg?alt=media&token=8a991c5d-0474-4d0b-b684-a355411ad032',
    1192:
        'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2Fweather%2Fflood.jpeg?alt=media&token=8b5aaaaf-c6d4-4bfb-b4c3-ca62a3d49cc6',
    1195:
        'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2Fweather%2Fflood.jpeg?alt=media&token=8b5aaaaf-c6d4-4bfb-b4c3-ca62a3d49cc6',
    1198:
        'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2Fweather%2Fraining.png?alt=media&token=ecd6b0cf-165b-4dd1-ac0a-d4b0e2d7eded',
    1201:
        'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2Fweather%2Fraining.png?alt=media&token=ecd6b0cf-165b-4dd1-ac0a-d4b0e2d7eded',
    1204:
        'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2Fweather%2Frainy.jpeg?alt=media&token=8a991c5d-0474-4d0b-b684-a355411ad032',
    1207:
        'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2Fweather%2Frainy.jpeg?alt=media&token=8a991c5d-0474-4d0b-b684-a355411ad032',
    1210:
        'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2Fweather%2Fraining.png?alt=media&token=ecd6b0cf-165b-4dd1-ac0a-d4b0e2d7eded',
    1213:
        'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2Fweather%2Fraining.png?alt=media&token=ecd6b0cf-165b-4dd1-ac0a-d4b0e2d7eded',
    1216:
        'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2Fweather%2Fraining.png?alt=media&token=ecd6b0cf-165b-4dd1-ac0a-d4b0e2d7eded',
    1219:
        'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2Fweather%2Fraining.png?alt=media&token=ecd6b0cf-165b-4dd1-ac0a-d4b0e2d7eded',
    1222:
        'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2Fweather%2Fraining.png?alt=media&token=ecd6b0cf-165b-4dd1-ac0a-d4b0e2d7eded',
    1225:
        'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2Fweather%2Fflood.jpeg?alt=media&token=8b5aaaaf-c6d4-4bfb-b4c3-ca62a3d49cc6',
    1237:
        'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2Fweather%2Fraining.png?alt=media&token=ecd6b0cf-165b-4dd1-ac0a-d4b0e2d7eded',
    1240:
        'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2Fweather%2Fraining.png?alt=media&token=ecd6b0cf-165b-4dd1-ac0a-d4b0e2d7eded',
    1243:
        'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2Fweather%2Fraining.png?alt=media&token=ecd6b0cf-165b-4dd1-ac0a-d4b0e2d7eded',
    1246:
        'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2Fweather%2Fflood.jpeg?alt=media&token=8b5aaaaf-c6d4-4bfb-b4c3-ca62a3d49cc6',
    1249:
        'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2Fweather%2Fraining.png?alt=media&token=ecd6b0cf-165b-4dd1-ac0a-d4b0e2d7eded',
    1252:
        'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2Fweather%2Fraining.png?alt=media&token=ecd6b0cf-165b-4dd1-ac0a-d4b0e2d7eded',
    1255:
        'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2Fweather%2Fraining.png?alt=media&token=ecd6b0cf-165b-4dd1-ac0a-d4b0e2d7eded',
    1258:
        'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2Fweather%2Fraining.png?alt=media&token=ecd6b0cf-165b-4dd1-ac0a-d4b0e2d7eded',
    1261:
        'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2Fweather%2Fraining.png?alt=media&token=ecd6b0cf-165b-4dd1-ac0a-d4b0e2d7eded',
    1264:
        'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2Fweather%2Fraining.png?alt=media&token=ecd6b0cf-165b-4dd1-ac0a-d4b0e2d7eded',
    1273:
        'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2Fweather%2Fthunder.jpeg?alt=media&token=3a824e3b-88b5-4712-8c06-1de26f3e92d8',
    1276:
        'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2Fweather%2Fthunder.jpeg?alt=media&token=3a824e3b-88b5-4712-8c06-1de26f3e92d8',
    1279:
        'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2Fweather%2Fthunder.jpeg?alt=media&token=3a824e3b-88b5-4712-8c06-1de26f3e92d8',
    1282:
        'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2Fweather%2Fthunder.jpeg?alt=media&token=3a824e3b-88b5-4712-8c06-1de26f3e92d8',
  };

  var animalAndBirdsImages = {
    // 'honey': 'assets/ikons/animals/honey.png',
    // 'veterinarian': 'assets/ikons/animals/veterinarian.png',
    // 'veterinary': 'assets/ikons/animals/veterinary.png',
    // 'shampoo': 'assets/ikons/animals/shampoo.png',
    // 'smoker': 'assets/ikons/animals/smoker.png',
    // 'rabbit': 'assets/ikons/animals/rabbit.png',
    // 'kennel': 'assets/ikons/animals/kennel.png',
    // 'milk tank': 'assets/ikons/animals/milk-tank.png',
    // 'pet food': 'assets/ikons/animals/pet-food.png',
    // 'pet supplies': 'assets/ikons/animals/pet-supplies.png',
    // 'dairy products': 'assets/ikons/animals/dairy-products.png',
    // 'dog-carrier': 'assets/ikons/animals/dog-carrier.png',
    // 'buffalo': 'assets/ikons/animals/buffalo.png',
    // 'cow': 'assets/ikons/animals/cow.png',
    // 'duck': 'assets/ikons/animals/duck.png',
    // 'bee': 'assets/ikons/animals/bee.png',
    // 'beehive': 'assets/ikons/animals/beehive.png',
    // 'hive': 'assets/ikons/animals/hive.png',
    // 'bird': 'assets/ikons/animals/bird.png',
    // 'donkey': 'assets/ikons/animals/donkey.png',
    // 'dog': 'assets/ikons/animals/dog.png',
    // 'fish': 'assets/ikons/animals/fish.png',
    // 'pig': 'assets/ikons/animals/pig.png',
    // 'pork': 'assets/ikons/animals/pork.png',
    // 'pills': 'assets/ikons/animals/pills.png',
    // 'sheep': 'assets/ikons/animals/sheep.png',
    // 'turkey': 'assets/ikons/animals/turkey.png',
    // 'hen': 'assets/ikons/animals/hen.png',
    // 'goat': 'assets/ikons/animals/goat.png',
    // 'fertilizer': 'assets/ikons/animals/fertilizer.png',
    // 'first aid kit': 'assets/ikons/animals/first-aid-kit.png',
    'cat': 'assets/ikons/animals/cat.png',
    'egg': 'assets/ikons/animals/egg.png',
    'emu': 'assets/ikons/animals/emu.png',
    'black cat': 'assets/ikons/animals/black-cat.png',
  };

  var downloadLinks = {};

  final AuthRepository authRepository = AuthRepository();

  List<Map> addresses = globaladdress;
  List<String> taluks = [];

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Widget'),
      ),
      // body: Column(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   crossAxisAlignment: CrossAxisAlignment.center,
      //   children: [
      //     const Text('Test Widget'),
      //     // Text(downloadLinks.toString()),
      //     ElevatedButton(
      //         onPressed: () => print(downloadLinks), child: Text('scam')),
      //     ElevatedButton(
      //       onPressed: () async {
      //         weatherCodeToImage.forEach(
      //           (key, value) async {
      //             String? downloadURL =
      //                 await uploadAssetToFirebase(key.toString(), value);
      //             print(key);
      //             print(downloadURL);
      //             downloadLinks[key] = downloadURL;
      //           },
      //         );
      //         print(downloadLinks);
      //       },
      //       child: const Text('Back'),
      //     ),
      //   ],
      // ),

      body: ListView.builder(
        itemCount: weatherCodeToImage.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Text('${weatherCodeToImage.keys.toList()[index]}'),
              CachedNetworkImage(
                imageUrl: weatherCodeToImage.values.toList()[index],
                height: 200,
                width: 150,
              ),
            ],
          );
        },
      ),
    );
  }
}

// https://api.weatherapi.com/v1/current.json?key=424c2d85d4af4f2b8fd230429230110&q=Delhi&aqi=no
