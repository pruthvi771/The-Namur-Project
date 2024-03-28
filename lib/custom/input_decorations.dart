import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';

class InputDecorations {
  static InputDecoration buildInputDecoration_1({hint_text = ""}) {
    return InputDecoration(
        hintText: hint_text,
        filled: true,
        fillColor: MyTheme.white,
        hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey[900]),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black87, width: 0.5),
          borderRadius: const BorderRadius.all(
            const Radius.circular(10.0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 0.5),
          borderRadius: const BorderRadius.all(
            const Radius.circular(10.0),
          ),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0));
  }

  static InputDecoration buildInputDecoration_phone({hint_text = ""}) {
    return InputDecoration(
        hintText: hint_text,
        hintStyle: TextStyle(fontSize: 12.0, color: MyTheme.dark_grey),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: MyTheme.dark_grey, width: 0.5),
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(10.0),
              bottomRight: Radius.circular(10.0)),
        ),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyTheme.primary_color, width: 0.5),
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(6.0),
                bottomRight: Radius.circular(6.0))),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0));
  }

  static InputDecoration buildInputDecoration_otp({hint_text = ""}) {
    return InputDecoration(
        hintText: hint_text,
        filled: true,
        fillColor: MyTheme.white,
        hintStyle: TextStyle(fontSize: 12.0, color: MyTheme.dark_grey),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: MyTheme.dark_grey, width: 0.5),
          borderRadius: const BorderRadius.all(
            const Radius.circular(10.0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: MyTheme.light_grey, width: 0.5),
          borderRadius: const BorderRadius.all(
            const Radius.circular(10.0),
          ),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0));
  }
}
