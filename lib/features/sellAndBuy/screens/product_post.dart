import 'dart:io';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:active_ecommerce_flutter/features/profile/services/hive_bloc/hive_bloc.dart';
import 'package:active_ecommerce_flutter/features/profile/services/hive_bloc/hive_event.dart';
import 'package:active_ecommerce_flutter/features/profile/services/hive_bloc/hive_state.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/models/sell_product.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/services/sell_bloc/sell_bloc.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/services/sell_bloc/sell_event.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/utils/enums.dart';
import 'package:active_ecommerce_flutter/utils/functions.dart';
import 'package:active_ecommerce_flutter/utils/hive_models/models.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:active_ecommerce_flutter/utils/enums.dart' as enums;
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';

class ProductPost extends StatefulWidget {
  final SubCategoryEnum subCategoryEnum;
  final List<String> alreadyExistingProductNames;

  final bool isProductEditScreen;
  final SellProduct? sellProduct;

  final bool isMachine;

  final bool isSecondHand;

  const ProductPost({
    Key? key,
    required this.subCategoryEnum,
    required this.alreadyExistingProductNames,
    this.isProductEditScreen = false,
    this.sellProduct,
    this.isMachine = false,
    required this.isSecondHand,
  }) : super(key: key);

  @override
  State<ProductPost> createState() => _ProductPostState();
}

