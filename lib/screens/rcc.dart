import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import '../formatters/NumericalRangeFormatter.dart';


class RccPage extends StatefulWidget {
  const RccPage({Key? key}) : super(key: key);

  @override
  _RccPageState createState() => _RccPageState();
}

class _RccPageState extends State<RccPage> {
  TextEditingController _thresholdController = TextEditingController(text: '70');
  TextEditingController _compressionController = TextEditingController(text: '-1');
  bool _useCompressionOptions = false;
  bool optionNoCompress = false;

  //int? optionThresholdLevel = null;
  //int? optionCompressionLevel = null;

  /// need Enable and Disable all the compression options
  void checkBoxUseCompression(bool? newValue) {
    setState(() {_useCompressionOptions = newValue!;});
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
        header: const PageHeader(title: Text('Rcc')),
        content: Padding(
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
            child:Wrap( // use wrap instead of Column to use spacing
                spacing: 20,     // the horizontal spacing
                runSpacing: 20,  // the vertical spacing
                children: [
                  const TextBox(
                    header: '.qrc file input path',
                    placeholder: 'C:/...',
                  ),
                  const TextBox(
                    header: '.py file output path',
                    placeholder: 'C:/...',
                  ),
                  SizedBox(
                    width: 440,
                    child: Mica( // Mica is like a group box, it's a different color
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Checkbox(
                                checked: _useCompressionOptions,
                                onChanged: checkBoxUseCompression, // enable/disable lower widgets
                                content: const Text('Use Compression Options'),
                              ),
                              Padding(
                                padding:const EdgeInsets.all(8),
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
                  ),
                SizedBox(
                  width: 600,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Button(
                        child: const Text('Create Resources'),
                        onPressed: checkAndRunCommandRcc),
                      const SizedBox(width: 30),
                      const InfoLabel(label: 'Save as:'),
                      SizedBox(
                          width: 200,
                          child: TextBox()),
                      Button(
                          child: const Text('Create and Save'),
                          onPressed: saveCommandRcc),
                    ],
                  ),
                ),
                ]
            )
        )
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
    // TODO: implement dispose
    _thresholdController.dispose();
    _compressionController.dispose();
    super.dispose();
  }

}