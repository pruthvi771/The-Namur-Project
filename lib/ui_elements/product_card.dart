import 'package:active_ecommerce_flutter/custom/box_decorations.dart';
import 'package:active_ecommerce_flutter/helpers/system_config.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/screens/product_details.dart';
import 'package:active_ecommerce_flutter/sell_screen/product_post/product_post.dart';
import 'package:flutter/material.dart';

import '../helpers/shared_value_helper.dart';
import '../screens/auction_products_details.dart';

class ProductCard extends StatefulWidget {
  var identifier;
  int? id;
  String? image;
  String? name;
  String? main_price;
  String? stroked_price;
  bool? has_discount;
  bool? is_wholesale;
  var discount;
  bool? isvalue;

  ProductCard({
    Key? key,
    this.identifier,
    this.id,
    this.image,
    this.name,
    this.main_price,
    this.is_wholesale=false,
    this.stroked_price,
    this.has_discount,
    this.discount,
    this.isvalue,
  }) : super(key: key);

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    //print((MediaQuery.of(context).size.width - 48 ) / 2);
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return widget.isvalue == false ? ProductPost(): widget.identifier == 'auction'
              ?
          AuctionProductsDetails(id: widget.id) :
          ProductDetails(
                  id: widget.id,
                );
        }));
      },
      child: Container(
        decoration: BoxDecorations.buildBoxDecoration_product(radius: 20,).copyWith(),
        child: Stack(
          children: [
            Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
              AspectRatio(
                aspectRatio: 1,
                child: Container(
                    width:  50,  //double.infinity,
                    height: 100,
                    child: ClipRRect(
                        clipBehavior: Clip.hardEdge,
                        borderRadius: BorderRadius.vertical(
                            top: Radius.circular(6), bottom: Radius.zero),
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/placeholder.png',
                          image: widget.image!,
                          fit: BoxFit.cover,
                        )
                    )),
              ),
              Container(
               // width: 80,
                height: 15,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${widget.name!}",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                          color: MyTheme.font_grey,
                          fontSize: 14,
                          height: 1.2,
                          fontWeight: FontWeight.w400),
                    ),
                    /*widget.has_discount!
                        ? Padding(
                            padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
                            child: Text(
                              SystemConfig.systemCurrency!.code != null
                                  ? widget.stroked_price!.replaceAll(
                                      SystemConfig.systemCurrency!.code!,
                                      SystemConfig.systemCurrency!.symbol!)
                                  : widget.stroked_price!,
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  color: MyTheme.medium_grey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400),
                            ),
                          )
                        : Container(
                            height: 8.0,
                          ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Text(
                        SystemConfig.systemCurrency!.code != null
                            ? widget.main_price!.replaceAll(
                                SystemConfig.systemCurrency!.code!,
                                SystemConfig.systemCurrency!.symbol!)
                            : widget.main_price!,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                            color: MyTheme.accent_color,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      ),
                    ),*/
                  ],
                ),
              ),
            ]),

            // discount and wholesale
           /* Positioned.fill(
              child: Align(
                alignment: Alignment.topRight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (widget.has_discount!)
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        margin: EdgeInsets.only(bottom: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xffe62e04),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(6.0),
                            bottomLeft: Radius.circular(6.0),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0x14000000),
                              offset: Offset(-1, 1),
                              blurRadius: 1,
                            ),
                          ],
                        ),
                        child: Text(
                          widget.discount ?? "",
                          style: TextStyle(
                            fontSize: 10,
                            color: const Color(0xffffffff),
                            fontWeight: FontWeight.w700,
                            height: 1.8,
                          ),
                          textHeightBehavior: TextHeightBehavior(
                              applyHeightToFirstAscent: false),
                          softWrap: false,
                        ),
                      ),
                    Visibility(
                      visible: whole_sale_addon_installed.$,
                      child: widget.is_wholesale !=null && widget.is_wholesale!
                          ? Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.blueGrey,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(6.0),
                                  bottomLeft: Radius.circular(6.0),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0x14000000),
                                    offset: Offset(-1, 1),
                                    blurRadius: 1,
                                  ),
                                ],
                              ),
                              child: Text(
                                "Wholesale",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: const Color(0xffffffff),
                                  fontWeight: FontWeight.w700,
                                  height: 1.8,
                                ),
                                textHeightBehavior: TextHeightBehavior(
                                    applyHeightToFirstAscent: false),
                                softWrap: false,
                              ),
                            )
                          : SizedBox.shrink(),
                    )
                  ],
                ),
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}
