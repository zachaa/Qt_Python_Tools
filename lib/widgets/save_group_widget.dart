import 'package:fluent_ui/fluent_ui.dart';

/// Widget for displaying the 'Create' and 'Create and Save' area/buttons/input
class SaveGroupWidget extends StatelessWidget {
  final String saveItemName;
  final TextEditingController projectNameController;
  final TextEditingController itemNameController;
  final FlyoutController dropDownController;
  final VoidCallback createRunFunction;
  final VoidCallback createRunSaveFunction;
  final VoidCallback createSaveFunction;

  const SaveGroupWidget(
      {Key? key,
      required this.saveItemName,
      required this.projectNameController,
      required this.itemNameController,
      required this.dropDownController,
      required this.createRunFunction,
      required this.createRunSaveFunction,
      required this.createSaveFunction
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 750),
        child: Mica(
          child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Button(
                        child: Text('Create $saveItemName'),
                        onPressed: createRunFunction),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 28,
                          child: SplitButtonBar(
                              style: SplitButtonThemeData(
                                primaryButtonStyle: ButtonStyle(
                                    padding: ButtonState.all(const EdgeInsets.fromLTRB(11, 5, 11, 6))),
                                actionButtonStyle: ButtonStyle(
                                    padding: ButtonState.all(const EdgeInsets.fromLTRB(8, 5, 11, 6))),
                              ),
                              buttons: [
                                SizedBox(
                                  height: 28,
                                  child: Button(
                                      child: const Text('Save and Run'),
                                      onPressed: createRunSaveFunction),
                                ),
                                SizedBox(
                                  height: 28,
                                  child: DropDownButton(
                                      controller: dropDownController,
                                      contentWidth: 150,
                                      items: [
                                        DropDownButtonItem(
                                            title: const Text('Save Only'),
                                            onTap: createSaveFunction ),
                                      ]),
                                ),
                              ]),
                        ),
                        Flexible(
                            child: Padding(
                                padding: const EdgeInsets.only(left: 16, right: 8),
                                child: TextBox(
                                  header: 'Project Name',
                                  controller: projectNameController,
                                ),
                            )),
                        Flexible(
                            child: Padding(
                                padding: const EdgeInsets.only(left: 8, right: 0),
                                child: TextBox(
                                  header: 'Name',
                                  controller: itemNameController,
                                ),
                            )),
                      ]),
                  ]),
          ),
        ),
    );
  }
}
