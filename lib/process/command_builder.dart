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

/// Runs the process asynchronously to allow for progress dialog to show
Future<io.ProcessResult> runQtProcess(String executable, List<String> arguments) async{
  var result = io.Process.run(executable, arguments);
  return result;
}