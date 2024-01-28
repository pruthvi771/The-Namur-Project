import 'dart:convert';
import 'dart:io';
import 'package:active_ecommerce_flutter/features/auth/services/auth_repository.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/screens/razorpay_payments.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import 'package:http/http.dart' as http;

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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RazorpayPayment(
                        amount: 2,
                      ),
                    ),
                  );
                },
                child: Text('payment')),
            ElevatedButton(
              onPressed: () async {
                var postOfficeResponse = await http.post(
                  Uri.parse('https://pincode.p.rapidapi.com/'),
                  headers: <String, String>{
                    'content-type': 'application/json',
                    'Content-Type': 'application/json',
                    'X-RapidAPI-Key':
                        'eaa65359f4mshafc281c7573fbe7p1d83eajsncdf2af96ce07',
                    'X-RapidAPI-Host': 'pincode.p.rapidapi.com'
                  },
                  body: jsonEncode(<String, String>{
                    'searchBy': 'pincode',
                    'value': "110052",
                  }),
                );

                if (postOfficeResponse.statusCode == 200) {
                  var jsonResponse = json.decode(postOfficeResponse.body);
                  print(jsonResponse);

                  // List<PostOffice> postOffices = [];
                }
              },
              child: const Text('Back'),
            ),
          ],
        ));
  }
}
