// translations done.

import 'package:active_ecommerce_flutter/features/profile/models/userdata.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/models/sell_product.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/services/buy_repository.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/services/cart_bloc/cart_bloc.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/services/cart_bloc/cart_event.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/services/cart_bloc/cart_state.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/services/cart_repository.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

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
    ratingDataFuture = getRating();
    BlocProvider.of<CartBloc>(context).add(
      CheckIfAlreadyInCartRequested(productId: widget.sellProduct.id),
    );
    super.initState();
  }

  late Future<BuyerData> _getSellerData;
  late Future ratingDataFuture;

  Future<BuyerData> getSellerDataFuture() async {
    BuyerData user = await BuyRepository()
        .getSellerData(userId: widget.sellProduct.sellerId);
    return user;
  }

  Future getRating() async {
    Map ratingData = await BuyRepository()
        .getRatingOfProduct(productId: widget.sellProduct.id);
    return ratingData;
  }

  int _current = 0;
  final CarouselController _controller = CarouselController();

  void openWhatsAppChat(String phoneNumber) async {
    String formattedPhoneNumber = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
    print(formattedPhoneNumber);
    String whatsappUrl = "https://wa.me/$formattedPhoneNumber";
    final Uri _url = Uri.parse(whatsappUrl);

    try {
      if (await canLaunchUrl(_url)) {
        await launchUrl(
          _url,
          mode: LaunchMode.externalApplication,
        );
      } else {
        throw 'Could not launch WhatsApp';
      }
    } catch (e) {
      print(e);
      // Handle exceptions, if any
    }
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
        SizedBox(
          height: 10,
        ),

        // product name
        Padding(
          padding:
              const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 15),
          child: Text(
            widget.sellProduct.productName,
            // "aksbfkjafknangg englkng lkegnang kegne",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              // letterSpacing: 1,
            ),
          ),
        ),

        // product images
        Container(
          height: 300,
          // color: Colors.red[100],
          child: CarouselSlider(
            items: widget.sellProduct.imageURL.map((fileURL) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: fileURL,
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width,
                      ),
                    ),
                  );
                },
              );
            }).toList(),
            carouselController: _controller,
            options: CarouselOptions(
                viewportFraction: 1,
                autoPlay: false,
                enlargeCenterPage: true,
                enableInfiniteScroll: false,
                aspectRatio: 1 / 1.5,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                }),
          ),
        ),

        SizedBox(
          height: 10,
        ),

        // product image indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.sellProduct.imageURL.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _controller.animateToPage(entry.key),
              child: Container(
                width: 8.0,
                height: 10.0,
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black)
                        .withOpacity(_current == entry.key ? 0.9 : 0.4)),
              ),
            );
          }).toList(),
        ),

        // product name and price
        Container(
          padding: EdgeInsets.only(top: 5, left: 15, right: 10),
          // color: Colors.grey[200],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 25,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '₹ ',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox.shrink()
                          ],
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '${widget.sellProduct.productPrice.toInt().toString()}',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            ' per ${widget.sellProduct.quantityUnit == "Units" ? 'unit' : widget.sellProduct.quantityUnit}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  BlocBuilder<CartBloc, CartState>(
                    builder: (context, state) {
                      if (state is CartLoading)
                        // circular progress indicator
                        return ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                MyTheme.primary_color, // background
                          ),
                          child: Container(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                        );
                      if (state is AddToCartSuccessful)
                        return ElevatedButton(
                          onPressed: null,
                          style: ElevatedButton.styleFrom(
                            elevation: 0.5,
                            backgroundColor:
                                MyTheme.primary_color, // background
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.added_to_cart,
                            style: TextStyle(
                                color: MyTheme.primary_color,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                letterSpacing: .5,
                                fontFamily: 'Poppins'),
                          ),
                        );
                      // if (state is CartUpdated)
                      //   return Padding(
                      //   padding: const EdgeInsets.only(top: 5, bottom: 5),
                      //   child: Row(
                      //     children: [
                      //       Container(
                      //         width: 35,
                      //         height: 35,
                      //         decoration: BoxDecoration(
                      //           border: Border.all(
                      //             color: MyTheme.primary_color,
                      //             width: 2.0,
                      //           ),
                      //           borderRadius: BorderRadius.circular(8.0),
                      //         ),
                      //         child: TextButton(
                      //           onPressed: () {
                      //             BlocProvider.of<CartBloc>(context).add(
                      //               UpdateCartQuantityRequested(
                      //                 productId: widget.sellProduct.id,
                      //                 currentQuantity: state.quantity,
                      //                 type: UpdateCartQuantityType.decrement,
                      //               ),
                      //             );
                      //           },
                      //           style: ElevatedButton.styleFrom(
                      //             padding: EdgeInsets.all(0),
                      //             elevation: 0,
                      //           ),
                      //           child: Icon(
                      //             Icons.remove,
                      //             color: MyTheme.primary_color,
                      //           ),
                      //         ),
                      //       ),
                      //       Padding(
                      //         padding:
                      //             const EdgeInsets.symmetric(horizontal: 12),
                      //         child: Text(
                      //           state.quantity.toString(),
                      //           style: TextStyle(
                      //               color: Colors.grey[700],
                      //               fontSize: 20,
                      //               fontWeight: FontWeight.w700,
                      //               letterSpacing: .5,
                      //               fontFamily: 'Poppins'),
                      //         ),
                      //       ),
                      //       Container(
                      //         width: 35,
                      //         height: 35,
                      //         decoration: BoxDecoration(
                      //           border: Border.all(
                      //             color:
                      //                 MyTheme.primary_color, // Border color
                      //             width: 2.0, // Border width
                      //           ),
                      //           borderRadius: BorderRadius.circular(
                      //               8.0), // Border radius
                      //         ),
                      //         child: TextButton(
                      //           onPressed: () {
                      //             BlocProvider.of<CartBloc>(context).add(
                      //               UpdateCartQuantityRequested(
                      //                 productId: widget.sellProduct.id,
                      //                 currentQuantity: state.quantity,
                      //                 type: UpdateCartQuantityType.increment,
                      //               ),
                      //             );
                      //           },
                      //           style: ElevatedButton.styleFrom(
                      //             padding: EdgeInsets.all(0),
                      //             elevation: 0,
                      //           ),
                      //           child: Icon(
                      //             Icons.add,
                      //             color: MyTheme.primary_color,
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // );
                      // if (state is CartQuantityLoading)
                      //   return Padding(
                      //     padding: const EdgeInsets.only(top: 5, bottom: 5),
                      //     child: Row(
                      //       children: [
                      //         Container(
                      //           width: 35,
                      //           height: 35,
                      //           decoration: BoxDecoration(
                      //             border: Border.all(
                      //               color: MyTheme.primary_color,
                      //               width: 2.0,
                      //             ),
                      //             borderRadius: BorderRadius.circular(8.0),
                      //           ),
                      //           child: TextButton(
                      //             onPressed: () {},
                      //             style: ElevatedButton.styleFrom(
                      //               padding: EdgeInsets.all(0),
                      //               elevation: 0,
                      //             ),
                      //             child: Icon(
                      //               Icons.remove,
                      //               color: MyTheme.primary_color,
                      //             ),
                      //           ),
                      //         ),
                      //         Container(
                      //             height: 40,
                      //             width: 40,
                      //             padding: const EdgeInsets.symmetric(
                      //                 horizontal: 10, vertical: 10),
                      //             child: Center(
                      //               child: CircularProgressIndicator(
                      //                 color: MyTheme.primary_color,
                      //                 strokeWidth: 3,
                      //               ),
                      //             )),
                      //         Container(
                      //           width: 35,
                      //           height: 35,
                      //           decoration: BoxDecoration(
                      //             border: Border.all(
                      //               color: MyTheme.primary_color,
                      //               width: 2.0,
                      //             ),
                      //             borderRadius: BorderRadius.circular(8.0),
                      //           ),
                      //           child: TextButton(
                      //             onPressed: () {},
                      //             style: ElevatedButton.styleFrom(
                      //               padding: EdgeInsets.all(0),
                      //               elevation: 0,
                      //             ),
                      //             child: Icon(
                      //               Icons.add,
                      //               color: MyTheme.primary_color,
                      //             ),
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   );
                      return ElevatedButton(
                        onPressed: () {
                          BlocProvider.of<CartBloc>(context).add(
                            AddToCartRequested(
                                productId: widget.sellProduct.id),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0.5,
                          backgroundColor: MyTheme.primary_color, // background
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.add_to_cart_ucf,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              letterSpacing: .5,
                              fontFamily: 'Poppins'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),

        // description
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.description_ucf,
                // "aksbfkjafknangg englkng lkegnang kegne",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w700,
                    letterSpacing: .5,
                    fontFamily: 'Poppins'),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 5, left: 8),
                child: Text(
                  widget.sellProduct.productDescription,
                  style: TextStyle(
                      fontSize: 15,
                      height: 1.4,
                      letterSpacing: .5,
                      fontFamily: 'Poppins'),
                ),
              ),
            ],
          ),
        ),

        // seller data
        FutureBuilder(
          future: _getSellerData,
          builder: (context, snapshot) {
            if (snapshot.hasData)
              return Container(
                height: 90,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                margin: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: MyTheme.green_lighter,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      child: snapshot.data!.photoURL == null ||
                              snapshot.data!.photoURL!.isEmpty
                          ? Image.asset('assets/profile_placeholder.png')
                          : ClipRRect(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                              child: CachedNetworkImage(
                                imageUrl: snapshot.data!.photoURL!,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            snapshot.data!.name,
                            // "aksbfkjafknangg englkng lkegnang kegne",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              // FaIcon(
                              //   FontAwesomeIcons.locationPin,
                              //   color: Colors.red,
                              //   size: 12,
                              // ),
                              // SizedBox(
                              //   width: 3,
                              // ),
                              Expanded(
                                child: Text(
                                  '${widget.sellProduct.village}, ${widget.sellProduct.gramPanchayat}, ${widget.sellProduct.taluk}, ${widget.sellProduct.district}',
                                  // "aksbfkjafknangg englkng lkegnang kegne",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: MyTheme.primary_color,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      child: Center(
                        child: IconButton(
                          icon: FaIcon(
                            FontAwesomeIcons.whatsapp,
                            color: Colors.white,
                            size: 30,
                          ),
                          onPressed: () {
                            openWhatsAppChat(snapshot.data!.phoneNumber!);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            return Container();
          },
        ),

        // rating
        FutureBuilder(
            future: ratingDataFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container();
              }
              if (snapshot.hasData) {
                if (snapshot.data!['numberOfRatings'] != null &&
                    snapshot.data!['rating'] != null) {
                  if (snapshot.data!['numberOfRatings'] != 0)
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Avg Rating',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              Text(
                                (snapshot.data!['rating'] /
                                        snapshot.data!['numberOfRatings'])
                                    .toString(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                ' ${snapshot.data!['numberOfRatings'].toString()} ${AppLocalizations.of(context)!.ratings}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          RatingBarIndicator(
                            rating: snapshot.data!['rating'] /
                                snapshot.data!['numberOfRatings'],
                            itemCount: 5,
                            itemSize: 30.0,
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                          ),
                        ],
                      ),
                    );
                } else {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.no_ratings_yet,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        RatingBarIndicator(
                          rating: 0,
                          itemCount: 5,
                          itemSize: 30.0,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                        ),
                      ],
                    ),
                  );
                }
              }
              return Container(
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.no_ratings_yet,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    RatingBarIndicator(
                      rating: 0,
                      itemCount: 5,
                      itemSize: 30.0,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                    ),
                  ],
                ),
              );
            }),
      ],
    );
  }
}
