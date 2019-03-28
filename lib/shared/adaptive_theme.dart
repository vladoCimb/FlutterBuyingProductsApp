import 'package:flutter/material.dart';

final ThemeData _androidTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.deepOrange,
    accentColor: Colors.deepPurple,
    //nastavenie napr farby buttonov alebo pozadia a podobne toto je velmi uzitocne

    fontFamily: 'Oswald');

final ThemeData _iOsTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.grey,
    accentColor: Colors.deepPurple,
    //nastavenie napr farby buttonov alebo pozadia a podobne toto je velmi uzitocne

    fontFamily: 'Oswald');

    ThemeData getADaptiveThemeData(context){
      return Theme.of(context).primaryColor ==TargetPlatform.android ? _androidTheme : _androidTheme;
    }