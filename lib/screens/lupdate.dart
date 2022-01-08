import 'package:fluent_ui/fluent_ui.dart';
import '/theme.dart';
import '/widgets/save_group_widget.dart';


class LUpdatePage extends StatefulWidget {
  const LUpdatePage({Key? key}) : super(key: key);

  @override
  _LUpdatePageState createState() => _LUpdatePageState();
}

class _LUpdatePageState extends State<LUpdatePage> {
  // default fields
  final _inputPathController = TextEditingController();
  final _outputPathController = TextEditingController();
  final _projectNameController = TextEditingController();
  final _itemNameController = TextEditingController();
  final _flyoutSaveController = FlyoutController();
  // lupdate option fields
  bool _noObsolete = false;
  final _trFunctionName = TextEditingController();
  final _translateFunctionName = TextEditingController();

  @override
  void dispose() {
    _inputPathController.dispose();
    _outputPathController.dispose();
    _projectNameController.dispose();
    _itemNameController.dispose();
    _flyoutSaveController.dispose();

    _trFunctionName.dispose();
    _translateFunctionName.dispose();
    super.dispose();
  }

  void checkBoxNoObsolete(bool? newValue) {
    setState(() {_noObsolete = newValue!;});
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
        header: const PageHeader(
            title: Text('LUpdate')
        ),
        content: Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 12, 0), // prevent scroller overlap
                child: Wrap( // use wrap instead of Column to use spacing
                  spacing: 20,     // the horizontal spacing
                  runSpacing: 20,  // the vertical spacing
                  children: [
                    TextBox(
                      header: '.pro/.qrc/.py file input path',
                      placeholder: 'C:/...',
                      controller: _inputPathController,
                    ),
                    TextBox(
                      header: '.ts file output path',
                      placeholder: 'C:/...',
                      controller: _outputPathController,
                    ),
                    SizedBox(
                      width: 520,
                      child: Mica( // Mica is like a group box, it's a different color
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Checkbox(
                                  checked: _noObsolete,
                                  onChanged: checkBoxNoObsolete,
                                  content: const Text('Drop all Obsolete Strings'),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                  child: SizedBox(
                                    width: 420,
                                    child: Acrylic(
                                      elevation: 1,
                                      tint: QtToolThemeColors.lupdateColor,
                                      tintAlpha: 0.2,
                                      luminosityAlpha: 0.1,
                                      blurAmount: 50,
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(8))),
                                      // TODO add notice to prefer using translate() not tr()
                                      child: Padding(
                                        padding: const EdgeInsets.all(5),
                                        child:
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                                const InfoLabel(label: 'PyQt Options'),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(width: 160,
                                                      child: Tooltip(
                                                          message: 'name() may be used instead of tr()',
                                                          child: TextBox(
                                                            header: 'tr Function Name',
                                                            controller: _trFunctionName,
                                                          ))),
                                                    SizedBox(width: 160,
                                                      child:Tooltip(
                                                          message: 'name() may be used instead of translate()',
                                                          child:TextBox(
                                                            header: 'translate Function Name',
                                                            controller: _translateFunctionName,
                                                          ))),
                                                  ]),
                                            ]),
                                      )),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                  child: SizedBox(
                                    width: 420,
                                    child: Acrylic(
                                      elevation: 1,
                                      tint: QtToolThemeColors.lupdateColor,
                                      tintAlpha: 0.2,
                                      luminosityAlpha: 0.1,
                                      blurAmount: 50,
                                      shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(8))),
                                      // TODO add notice to prefer using translate() not tr()
                                      child: Padding(
                                        padding: const EdgeInsets.all(5),
                                        child:
                                          Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const InfoLabel(label: 'PySide Options'),]
                                    ))),
                                ))
                              ]
                          )
                      ),
                    ),
                    SaveGroupWidget(
                        saveItemName: 'LUpdate',
                        projectNameController: _projectNameController,
                        itemNameController: _itemNameController,
                        dropDownController: _flyoutSaveController,
                        createRunFunction: runCommandLUpdate,
                        createRunSaveFunction: saveRunCommandLUpdate,
                        createSaveFunction: saveCommandLUpdate,),
                  ]
            )))
        ));
  }

  void runCommandLUpdate() {
    // TODO
    return;}

  void saveCommandLUpdate(){
    // TODO
    return;}

  void saveRunCommandLUpdate(){
    return;}
}