class _ProductPostState extends State<ProductPost> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _runningHoursController = TextEditingController();
  TextEditingController _kmsController = TextEditingController();
  TextEditingController _additionalController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();

  String? _selectedItem;

  late List<String> _dropdownItems;

  late String category;
  late String subCategory;

  List<dynamic>? imageURL;

  var listOfQuantityUnits = nameForProductQuantity.values.toList();
  String? selectedQuantityUnit;

  bool hideQuantityBox = false;

  List<XFile>? _mediaFileList;
  final ImagePicker imagePicker = ImagePicker();
  List imagesOnFirebase = [];

  late ParentEnum parentEnum;

  String? hiveMachineDropdown;
  String? landDropdownValue;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<HiveBloc>(context).add(
      HiveDataRequested(),
    );

    category = enums.nameForCategoryEnum[
        enums.findCategoryForSubCategory(widget.subCategoryEnum)]!;
    parentEnum = enums.findParentForCategory(
        enums.findCategoryForSubCategory(widget.subCategoryEnum)!)!;
    subCategory = enums.nameForSubCategoryEnum[widget.subCategoryEnum]!;

    if (parentEnum == ParentEnum.machine) {
      _dropdownItems = ['On Rent', 'Sell'];
      hideQuantityBox = true;
      _quantityController.text = "1";
    } else {
      hideQuantityBox = false;
      _dropdownItems = enums.SubSubCategoryList[widget.subCategoryEnum] ??
          [nameForSubCategoryEnum[widget.subCategoryEnum]!];
    }

    if (widget.isProductEditScreen) {
      _nameController.text = widget.sellProduct!.productName;
      _additionalController.text = widget.sellProduct!.productDescription;
      _priceController.text = widget.sellProduct!.productPrice.toString();
      _quantityController.text = widget.sellProduct!.productQuantity.toString();
      imageURL = widget.sellProduct!.imageURL;
      _selectedItem = widget.sellProduct!.subSubCategory;
      selectedQuantityUnit = widget.sellProduct!.quantityUnit;
      imagesOnFirebase = widget.sellProduct!.imageURL;
    }
  }

  selectImages() async {
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages != null || selectedImages!.isNotEmpty) {
      _mediaFileList = selectedImages;
      printError(_mediaFileList.toString());
      setState(() {});
    }
  }

  onPressedPost(BuildContext buildContext) async {
    //
    var productName = _nameController.text.toString();
    var productSubSubCategory = _selectedItem;
    var description = _additionalController.text.toString();
    var productSubCategory = subCategory;
    var productCategory = category;
    var productQuantity = _quantityController.text.toString();
    var quantityUnit = selectedQuantityUnit;
    String price = _priceController.text;
    var runningHours = _runningHoursController.text.toString();
    var kms = _kmsController.text.toString();
    // String productPriceType = perPiecePrice ? "Per piece" : "Per kg";

    if (productName == "") {
      ToastComponent.showDialog(
          AppLocalizations.of(context)!.enter_product_name,
          gravity: Toast.center,
          duration: Toast.lengthLong);
      // ToastComponent.showDialog(AppLocalizations.of(context)!.enter,
      //     gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }

    if (widget.alreadyExistingProductNames.contains(productName)) {
      ToastComponent.showDialog(
          AppLocalizations.of(context)!.a_product_by_this_name_exists,
          gravity: Toast.center,
          duration: Toast.lengthLong);
      return;
    }

    if (productSubSubCategory == null) {
      ToastComponent.showDialog(AppLocalizations.of(context)!.select_category,
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }
    if (quantityUnit == null) {
      ToastComponent.showDialog(
          AppLocalizations.of(context)!.select_quantity_unit,
          gravity: Toast.center,
          duration: Toast.lengthLong);
      return;
    }
    if (description == "") {
      ToastComponent.showDialog(
          AppLocalizations.of(context)!.enter_product_description,
          gravity: Toast.center,
          duration: Toast.lengthLong);
      return;
    }
    if (price == "") {
      ToastComponent.showDialog(
          AppLocalizations.of(context)!.enter_product_price,
          gravity: Toast.center,
          duration: Toast.lengthLong);
      return;
    }
    if (productQuantity == "") {
      ToastComponent.showDialog(
          AppLocalizations.of(context)!.enter_product_quantity,
          gravity: Toast.center,
          duration: Toast.lengthLong);
      return;
    }
    if (_mediaFileList == null || _mediaFileList!.isEmpty) {
      ToastComponent.showDialog(
          AppLocalizations.of(context)!.select_product_image,
          gravity: Toast.center,
          duration: Toast.lengthLong);
      return;
    }

    double productPrice = 0.0;
    try {
      productPrice = double.parse(price);
    } catch (e) {
      ToastComponent.showDialog(AppLocalizations.of(context)!.enter_valid_price,
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }

    int productQuantityInt = 0;
    try {
      productQuantityInt = int.parse(productQuantity);
    } catch (e) {
      ToastComponent.showDialog(
          AppLocalizations.of(context)!.enter_valid_quantity,
          gravity: Toast.center,
          duration: Toast.lengthLong);
      return;
    }

    int runningHoursInt = 0;
    int kmsInt = 0;

    if (parentEnum == ParentEnum.machine) {
      if (runningHours == "") {
        ToastComponent.showDialog(
            AppLocalizations.of(context)!.enter_running_hours,
            gravity: Toast.center,
            duration: Toast.lengthLong);
        // ToastComponent.showDialog(AppLocalizations.of(context)!.enter,
        //     gravity: Toast.center, duration: Toast.lengthLong);
        return;
      }
      if (kms == "") {
        ToastComponent.showDialog(AppLocalizations.of(context)!.enter_total_kms,
            gravity: Toast.center, duration: Toast.lengthLong);
        // ToastComponent.showDialog(AppLocalizations.of(context)!.enter,
        //     gravity: Toast.center, duration: Toast.lengthLong);
        return;
      }

      if (landDropdownValue == null) {
        ToastComponent.showDialog(AppLocalizations.of(context)!.select_land,
            gravity: Toast.center, duration: Toast.lengthLong);
        // ToastComponent.showDialog(AppLocalizations.of(context)!.enter,
        //     gravity: Toast.center, duration: Toast.lengthLong);
        return;
      }

      if (hiveMachineDropdown == null) {
        ToastComponent.showDialog(AppLocalizations.of(context)!.select_machine,
            gravity: Toast.center, duration: Toast.lengthLong);
        // ToastComponent.showDialog(AppLocalizations.of(context)!.enter,
        //     gravity: Toast.center, duration: Toast.lengthLong);
        return;
      }

      try {
        runningHoursInt = int.parse(runningHours);
      } catch (e) {
        ToastComponent.showDialog('Enter Valid Running Hours',
            gravity: Toast.center, duration: Toast.lengthLong);
        return;
      }

      try {
        kmsInt = int.parse(kms);
      } catch (e) {
        ToastComponent.showDialog('Enter Valid KMs Completed',
            gravity: Toast.center, duration: Toast.lengthLong);
        return;
      }
    }

    Address? userLocation = getUserLocationFromHive();

    if (userLocation == null) {
      ToastComponent.showDialog(
          AppLocalizations.of(context)!.add_address_to_post_products,
          gravity: Toast.center,
          duration: Toast.lengthLong);
      return;
    }

    BlocProvider.of<SellBloc>(buildContext).add(
      AddProductRequested(
        productName: productName,
        productDescription: description,
        productPrice: productPrice,
        productQuantity: productQuantityInt,
        quantityUnit: quantityUnit,
        category: productCategory,
        subCategory: productSubCategory,
        subSubCategory: productSubSubCategory,
        imageList: _mediaFileList!,
        isSecondHand: widget.isSecondHand,
        productType: widget.isSecondHand
            ? ProductType.secondHand
            : ProductType.newProduct,
        runningHours: runningHoursInt,
        kms: kmsInt,
        isMachine: parentEnum == ParentEnum.machine,
        district: userLocation.district,
        taluk: userLocation.taluk,
        gramPanchayat: userLocation.gramPanchayat,
        villageName: userLocation.village,
        parentName: nameForParentEnum[parentEnum]!,
        landSynoValue: landDropdownValue ?? "",
        hiveMachineName: hiveMachineDropdown ?? "",
      ),
    );

    Navigator.pop(context);
  }

  onPressedEdit(BuildContext buildContext) async {
    //
    var productName = _nameController.text.toString();
    var productSubSubCategory = _selectedItem;
    var description = _additionalController.text.toString();
    var productSubCategory = subCategory;
    var productCategory = category;
    var productQuantity = _quantityController.text.toString();
    var quantityUnit = selectedQuantityUnit;
    var runningHours = _runningHoursController.text.toString();
    var kms = _kmsController.text.toString();

    String price = _priceController.text;
    // String productPriceType = perPiecePrice ? "Per piece" : "Per kg";

    if (productName == "") {
      ToastComponent.showDialog(
          AppLocalizations.of(context)!.enter_product_name,
          gravity: Toast.center,
          duration: Toast.lengthLong);
      return;
    }

    if (widget.alreadyExistingProductNames.contains(productName)) {
      ToastComponent.showDialog(
          AppLocalizations.of(context)!.a_product_by_this_name_exists,
          gravity: Toast.center,
          duration: Toast.lengthLong);
      return;
    }

    if (productSubSubCategory == null) {
      ToastComponent.showDialog(AppLocalizations.of(context)!.select_category,
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }
    if (quantityUnit == null) {
      ToastComponent.showDialog(
          AppLocalizations.of(context)!.select_quantity_unit,
          gravity: Toast.center,
          duration: Toast.lengthLong);
      return;
    }
    if (description == "") {
      ToastComponent.showDialog(
          AppLocalizations.of(context)!.enter_product_description,
          gravity: Toast.center,
          duration: Toast.lengthLong);
      return;
    }
    if (price == "") {
      ToastComponent.showDialog(
          AppLocalizations.of(context)!.enter_product_price,
          gravity: Toast.center,
          duration: Toast.lengthLong);
      return;
    }
    if (productQuantity == "") {
      ToastComponent.showDialog(
          AppLocalizations.of(context)!.enter_product_quantity,
          gravity: Toast.center,
          duration: Toast.lengthLong);
      return;
    }
    // if (_image == null) {
    //   ToastComponent.showDialog('Select Product Image',
    //       gravity: Toast.center, duration: Toast.lengthLong);
    //   return;
    // }

    double productPrice = 0.0;
    try {
      productPrice = double.parse(price);
    } catch (e) {
      ToastComponent.showDialog(AppLocalizations.of(context)!.enter_valid_price,
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }

    int productQuantityInt = 0;
    try {
      productQuantityInt = int.parse(productQuantity);
    } catch (e) {
      ToastComponent.showDialog(
          AppLocalizations.of(context)!.enter_valid_quantity,
          gravity: Toast.center,
          duration: Toast.lengthLong);
      return;
    }

    int runningHoursInt = 0;
    int kmsInt = 0;

    if (parentEnum == ParentEnum.machine) {
      if (runningHours == "") {
        ToastComponent.showDialog(
            AppLocalizations.of(context)!.enter_running_hours,
            gravity: Toast.center,
            duration: Toast.lengthLong);
        // ToastComponent.showDialog(AppLocalizations.of(context)!.enter,
        //     gravity: Toast.center, duration: Toast.lengthLong);
        return;
      }
      if (kms == "") {
        ToastComponent.showDialog(AppLocalizations.of(context)!.enter_total_kms,
            gravity: Toast.center, duration: Toast.lengthLong);
        // ToastComponent.showDialog(AppLocalizations.of(context)!.enter,
        //     gravity: Toast.center, duration: Toast.lengthLong);
        return;
      }
      if (landDropdownValue == null) {
        ToastComponent.showDialog(AppLocalizations.of(context)!.select_land,
            gravity: Toast.center, duration: Toast.lengthLong);
        // ToastComponent.showDialog(AppLocalizations.of(context)!.enter,
        //     gravity: Toast.center, duration: Toast.lengthLong);
        return;
      }

      if (hiveMachineDropdown == null) {
        ToastComponent.showDialog(AppLocalizations.of(context)!.select_machine,
            gravity: Toast.center, duration: Toast.lengthLong);
        // ToastComponent.showDialog(AppLocalizations.of(context)!.enter,
        //     gravity: Toast.center, duration: Toast.lengthLong);
        return;
      }

      try {
        runningHoursInt = int.parse(runningHours);
      } catch (e) {
        ToastComponent.showDialog('Enter Valid Running Hours',
            gravity: Toast.center, duration: Toast.lengthLong);
        return;
      }

      try {
        kmsInt = int.parse(kms);
      } catch (e) {
        ToastComponent.showDialog('Enter Valid KMs Completed',
            gravity: Toast.center, duration: Toast.lengthLong);
        return;
      }
    }

    BlocProvider.of<SellBloc>(buildContext).add(
      EditProductRequested(
        isMachine: parentEnum == ParentEnum.machine,
        productId: widget.sellProduct!.id,
        productName: productName,
        productDescription: description,
        productPrice: productPrice,
        productQuantity: productQuantityInt,
        quantityUnit: quantityUnit,
        category: productCategory,
        subCategory: productSubCategory,
        subSubCategory: productSubSubCategory,
        areImagesUpdated: _mediaFileList != null
            ? _mediaFileList!.isNotEmpty
                ? true
                : false
            : false,
        imageList: _mediaFileList,
        runningHours: runningHoursInt,
        kms: kmsInt,
        landSynoValue: landDropdownValue ?? "",
        hiveMachineName: hiveMachineDropdown ?? "",
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
            widget.isProductEditScreen
                ? AppLocalizations.of(context)!.product_ucf
                : AppLocalizations.of(context)!.product_post_ucf,
            style: TextStyle(
                color: MyTheme.white,
                fontWeight: FontWeight.w500,
                letterSpacing: .5,
                fontFamily: 'Poppins')),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xff107B28), Color(0xff4C7B10)]),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.keyboard_arrow_left,
              size: 35,
              color: MyTheme.white,
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      bottomSheet: Container(
        height: 60,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () async {
            widget.isProductEditScreen
                ? await onPressedEdit(context)
                : await onPressedPost(context);
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(MyTheme.primary_color),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(0))),
          ),
          child: Text(
            widget.isProductEditScreen
                ? AppLocalizations.of(context)!.update_product_ucf
                : AppLocalizations.of(context)!.add_to_stock,
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
      ),
      body: bodycontent(),
    );
  }

  bodycontent() {
    var productCategoryEnum =
        enums.findCategoryForSubCategory(widget.subCategoryEnum);
    var showQuantityDropdown = true;
    String machinePriceHintText = 'Price';
    if (productCategoryEnum == CategoryEnum.animals ||
        productCategoryEnum == CategoryEnum.birds ||
        productCategoryEnum == CategoryEnum.machines ||
        productCategoryEnum == CategoryEnum.attachments ||
        productCategoryEnum == CategoryEnum.sparesService) {
      selectedQuantityUnit = listOfQuantityUnits[0];
      showQuantityDropdown = false;
    }
    if (_selectedItem == "On Rent") {
      machinePriceHintText = 'Price (per hr)';
    } else if (_selectedItem == "Sell") {
      machinePriceHintText = 'Price (per unit)';
    }
    return ListView(
      physics: BouncingScrollPhysics(),
      children: [
        // add image
        widget.isProductEditScreen
            ? Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                    height: 200,
                    padding: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: MyTheme.light_grey),
                        borderRadius: BorderRadius.circular(10)),
                    child: _mediaFileList != null
                        ? _mediaFileList!.isNotEmpty
                            ? InkWell(
                                onTap: () {
                                  selectImages();
                                },
                                child: Center(
                                  child: CarouselSlider(
                                    options: CarouselOptions(
                                      enlargeCenterPage: true,
                                      enableInfiniteScroll: false,
                                      autoPlay: false,
                                    ),
                                    items:
                                        _mediaFileList!.map((XFile imageFile) {
                                      return Builder(
                                        builder: (BuildContext context) {
                                          return Image.file(
                                              File(imageFile.path));
                                        },
                                      );
                                    }).toList(),
                                  ),
                                ),
                              )
                            : Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add,
                                        color: MyTheme.primary_color,
                                      ),
                                      Text(
                                        AppLocalizations.of(context)!
                                            .add_featured_image,
                                        style: TextStyle(
                                            color: MyTheme.primary_color,
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "Supported formats are JPG and PNG",
                                    style: TextStyle(
                                      color: MyTheme.dark_grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Divider(),
                                  InkWell(
                                    onTap: () {
                                      selectImages();
                                    },
                                    child: Container(
                                      height: 110,
                                      width: MediaQuery.of(context).size.width,
                                      child: Image.asset(
                                        "assets/imgplaceholder.png",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                        : InkWell(
                            onTap: () {
                              selectImages();
                            },
                            child: Center(
                              child: CarouselSlider(
                                options: CarouselOptions(
                                  enlargeCenterPage: true,
                                  enableInfiniteScroll: false,
                                  autoPlay: false,
                                ),
                                items: imagesOnFirebase.map((imageURL) {
                                  return Builder(
                                    builder: (BuildContext context) {
                                      // return Image.network(imageURL as String);
                                      return CachedNetworkImage(
                                          imageUrl: imageURL as String);
                                    },
                                  );
                                }).toList(),
                              ),
                            ),
                          )))
            : Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  height: 200,
                  padding: EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: MyTheme.light_grey),
                      borderRadius: BorderRadius.circular(10)),
                  child: _mediaFileList != null
                      ? _mediaFileList!.isNotEmpty
                          ? InkWell(
                              onTap: () {
                                selectImages();
                              },
                              child: Center(
                                child: CarouselSlider(
                                  options: CarouselOptions(
                                    viewportFraction: 1,
                                    enlargeCenterPage: true,
                                    enableInfiniteScroll: false,
                                    autoPlay: false,
                                  ),
                                  items: _mediaFileList!.map((XFile imageFile) {
                                    return Builder(
                                      builder: (BuildContext context) {
                                        return Image.file(File(imageFile.path));
                                      },
                                    );
                                  }).toList(),
                                ),
                              ),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add,
                                      color: MyTheme.primary_color,
                                    ),
                                    Text(
                                      AppLocalizations.of(context)!
                                          .add_featured_image,
                                      style: TextStyle(
                                          color: MyTheme.primary_color,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Text(
                                  "Supported formats are JPG and PNG",
                                  style: TextStyle(
                                    color: MyTheme.dark_grey,
                                    fontSize: 14,
                                  ),
                                ),
                                Divider(),
                                InkWell(
                                  onTap: () {
                                    selectImages();
                                  },
                                  child: Container(
                                    height: 110,
                                    width: MediaQuery.of(context).size.width,
                                    child: Image.asset(
                                      "assets/imgplaceholder.png",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add,
                                  color: MyTheme.primary_color,
                                ),
                                Text(
                                  AppLocalizations.of(context)!
                                      .add_featured_image,
                                  style: TextStyle(
                                      color: MyTheme.primary_color,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Text(
                              "Supported formats are JPG and PNG",
                              style: TextStyle(
                                color: MyTheme.dark_grey,
                                fontSize: 14,
                              ),
                            ),
                            Divider(),
                            InkWell(
                              onTap: () {
                                selectImages();
                              },
                              child: Container(
                                height: 110,
                                width: MediaQuery.of(context).size.width,
                                child: Image.asset(
                                  "assets/imgplaceholder.png",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ),

        if (parentEnum == ParentEnum.machine)
          BlocBuilder<HiveBloc, HiveState>(
            builder: (context, state) {
              if (state is HiveDataReceived) {
                List<String> machines = [];

                for (Land land in state.profileData.land) {
                  for (String machine in land.equipments) {
                    machines.add(machine);
                  }
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 25, bottom: 8),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            AppLocalizations.of(context)!.select_machine,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          state.profileData.land.length == 0
                              ? Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                      top: 10.0,
                                      left: 20.0,
                                      right: 5.0,
                                    ),
                                    child: Container(
                                      height: 50,
                                      width: double.infinity,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 12),
                                      decoration: BoxDecoration(
                                          color: MyTheme.field_color,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .add_land_first,
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey[600],
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: 'Poppins'),
                                            ),
                                          ),
                                          Icon(
                                            Icons.block,
                                            size: 20,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : Expanded(
                                  child: Container(
                                    padding: EdgeInsets.only(left: 20),
                                    child: DropdownButtonWidget(
                                      '',
                                      AppLocalizations.of(context)!
                                          .renting_location,
                                      state.profileData.land
                                          .map((e) => DropdownMenuItem<String>(
                                                child: Text(e.village),
                                                value: e.syno,
                                              ))
                                          .toList(),
                                      landDropdownValue,
                                      (value) {
                                        setState(() {
                                          hiveMachineDropdown = null;
                                          landDropdownValue = value;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                          landDropdownValue == null
                              ? Expanded(child: Container())
                              : state.profileData.land
                                          .firstWhere((element) =>
                                              element.syno == landDropdownValue)
                                          .equipments
                                          .length ==
                                      0
                                  ? Expanded(
                                      child: Container(
                                        height: 50,
                                        width: double.infinity,
                                        margin: const EdgeInsets.only(
                                            right: 20, left: 5),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12),
                                        decoration: BoxDecoration(
                                            color: MyTheme.field_color,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            AppLocalizations.of(context)!
                                                .no_machines_added,
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.grey[600],
                                                fontWeight: FontWeight.w400,
                                                fontFamily: 'Poppins'),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5, right: 20),
                                        child: DropdownButtonWidget(
                                          '',
                                          AppLocalizations.of(context)!
                                              .select_machine,
                                          state.profileData.land
                                              .firstWhere((element) =>
                                                  element.syno ==
                                                  landDropdownValue)
                                              .equipments
                                              .map((e) =>
                                                  DropdownMenuItem<String>(
                                                    child: Text(e),
                                                    value: e,
                                                  ))
                                              .toList(),
                                          hiveMachineDropdown,
                                          (value) {
                                            setState(() {
                                              hiveMachineDropdown = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                        ],
                      ),
                    ],
                  ),
                );
              } else {
                return Container();
              }
            },
          ),

        // product name
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Container(
            decoration: BoxDecoration(
                color: MyTheme.field_color,
                borderRadius: BorderRadius.circular(10)),
            child: TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 15),
                hintText: AppLocalizations.of(context)!.product_name_ucf,
                hintStyle: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins'),
              ),
            ),
          ),
        ),

        // product category
        Container(
            margin: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
            decoration: BoxDecoration(
                color: MyTheme.field_color,
                borderRadius: BorderRadius.circular(10)),
            child: DropdownButton<String>(
              padding: EdgeInsets.only(left: 15),
              underline: Container(
                // Remove the underline
                height: 0,
                color: Colors.transparent,
              ),
              value: _selectedItem,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedItem = newValue!;
                });
              },
              items:
                  _dropdownItems.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              hint: SizedBox(
                width: MediaQuery.of(context).size.width /
                    1.3, // Adjust the width to your desired value
                child: Text(
                  AppLocalizations.of(context)!.product_category,
                  style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Poppins'),
                ),
              ),
            )),

        // product quantity
        if (hideQuantityBox == false)
          Container(
            margin: const EdgeInsets.only(top: 20.0, left: 20.0, right: 15.0),
            height: 50, // Specify a fixed height for the container
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: MyTheme.field_color,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      enabled: !hideQuantityBox,
                      controller: _quantityController,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 15),
                        hintText: AppLocalizations.of(context)!.quantity_ucf,
                        hintStyle: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                if (showQuantityDropdown)
                  Container(
                    // width: double.infinity,
                    decoration: BoxDecoration(
                      color: MyTheme.field_color,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 6),
                          child: Icon(
                            Icons.close,
                            color: Colors.grey[600],
                            size: 15,
                          ),
                        ),
                        DropdownButton<String>(
                          dropdownColor: Colors.grey[200],
                          borderRadius: BorderRadius.circular(18),
                          menuMaxHeight: 200,
                          padding: EdgeInsets.only(left: 15, right: 5),
                          underline: Container(
                            height: 0,
                            color: Colors.transparent,
                          ),
                          value: selectedQuantityUnit,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedQuantityUnit = newValue!;
                            });
                          },
                          items: listOfQuantityUnits
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          hint: Text(
                            AppLocalizations.of(context)!.select_quantity_unit,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          // icon: SizedBox(width: 24),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

        // product price
        Container(
          margin:
              EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0, bottom: 20),
          width: MediaQuery.of(context).size.width,
          height: 50,
          decoration: BoxDecoration(
            color: MyTheme.field_color,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: Row(
              children: [
                (productCategoryEnum == CategoryEnum.machines ||
                        productCategoryEnum == CategoryEnum.attachments ||
                        productCategoryEnum == CategoryEnum.sparesService)
                    ? Expanded(
                        child: TextFormField(
                          controller: _priceController,
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: machinePriceHintText,
                            hintStyle: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      )
                    : Expanded(
                        child: TextFormField(
                          controller: _priceController,
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText:
                                "${AppLocalizations.of(context)!.price_ucf} (per ${selectedQuantityUnit == "Units" ? 'unit' : selectedQuantityUnit ?? 'unit'})",
                            hintStyle: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),

        // Text(parentEnum.toString()),

        if (parentEnum == ParentEnum.machine)
          Column(
            children: [
              Container(
                margin: EdgeInsets.only(left: 20.0, right: 20.0),
                decoration: BoxDecoration(
                    color: MyTheme.field_color,
                    borderRadius: BorderRadius.circular(10)),
                child: TextFormField(
                  controller: _runningHoursController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 15),
                    hintText: AppLocalizations.of(context)!.enter_running_hours,
                    hintStyle: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Poppins'),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    top: 20.0, left: 20.0, right: 20.0, bottom: 20),
                decoration: BoxDecoration(
                    color: MyTheme.field_color,
                    borderRadius: BorderRadius.circular(10)),
                child: TextFormField(
                  controller: _kmsController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 15),
                    hintText: AppLocalizations.of(context)!.enter_total_kms,
                    hintStyle: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Poppins'),
                  ),
                ),
              ),
            ],
          ),

        // Text(landDropdownValue.toString()),
        // Text(hiveMachineDropdown.toString()),

        // additional description
        Padding(
          padding: const EdgeInsets.only(
            left: 20.0,
            right: 20.0,
            bottom: 20,
          ),
          child: Container(
            height: 130,
            padding: EdgeInsets.only(left: 5, top: 15, right: 5),
            decoration: BoxDecoration(
                color: MyTheme.field_color,
                borderRadius: BorderRadius.circular(10)),
            child: TextFormField(
              maxLines: 5,
              // maxLength: 300,
              controller: _additionalController,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 15, right: 15),
                hintText: AppLocalizations.of(context)!.description_ucf,
                hintStyle: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins'),
              ),
            ),
          ),
        ),

        Container(
          height: 60,
        ),
      ],
    );
  }

  Container DropdownButtonWidget(
      String title,
      String hintText,
      List<DropdownMenuItem<String>>? itemList,
      String? dropdownValue,
      Function(String) onChanged) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      margin: EdgeInsets.only(top: 0, left: 0, right: 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: MyTheme.field_color,
      ),
      child: DropdownButton<String>(
        hint: Text(
          hintText,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        isExpanded: true,
        value: dropdownValue,
        icon: Icon(Icons.arrow_drop_down),
        iconSize: 24,
        elevation: 16,
        underline: SizedBox(),
        style: TextStyle(
          fontSize: 16,
          color: Colors.black,
        ),
        onChanged: (String? value) {
          onChanged(value!);
        },
        items: itemList,
      ),
    );
  }
}
