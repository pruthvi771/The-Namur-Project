// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../my_theme.dart';

class TermsConditions extends StatefulWidget {
  String? title;
  String? url;
  TermsConditions({
    Key? key,
    this.title,
    this.url,
  }) : super(key: key);

  @override
  State<TermsConditions> createState() => _TermsConditionsState();
}

class _TermsConditionsState extends State<TermsConditions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: buildCustomAppBar(context),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.keyboard_arrow_left,
            size: 35,
            color: MyTheme.white,
          ),
        ),
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xff107B28), Color(0xff4C7B10)]),
          ),
        ),
        title: Text(
            widget.title != null ? widget.title! : 'Terms and Conditions',
            style: TextStyle(
                color: MyTheme.white,
                fontWeight: FontWeight.w500,
                letterSpacing: .5,
                fontFamily: 'Poppins')),
        centerTitle: true,
      ),
      body: SfPdfViewer.network(
        widget.url != null
            ? widget.url!
            : 'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/main%2FIA_Namur%20Agro_T%26C.pdf?alt=media&token=7fe405c6-1125-4e23-8b44-16f3c61811afw',
      ),
    );
  }
}
