import 'package:active_ecommerce_flutter/features/profile/models/userdata.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/models/sell_product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CartRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;

  Future<List<SellProduct>> getProductsForSubSubCategory({
    required String subSubCategory,
  }) async {
    // QuerySnapshot productSnapshot = await productsCollection.get();

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('products')
        .where(FieldPath.documentId, isNotEqualTo: null)
        .where('subSubCategory', isEqualTo: subSubCategory)
        .get();

    var products = querySnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data();
      print(doc.id);
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
      );
    }).toList();
    print(products.length);

    return products;
  }

  Future<Null> addToCart({
    required String productId,
  }) async {
    var currentUser = _firebaseAuth.currentUser!;
    var userDoc =
        await _firestore.collection('buyer').doc(currentUser.uid).get();

    return null;
  }
}
