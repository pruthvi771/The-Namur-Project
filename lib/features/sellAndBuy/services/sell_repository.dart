import 'dart:io';
import 'package:active_ecommerce_flutter/features/sellAndBuy/models/sell_product.dart';
import 'package:active_ecommerce_flutter/utils/enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class SellRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> addProductBuying({
    required String productName,
    required String productDescription,
    required double productPrice,
    required int productQuantity,
    required String quantityUnit,
    // required String priceType,
    required String category,
    required String subCategory,
    required String subSubCategory,
    required List imageURL,
    required String userId,
    required bool isSecondHand,
    required String villageName,
    required String district,
    required String taluk,
    required String gramPanchayat,
  }) async {
    try {
      // Get a reference to the Firestore collection
      CollectionReference products = _firestore.collection('products');

      // Add a new document with a generated ID
      DocumentReference documentReference = await products.add({
        'name': productName,
        'description': productDescription,
        'price': productPrice,
        'quantity': productQuantity,
        'quantityUnit': quantityUnit,
        // 'priceType': priceType,
        'category': category,
        'subCategory': subCategory,
        'subSubCategory': subSubCategory,
        'imageURL': imageURL,
        'sellerId': userId,
        'isSecondHand': isSecondHand,
        'rating': 0.0,
        'numberOfRatings': 0,
        'villageName': villageName,
        'district': district,
        'taluk': taluk,
        'gramPanchayat': gramPanchayat,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'isDeleted': false,
      });
      return documentReference.id;
    } catch (e) {
      return null; // Return null in case of error
    }
  }

  Future<String?> addMachineBuying({
    required String productName,
    required String productDescription,
    required double productPrice,
    required int productQuantity,
    required String quantityUnit,
    // required String priceType,
    required String category,
    required String subCategory,
    required String subSubCategory,
    required List imageURL,
    required String userId,
    required bool isSecondHand,
    required int runningHours,
    required int kms,
    required String villageName,
    required String district,
    required String taluk,
    required String gramPanchayat,
    required String hiveMachineName,
    required String landSynoValue,
  }) async {
    try {
      // Get a reference to the Firestore collection
      CollectionReference products = _firestore.collection('products');

      // Add a new document with a generated ID
      DocumentReference documentReference = await products.add({
        'name': productName,
        'description': productDescription,
        'price': productPrice,
        'quantity': productQuantity,
        'quantityUnit': quantityUnit,
        // 'priceType': priceType,
        'category': category,
        'subCategory': subCategory,
        'subSubCategory': subSubCategory,
        'imageURL': imageURL,
        'sellerId': userId,
        'isSecondHand': isSecondHand,
        'runningHours': runningHours,
        'kms': kms,
        'rating': 0.0,
        'numberOfRatings': 0,
        'villageName': villageName,
        'district': district,
        'taluk': taluk,
        'gramPanchayat': gramPanchayat,
        'hiveMachineName': hiveMachineName,
        'landSynoValue': landSynoValue,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'isDeleted': false,
      });
      return documentReference.id;
    } catch (e) {
      return null; // Return null in case of error
    }
  }

  Future<void> editAddressForAllProductsAndSellerDocument({
    required String sellerId,
    required String district,
    required String gramPanchayat,
    required String taluk,
    required String villageName,
  }) async {
    try {
      CollectionReference products = _firestore.collection('products');

      await saveAddressToSellerDocument(
        sellerId: sellerId,
        district: district,
        gramPanchayat: gramPanchayat,
        taluk: taluk,
        villageName: villageName,
      );

      List<String>? productsForSeller =
          await getAllProductIdsForSeller(sellerId: sellerId);

      if (productsForSeller == null || productsForSeller.length == 0) {
        return;
      }

      for (String product in productsForSeller) {
        await products.doc(product).update({
          'villageName': villageName,
          'gramPanchayat': gramPanchayat,
          'district': district,
          'taluk': taluk,
        });
      }
    } catch (e) {
      // Handle the error according to your application's requirements
    }
  }

  Future<void> saveAddressToSellerDocument({
    required String sellerId,
    required String district,
    required String gramPanchayat,
    required String taluk,
    required String villageName,
  }) async {
    try {
      CollectionReference sellerCollection = _firestore.collection('seller');

      await sellerCollection.doc(sellerId).update({
        'villageName': villageName,
        'gramPanchayat': gramPanchayat,
        'district': district,
        'taluk': taluk,
      });
    } catch (e) {
      // Handle the error according to your application's requirements
    }
  }

  Future<void> addProductParentNameToSellerDocument({
    required String sellerId,
    required String parentName,
  }) async {
    try {
      CollectionReference sellerCollection = _firestore.collection('seller');

      await sellerCollection.doc(sellerId).update({
        'productParentNames': FieldValue.arrayUnion([parentName])
      });
    } catch (e) {
      // Handle the error according to your application's requirements
    }
  }

  Future<List<String>?> getAllProductIdsForSeller({
    required String sellerId,
  }) async {
    try {
      var userSnapshot =
          await _firestore.collection('seller').doc(sellerId).get();

      List<String> products = [];

      for (var product in userSnapshot.data()!['products']) {
        products.add(product);
      }

      for (var product in userSnapshot.data()!['secondHandProducts']) {
        products.add(product);
      }

      //

      if (products.length == 0) {
        return null;
      }

      return products;
    } catch (e) {
      // Handle the error according to your application's requirements
    }
  }

  Future<String?> editProductBuying({
    required String productId,
    required String productName,
    required String productDescription,
    required double productPrice,
    required int productQuantity,
    required String quantityUnit,
    required String category,
    required String subCategory,
    required String subSubCategory,
    // required String imageURL,
    // required String userId,
  }) async {
    CollectionReference products = _firestore.collection('products');

    try {
      await products.doc(productId).update({
        'name': productName,
        'description': productDescription,
        'price': productPrice,
        'quantity': productQuantity,
        'quantityUnit': quantityUnit,
        'category': category,
        'subCategory': subCategory,
        'subSubCategory': subSubCategory,
        'updatedAt': FieldValue.serverTimestamp(),
        // 'imageURL': imageURL,
      });
    } catch (e) {
      // Handle the error according to your application's requirements
    }
  }

  Future<String?> editMachineBuying({
    required String productId,
    required String productName,
    required String productDescription,
    required double productPrice,
    required int productQuantity,
    required String quantityUnit,
    required String category,
    required String subCategory,
    required String subSubCategory,
    required int runningHours,
    required int kms,
    required String hiveMachineName,
    required String landSynoValue,
    // required String imageURL,
    // required String userId,
  }) async {
    CollectionReference products = _firestore.collection('products');

    try {
      await products.doc(productId).update({
        'name': productName,
        'description': productDescription,
        'price': productPrice,
        'quantity': productQuantity,
        'quantityUnit': quantityUnit,
        'category': category,
        'subCategory': subCategory,
        'subSubCategory': subSubCategory,
        'runningHours': runningHours,
        'kms': kms,
        'hiveMachineName': hiveMachineName,
        'landSynoValue': landSynoValue,
        'updatedAt': FieldValue.serverTimestamp(),
        // 'imageURL': imageURL,
      });
    } catch (e) {
      // Handle the error according to your application's requirements
    }
  }

  Future<List<SellProduct>> getProducts({
    required String subCategory,
    required bool isSecondHand,
  }) async {
    // QuerySnapshot productSnapshot = await productsCollection.get();

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('products')
        .where(FieldPath.documentId, isNotEqualTo: null)
        .where('subCategory', isEqualTo: subCategory)
        .where('sellerId', isEqualTo: _firebaseAuth.currentUser!.uid)
        .where('isSecondHand', isEqualTo: isSecondHand)
        .where('isDeleted', isNotEqualTo: true)
        .get();

    var products = querySnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data();

      return SellProduct(
        id: doc.id,
        productName: data['name'],
        productDescription: data['description'],
        productPrice: data['price'],
        productQuantity: data['quantity'],
        quantityUnit: data['quantityUnit'],
        // priceType: data['priceType'],
        category: data['category'],
        subCategory: data['subCategory'],
        subSubCategory: data['subSubCategory'],
        imageURL: data['imageURL'],
        sellerId: data['sellerId'],
        isSecondHand: data['isSecondHand'],
        village: data['villageName'],
        gramPanchayat: data['gramPanchayat'],
        taluk: data['taluk'],
        district: data['district'],
        createdAt: data['createdAt'].toDate(),
      );
    }).toList();

    return products;
  }

  Future<List<SellProduct>> getAllProducts() async {
    // QuerySnapshot productSnapshot = await productsCollection.get();

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('products')
        .where(FieldPath.documentId, isNotEqualTo: null)
        .where('sellerId', isEqualTo: _firebaseAuth.currentUser!.uid)
        .where('isDeleted', isNotEqualTo: true)
        .get();

    var products = querySnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data();

      return SellProduct(
        id: doc.id,
        productName: data['name'],
        productDescription: data['description'],
        productPrice: data['price'],
        productQuantity: data['quantity'],
        quantityUnit: data['quantityUnit'],
        // priceType: data['priceType'],
        category: data['category'],
        subCategory: data['subCategory'],
        subSubCategory: data['subSubCategory'],
        imageURL: data['imageURL'],
        sellerId: data['sellerId'],
        isSecondHand: data['isSecondHand'],
        village: data['villageName'],
        gramPanchayat: data['gramPanchayat'],
        taluk: data['taluk'],
        district: data['district'],
        createdAt: data['createdAt'].toDate(),
      );
    }).toList();

    return products;
  }

  Future<void> deleteProduct({
    required String productId,
  }) async {
    try {
      await _firestore.collection('products').doc(productId).delete();
    } catch (_) {
      throw Exception('Something went wrong. Please try again.');
    }
  }

  Future<void> setProductToDelete({
    required String productId,
  }) async {
    CollectionReference products = _firestore.collection('products');

    try {
      await products.doc(productId).update({
        'isDeleted': true,
      });
    } catch (e) {
      // Handle the error according to your application's requirements
    }
  }

  Future<void> removeProductFromSellerDocument(
      {required String productId, required String sellerId}) async {
    CollectionReference sellerCollection = _firestore.collection('seller');

    try {
      await sellerCollection.doc(sellerId).update({
        'products': FieldValue.arrayRemove([productId]),
        'secondHandProducts': FieldValue.arrayRemove([productId])
      });
    } catch (e) {}
  }

  Future<List<String>?> uploadImagesToFirebaseStorage({
    required List<XFile> imageFiles,
    required String docId,
  }) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;

      List<String> downloadURLs = [];

      int fileNameIndex = 0;

      for (var imageFile in imageFiles) {
        File file = File(imageFile.path);
        String fileName = fileNameIndex.toString();
        fileNameIndex++;

        // Reference to the image file in Firebase Storage
        Reference ref = storage.ref().child('products/$docId/$fileName');

        // Upload file to Firebase Storage
        await ref.putFile(file);

        // Get the download URL of the uploaded file
        String downloadURL = await ref.getDownloadURL();
        downloadURLs.add(downloadURL);
      }

      return downloadURLs;
    } catch (e) {}
    return null;
  }

  Future<void> saveProductImages({
    required List<XFile> imageList,
    required String docId,
  }) async {
    try {
      var imageURL = await uploadImagesToFirebaseStorage(
          docId: docId, imageFiles: imageList);
      await _firestore.collection('products').doc(docId).update({
        'imageURL': imageURL,
      });
    } catch (_) {
      throw Exception('Something went wrong. Please try again.');
    }
  }

  Future<void> deleteProductImagesByProductId(
      {required String productId}) async {
    try {
      var storage = FirebaseStorage.instance;
      var productImagesRef = storage.ref().child('product_images/$productId');

      var productsList = await productImagesRef.listAll();

      // Delete each image in the folder
      await Future.forEach(productsList.items, (Reference imageRef) async {
        await imageRef.delete();
      });

      await _firestore.collection('products').doc(productId).update({
        'imageURL': [],
      });
    } catch (error) {
      throw Exception('Failed to delete product images. Please try again.');
    }
  }

  Future<void> addProductToSellerDocument({
    required String productDocId,
    required ProductType productType,
    required String sellerId,
  }) async {
    CollectionReference sellerCollection = _firestore.collection('seller');

    try {
      if (productType == ProductType.newProduct) {
        await sellerCollection.doc(sellerId).update({
          'products': FieldValue.arrayUnion([productDocId])
        });
      } else if (productType == ProductType.secondHand) {
        await sellerCollection.doc(sellerId).update({
          'secondHandProducts': FieldValue.arrayUnion([productDocId])
        });
      }
      // else if (productType == ProductType.onRent) {
      //   await sellerCollection.doc(sellerId).update({
      //     'onRent': FieldValue.arrayUnion([productDocId])
      //   });
      // }
    } catch (e) {
      // Handle the error according to your application's requirements
    }
  }
}
