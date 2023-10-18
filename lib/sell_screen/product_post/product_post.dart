import 'package:active_ecommerce_flutter/dummy_data/products.dart';
import 'package:active_ecommerce_flutter/sell_screen/product_inventory/product_inventory.dart';
import 'package:active_ecommerce_flutter/sell_screen/seller_platform/seller_platform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../custom/device_info.dart';
import '../../my_theme.dart';

const List<String> productList = <String>[
  'Product Category',
  'Two',
  'Three',
  'Four'
];

class ProductPost extends StatefulWidget {
  const ProductPost({Key? key}) : super(key: key);

  @override
  State<ProductPost> createState() => _ProductPostState();
}

class _ProductPostState extends State<ProductPost> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _additionalController = TextEditingController();
  TextEditingController _commentsController = TextEditingController();

  Future<void> _onPageRefresh() async {
    //reset();
    // fetchAll();
  }

  bool _switchValue = false;

  String? _selectedItem;

  List<String> _dropdownItems = [
    'Option 1',
    'Option 2',
    'Option 3',
    'Option 4',
  ];

  String priceType = "Per piece";
  bool perPiecePrice = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: homeData.scaffoldKey,
      // drawer: const MainDrawer(),
      backgroundColor: Colors.transparent,
      appBar: buildCustomAppBar(context),
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
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Text(
                            'Product Category',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Poppins'),
                          ),
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
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      "Product Price",
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  Row(
                    children: [
                      RichText(
                        text: TextSpan(
                            text: "Per Pis / ",
                            style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                            children: [
                              TextSpan(
                                  text: "Per kg",
                                  style: TextStyle(
                                      color: MyTheme.primary_color,
                                      fontSize: 15))
                            ]),
                      ),
                      VerticalDivider(
                        thickness: 1,
                      ),
                      RichText(
                        text: TextSpan(
                            text: "10/",
                            style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                            children: [
                              TextSpan(
                                  text: "Rs",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 15))
                            ]),
                      ),
                      SizedBox(
                        width: 5,
                      )
                    ],
                  ),
                ],
              )),
        ),

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
                      controller: _nameController,
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

        //comments
        Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
          child: Container(
            height: 130,
            decoration: BoxDecoration(
                color: MyTheme.field_color,
                borderRadius: BorderRadius.circular(10)),
            child: TextFormField(
              controller: _commentsController,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 15),
                hintText: "Comments",
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
            child: Column(
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
                Container(
                  height: 110,
                  width: MediaQuery.of(context).size.width,
                  child: Image.asset(
                    "assets/imgplaceholder.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Preview button
        Container(
          height: 60,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProductInventory()));
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(MyTheme.primary_color),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0))),
            ),
            child: Text(
              "Preview",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
            ),
          ),
        )
      ],
    );
  }

  PreferredSize buildCustomAppBar(context) {
    return PreferredSize(
      preferredSize: Size(DeviceInfo(context).width!, 80),
      child: Container(
        height: 92,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xff107B28), Color(0xff4C7B10)])),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 30,
                ),
                Center(
                  child: Text(AppLocalizations.of(context)!.product_post_ucf,
                      style: TextStyle(
                          color: MyTheme.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          letterSpacing: .5,
                          fontFamily: 'Poppins')),
                ),
                Container(
                  margin: EdgeInsets.only(right: 0),
                  height: 30,
                  child: Container(
                    child: InkWell(
                      //padding: EdgeInsets.zero,
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.keyboard_arrow_left,
                        size: 35,
                        color: MyTheme.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
