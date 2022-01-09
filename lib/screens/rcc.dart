import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';

import '/globals.dart';
import '/input_checks.dart';
import '/run_process.dart';
import '/theme.dart';
import '/data/commands_model.dart';
import '/data/command_db.dart';
import '/formatters/NumericalRangeFormatter.dart';
import '/process/command_rcc.dart';
import '/widgets/save_group_widget.dart';


class RccPage extends StatefulWidget {
  const RccPage({Key? key}) : super(key: key);

  @override
  _RccPageState createState() => _RccPageState();
}

class _RccPageState extends State<RccPage> {
  // default fields
  final _inputPathController = TextEditingController();
  final _outputPathController = TextEditingController();
  final _projectNameController = TextEditingController();
  final _itemNameController = TextEditingController();
  final _flyoutSaveController = FlyoutController();
  // rcc option fields
  final _thresholdController = TextEditingController(text: '70');
  final _compressionController = TextEditingController(text: '-1');
  bool _useCompressionOptions = false;
  bool optionNoCompress = false;

  @override
  void dispose() {
    _inputPathController.dispose();
    _outputPathController.dispose();
    _projectNameController.dispose();
    _itemNameController.dispose();
    _flyoutSaveController.dispose();

    _thresholdController.dispose();
    _compressionController.dispose();
    super.dispose();
  }

