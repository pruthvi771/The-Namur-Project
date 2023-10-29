import 'dart:typed_data';

import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:active_ecommerce_flutter/features/profile/utils.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/models/sell_product.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/services/sell_bloc/sell_bloc.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/services/sell_bloc/sell_event.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/sell_screen/product_inventory/product_inventory.dart';
import 'package:active_ecommerce_flutter/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:active_ecommerce_flutter/utils/enums.dart' as enums;
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';

const List<String> productList = <String>[
  'Product Category',
  'Two',
  'Three',
  'Four'
];

class ProductPost extends StatefulWidget {
  final SubCategoryEnum subCategoryEnum;
  final List<String> alreadyExistingProductNames;

  final bool isProductEditScreen;
  final SellProduct? sellProduct;

  final bool isMachine;

  const ProductPost({
    Key? key,
    required this.subCategoryEnum,
    required this.alreadyExistingProductNames,
    this.isProductEditScreen = false,
    this.sellProduct,
    this.isMachine = false,
  }) : super(key: key);

  @override
  State<ProductPost> createState() => _ProductPostState();
}

class _ProductPostState extends State<ProductPost> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _additionalController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();

  Future<void> _onPageRefresh() async {
    //reset();
    // fetchAll();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dropdownItems = enums.SubSubCategoryList[widget.subCategoryEnum]!;
    category = enums.nameForCategoryEnum[
        enums.findCategoryForSubCategory(widget.subCategoryEnum)]!;
    subCategory = enums.nameForSubCategoryEnum[widget.subCategoryEnum]!;
    // perPiecePrice = true;
    if (widget.isProductEditScreen) {
      _nameController.text = widget.sellProduct!.productName;
      _additionalController.text = widget.sellProduct!.productDescription;
      _priceController.text = widget.sellProduct!.productPrice.toString();
      _quantityController.text = widget.sellProduct!.productQuantity.toString();
      imageURL = widget.sellProduct!.imageURL;
      _selectedItem = widget.sellProduct!.subSubCategory;
      selectedQuantityUnit = widget.sellProduct!.quantityUnit;
      // perPiecePrice = widget.sellProduct!.priceType == "Per piece";
    }
  }

  bool _switchValue = false;

  String? _selectedItem;

  late List<String> _dropdownItems;

  late String category;
  late String subCategory;
  // late bool perPiecePrice;

  Uint8List? _image;

  String? imageURL;

  var listOfQuantityUnits = nameForProductQuantity.values.toList();
  String? selectedQuantityUnit;

  // Output the list of names
  // print(listOfNames);

  selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    print('image uploaded');
    _image = img;
    setState(() {});
  }

  onPressedPost(BuildContext buildContext) async {
    // print('login clicked');
    var productName = _nameController.text.toString();
    var productSubSubCategory = _selectedItem;
    var description = _additionalController.text.toString();
    var productSubCategory = subCategory;
    var productCategory = category;
    var productQuantity = _quantityController.text.toString();
    var quantityUnit = selectedQuantityUnit;
    String price = _priceController.text;
    // String productPriceType = perPiecePrice ? "Per piece" : "Per kg";

    if (productName == "") {
      ToastComponent.showDialog('Enter Product Name',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }

    if (widget.alreadyExistingProductNames.contains(productName)) {
      ToastComponent.showDialog('A Product By This Name Already Exists',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }

    if (productSubSubCategory == null) {
      ToastComponent.showDialog('Select Category',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }
    if (quantityUnit == null) {
      ToastComponent.showDialog('Select Quantity Unit',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }
    if (description == "") {
      ToastComponent.showDialog('Enter Product Description',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }
    if (price == "") {
      ToastComponent.showDialog('Enter Product Price',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }
    if (productQuantity == "") {
      ToastComponent.showDialog('Enter Product Quantity',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }
    if (_image == null) {
      ToastComponent.showDialog('Select Product Image',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }

    double productPrice = 0.0;
    try {
      productPrice = double.parse(price);
    } catch (e) {
      ToastComponent.showDialog('Please Enter Valid Price',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }

    int productQuantityInt = 0;
    try {
      productQuantityInt = int.parse(productQuantity);
    } catch (e) {
      ToastComponent.showDialog('Please Enter Valid Quantity',
          gravity: Toast.center, duration: Toast.lengthLong);
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
        image: _image!,
      ),
    );

    Navigator.pop(context);
  }

  onPressedEdit(BuildContext buildContext) async {
    // print('login clicked');
    var productName = _nameController.text.toString();
    var productSubSubCategory = _selectedItem;
    var description = _additionalController.text.toString();
    var productSubCategory = subCategory;
    var productCategory = category;
    var productQuantity = _quantityController.text.toString();
    var quantityUnit = selectedQuantityUnit;

    String price = _priceController.text;
    // String productPriceType = perPiecePrice ? "Per piece" : "Per kg";

    if (productName == "") {
      ToastComponent.showDialog('Enter Product Name',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }

    if (widget.alreadyExistingProductNames.contains(productName)) {
      ToastComponent.showDialog('A Product By This Name Already Exists',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }

    if (productSubSubCategory == null) {
      ToastComponent.showDialog('Select Category',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }
    if (quantityUnit == null) {
      ToastComponent.showDialog('Select Quantity Unit',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }
    if (description == "") {
      ToastComponent.showDialog('Enter Product Description',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }
    if (price == "") {
      ToastComponent.showDialog('Enter Product Price',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }
    if (productQuantity == "") {
      ToastComponent.showDialog('Enter Product Quantity',
          gravity: Toast.center, duration: Toast.lengthLong);
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
      ToastComponent.showDialog('Please Enter Valid Price',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }

    int productQuantityInt = 0;
    try {
      productQuantityInt = int.parse(productQuantity);
    } catch (e) {
      ToastComponent.showDialog('Please Enter Valid Quantity',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }

    BlocProvider.of<SellBloc>(buildContext).add(
      EditProductRequested(
        productId: widget.sellProduct!.id,
        productName: productName,
        productDescription: description,
        productPrice: productPrice,
        productQuantity: productQuantityInt,
        quantityUnit: quantityUnit,
        category: productCategory,
        subCategory: productSubCategory,
        subSubCategory: productSubSubCategory,
        // image: _image!,
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
                ? "Product"
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
            widget.isProductEditScreen ? "Edit Product" : "Add to Stock",
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
        productCategoryEnum == CategoryEnum.electronics ||
        productCategoryEnum == CategoryEnum.equipments ||
        productCategoryEnum == CategoryEnum.jcb) {
      selectedQuantityUnit = listOfQuantityUnits[0];
      showQuantityDropdown = false;
    }
    if (_selectedItem == "On Rent") {
      machinePriceHintText = 'Price (per 30 mins)';
    } else if (_selectedItem == "Sell") {
      machinePriceHintText = 'Price (per unit)';
    }
    return ListView(
      physics: BouncingScrollPhysics(),
      children: [
        // product name
        Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
          child: Container(
            decoration: BoxDecoration(
                color: MyTheme.field_color,
                borderRadius: BorderRadius.circular(10)),
            child: TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 15),
                hintText: "Product Name",
                hintStyle: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins'),
              ),
            ),
          ),
        ),

        // product category
        Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
          child: Container(
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
                items: _dropdownItems
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                hint: SizedBox(
                  width: MediaQuery.of(context).size.width /
                      1.3, // Adjust the width to your desired value
                  child: Text(
                    'Product Category',
                    style: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Poppins'),
                  ),
                ),
              )),
        ),

        // product quantity
        Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 15.0),
          child: Container(
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
                      controller: _quantityController,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 15),
                        hintText: "Quantity",
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
                            'Select Unit',
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
        ),

        // product price
        Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
          child: Container(
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
                  (productCategoryEnum == CategoryEnum.electronics ||
                          productCategoryEnum == CategoryEnum.equipments ||
                          productCategoryEnum == CategoryEnum.jcb)
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
                                  "Price (per ${selectedQuantityUnit == "Units" ? 'unit' : selectedQuantityUnit ?? 'unit'})",
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
        ),

        // additional description
        Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
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
                contentPadding: EdgeInsets.only(left: 15),
                hintText: "Additional Description",
                hintStyle: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins'),
              ),
            ),
          ),
        ),

        // add image
        widget.isProductEditScreen
            ? Container()
            : Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  height: 200,
                  padding: EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: MyTheme.light_grey),
                      borderRadius: BorderRadius.circular(10)),
                  child: _image != null
                      ? InkWell(
                          onTap: () {
                            selectImage();
                          },
                          child: Image.memory(
                            _image!,
                            fit: BoxFit.cover,
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
                                  "Add Featured Image",
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
                                selectImage();
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

        Container(
          height: 60,
        ),

        // Preview button
        // Container(
        //   height: 60,
        //   child: ElevatedButton(
        //     onPressed: () {
        //       Navigator.push(context,
        //           MaterialPageRoute(builder: (context) => ProductInventory()));
        //     },
        //     style: ButtonStyle(
        //       backgroundColor: MaterialStateProperty.all(MyTheme.primary_color),
        //       shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        //           RoundedRectangleBorder(
        //               borderRadius: BorderRadius.circular(0))),
        //     ),
        //     child: Text(
        //       "Add to Stock",
        //       style: TextStyle(
        //           color: Colors.white,
        //           fontSize: 20,
        //           fontWeight: FontWeight.w500),
        //     ),
        //   ),
        // )
      ],
    );
  }
}
