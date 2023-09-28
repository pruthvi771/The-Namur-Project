import 'package:flutter/material.dart';

import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';

class ExpandedTileWidget extends StatelessWidget {
  const ExpandedTileWidget({
    super.key,
    required ExpandedTileController controller,
    required this.title,
    required Column children,
  })  : _controller = controller,
        _children = children;

  final ExpandedTileController _controller;
  final String title;
  final Column _children;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: ExpandedTile(
        theme: const ExpandedTileThemeData(
          headerColor: Color.fromARGB(199, 180, 251, 149),
          // headerRadius: 24.0,
          headerPadding: EdgeInsets.all(7),
          headerSplashColor: Color.fromARGB(198, 141, 200, 116),
          contentBackgroundColor: Color.fromRGBO(239, 239, 239, 1),
          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
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
        trailing: Image.asset(
          "assets/add 2.png",
          height: 27,
        ),
        content: _children,
      ),
    );
  }
}
