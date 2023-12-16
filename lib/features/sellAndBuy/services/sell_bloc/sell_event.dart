import 'package:active_ecommerce_flutter/utils/enums.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

abstract class SellEvent extends Equatable {
  const SellEvent();

  @override
  List<Object> get props => [];
}

class AddProductRequested extends SellEvent {
  final String productName;
  final String productDescription;
  final double productPrice;
  final int productQuantity;
  final String quantityUnit;
  // final String priceType;
  final String category;
  final String subCategory;
  final String subSubCategory;
  final List<XFile> imageList;
  final bool isSecondHand;
  final ProductType productType;
  final int runningHours;
  final int kms;
  final bool isMachine;
  final String district;
  final String taluk;
  final String gramPanchayat;
  final String villageName;

  const AddProductRequested({
    required this.productName,
    required this.productDescription,
    required this.productPrice,
    required this.productQuantity,
    required this.quantityUnit,
    // required this.priceType,
    required this.category,
    required this.subCategory,
    required this.subSubCategory,
    required this.imageList,
    required this.isSecondHand,
    required this.productType,
    this.runningHours = 0,
    this.kms = 0,
    this.isMachine = false,
    required this.district,
    required this.taluk,
    required this.gramPanchayat,
    required this.villageName,
  });

  @override
  List<Object> get props => [
        productName,
        productDescription,
        productPrice,
        productQuantity,
        quantityUnit,
        category,
        subCategory,
        subSubCategory,
        imageList,
        isSecondHand,
        productType,
        runningHours,
        kms,
        isMachine,
        district,
        taluk,
        gramPanchayat,
        villageName,
      ];
}

class EditProductRequested extends SellEvent {
  final String productId;
  final String productName;
  final String productDescription;
  final double productPrice;
  final int productQuantity;
  final String quantityUnit;
  // final String priceType;
  final String category;
  final String subCategory;
  final String subSubCategory;
  final bool areImagesUpdated;
  final List<XFile>? imageList;
  final int? runningHours;
  final int? kms;
  final bool isMachine;
  // final Uint8List image;

  const EditProductRequested({
    required this.productId,
    required this.productName,
    required this.productDescription,
    required this.productPrice,
    required this.productQuantity,
    required this.quantityUnit,
    required this.category,
    required this.subCategory,
    required this.subSubCategory,
    required this.areImagesUpdated,
    this.imageList,
    this.kms,
    this.runningHours,
    this.isMachine = false,
    // required this.image,
  });

  @override
  List<Object> get props => [
        productId,
        productName,
        productDescription,
        productPrice,
        productQuantity,
        quantityUnit,
        category,
        subCategory,
        subSubCategory,
        areImagesUpdated,
        imageList!,
        runningHours!,
        kms!,
        // image,
      ];
}

class ProductsForSubCategoryRequested extends SellEvent {
  final String subCategory;
  final bool isSecondHand;

  const ProductsForSubCategoryRequested({
    required this.subCategory,
    required this.isSecondHand,
  });

  @override
  List<Object> get props => [subCategory];
}

class DeleteProductRequested extends SellEvent {
  final String productId;

  const DeleteProductRequested({
    required this.productId,
  });

  @override
  List<Object> get props => [productId];
}

class UpdateAddressInProductsRequested extends SellEvent {
  final String district;
  final String taluk;
  final String gramPanchayat;
  final String villageName;

  const UpdateAddressInProductsRequested({
    required this.district,
    required this.taluk,
    required this.gramPanchayat,
    required this.villageName,
  });

  @override
  List<Object> get props => [
        district,
        taluk,
        gramPanchayat,
        villageName,
      ];
}
