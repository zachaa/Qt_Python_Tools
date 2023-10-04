import '/data/commands_model.dart';
import '/process/command_base.dart';

/// Class for creating pyuic#/pyside#-uic commands to run with Process
class CommandUIC extends Command{
  final String inputpath;
  final String outputpath;
  final bool pyqtXOption;
  final String pyqtResourceExtension;

  const CommandUIC({
    required this.inputpath,
    required this.outputpath,
    required this.pyqtXOption,
    required this.pyqtResourceExtension});

  /// Creates a command from a QtCommand (selected from the Home table)
  static CommandUIC fromQtCommand(QtCommand qtCommand){
    // uic command does not have any PySide options or shared options
    bool xOpt = false;
    String resourceExt = '';

    if (qtCommand.cmdPyQtOptions.isEmpty) {
      xOpt = false;
      resourceExt = '';
    } else {
      List<String> splitPyQtArgs = qtCommand.cmdPyQtOptions.split(' ');
      // need to make sure different elements are valid
      for (var element in splitPyQtArgs) {
        if (element.startsWith('-x')){
          xOpt = true;}
        else if (element.startsWith('--resource')){
          // second item is the extension: gives "xxx"
          String quotedExt = element.split('=')[1];
          // remove the " " around the text, they get added back when needed
          resourceExt = quotedExt.replaceAll('"', '');}  //
      }
    }

    return CommandUIC(
        inputpath: qtCommand.pathInput,
        outputpath: qtCommand.pathOutput,
        pyqtXOption: xOpt,
        pyqtResourceExtension: resourceExt);
  }

  // TODO need to check what happens if I want NO suffix
  String _resourceExtension(){
    //String extension = pyqtResourceExtension ?? '""'; // does this work
    return '--resource-suffix="$pyqtResourceExtension"';
    // if (extension.isNotEmpty) {return '--resource_suffix="$extension"';}
  }

  ///Gives the pyqtOptions string for use with QtCommand
  String _pyqtOptions(){
    String xOptStr = pyqtXOption ? '-x' : '';
    List<String> pyqtOptionsList = [xOptStr, _resourceExtension()];
    return pyqtOptionsList.join(' ');
  }

  /// Creates a QtCommand to add to a database of previous commands
  @override
  QtCommand getQtCommand(String projectName, String itemName){
    return QtCommand(projectName: projectName, itemName: itemName,
        pathInput: inputpath, pathOutput: outputpath,
        cmdOptions: '',
        cmdPyQtOptions: _pyqtOptions(), cmdPySideOptions: '');
  }

  /// Gives the arguments of the uic command in a list for use with Process.run
  @override
  List<String> getArgumentsList(int qtImplementation){
    List<String> argList = [inputpath];
    if (qtImplementation <= 1) {  // PyQt5 and PyQt6 only
      if (pyqtXOption) {
        argList.add('-x');
      }}
    if (qtImplementation == 0){  // PyQt5 only
      argList.add(_resourceExtension());
    }
    argList.add('-o');
    argList.add(outputpath);
    return argList;
  }

  @override
  String toString(){
    return "inputpath=$inputpath, outputpath=$outputpath,"
        " pyqtXOption=$pyqtXOption, pyqtResourceExtension=$pyqtResourceExtension";
  }

  @override
  bool operator ==(Object other) =>
      (other is CommandUIC) ?
        (inputpath == other.inputpath &&
        outputpath == other.outputpath &&
        pyqtXOption == other.pyqtXOption &&
        pyqtResourceExtension == other.pyqtResourceExtension)
          : false;

  @override
  int get hashCode => Object.hash(inputpath, outputpath,
      pyqtXOption, pyqtResourceExtension);
}