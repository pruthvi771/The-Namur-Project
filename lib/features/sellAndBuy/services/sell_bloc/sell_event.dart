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
  final String parentName;
  final String hiveMachineName;
  final String landSynoValue;

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
    this.landSynoValue = "",
    this.hiveMachineName = "",
    required this.district,
    required this.taluk,
    required this.gramPanchayat,
    required this.villageName,
    required this.parentName,
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
        hiveMachineName,
        landSynoValue,
        district,
        taluk,
        gramPanchayat,
        villageName,
        parentName,
      ];
}

class EditProductRequested extends SellEvent {
  final String productId;
  final String productName;
  final String productDescription;
  final double productPrice;
  final int productQuantity;
  final bool isSecondHand;
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
  final String landSynoValue;
  final String hiveMachineName;
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
    required this.isSecondHand,
    required this.areImagesUpdated,
    this.imageList,
    this.kms,
    this.runningHours,
    this.isMachine = false,
    this.landSynoValue = "",
    this.hiveMachineName = "",
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
        isMachine,
        landSynoValue,
        // image,
      ];
}

class ProductsForSubCategoryRequested extends SellEvent {
  final String subCategory;
  final bool isSecondHand;
  final bool isMachine;

  const ProductsForSubCategoryRequested({
    required this.subCategory,
    required this.isSecondHand,
    required this.isMachine,
  });

  @override
  List<Object> get props => [subCategory];
}

class SellerInventoryRequested extends SellEvent {
  const SellerInventoryRequested();

  @override
  List<Object> get props => [];
}

class DeleteProductRequested extends SellEvent {
  final String productId;

  const DeleteProductRequested({
    required this.productId,
  });

  @override
  List<Object> get props => [productId];
}

class UpdateAddressInProductsAndSellerDocumentRequested extends SellEvent {
  final String district;
  final String taluk;
  final String gramPanchayat;
  final String villageName;

  const UpdateAddressInProductsAndSellerDocumentRequested({
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
