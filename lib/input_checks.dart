import 'dart:io' as io;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:path/path.dart';

import 'globals.dart';
import '/widgets/popup_dialogs.dart';


bool checkProjectItemName(String projectName, String itemName, BuildContext context){
  if (projectName.isEmpty || itemName.isEmpty){
    showDialog(
        context: context,
        builder: (_) => messageDialog(context,
            'Empty Text',
            'Project Name and Item Name must have some text.'));
    return false;
  }
  return true;
}

bool checkInputOutput(String inputPath, String outputPath, BuildContext context){
  if (inputPath.isEmpty || outputPath.isEmpty){
    showDialog(
        context: context,
        builder: (_) => messageDialog(context,
            'Empty Text',
            'Input Path and Output Path must both be given.'));
    return false;
  }
  return true;
}

bool checkExtension(String filePath, String inputWidgetName, List<String> allowedExtensions, BuildContext context) {
  String ext = extension(filePath).replaceAll('.', '');
  if (allowedExtensions.contains(ext)) {return true;}
  showDialog(
      context: context,
      builder: (_) => messageDialog(context,
          'Invalid File Extension',
          'The $inputWidgetName field requires a ${allowedExtensions.toString()} file extension.'));
  return false;
}

bool checkInputFilePathExist(String inputPath, BuildContext context){
  if (io.File(inputPath).existsSync()) {return true;}
  showDialog(
      context: context,
      builder: (_) => messageDialog(context,
          'File Does not Exist',
          'The input file does not exist.'));
  return false;
}

bool checkQtImplementationDirectory(int pythonQt, BuildContext context) {
  String path = App.localStorage.getString(settingsPathNames[pythonQt]) ?? '';
  if (path.isEmpty) {
    showDialog(
        context: context,
        builder: (_) => messageDialog(context,
            'Missing Path',
            "Please add a path to the 'scripts' directory for this Qt implementation in the 'Settings' page."));
    return false;
  } else if (!io.Directory(path).existsSync()) {
    showDialog(
        context: context,
        builder: (_) => messageDialog(context,
            'Missing Path',
            "The path to the 'scripts' directory for this Qt implementation does not exist. Please update the 'Settings' page."));
    return false;
  }
  return true;
}

/// Checks if the tool is supported and if it exists
bool checkIfValidTool(int qtVersion, String toolName, BuildContext context) {
  String? qtPyTool = commandMap[toolName]![qtVersion];
  if (qtPyTool == null) {
    showDialog(
        context: context,
        builder: (_) => messageDialog(context,
            'Unsupported Tool',
            'The $toolName tool is not supported for this python Qt implementation.'));
    return false;
  }

  String pathToScripts = App.localStorage.getString(settingsPathNames[qtVersion]) ?? '';
  if (!io.File(join(pathToScripts, qtPyTool + '.exe')).existsSync()) {
    showDialog(
        context: context,
        builder: (_) => messageDialog(context,
            'Tool Not Found',
            'The tool "$qtPyTool.exe" was not found in "$pathToScripts".'));
    return false;
  }

  return true;
}