import 'package:active_ecommerce_flutter/features/profile/models/userdata.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/models/sell_product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BuyRepository {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<SellProduct>> getProductsForSubSubCategory({
    required String subSubCategory,
  }) async {
    // QuerySnapshot productSnapshot = await productsCollection.get();

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
        .collection('products')
        .where(FieldPath.documentId, isNotEqualTo: null)
        .where('subSubCategory', isEqualTo: subSubCategory)
        .where('isDeleted', isNotEqualTo: true)
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
        village: data['villageName'],
        gramPanchayat: data['gramPanchayat'],
        taluk: data['taluk'],
        district: data['district'],
        createdAt: data['createdAt'].toDate(),
      );
    }).toList();
    print(products.length);

    return products;
  }

  Future<List<SellProduct>> getProductsForSubCategory({
    required String subCategory,
    // required bool isSecondHand,
  }) async {
    // QuerySnapshot productSnapshot = await productsCollection.get();

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
        .collection('products')
        .where(FieldPath.documentId, isNotEqualTo: null)
        .where('subCategory', isEqualTo: subCategory)
        .where('isSecondHand', isEqualTo: false)
        .where('isDeleted', isNotEqualTo: true)
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
        village: data['villageName'],
        gramPanchayat: data['gramPanchayat'],
        taluk: data['taluk'],
        district: data['district'],
        createdAt: data['createdAt'].toDate(),
      );
    }).toList();
    print(products.length);

    return products;
  }

  Future<BuyerData> getSellerData({
    required String userId,
  }) async {
    // QuerySnapshot productSnapshot = await productsCollection.get();

    var userSnapshot = await _firestore.collection('buyer').doc(userId).get();
    return BuyerData.fromJson(userSnapshot.data() as Map<String, dynamic>);
  }

  Future<void> updateRatingInOrderDoc({
    required String orderId,
    required int indexInOrderItems,
    required double rating,
  }) async {
    final cartDoc = await _firestore.collection('orders').doc(orderId).get();

    var items = cartDoc.data()!['items'];

    items[indexInOrderItems]['rating'] = rating;

    await _firestore.collection('orders').doc(orderId).update({'items': items});
  }

  Future<double> getRatingFromOrderDoc({
    required String orderId,
    required int indexInOrderItems,
  }) async {
    final cartDoc = await _firestore.collection('orders').doc(orderId).get();

    var items = cartDoc.data()!['items'];

    return items[indexInOrderItems]['rating'];
  }

  Future<void> updateRatingInProductDoc({
    required double? initialRatingInProductDoc,
    required String productId,
    required double rating,
    required bool isFirstTime,
  }) async {
    final productDoc =
        await _firestore.collection('products').doc(productId).get();

    var initialRating = productDoc.data()!['rating'];
    var initialNumberOfRatings = productDoc.data()!['numberOfRatings'];
    if (initialRatingInProductDoc == null) {
      initialRatingInProductDoc = 0;
    }

    await _firestore.collection('products').doc(productId).update(
      {
        'rating': initialRating - initialRatingInProductDoc + rating,
        'numberOfRatings':
            isFirstTime ? initialNumberOfRatings + 1 : initialNumberOfRatings,
      },
    );
  }

  Future<Map> getRunningHoursAndKmsForMachine({
    required String machineId,
  }) async {
    // QuerySnapshot productSnapshot = await productsCollection.get();

    var userSnapshot =
        await _firestore.collection('products').doc(machineId).get();
    // return BuyerData.fromJson(userSnapshot.data() as Map<String, dynamic>);
    return {
      'runningHours': userSnapshot.data()!['runningHours'],
      'kms': userSnapshot.data()!['kms'],
      'rating': userSnapshot.data()!['rating'],
      'numberOfRatings': userSnapshot.data()!['numberOfRatings'],
    };
  }

  Future<Map> getRatingOfProduct({
    required String productId,
  }) async {
    // QuerySnapshot productSnapshot = await productsCollection.get();

    var userSnapshot =
        await _firestore.collection('products').doc(productId).get();
    // return BuyerData.fromJson(userSnapshot.data() as Map<String, dynamic>);
    return {
      'rating': userSnapshot.data()!['rating'],
      'numberOfRatings': userSnapshot.data()!['numberOfRatings'],
    };
  }

  Future<List<SellProduct>> getSecondHandProductsForSubCategory({
    required String subCategory,
  }) async {
    // QuerySnapshot productSnapshot = await productsCollection.get();

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
        .collection('products')
        .where(FieldPath.documentId, isNotEqualTo: null)
        .where('subCategory', isEqualTo: subCategory)
        .where('isSecondHand', isEqualTo: true)
        .where('isDeleted', isNotEqualTo: true)
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
        village: data['villageName'],
        gramPanchayat: data['gramPanchayat'],
        taluk: data['taluk'],
        district: data['district'],
        createdAt: data['createdAt'].toDate(),
      );
    }).toList();
    print(products.length);

    return products;
  }
}
