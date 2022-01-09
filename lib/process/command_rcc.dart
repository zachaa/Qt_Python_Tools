import 'dart:ui';
import '/data/commands_model.dart';
import '/process/command_base.dart';

// TODO PyQt5 only uses 1 '-' while pyside2/6 use 2 except for -o
// TODO should I add -root <path> option as well (both have it)

/// Class for creating pyrcc#/pyside#-rcc commands to run with Process
class CommandRCC extends Command{
  final String inputpath;
  final String outputpath;
  final bool useCompressionOptions;
  final bool useNoCompression;
  final String compressionThreshold;
  final String compressionValue;

  const CommandRCC({
    required this.inputpath,
    required this.outputpath,
    required this.useCompressionOptions,
    required this.useNoCompression,
    required this.compressionThreshold,
    required this.compressionValue,});

  /// Creates a command from a QtCommand (selected from the Home table)
  static CommandRCC fromQtCommand(QtCommand qtCommand){
    // rcc command only has shared options
    bool useCompressOpt = false;
    bool useNoCompress = false;
    String compressThresh = '70';
    String compressValue = '-1';

    if (qtCommand.cmdOptions.isEmpty) { // same as No Compression Options
      useCompressOpt = false;
    } else {
        useCompressOpt = true;
        List<String> splitPyQtArgs = qtCommand.cmdPyQtOptions.split(' ');
        // need to make sure different elements are valid
        for (var i=0; i<splitPyQtArgs.length; i++) {
          if (splitPyQtArgs[i] == '-no-compress'){
            useNoCompress = true;
            continue;
          } else if (splitPyQtArgs[i] == '-threshold'){
            compressThresh = splitPyQtArgs[i+1];
            continue;
          } else if (splitPyQtArgs[i] == '-compress'){
            compressValue = splitPyQtArgs[i+1];
          }
        }
    }

    return CommandRCC(
        inputpath: qtCommand.pathInput,
        outputpath: qtCommand.pathOutput,
        useCompressionOptions: useCompressOpt,
        useNoCompression: useNoCompress,
        compressionThreshold: compressThresh,
        compressionValue: compressValue);
  }

  ///Gives the Options string for use with QtCommand
  String _sharedOptions(){
    if (!useCompressionOptions){return '';}
    if (useNoCompression) {return '-no-compress';}

    String thresh = compressionThreshold=='70' ? '' : '-threshold $compressionThreshold';
    String value = compressionValue=='-1' ? '' : '-compression $compressionValue';
    List<String> rccOptionsList = [thresh, value];
    return rccOptionsList.join(' ');
  }

  /// Creates a QtCommand to add to a database of previous commands
  @override
  QtCommand getQtCommand(String projectName, String itemName){
    return QtCommand(projectName: projectName, itemName: itemName,
        pathInput: inputpath, pathOutput: outputpath,
        cmdOptions: _sharedOptions(),
        cmdPyQtOptions: '',
        cmdPySideOptions: '');
  }

  /// Gives the arguments of the uic command in a list for use with Process.run
  @override
  List<String> getArgumentsList(int qtImplementation){
    assert (qtImplementation != 1);
    List<String> argList = [inputpath];

    if (useCompressionOptions){
      if (useNoCompression){
        argList.add('-no-compress');
      } else {
        if (!(compressionThreshold == '70')){
          argList.add('-threshold');
          argList.add(compressionThreshold);
        }
        if (!(compressionValue == '-1')){
          argList.add('-compress');
          argList.add(compressionValue);
        }
      }
    }

    argList.add('-o');
    argList.add(outputpath);
    return argList;
  }

  @override
  String toString(){
    return "inputpath=$inputpath, outputpath=$outputpath,"
        " useCompress=$useCompressionOptions: (noCompress=$useNoCompression,"
        " threshold=$compressionThreshold, value=$compressionValue)";
  }

  @override
  bool operator ==(Object other) =>
      (other is CommandRCC) ?
        (inputpath == other.inputpath &&
        outputpath == other.outputpath &&
        useCompressionOptions == other.useCompressionOptions &&
        useNoCompression == other.useNoCompression &&
        compressionThreshold == other.compressionThreshold &&
        compressionValue == other.compressionValue)
          : false;

  @override
  int get hashCode => hashValues(inputpath, outputpath,
      useCompressionOptions, useNoCompression,
      compressionThreshold, compressionValue);
}