import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hiddenmind/shared/theme/colors.dart';


final theme= ThemeData(
primaryColor: defeultColor,
scaffoldBackgroundColor: Colors.white,
appBarTheme: AppBarTheme(
systemOverlayStyle: SystemUiOverlayStyle(
statusBarBrightness: Brightness.dark,
statusBarColor: Colors.grey,
),
iconTheme: IconThemeData(
color: defeultColor,
),
backgroundColor: Colors.white,
elevation: 0.0,
),
bottomNavigationBarTheme: const BottomNavigationBarThemeData(
backgroundColor: Colors.white,
  showUnselectedLabels: false,
  showSelectedLabels: false,
type: BottomNavigationBarType.fixed,
elevation: 0.0,
selectedItemColor: Colors.indigo,
unselectedItemColor: Colors.indigoAccent,
selectedIconTheme: IconThemeData(size: 25),
  unselectedIconTheme: IconThemeData(size: 25),
),
primarySwatch:Colors.indigo,
textTheme:  const TextTheme(
bodyText1: TextStyle(
color: Colors.black,
fontSize: 14,
fontWeight: FontWeight.bold,
),
),

);
