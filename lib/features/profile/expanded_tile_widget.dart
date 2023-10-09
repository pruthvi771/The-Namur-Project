import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:flutter_html/flutter_html.dart';

class ExpandedTileWidget extends StatelessWidget {
  final ExpandedTileController _controller;
  final String title;
  final Widget _children;
  final Widget? _imageIcon;
  // final EdgeInsets? _contentPadding;

  ExpandedTileWidget({
    Key? key,
    required ExpandedTileController controller,
    required this.title,
    required Widget children,
    Widget? imageIcon,
    EdgeInsets? contentPadding,
  })  : _controller = controller,
        _children = children,
        _imageIcon = imageIcon,
        // _contentPadding = contentPadding,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget trailingWidget = _imageIcon ??
        Image.asset(
          'assets/dropdown.png',
          height: 25,
        );

    // final contentPaddingWidget = _contentPadding ??
    //     EdgeInsets.symmetric(horizontal: 15, vertical: 8);

    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: ExpandedTile(
        theme: const ExpandedTileThemeData(
          headerColor: MyTheme.green_lighter,
          headerPadding: EdgeInsets.all(7),
          headerSplashColor: Color.fromARGB(198, 141, 200, 116),
          contentBackgroundColor: Color.fromRGBO(239, 239, 239, 1),
          contentPadding: EdgeInsets.all(0),
          contentRadius: 0,
          headerRadius: 0,
        ),
        contentseparator: 0,
        controller: _controller,
        title: Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
        // trailing: trailingWidget,
        content: _children,
      ),
    );
  }
}
