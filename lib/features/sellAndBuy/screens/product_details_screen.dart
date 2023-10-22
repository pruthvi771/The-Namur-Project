import 'dart:ui';

import 'package:active_ecommerce_flutter/features/profile/models/userdata.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/models/sell_product.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/services/buy_bloc/buy_bloc.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/services/buy_bloc/buy_event.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/services/buy_bloc/buy_state.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/services/buy_repository.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProductDetails extends StatefulWidget {
  final SellProduct sellProduct;
  ProductDetails({
    Key? key,
    required this.sellProduct,
  }) : super(key: key);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  initState() {
    _getSellerData = getSellerDataFuture();
    super.initState();
  }

  late Future<BuyerData> _getSellerData;

  Future<BuyerData> getSellerDataFuture() async {
    BuyerData user = await BuyRepository()
        .getSellerData(userId: widget.sellProduct.sellerId);
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          app_language_rtl.$! ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            // elevation: 0,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xff107B28), Color(0xff4C7B10)]),
              ),
            ),
            title: Text(
              AppLocalizations.of(context)!.product_description_ucf,
              // "new ",
              style: TextStyle(
                  color: MyTheme.white,
                  fontWeight: FontWeight.w500,
                  letterSpacing: .5,
                  fontFamily: 'Poppins'),
            ),
            centerTitle: true,
          ),
          body: bodycontent()),
    );
  }

  bodycontent() {
    return ListView(
      physics: BouncingScrollPhysics(),
      children: [
        Container(
          height: 300,
          color: MyTheme.green_light,
          child: Image.network(
            widget.sellProduct.imageURL,
            fit: BoxFit.fitWidth,
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 10, left: 15, right: 10, bottom: 10),
          color: Colors.grey[200],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.sellProduct.productName,
                // "aksbfkjafknangg englkng lkegnang kegne",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    letterSpacing: .5,
                    fontFamily: 'Poppins'),
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '₹ ${widget.sellProduct.productPrice.toString()} per ${widget.sellProduct.quantityUnit}',
                    // "aksbfkjafknangg englkng lkegnang kegne",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                        letterSpacing: .5,
                        fontFamily: 'Poppins'),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyTheme.primary_color, // background
                    ),
                    child: Text(
                      "Add to cart",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          letterSpacing: .5,
                          fontFamily: 'Poppins'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        FutureBuilder(
          future: _getSellerData,
          builder: (context, snapshot) {
            if (snapshot.hasData)
              return Container(
                padding: EdgeInsets.all(15),
                color: Colors.grey[300],
                child: Row(
                  children: [
                    Container(
                      height: 70,
                      width: 70,
                      child: snapshot.data!.photoURL == null
                          ? Image.asset('assets/profile_placeholder.png')
                          : ClipRRect(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              child: Image.network(
                                snapshot.data!.photoURL!,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Seller",
                            // "aksbfkjafknangg englkng lkegnang kegne",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                letterSpacing: .5,
                                fontFamily: 'Poppins'),
                          ),
                          Text(
                            snapshot.data!.name,
                            // "aksbfkjafknangg englkng lkegnang kegne",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                letterSpacing: .5,
                                fontFamily: 'Poppins'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            return Container();
          },
        ),
        Container(
          padding: EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Description",
                // "aksbfkjafknangg englkng lkegnang kegne",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w700,
                    letterSpacing: .5,
                    fontFamily: 'Poppins'),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                widget.sellProduct.productDescription,
                // "aksbfkjafknangg englkng lkegnang kegne",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    letterSpacing: .5,
                    fontFamily: 'Poppins'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
