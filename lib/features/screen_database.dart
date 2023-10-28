import 'package:active_ecommerce_flutter/features/profile/hive_models/models.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/screens/machine_rent_form.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/screens/parent_screen.dart';
import 'package:active_ecommerce_flutter/screens/Payment_info/payment_info_screen.dart';
import 'package:active_ecommerce_flutter/screens/auction_products.dart';
import 'package:active_ecommerce_flutter/screens/auction_products_details.dart';
import 'package:active_ecommerce_flutter/screens/brand_products.dart';
import 'package:active_ecommerce_flutter/screens/cart.dart';
import 'package:active_ecommerce_flutter/screens/category/sub_category.dart';
import 'package:active_ecommerce_flutter/screens/category_list.dart';
import 'package:active_ecommerce_flutter/screens/category_products.dart';
import 'package:active_ecommerce_flutter/screens/change_language.dart';
import 'package:active_ecommerce_flutter/screens/chat.dart';
import 'package:active_ecommerce_flutter/screens/checkout.dart';
import 'package:active_ecommerce_flutter/screens/classified_ads/classified_ads.dart';
import 'package:active_ecommerce_flutter/screens/classified_ads/classified_product_details.dart';
import 'package:active_ecommerce_flutter/screens/classified_ads/my_classified_ads.dart';
import 'package:active_ecommerce_flutter/screens/club_point.dart';
import 'package:active_ecommerce_flutter/screens/common_webview_screen.dart';
import 'package:active_ecommerce_flutter/screens/contact_us/contact_us.dart';
import 'package:active_ecommerce_flutter/screens/currency_change.dart';
import 'package:active_ecommerce_flutter/screens/filter.dart';
import 'package:active_ecommerce_flutter/screens/flash_deal_list.dart';
import 'package:active_ecommerce_flutter/screens/flash_deal_products.dart';
import 'package:active_ecommerce_flutter/screens/followed_sellers.dart';
import 'package:active_ecommerce_flutter/screens/home.dart';
import 'package:active_ecommerce_flutter/screens/man_machine/man_machine.dart';
import 'package:active_ecommerce_flutter/screens/map_location.dart';
import 'package:active_ecommerce_flutter/screens/messenger_list.dart';
import 'package:active_ecommerce_flutter/screens/notification/notification_screen.dart';
import 'package:active_ecommerce_flutter/screens/option/option.dart';
import 'package:active_ecommerce_flutter/screens/order_details.dart';
import 'package:active_ecommerce_flutter/screens/order_list.dart';
import 'package:active_ecommerce_flutter/screens/package/packages.dart';
import 'package:active_ecommerce_flutter/screens/payment_method_screen/bkash_screen.dart';
import 'package:active_ecommerce_flutter/screens/payment_method_screen/flutterwave_screen.dart';
import 'package:active_ecommerce_flutter/screens/payment_method_screen/iyzico_screen.dart';
import 'package:active_ecommerce_flutter/screens/payment_method_screen/khalti_screen.dart';
import 'package:active_ecommerce_flutter/screens/payment_method_screen/nagad_screen.dart';
import 'package:active_ecommerce_flutter/screens/payment_method_screen/offline_screen.dart';
import 'package:active_ecommerce_flutter/screens/payment_method_screen/paypal_screen.dart';
import 'package:active_ecommerce_flutter/screens/payment_method_screen/paystack_screen.dart';
import 'package:active_ecommerce_flutter/screens/payment_method_screen/paytm_screen.dart';
import 'package:active_ecommerce_flutter/screens/payment_method_screen/razorpay_screen.dart';
import 'package:active_ecommerce_flutter/screens/payment_method_screen/sslcommerz_screen.dart';
import 'package:active_ecommerce_flutter/screens/payment_method_screen/stripe_screen.dart';
import 'package:active_ecommerce_flutter/screens/product_details.dart';
import 'package:active_ecommerce_flutter/screens/product_reviews.dart';
import 'package:active_ecommerce_flutter/screens/profile_edit.dart';
import 'package:active_ecommerce_flutter/screens/refund_request.dart';
import 'package:active_ecommerce_flutter/screens/select_address.dart';
import 'package:active_ecommerce_flutter/screens/seller_details.dart';
import 'package:active_ecommerce_flutter/screens/seller_products.dart';
import 'package:active_ecommerce_flutter/screens/setting/setting.dart';
import 'package:active_ecommerce_flutter/screens/shipping_info.dart';
import 'package:active_ecommerce_flutter/screens/splash.dart';
import 'package:active_ecommerce_flutter/screens/todays_deal_products.dart';
import 'package:active_ecommerce_flutter/screens/top_selling_products.dart';
import 'package:active_ecommerce_flutter/screens/video_description_screen.dart';
import 'package:active_ecommerce_flutter/screens/wallet.dart';
import 'package:active_ecommerce_flutter/screens/whole_sale_products.dart';
import 'package:active_ecommerce_flutter/screens/wishlist.dart';
import 'package:active_ecommerce_flutter/utils/enums.dart';
import 'package:flutter/material.dart';

