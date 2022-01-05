import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import '../formatters/NumericalRangeFormatter.dart';
import 'package:qt_python_tools/widgets/save_group_widget.dart';


class RccPage extends StatefulWidget {
  const RccPage({Key? key}) : super(key: key);

  @override
  _RccPageState createState() => _RccPageState();
}

class _RccPageState extends State<RccPage> {
  // default fields
  var _inputPathController = TextEditingController();
  var _outputPathController = TextEditingController();
  var _projectNameController = TextEditingController();
  var _itemNameController = TextEditingController();
  // rcc option fields
  TextEditingController _thresholdController = TextEditingController(text: '70');
  TextEditingController _compressionController = TextEditingController(text: '-1');
  bool _useCompressionOptions = false;
  bool optionNoCompress = false;

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
                                          enabled: _useCompressionOptions,
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
                                        enabled: _useCompressionOptions,
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
                      createRunFunction: checkAndRunCommandRcc,
                      createRunSaveFunction: saveCommandRcc),
                ]
              )
        )))
    );
  }

  void checkAndRunCommandRcc() {
    // TODO
    return;}

  void saveCommandRcc(){
    // TODO
    return;}

  @override
  void dispose() {
    _inputPathController.dispose();
    _outputPathController.dispose();
    _projectNameController.dispose();
    _itemNameController.dispose();

    _thresholdController.dispose();
    _compressionController.dispose();
    super.dispose();
  }

}