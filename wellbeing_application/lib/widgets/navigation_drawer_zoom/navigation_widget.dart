import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

class NavigationWidget extends StatelessWidget {
  const NavigationWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.menu),
      onPressed: () => ZoomDrawer.of(context)!.toggle() ,
    );
  }
}

