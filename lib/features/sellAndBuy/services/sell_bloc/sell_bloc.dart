import 'package:active_ecommerce_flutter/features/auth/services/auth_repository.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/models/sell_product.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/services/sell_bloc/sell_event.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/services/sell_bloc/sell_state.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/services/sell_repository.dart';
import 'package:bloc/bloc.dart';

class SellBloc extends Bloc<SellEvent, SellState> {
  final AuthRepository authRepository;
  final SellRepository sellRepository;

  SellBloc({required this.authRepository, required this.sellRepository})
      : super(SellInitial()) {
    on<SellEvent>((event, emit) {});

    on<AddProductRequested>((event, emit) async {
      emit(ProductAddEditDeleteLoading());
      var currentUser = authRepository.currentUser!;

      try {
        var docId;
        if (event.isMachine) {
          docId = await sellRepository.addMachineBuying(
            hiveMachineName: event.hiveMachineName,
            landSynoValue: event.landSynoValue,
            productName: event.productName,
            productDescription: event.productDescription,
            productPrice: event.productPrice,
            productQuantity: event.productQuantity,
            quantityUnit: event.quantityUnit,
            // priceType: event.priceType,
            category: event.category,
            subCategory: event.subCategory,
            subSubCategory: event.subSubCategory,
            imageURL: [],
            userId: currentUser.userId,
            isSecondHand: event.isSecondHand,
            runningHours: event.runningHours,
            kms: event.kms,
            villageName: event.villageName,
            gramPanchayat: event.gramPanchayat,
            taluk: event.taluk,
            district: event.district,
          );
        } else {
          docId = await sellRepository.addProductBuying(
            productName: event.productName,
            productDescription: event.productDescription,
            productPrice: event.productPrice,
            productQuantity: event.productQuantity,
            quantityUnit: event.quantityUnit,
            // priceType: event.priceType,
            category: event.category,
            subCategory: event.subCategory,
            subSubCategory: event.subSubCategory,
            imageURL: [],
            userId: currentUser.userId,
            isSecondHand: event.isSecondHand,
            villageName: event.villageName,
            gramPanchayat: event.gramPanchayat,
            taluk: event.taluk,
            district: event.district,
          );
        }

        // await sellRepository.saveProductImage(file: event.image, docId: docId!);
        await sellRepository.saveProductImages(
            imageList: event.imageList, docId: docId!);

        await sellRepository.addProductToSellerDocument(
          productDocId: docId,
          sellerId: currentUser.userId,
          productType: event.productType,
        );

        await sellRepository.addProductParentNameToSellerDocument(
          sellerId: currentUser.userId,
          parentName: event.parentName,
        );

        emit(ProductAddEditDeleteSuccessfully());

        // emit(SellAddProductSuccessState());
      } catch (e) {
        // emit(SellAddProductErrorState(message: e.toString()));
        print('error happened');
      }
    });

    on<UpdateAddressInProductsAndSellerDocumentRequested>((event, emit) async {
      emit(ProductAddEditDeleteLoading());
      try {
        var currentUser = authRepository.currentUser!;

        // await sellRepository.saveProductImage(file: event.image, docId: docId!);

        await sellRepository.editAddressForAllProductsAndSellerDocument(
          sellerId: currentUser.userId,
          district: event.district,
          taluk: event.taluk,
          gramPanchayat: event.gramPanchayat,
          villageName: event.villageName,
        );

        emit(ProductAddEditDeleteSuccessfully());
      } catch (e) {
        // emit(SellAddProductErrorState(message: e.toString()));
        print('error trying to update address in products');
      }
    });

    on<ProductsForSubCategoryRequested>((event, emit) async {
      try {
        emit(ProductLoading());
        List<SellProduct> products = await sellRepository.getProducts(
          subCategory: event.subCategory,
          isSecondHand: event.isSecondHand,
        );

        emit(ProductsForSubCategoryReceived(products: products));
      } catch (e) {
        // emit(SellAddProductErrorState(message: e.toString()));
        print('error happened in ProductsForSubCategoryRequested');
        print(e.toString());
      }
    });

    on<DeleteProductRequested>((event, emit) async {
      try {
        emit(ProductAddEditDeleteLoading());
        var currentUser = authRepository.currentUser!;
        // await sellRepository.deleteProduct(productId: event.productId);
        await sellRepository.setProductToDelete(productId: event.productId);
        await sellRepository.removeProductFromSellerDocument(
            productId: event.productId, sellerId: currentUser.userId);
        emit(ProductAddEditDeleteSuccessfully());
      } catch (e) {
        // emit(SellAddProductErrorState(message: e.toString()));
        print('error happened in DeleteProductRequested');
        print(e.toString());
      }
    });

    on<EditProductRequested>((event, emit) async {
      emit(ProductAddEditDeleteLoading());
      try {
        if (event.isMachine) {
          await sellRepository.editMachineBuying(
            hiveMachineName: event.hiveMachineName,
            productId: event.productId,
            productName: event.productName,
            productDescription: event.productDescription,
            productPrice: event.productPrice,
            productQuantity: event.productQuantity,
            quantityUnit: event.quantityUnit,
            category: event.category,
            subCategory: event.subCategory,
            subSubCategory: event.subSubCategory,
            runningHours: event.runningHours!,
            kms: event.kms!,
            landSynoValue: event.landSynoValue,
          );
        } else {
          await sellRepository.editProductBuying(
            productId: event.productId,
            productName: event.productName,
            productDescription: event.productDescription,
            productPrice: event.productPrice,
            productQuantity: event.productQuantity,
            quantityUnit: event.quantityUnit,
            category: event.category,
            subCategory: event.subCategory,
            subSubCategory: event.subSubCategory,
          );
        }

        if (event.areImagesUpdated) {
          await sellRepository.deleteProductImagesByProductId(
              productId: event.productId);
          await sellRepository.saveProductImages(
              imageList: event.imageList!, docId: event.productId);
        }

        emit(ProductAddEditDeleteSuccessfully());
      } catch (e) {
        // emit(SellAddProductErrorState(message: e.toString()));
        print('error happened in EditProductRequested');
        print(e.toString());
      }
    });

    on<SellerInventoryRequested>((event, emit) async {
      try {
        emit(ProductLoading());
        List<SellProduct> products = await sellRepository.getAllProducts();

        emit(SellerInventoryReceived(products: products));
      } catch (e) {
        // emit(SellAddProductErrorState(message: e.toString()));
        print('error happened in ProductsForSubCategoryRequested');
        print(e.toString());
      }
    });
  }
}
