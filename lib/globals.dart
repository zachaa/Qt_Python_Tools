import 'package:shared_preferences/shared_preferences.dart';

/// run on startup to give SharedPreferences throughout the application
class App {
  static late SharedPreferences localStorage;

  static Future init() async {
    localStorage = await SharedPreferences.getInstance();
  }
}

/// The current index of the PillBox widget describing which Qt Implementation to use
int selectedQtImplementation = 0;

/// strings giving the name of the SharedPreferences settings for paths
const List<String> settingsPathNames = ['path_pyqt5', 'path_pyqt6', 'path_pyside2', 'path_pyside6'];

/// Python script names
const String pySide2Uic = 'pyside2-uic';
const String pySide2Rcc = 'pyside2-rcc';
const String pySide2LUpdate = 'pyside2-lupdate';
const String pySide2LRelease = 'pyside2-lrelease';
const String pySide6Uic = 'pyside6-uic';
const String pySide6Rcc = 'pyside6-rcc';
const String pySide6LUpdate = 'pyside6-lupdate';
const String pySide6LRelease = 'pyside6-lrelease';
const String pyQt5Uic = 'pyuic5';
const String pyQt5Rcc = 'pyrcc5';
const String pyQt5LUpdate = 'pylupdate5';
const String? pyQt5LRelease = null;
const String pyQt6Uic = 'pyuic6';
const String? pyQt6Rcc = null;
const String pyQt6LUpdate = 'pylupdate6';
const String? pyQt6LRelease = null;

/// Map of tool type to actual name if it exists
const Map<String, List<String?>> commandMap = {
  'uic': [pyQt5Uic, pyQt6Uic, pySide2Uic, pySide6Uic],
  'rcc': [pyQt5Rcc, pyQt6Rcc, pySide2Rcc, pySide6Rcc],
  'lupdate': [pyQt5LUpdate, pyQt6LUpdate, pySide2LUpdate, pySide6LUpdate],
  'lrelease': [pyQt5LRelease, pyQt6LRelease, pySide2LRelease, pySide6LRelease]};