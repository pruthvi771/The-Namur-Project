import 'dart:convert';
import 'dart:io';
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

  List<String> taluks = [];

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
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
                onPressed: () async {
                  FirebaseFirestore firestore = FirebaseFirestore.instance;

                  // Reference to the document in the specified collection
                  DocumentReference documentReference =
                      firestore.collection('calendar').doc('cauliflower');

                  // Update the specific field in the document
                  await documentReference.update({
                    'pest control': [
                      {
                        'stageName': 'Planting Stage',
                        'pests': [
                          {
                            'name': 'Swirling Virus',
                            'image': 'assets/swirling.png',
                            'description': 'Swirling Virus is a virus'
                          },
                          {
                            'name': 'Leaf Eaters',
                            'image':
                                'https://cdn-developer-wp.arc.dev/wp-content/uploads/2021/08/Adham-Dannaway-home.gif',
                            'description':
                                'Leaf Eaters are insects that eat leaves. Leaf Eaters are insects that eat leaves. Leaf Eaters are insects that eat leaves. Leaf Eaters are insects that eat leaves. Leaf Eaters are insects that eat leaves. Leaf Eaters are insects that eat leaves. Leaf Eaters are insects that eat leaves. Leaf Eaters are insects that eat leaves'
                          },
                          {
                            'name': 'Fruit Flies',
                            'image': 'assets/fruit_flies.png',
                            'description':
                                'Fruit Flies are small flying insects that infest fruits'
                          },
                        ]
                      },
                      {
                        'stageName': 'Planting Stage 2',
                        'pests': [
                          {
                            'name': 'Swirling Virus',
                            'image': 'assets/swirling.png',
                            'description': 'Swirling Virus is a virus'
                          },
                          {
                            'name': 'Leaf Eaters',
                            'image':
                                'https://cdn-developer-wp.arc.dev/wp-content/uploads/2021/08/Adham-Dannaway-home.gif',
                            'description':
                                'Leaf Eaters are insects that eat leaves. Leaf Eaters are insects that eat leaves. Leaf Eaters are insects that eat leaves. Leaf Eaters are insects that eat leaves. Leaf Eaters are insects that eat leaves. Leaf Eaters are insects that eat leaves. Leaf Eaters are insects that eat leaves. Leaf Eaters are insects that eat leaves'
                          },
                          {
                            'name': 'Fruit Flies',
                            'image': 'assets/fruit_flies.png',
                            'description':
                                'Fruit Flies are small flying insects that infest fruits'
                          },
                        ]
                      },
                    ]
                  });
                },
                child: Text('scam')),
            ElevatedButton(
              onPressed: () async {
                QuerySnapshot<Map<String, dynamic>> querySnapshot =
                    await _firestore
                        .collection('buyer')
                        .where(FieldPath.documentId, isNotEqualTo: null)
                        .where('profileData', isNotEqualTo: null)
                        .get();

                var documents = querySnapshot.docs;

                // for (var document in documents) {
                //   Map<String, dynamic> data = document.data()!;
                //   if (data['profileData']['address'].isNotEmpty) {
                //     Map<String, dynamic> data = document.data()!;
                //     if (data['profileData']['address'][0]['pincode'] ==
                //         savedData.address[0].pincode) {
                //       friendsCount++;
                //
                //     }
                //   }
                // }

                for (var document in documents) {
                  Map<String, dynamic> data = document.data();

                  // if (data['profileData'] == null) {
                  //   continue;
                  // }

                  //
                  //

                  // if (data['profileData']['address'][0]['pincode'] ==
                  //     savedData.address[0].pincode) {
                  //   friendsCount++;
                  //
                  // }
                }
              },
              child: const Text('Back'),
            ),
          ],
        ));
  }
}
