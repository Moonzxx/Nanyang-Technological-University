import 'bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/screen1.dart';
import '../widgets/screen2.dart';
import '../widgets/screen3.dart';
import '../widgets/screen4.dart';
import '../widgets/screen5.dart';


class NavHomePage extends StatelessWidget {
  const NavHomePage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Liquid',
      home: BottomLiquidBar(screen: [Screen1(), Screen2(), Screen3(), Screen4(), Screen5()],barItemNo: 5),

    );

  }
}
