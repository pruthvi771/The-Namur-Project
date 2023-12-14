import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:active_ecommerce_flutter/utils/location_repository.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

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
          .child('helpers3/animals/$key.png');

      await ref.putFile(file);

      String downloadURL = await ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error uploading file: $e');
      return null;
    }
  }

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

              animalAndBirdsImages.forEach(
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

          ElevatedButton(
            onPressed: () async {
              print('it starts');
              String jsonString =
                  await rootBundle.loadString('assets/address.json');
              List jsonData = json.decode(jsonString);

              int count = 0;

              final FirebaseFirestore firestore = FirebaseFirestore.instance;

              // Loop through the JSON data and upload to Firestore
              for (Map<String, dynamic> villageData in jsonData) {
                print(count.toString());
                // Create a reference to the Firestore collection
                CollectionReference villagesCollection =
                    firestore.collection('globaladdress');

                // Map the JSON data to Firestore data
                Map<String, dynamic> firestoreData = {
                  'villageName': villageData['Village Name'],
                  'gramPanchayat': villageData['Gram Panchayat'],
                  'taluk': villageData['TALUK'],
                  'district': villageData['district'],
                  'state': villageData['state'],
                };
                print(villageData['TALUK']);

                // Add the data to Firestore
                await villagesCollection.add(firestoreData);
                count++;
              }

              print('and it\'s done');
            },
            child: const Text('another scam'),
          ),
          ElevatedButton(
            onPressed: () async {
              print('it starts');

              List list = await LocationRepository()
                  .getDistrictsForPincode(pinCode: '585201');

              print(list);

              QuerySnapshot<Map<String, dynamic>> querySnapshot =
                  await FirebaseFirestore.instance
                      .collection('globaladdress')
                      .where(FieldPath.documentId, isNotEqualTo: null)
                      .where('district',
                          isEqualTo: list[0].toString().toUpperCase())
                      .get();

              List<DocumentSnapshot<Map<String, dynamic>>> documents =
                  querySnapshot.docs;

              print('document count: ${documents.length}');

              for (var document in documents) {
                Map<String, dynamic> data = document.data()!;
                // if (!sellerIDs.contains(data['sellerId'])) {
                //   sellerIDs.add(data['sellerId']);
                // }
                print(data);
              }

              // print(list);
              print('and it\'s done');
            },
            child: const Text('yet another scam'),
          ),

          ElevatedButton(
            onPressed: () async {
              print('it starts');

              var userSnapshot = await FirebaseFirestore.instance
                  .collection('seller')
                  .doc('BZ90pBJ7O6f2cmk0nwrCRcsvbks2')
                  .get();

              List<String> products = [];

              print(userSnapshot.data()!['products'].length.toString());
              print(
                  userSnapshot.data()!['secondHandProducts'].length.toString());

              for (var product in userSnapshot.data()!['products']) {
                products.add(product);
              }

              for (var product in userSnapshot.data()!['secondHandProducts']) {
                products.add(product);
              }

              print(products.length);

              // for

              // print(list);
              print('and it\'s done');
            },
            child: const Text('yet another scam: part 2'),
          ),
        ],
      ),
    );
  }
}
