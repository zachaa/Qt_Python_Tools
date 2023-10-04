import 'dart:io' as io;
import 'package:path/path.dart';
import '/globals.dart';

/// Gets the absolute path to the [toolName] exe for the given [0-3] [qtImplementation]
String? getExecutableFullPath(int qtImplementation, String toolName){
  String qtPyTool = commandMap[toolName]![qtImplementation] ?? '';
  if (qtPyTool == '') {return null;}
  String pathToScripts = App.localStorage.getString(settingsPathNames[qtImplementation]) ?? '';
  if (pathToScripts == '') {return null;}

  return join(pathToScripts, '$qtPyTool.exe');
}

/// Runs the process asynchronously to allow for progress dialog to show given
/// the absolute path [executable] with the list [arguments].
Future<io.ProcessResult> runQtProcess(String executable, List<String> arguments) async{
  var result = io.Process.run(executable, arguments);
  return result;
}