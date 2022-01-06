import 'package:fluent_ui/fluent_ui.dart';
import 'package:qt_python_tools/widgets/save_group_widget.dart';

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

  void runCommandUic() {
    // TODO
    return;}

  void saveCommandUic(){
    // TODO
    return;}

  void saveRunCommandUic(){
    return ;}
}