import 'package:active_ecommerce_flutter/screens/about_us/about_us.dart';
import 'package:active_ecommerce_flutter/screens/calender/calender.dart';
import 'package:active_ecommerce_flutter/screens/description/description.dart';
import 'package:active_ecommerce_flutter/screens/my_account/my_account.dart';
import 'package:active_ecommerce_flutter/sell_screen/more_detail/more_detail.dart';
import 'package:active_ecommerce_flutter/sell_screen/product_inventory/product_inventory.dart';
import 'package:active_ecommerce_flutter/sell_screen/product_post/product_post.dart';
import 'package:active_ecommerce_flutter/sell_screen/seller_platform/seller_platform.dart';

class ScreenDatabase extends StatefulWidget {
  ScreenDatabase({super.key});

  @override
  State<ScreenDatabase> createState() => _ScreenDatabaseState();
}

class _ScreenDatabaseState extends State<ScreenDatabase> {
  @override
  Widget build(BuildContext context) {
    List screensList = [
      [
        'Parent screen',
        ParentScreen(
          parentEnum: ParentEnum.animal,
        )
      ],
      ['Machine Rent Form', MachineRentForm()],
      ['Product Inventory', ProductInventory()],
      ['More Detail', MoreDetail()],
      ['Product Post', ProductPost()],
      ['Seller Platform', SellerPlatform()],
      ['About Us', AboutUs()],
      ['Calender', Calender()],
      ['My Account', MyAccount()],
      ['Sub category', SubCategory()],
      ['Description', Description()],
      ['ClassifiedAds', ClassifiedAds()],
      ['ClassifiedAdsDetails', ClassifiedAdsDetails()],
      ['MyClassifiedAds', MyClassifiedAds()],
      ['Contact Us', ContactUs()],
      ['Man Machine', ManMachine()],
      ['Notifications', NotificationScreen()],
      ['Option', Option()],
      ['Update Package (dont enter)', UpdatePackage()],
      ['Wishlist', Wishlist()],
      ['wholesale products', WholeSaleProducts()],
      ['wallet', Wallet()],
      ['video description (DO NOT ENTER)', VideoDescription()],
      ['top selling products', TopSellingProducts()],
      ['todays deal products', TodaysDealProducts()],
      ['splash', Splash()],
      ['shipping info', ShippingInfo()],
      ['seller products', SellerProducts()],
      ['seller details', SellerDetails()],
      ['select address', SelectAddress()],
      ['refund request', RefundRequest()],
      ['profile edit', ProfileEdit()],
      ['product review', ProductReviews()],
      ['pzroduct details', ProductDetails()],
      ['order list', OrderList()],
      ['order details', OrderDetails()],
      ['messenger list', MessengerList()],
      ['map location', MapLocation()],
      ['home', Home()],
      ['followed sellers', FollowedSellers()],
      ['flash deal products', FlashDealProducts()],
      ['flash deal list', FlashDealList()],
      ['filter', Filter()],
      ['CurrencyChange', CurrencyChange()],
      ['CommonWebviewScreen', CommonWebviewScreen()],
      ['Clubpoint', Clubpoint()],
      ['Checkout', Checkout()],
      ['Chat', Chat()],
      ['ChangeLanguage', ChangeLanguage()],
      ['CategoryProducts', CategoryProducts()],
      ['CategoryList', CategoryList()],
      ['Cart', Cart()],
      ['BrandProducts', BrandProducts()],
      ['AuctionProducts', AuctionProducts()],
      ['AuctionProductsDetails', AuctionProductsDetails()],
      ['Address', Address()],
      ['Setting', Setting()],
      ['PaymentInfo', PaymentInfo()],
      ['BkashScreen', BkashScreen()],
      ['FlutterwaveScreen', FlutterwaveScreen()],
      ['IyzicoScreen', IyzicoScreen()],
      ['KhaltiScreen', KhaltiScreen()],
      ['NagadScreen', NagadScreen()],
      ['OfflineScreen', OfflineScreen()],
      ['PaypalScreen', PaypalScreen()],
      ['PaystackScreen', PaystackScreen()],
      ['PaytmScreen', PaytmScreen()],
      ['RazorpayScreen', RazorpayScreen()],
      ['SslCommerzScreen', SslCommerzScreen()],
      ['StripeScreen', StripeScreen()],
    ];

    return Scaffold(
      appBar: AppBar(
        //  [Color(0xff107B28), Color(0xff4C7B10)
        backgroundColor: Color(0xff107B28),
        title: Text('Database'),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            ListView.builder(
                padding: EdgeInsets.all(10),
                physics: BouncingScrollPhysics(),
                itemCount: screensList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      color: Colors.grey[200],
                      child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        screensList[index][1]));
                          },
                          child: Text(
                            '${index + 1}. ${screensList[index][0] as String}',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          )),
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
