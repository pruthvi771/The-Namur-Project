import 'dart:typed_data';

import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:active_ecommerce_flutter/features/profile/utils.dart';
import 'package:active_ecommerce_flutter/features/sell/services/bloc/sell_bloc.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/sell_screen/product_inventory/product_inventory.dart';
import 'package:active_ecommerce_flutter/utils/enums.dart';
import 'package:flutter/material.dart';
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

  const ProductPost({
    Key? key,
    required this.subCategoryEnum,
  }) : super(key: key);

  @override
  State<ProductPost> createState() => _ProductPostState();
}

class _ProductPostState extends State<ProductPost> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _additionalController = TextEditingController();
  TextEditingController _priceController = TextEditingController();

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
  }

  bool _switchValue = false;

  String? _selectedItem;

  late List<String> _dropdownItems;

  late String category;
  late String subCategory;
  bool perPiecePrice = true;

  Uint8List? _image;

  selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    print('image uploaded');
    _image = img;
    setState(() {});
  }

  // saveProfileImage() async {
  //   await selectImage();
  //   // BlocProvider.of<ProfileBloc>(context).add(
  //   //   ProfileImageUpdateRequested(file: _image!),
  //   // );
  // }

  onPressedPost(BuildContext buildContext) async {
    // print('login clicked');
    var productName = _nameController.text.toString();
    var productSubSubCategory = _selectedItem;
    var description = _additionalController.text.toString();
    var productSubCategory = subCategory;
    var productCategory = category;
    String price = _priceController.text;
    String productPriceType = perPiecePrice ? "Per piece" : "Per kg";

    if (productName == "") {
      ToastComponent.showDialog('Enter Product Name',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    } else if (productSubSubCategory == null) {
      ToastComponent.showDialog('Select Category',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    } else if (description == "") {
      ToastComponent.showDialog('Enter Product Description',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    } else if (price == "") {
      ToastComponent.showDialog('Enter Product Price',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    } else if (_image == null) {
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

    BlocProvider.of<SellBloc>(buildContext).add(
      SellAddProductEvent(
        productName: productName,
        productDescription: description,
        productPrice: productPrice,
        priceType: productPriceType,
        category: productCategory,
        subCategory: productSubCategory,
        subSubCategory: productSubSubCategory!,
        image: _image!,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(AppLocalizations.of(context)!.product_post_ucf,
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
            await onPressedPost(context);
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(MyTheme.primary_color),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(0))),
          ),
          child: Text(
            "Add to Stock",
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
      ),
      body: bodycontent(),
    );
  }

  bodycontent() {
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
                    color: Colors.black,
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
                  icon: SizedBox.shrink(),
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
                  hint: Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width /
                            1.3, // Adjust the width to your desired value
                        child: Text(
                          'Product Category',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Poppins'),
                        ),
                      ),
                      Icon(
                        Icons.arrow_drop_down,
                        size: 24,
                      ),
                    ],
                  ),
                ))),

        // product price
        // Padding(
        //   padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
        //   child: Container(
        //       width: MediaQuery.of(context).size.width,
        //       height: 50,
        //       decoration: BoxDecoration(
        //           color: MyTheme.field_color,
        //           borderRadius: BorderRadius.circular(10)),
        //       child: Row(
        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //         children: [
        //           Padding(
        //             padding: const EdgeInsets.all(15.0),
        //             child: Text(
        //               "Product Price",
        //               style: TextStyle(
        //                   fontSize: 15,
        //                   fontFamily: 'Poppins',
        //                   fontWeight: FontWeight.w400),
        //             ),
        //           ),
        //           Row(
        //             children: [
        //               RichText(
        //                 text: TextSpan(
        //                     text: "Per Pis / ",
        //                     style: TextStyle(
        //                         fontSize: 15,
        //                         fontFamily: 'Poppins',
        //                         fontWeight: FontWeight.w400,
        //                         color: Colors.black),
        //                     children: [
        //                       TextSpan(
        //                           text: "Per kg",
        //                           style: TextStyle(
        //                               color: MyTheme.primary_color,
        //                               fontSize: 15))
        //                     ]),
        //               ),
        //               VerticalDivider(
        //                 thickness: 1,
        //               ),
        //               RichText(
        //                 text: TextSpan(
        //                     text: "10/",
        //                     style: TextStyle(
        //                         fontSize: 15,
        //                         fontFamily: 'Poppins',
        //                         fontWeight: FontWeight.w400,
        //                         color: Colors.black),
        //                     children: [
        //                       TextSpan(
        //                           text: "Rs",
        //                           style: TextStyle(
        //                               color: Colors.black, fontSize: 15))
        //                     ]),
        //               ),
        //               SizedBox(
        //                 width: 5,
        //               )
        //             ],
        //           ),
        //         ],
        //       )),
        // ),

        Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              decoration: BoxDecoration(
                  color: MyTheme.field_color,
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _priceController,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 15),
                        hintText: "Price",
                        hintStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Poppins'),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              perPiecePrice = true;
                            });
                          },
                          child: Text(
                            "Per piece / ",
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              color: perPiecePrice
                                  ? MyTheme.primary_color
                                  : Colors.black,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              perPiecePrice = false;
                            });
                          },
                          child: Text(
                            "Per kg",
                            style: TextStyle(
                              color: perPiecePrice
                                  ? Colors.black
                                  : MyTheme.primary_color,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              )),
        ),

        // additional description
        Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
          child: Container(
            height: 130,
            decoration: BoxDecoration(
                color: MyTheme.field_color,
                borderRadius: BorderRadius.circular(10)),
            child: TextFormField(
              controller: _additionalController,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 15),
                hintText: "Additional Description",
                hintStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins'),
              ),
            ),
          ),
        ),

        // add image
        Padding(
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