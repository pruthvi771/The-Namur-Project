import 'package:flutter/material.dart';

import '../category_list.dart';
import '../../my_theme.dart';
class BuySellButton extends StatefulWidget {
   BuySellButton({Key? key,}) : super(key: key);

  @override
  State<BuySellButton> createState() => _BuySellButtonState();
}

class _BuySellButtonState extends State<BuySellButton> {

  String color = "buy";
  bool? isvalue;
  @override
  Widget build(BuildContext context) {
    return   Center(
      child: Stack(
        children: [
          Container(
            height: 44,
            width: 162,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: MyTheme.light_grey,
                border: Border.all(color: MyTheme.light_grey)
            ),
            child: Center(child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(),
                InkWell(
                  onTap: (){
                    setState(() {
                      color = "sell";
                      isvalue = false;
                      CategoryList();
                    });
                  //  Navigator.push(context, MaterialPageRoute(builder: (context)=> ProductInventory() ));
                  },
                  child: Container(
                    height: 44,
                    width: 77,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: color == "sell"?MyTheme.primary_color:MyTheme.light_grey),
                    child: Center(
                      child: Text("SELL",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14,fontWeight: FontWeight.w600,
                          color: color == "sell"?MyTheme.white:Colors.black,
                        ),),
                    ),
                  ),
                ),
              ],
            )),
          ),
          Positioned(child:  InkWell(
            onTap: (){
              setState(() {
                color = "buy";
                isvalue = true;
              });
            },
            child: Container(
              height: 44,
              width: 77,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: color == "buy" ?MyTheme.primary_color:MyTheme.light_grey
              ),
              child:  Center(
                child: Text("BUY",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      fontSize: 14,fontWeight: FontWeight.w600,
                    color: color == "buy"?MyTheme.white:Colors.black,
                  ),),
              ),
            ),
          ),)
        ],
      ),
    );
  }
}
