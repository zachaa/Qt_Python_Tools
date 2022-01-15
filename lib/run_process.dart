import 'dart:io' as io;
import 'package:flutter/foundation.dart' as foundation;
import 'package:fluent_ui/fluent_ui.dart';

import '/globals.dart';
import '/process/command_builder.dart';
import '/process/command_base.dart';
import '/widgets/popup_dialogs.dart';

/// Runs the [command] for type [commandType] provided the [0-3] [qtImplementation].
/// [runningColor] changes the color of the [runningTitle] text and spinner.
///
/// [commandType] : should be 'uic' 'rcc' 'lupdate' or 'lrelease'
/// [minArgCount] : prevents running if # < count, default to 2 (input/output)
void runCommandProcess(
    Command command,
    String commandType,
    int qtImplementation,
    String runningTitle,
    Color runningColor,
    BuildContext context,
    {int minArgCount = 2}) async {
  // This *should* never happen because check should prevent it.
  assert(commandMap.keys.contains(commandType));

  List<String> argsList = command.getArgumentsList(qtImplementation);
  String? executable = getExecutableFullPath(qtImplementation, commandType);
  // This *should* never happen because check should prevent it.
  if (executable == null || executable.isEmpty) {return;}
  // Must be input and output path at minimum. This *should* never happen.
  if (argsList.length < minArgCount) {
    showDialog(
        context: context,
        builder: (_) =>
            messageDialog(context,
                'Arguments error',
                'Not enough arguments given (need at least $minArgCount).\n'
                    '${argsList.toString()}'));
    return;
  }

  // Run the command with command_builder function and show progress dialog
  showDialog(
      context: context,
      builder: (_) => processingDialog(context, runningTitle, runningColor),
  );

  // Debug Only: To test that processingDialog will appear
  if (foundation.kDebugMode) {await Future.delayed(const Duration(seconds: 1));}

  io.ProcessResult result = await runQtProcess(executable, argsList);
  Navigator.pop(context); // close the dialog

  // Exit if good, Show error message popup if bad
  if (result.exitCode == 0) {return;} // Success!
  else { // There was an error, show the error message to user
    showDialog(
        context: context,
        builder: (_) =>
            messageDialog(context, 'Run Error', result.stderr as String));
  }
}