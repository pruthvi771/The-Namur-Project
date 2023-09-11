import 'package:active_ecommerce_flutter/custom/box_decorations.dart';
import 'package:active_ecommerce_flutter/custom/useful_elements.dart';
import 'package:active_ecommerce_flutter/presenter/home_presenter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/repositories/language_repository.dart';
import 'package:active_ecommerce_flutter/repositories/coupon_repository.dart';
import 'package:active_ecommerce_flutter/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:toast/toast.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/screens/main.dart';
import 'package:active_ecommerce_flutter/providers/locale_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChangeLanguage extends StatefulWidget {
  ChangeLanguage({Key? key}) : super(key: key);

  @override
  _ChangeLanguageState createState() => _ChangeLanguageState();
}

class _ChangeLanguageState extends State<ChangeLanguage> {
  var _selected_index = 0;
  ScrollController _mainScrollController = ScrollController();
  var _list = [];
  bool _isInitial = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fetchList();
  }

  @override
  void dispose() {
    super.dispose();
    _mainScrollController.dispose();
  }

  fetchList() async {
    var languageListResponse = await LanguageRepository().getLanguageList();
    _list.addAll(languageListResponse.languages!);

    var idx = 0;
    if (_list.length > 0) {
      _list.forEach((lang) {
        if (lang.code == app_language.$) {
          setState(() {
            _selected_index = idx;
          });
        }
        idx++;
      });
    }
    _isInitial = false;
    setState(() {});
  }

  reset() {
    _list.clear();
    _isInitial = true;
    _selected_index = 0;
    setState(() {});
  }

  Future<void> _onRefresh() async {
    reset();
    fetchList();
  }

  onPopped(value) {
    reset();
    fetchList();
  }

  onCouponRemove() async {
    var couponRemoveResponse =
        await CouponRepository().getCouponRemoveResponse();

    if (couponRemoveResponse.result == false) {
      ToastComponent.showDialog(couponRemoveResponse.message,
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }
  }

  onLanguageItemTap(index) {
    if (index != _selected_index) {
      setState(() {
        _selected_index = index;
      });

      // if(Locale().)

      app_language.$ = _list[_selected_index].code;
      app_language.save();
      app_mobile_language.$ = _list[_selected_index].mobile_app_code;
      app_mobile_language.save();
      app_language_rtl.$ = _list[_selected_index].rtl;
      app_language_rtl.save();

      // var local_provider = new LocaleProvider();
      // local_provider.setLocale(_list[_selected_index].code);
      Provider.of<LocaleProvider>(context, listen: false)
          .setLocale(_list[_selected_index].mobile_app_code);

      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) {
        return Main(
          go_back: false,
        );
      }), (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          app_language_rtl.$! ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: buildAppBar(context),
          body: Stack(
            children: [
              RefreshIndicator(
                color: MyTheme.accent_color,
                backgroundColor: Colors.white,
                onRefresh: _onRefresh,
                displacement: 0,
                child: CustomScrollView(
                  controller: _mainScrollController,
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  slivers: [
                    SliverList(
                      delegate: SliverChildListDelegate([
                        SizedBox(height: 100,),
                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: buildLanguageMethodList(),
                        ),
                      ]),
                    )
                  ],
                ),
              ),
            ],
          )),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      //   backgroundColor: Colors.white,
      flexibleSpace: Container(
          decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF107B28), Color(0xFF4C7B10)],
        ),
      )),
      centerTitle: true,
      leading: Builder(
        builder: (context) => IconButton(
          padding: EdgeInsets.zero,
          icon: UsefulElements.backButton(context),
          color: MyTheme.white,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      title: Text(
        "${AppLocalizations.of(context)!.change_language_ucf} ",
        /*(${app_language.$}) - (${app_mobile_language.$})*/
        style: TextStyle(
            fontSize: 16, color: MyTheme.white, fontWeight: FontWeight.bold),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  buildLanguageMethodList() {
    if (_isInitial && _list.length == 0) {
      return SingleChildScrollView(
          child: ShimmerHelper()
              .buildListShimmer(item_count: 5, item_height: 100.0));
    } else if (_list.length > 0) {
      return SingleChildScrollView(
        child: GridView.builder(
          /*  separatorBuilder: (context, index) {
            return SizedBox(
              height: 14,
            );
          },*/
          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 20,
          mainAxisExtent: 70),
          itemCount: _list.length,
          scrollDirection: Axis.vertical,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return buildPaymentMethodItemCard(index);
          },
        ),
      );
    } else if (!_isInitial && _list.length == 0) {
      return Container(
          height: 0,
          child: Center(
              child: Text(
            AppLocalizations.of(context)!.no_language_is_added,
            style: TextStyle(color: MyTheme.font_grey),
          )));
    }
  }

  GestureDetector buildPaymentMethodItemCard(index) {
    return GestureDetector(
      onTap: () {
        onLanguageItemTap(index);
      },
      child: Stack(
        children: [
          AnimatedContainer(
            height: 44,
            width: 140,
            duration: Duration(milliseconds: 400),
            decoration: BoxDecorations.buildBoxDecoration_1(radius: 15).copyWith(
               /* border: Border.all(
                    color: _selected_index == index
                        ? MyTheme.primary_color
                        : MyTheme.green_light!,
                    width: _selected_index == index ? 1.0 : 0.0),*/
                ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  /*  Container(
                      width: 10,
                      height: 50,
                      child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child:
                              */ /*Image.asset(
                          _list[index].image,
                          fit: BoxFit.fitWidth,
                        ),*/ /*
                              FadeInImage.assetNetwork(
                            placeholder: 'assets/placeholder.png',
                            image: _list[index].image,
                            fit: BoxFit.fitWidth,
                          ))),*/
                  Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
                      color: index==0? Color(0xffF9EAB7):
                      index==1? Color(0xffD2F8B5):
                      index==2? Color(0xffB7F9E1):
                      index==3? Color(0xffF2B5F8):
                      index==4? Color(0xffEFFDA3):
                      index==5? Color(0xffB5C7F8):
                      index==6? Color(0xffFFCDA9):
                      index==7? Color(0xffE6E9F0):
                      index==8? Color(0xffD2F8B5):Color(0xffE6E9F0) ,
                    ),

                    width: 140,
                    height: 44,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Center(
                            child: Text(
                              "${_list[index].name}", // - ${_list[index].code} - ${_list[index].mobile_app_code}
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  height: 1.6,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
          ),
          /*  app_language_rtl.$!
              ? Positioned(
                  left: 16,
                  top: 16,
                  child: buildCheckContainer(_selected_index == index),
                )
              : Positioned(
                  right: 16,
                  top: 16,
                  child: buildCheckContainer(_selected_index == index),
                )*/
        ],
      ),
    );
  }

  Container buildCheckContainer(bool check) {
    return check
        ? Container(
            height: 16,
            width: 16,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0), color: Colors.green),
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: Icon(Icons.check, color: Colors.white, size: 10),
            ),
          )
        : Container();
  }
}