  /// need Enable and Disable all the compression options
  void checkBoxUseCompression(bool? newValue) {
    setState(() {_useCompressionOptions = newValue!;});
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
        header: const PageHeader(title: Text('Rcc')),
        content: Padding(
          padding: const EdgeInsets.fromLTRB(14, 0, 6, 0),
          child:SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 12, 0), // prevent scroller overlap
              child:Wrap( // use wrap instead of Column to use spacing
                spacing: 20,     // the horizontal spacing
                runSpacing: 20,  // the vertical spacing
                children: [
                  TextBox(
                    header: '.qrc file input path',
                    placeholder: 'C:/...',
                    controller: _inputPathController,
                  ),
                  TextBox(
                    header: '.py file output path',
                    placeholder: 'C:/...',
                    controller: _outputPathController,
                  ),
                  Mica(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                            checked: _useCompressionOptions,
                            onChanged: checkBoxUseCompression, // enable/disable lower widgets
                            content: const Text('Use Compression Options'),
                          ),
                          Padding(
                            padding:const EdgeInsets.all(10),
                            child:Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Tooltip(
                                  message: 'Do not compress resources. '
                                           'Threshold and Compression Level values are ignored.',
                                  child: Checkbox(
                                      checked: optionNoCompress,
                                      onChanged: _useCompressionOptions
                                          ? (bool? value) {setState(
                                              () {optionNoCompress = value!;});}
                                          : null,
                                      content: const Text('No Compression'))
                                ),
                                SizedBox(width: 120,
                                    child:Tooltip(
                                        message: 'Specifies a threshold level (as a percentage) to use when deciding whether '
                                            'to compress a file. If the reduction in the file size is greater than the '
                                            'threshold level, it is compressed; otherwise, the uncompressed data is stored '
                                            'instead. The default threshold level is 70%, meaning that compressed files '
                                            'which are 30% or less of their original size are stored as compressed data.',
                                        child:TextBox(
                                          header: 'Threshold Value',  // TODO starting value 70
                                          controller: _thresholdController,
                                          enabled: _useCompressionOptions && !optionNoCompress,
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.digitsOnly,
                                            NumericalRangeFormatter(min: 0, max: 100, decimalsToShow: 0)],
                                        )
                                    )
                                ),
                                SizedBox(width: 120,
                                    child: Tooltip(
                                      message: 'Compress input files to the given compression level, which is algorithm-dependent. '
                                          'The level is an integer in the range 1 to 9. Level 1 does the least compression but is '
                                          'fastest. Level 9 does the most compression but is slowest. To turn off compression, use '
                                          'the "No Compression" Check Box. The default value for level is -1.',
                                      child: TextBox(
                                        header: 'Compression Value',  // TODO starting value -1
                                        controller: _compressionController,
                                        enabled: _useCompressionOptions && !optionNoCompress,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly,
                                          NumericalRangeFormatter(min: -1, max: 9, decimalsToShow: 0)],
                                      )
                                    )
                                ),
                              ],
                            )
                        )]
                    )
                    ),
                  SaveGroupWidget(
                      saveItemName: 'RCC',
                      projectNameController: _projectNameController,
                      itemNameController: _itemNameController,
                      dropDownController: _flyoutSaveController,
                      createRunFunction: runCommandRcc,
                      createRunSaveFunction: saveRunCommandRcc,
                      createSaveFunction: saveCommandRcc,),
                ]
              )
        )))
    );
  }

  CommandRCC constructCommand(){
    return CommandRCC(
        inputpath: _inputPathController.text,
        outputpath: _outputPathController.text,
        useCompressionOptions: _useCompressionOptions,
        useNoCompression: optionNoCompress,
        compressionThreshold: _thresholdController.text,
        compressionValue: _compressionController.text);
  }

  /// Internal check to make sure paths are valid and names exist
  bool _saveCommandRcc(String projectName, String itemName, String inputPath, String outputPath){
    if (!checkInputOutput(inputPath, outputPath, context)) {return false;}
    if (!checkExtension(inputPath, 'Input File', ['qrc'], context)){return false;}
    if (!checkExtension(outputPath, 'Output File', ['py'], context)){return false;}
    if (checkProjectItemName(projectName, itemName, context)){return true;}
    return false;
  }

  /// Internal check to make sure paths and tools exists and are valid
  bool _runCommandRccCheck(String inputPath, String outputPath, int qtImplementation){
    if (!checkInputOutput(inputPath, outputPath, context)) {return false;}
    if (!checkExtension(inputPath, 'Input File', ['qrc'], context)){return false;}
    if (!checkExtension(outputPath, 'Output File', ['py'], context)){return false;}
    if (!checkInputFilePathExist(inputPath, context)) {return false;}
    if (!checkQtImplementationDirectory(qtImplementation, context)) {return false;}
    if (!checkIfValidTool(qtImplementation, 'rcc', context)) {return false;}
    return true;
  }

  void runCommandRcc() {
    String inputPath = _inputPathController.text;
    String outputPath = _outputPathController.text;
    if (!_runCommandRccCheck(inputPath, outputPath, selectedQtImplementation)) {return;}
    // Run command
    CommandRCC command = constructCommand();
    runCommandProcess(command, 'rcc',
        selectedQtImplementation,
        'Running RCC',
        QtToolThemeColors.rccColor, context);
  }

  void saveCommandRcc(){
    String projectName = _projectNameController.text;
    String itemName = _itemNameController.text;
    String inputPath = _inputPathController.text;
    String outputPath = _outputPathController.text;
    if (!_saveCommandRcc(projectName, itemName, inputPath, outputPath)) {return;}
    // Save command
    CommandRCC command = constructCommand();
    QtCommand qtCommand = command.getQtCommand(projectName, itemName);
    QtCommandDatabase.instance.insertQtCommand(qtCommand, tableRcc);
  }

  void saveRunCommandRcc(){
    String projectName = _projectNameController.text;
    String itemName = _itemNameController.text;
    String inputPath = _inputPathController.text;
    String outputPath = _outputPathController.text;
    // check to make sure all fields are valid
    if (_saveCommandRcc(projectName, itemName, inputPath, outputPath) &&
        _runCommandRccCheck(inputPath, outputPath, selectedQtImplementation)){
      // Save command
      CommandRCC command = constructCommand();
      QtCommand qtCommand = command.getQtCommand(projectName, itemName);
      QtCommandDatabase.instance.insertQtCommand(qtCommand, tableRcc);
      // Run command
      runCommandProcess(command, 'rcc',
          selectedQtImplementation,
          'Running RCC',
          QtToolThemeColors.rccColor, context);
    }
  }
}