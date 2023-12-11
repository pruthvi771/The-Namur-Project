import 'package:active_ecommerce_flutter/utils/translation_bloc/translation_bloc.dart';
import 'package:active_ecommerce_flutter/utils/translation_bloc/translation_event.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChangeLanguage extends StatefulWidget {
  ChangeLanguage({Key? key}) : super(key: key);

  @override
  _ChangeLanguageState createState() => _ChangeLanguageState();
}

class _ChangeLanguageState extends State<ChangeLanguage> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          app_language_rtl.$! ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: buildAppBar(context),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              child: GestureDetector(
                onTap: () {
                  BlocProvider.of<TranslationBloc>(context).add(
                    TranslationDataRequested(
                      locale: 'en',
                    ),
                  );
                  Navigator.pop(context);
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Material(
                    elevation: 2,
                    child: Container(
                      height: 70,
                      width: double.infinity,
                      color: Colors.red.shade100,
                      child: Center(
                        child: Text(
                          'English',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              child: GestureDetector(
                onTap: () {
                  BlocProvider.of<TranslationBloc>(context).add(
                    TranslationDataRequested(
                      locale: 'kn',
                    ),
                  );
                  Navigator.pop(context);
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Material(
                    elevation: 2,
                    child: Container(
                      height: 70,
                      width: double.infinity,
                      color: Colors.yellow.shade200,
                      child: Center(
                        child: Text(
                          'ಕನ್ನಡ',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      flexibleSpace: Container(
          decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF107B28), Color(0xFF4C7B10)],
        ),
      )),
      centerTitle: true,
      title: Text(
        AppLocalizations.of(context)!.change_language_ucf,
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
    );
  }
}
