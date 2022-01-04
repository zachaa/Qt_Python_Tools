import 'dart:ui';
import 'package:fluent_ui/fluent_ui.dart' as flui;

///Constant colors and other theme items
class QtToolThemeColors {
  //static const Color black = Color(0xFF000000);
  //static const Color white = Color(0xFFFFFFFF);
  static const Color qtGreenBase = Color(0xFF41CD52);
  static const Color lupdateColor = Color(0xFFCA4CBB); // pink
  static const Color lreleaseColor = Color(0xFFF87A30); // orange
  static const Color rccColor = Color(0xFF8664B4); //light purple
  static const Color uicColor = Color(0xFF268CDA); //light blue

  static const Color tableTextColor = Color(0xFFDDDDDD);
  static const Color tableGridLineColor = Color(0xFF666666);

  /// Accent Color based off of the shade of green from qt.io (qtGreenBase)
  static final flui.AccentColor qtGreenAccent = flui.AccentColor('normal', const <String, Color>{
    'darkest': Color(0xff287f32),  //print(qtGreenBase.lerpWith(black, 0.38));
    'darker': Color(0xff2d8f39), //print(qtGreenBase.lerpWith(black, 0.30));
    'dark': Color(0xff37ae45), //print(qtGreenBase.lerpWith(black, 0.15));
    'normal': qtGreenBase,
    'light': Color(0xff5dd46b), //print(qtGreenBase.lerpWith(white, 0.15));
    'lighter': Color(0xff7adc85), //print(qtGreenBase.lerpWith(white, 0.30));
    'lightest': Color(0xff89e093), //print(qtGreenBase.lerpWith(white, 0.38));
  });
}