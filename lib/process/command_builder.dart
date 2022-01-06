import 'dart:io' as io;
import 'package:path/path.dart';

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

/// Provides a way to return multiple variables at once since this is not native to dart
class BoolMessage{
  final bool isValid;
  final String message;

  const BoolMessage({required this.isValid, required this.message});
}


bool checkFilePath(String filePath){
  return io.File(filePath).existsSync();
}

///Make sure the script is in the folder and valid for the tool to be used
BoolMessage isValidPythonQt(int qtVersion, String toolName, String pathToScripts) {
  if (!io.Directory(pathToScripts).existsSync()) {
    return const BoolMessage(isValid: false,
        message: 'Check your path to the python scripts folder.');
  }

  String? qtPyTool = commandMap[toolName]![qtVersion];
  if (qtPyTool == null) {
    return BoolMessage(
        isValid: false,
        message: 'The $toolName tool is not supported for this python Qt version.');
  }

  if (!checkFilePath(join(pathToScripts, qtPyTool + '.exe'))) {
    return BoolMessage(isValid: false,
        message: 'The tool "$qtPyTool.exe" was not found in "$pathToScripts".');
  }

  return const BoolMessage(isValid: true, message: 'Path to exe is good.');
  // return const BoolMessage(isValid: false, message: 'Invalid');
}

dynamic runProcess(String executable, List<String> arguments) async{
  var result = await io.Process.run(executable, arguments);
  print(result.stdout);
  if (result.exitCode == 0){
    return null;
  } else {
    return result.stderr;
  }
}