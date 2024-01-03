import 'package:active_ecommerce_flutter/utils/hive_models/models.dart';
import 'package:active_ecommerce_flutter/screens/category_list.dart';
import 'package:active_ecommerce_flutter/screens/change_language.dart';
import 'package:active_ecommerce_flutter/screens/setting/setting.dart';
import 'package:flutter/material.dart';

// import 'package:active_ecommerce_flutter/screens/about_us/about_us.dart';
// import 'package:active_ecommerce_flutter/screens/calender/calender.dart';
// import 'package:active_ecommerce_flutter/screens/description/description.dart';
// import 'package:active_ecommerce_flutter/screens/my_account/my_account.dart';
// import 'package:active_ecommerce_flutter/sell_screen/more_detail/more_detail.dart';
// import 'package:active_ecommerce_flutter/sell_screen/product_inventory/product_inventory.dart';
// import 'package:active_ecommerce_flutter/sell_screen/product_post/product_post.dart';
// import 'package:active_ecommerce_flutter/sell_screen/seller_platform/seller_platform.dart';

class ScreenDatabase extends StatefulWidget {
  ScreenDatabase({super.key});

  @override
  State<ScreenDatabase> createState() => _ScreenDatabaseState();
}

class _ScreenDatabaseState extends State<ScreenDatabase> {
  @override
  Widget build(BuildContext context) {
    List screensList = [
      // [
      //   'Parent screen',
      //   ParentScreen(
      //     parentEnum: ParentEnum.animal,
      //   )
      // ],
      // ['Notifications', NotificationScreen()],
      ['ChangeLanguage', ChangeLanguage()],
      ['CategoryList', CategoryList()],
      ['Address', Address()],
      ['Setting', Setting()],
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
