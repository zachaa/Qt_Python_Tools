import 'dart:io' as io;
import 'package:fluent_ui/fluent_ui.dart';

import '/globals.dart';
import '/input_checks.dart';
import '/data/commands_model.dart';
import '/data/command_db.dart';
import '/process/command_builder.dart';
import '/process/command_uic.dart';
import '/widgets/popup_dialogs.dart';
import '/widgets/save_group_widget.dart';


class UicPage extends StatefulWidget {
  const UicPage({Key? key}) : super(key: key);

  @override
  _UicPageState createState() => _UicPageState();
}

class _UicPageState extends State<UicPage> {
  // default fields
  final _inputPathController = TextEditingController();
  final _outputPathController = TextEditingController();
  final _projectNameController = TextEditingController();
  final _itemNameController = TextEditingController();
  final _flyoutSaveController = FlyoutController();
  // uic option fields
  final _resourceExtensionController = TextEditingController(text: '_rc');
  bool _optionUicXpyqt = false;

  @override
  void dispose() {
    _inputPathController.dispose();
    _outputPathController.dispose();
    _projectNameController.dispose();
    _itemNameController.dispose();
    _flyoutSaveController.dispose();

    _resourceExtensionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
        header: const PageHeader(title: Text('Uic')),
        content: Padding(
          padding: const EdgeInsets.fromLTRB(14, 0, 6, 0),
            child:SingleChildScrollView(
            scrollDirection: Axis.vertical,
              child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 12, 0), // prevent scroller overlap
              child: Wrap( // use wrap instead of Column to use spacing
                spacing: 20,     // the horizontal spacing
                runSpacing: 20,  // the vertical spacing
                children: [
                  TextBox(
                    header: '.ui file input path',
                    placeholder: 'C:/...',
                    controller: _inputPathController,
                  ),
                  TextBox(
                    header: '.py file output path',
                    placeholder: 'C:/...',
                    controller: _outputPathController,
                  ),
                  Mica(
                    child: Padding(padding: const EdgeInsets.all(8),
                      child: InfoLabel(
                        label: 'PyQt Options:',
                        child: Padding(
                            padding:const EdgeInsets.fromLTRB(8, 8, 2, 0),
                            child:Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Checkbox(
                                      checked: _optionUicXpyqt,
                                      onChanged: checkBoxUseX,
                                      content: const Text('Add code to run Ui from file (-x)')),
                                  const SizedBox(height: 12),  // Spacing between items
                                  Tooltip(
                                      message: '(PyQt5 Only) Rcc Support was removed in PyQt6 because reasons.',
                                      child:SizedBox(
                                        width: 200,
                                        child: TextBox(
                                          header: 'Resources Extension Suffix',
                                          controller: _resourceExtensionController,))),
                              ],
                            )
                        )
                      )
                    ),
                  ),
                  SaveGroupWidget(
                      saveItemName: 'UI',
                      projectNameController: _projectNameController,
                      itemNameController: _itemNameController,
                      dropDownController: _flyoutSaveController,
                      createRunFunction: runCommandUic,
                      createRunSaveFunction: saveRunCommandUic,
                      createSaveFunction: saveCommandUic,)
                ]
              )
        )))
    );
  }

  void checkBoxUseX(bool? newValue) {
    setState(() {_optionUicXpyqt = newValue!;});
  }

  CommandUIC constructCommand() {
    return CommandUIC(
        inputpath: _inputPathController.text,
        outputpath: _outputPathController.text,
        pyqtXOption: _optionUicXpyqt,
        pyqtResourceExtension: _resourceExtensionController.text);
  }

  /// Internal check to make sure paths are valid and names exist
  bool _saveCommandUic(String projectName, String itemName, String inputPath, String outputPath){
    if (!checkInputOutput(inputPath, outputPath, context)) {return false;}
    if (!checkExtension(inputPath, 'Input File', ['ui'], context)){return false;}
    if (!checkExtension(outputPath, 'Output File', ['py'], context)){return false;}
    if (checkProjectItemName(projectName, itemName, context)){return true;}
    return false;
  }

  /// Internal check to make sure paths and tools exists and are valid
  bool _runCommandUicCheck(String inputPath, String outputPath, int qtImplementation){
    if (!checkInputOutput(inputPath, outputPath, context)) {return false;}
    if (!checkExtension(inputPath, 'Input File', ['ui'], context)){return false;}
    if (!checkExtension(outputPath, 'Output File', ['py'], context)){return false;}
    if (!checkInputFilePathExist(inputPath, context)) {return false;}
    if (!checkQtImplementationDirectory(qtImplementation, context)) {return false;}
    if (!checkIfValidTool(qtImplementation, 'uic', context)) {return false;}
    return true;
  }

  // Actually execute the command
  void _runCommandUicProcess(CommandUIC command){
    List<String> argsList = command.getArgumentsList(selectedQtImplementation);
    String? executable = getExecutableFullPath(selectedQtImplementation, 'uic');
    // This *should* never happen because check should prevent it.
    if (executable == null || executable.isEmpty) {return;}
    // Must be input and output path at minimum. This *should* never happen.
    if (argsList.length < 2) {
      showDialog(
          context: context,
          builder: (_) => messageDialog(context,
              'Arguments error',
              'Not enough arguments given (need at least 2).\n'
              '${argsList.toString()}'));
      return;
    }

    // run the command with command_builder function
    print(executable);
    print(argsList);
    // io.ProcessResult? result = runQtProcess(executable, argsList);
    //
    // if (result == null) {return;} // Success!
    // else { // There was an error, show the error message to user
    //   showDialog(
    //     context: context,
    //     builder: (_) => messageDialog(context,
    //         'Run Error',
    //         result.stderr as String));
    // }
  }

  void runCommandUic() {
    String inputPath = _inputPathController.text;
    String outputPath = _outputPathController.text;
    if (!_runCommandUicCheck(inputPath, outputPath, selectedQtImplementation)) {return;}
    // Run command
    CommandUIC command = constructCommand();
    _runCommandUicProcess(command);
  }

  void saveCommandUic(){
    String projectName = _projectNameController.text;
    String itemName = _itemNameController.text;
    String inputPath = _inputPathController.text;
    String outputPath = _outputPathController.text;
    if (!_saveCommandUic(projectName, itemName, inputPath, outputPath)) {return;}
    // Save command
    CommandUIC command = constructCommand();
    QtCommand qtCommand = command.getQtCommand(projectName, itemName);
    QtCommandDatabase.instance.insertQtCommand(qtCommand, tableUic);
  }

  void saveRunCommandUic(){
    String projectName = _projectNameController.text;
    String itemName = _itemNameController.text;
    String inputPath = _inputPathController.text;
    String outputPath = _outputPathController.text;
    // check to make sure all fields are valid
    if (_saveCommandUic(projectName, itemName, inputPath, outputPath) &&
        _runCommandUicCheck(inputPath, outputPath, selectedQtImplementation)){
      // Save command
      CommandUIC command = constructCommand();
      QtCommand qtCommand = command.getQtCommand(projectName, itemName);
      QtCommandDatabase.instance.insertQtCommand(qtCommand, tableUic);
      // Run command
      _runCommandUicProcess(command);
    }
  }
}
