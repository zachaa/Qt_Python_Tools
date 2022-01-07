import 'dart:io' as io;
import 'package:path/path.dart';
import '/globals.dart';

/// Provides a way to return multiple variables at once since this is not native to dart
// class BoolMessage{
//   final bool isValid;
//   final String message;
//
//   const BoolMessage({required this.isValid, required this.message});
// }

String? getExecutableFullPath(int qtImplementation, String toolName){
  String qtPyTool = commandMap[toolName]![qtImplementation] ?? '';
  if (qtPyTool == '') {return null;}
  String pathToScripts = App.localStorage.getString(settingsPathNames[qtImplementation]) ?? '';
  if (pathToScripts == '') {return null;}

  return join(pathToScripts, qtPyTool + '.exe');
}

io.ProcessResult? runQtProcess(String executable, List<String> arguments) {
  var result = io.Process.runSync(executable, arguments);
  print(result.stdout);
  if (result.exitCode == 0){
    return null;
  } else {
    return result;
  }
}