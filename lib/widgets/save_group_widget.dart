import 'package:fluent_ui/fluent_ui.dart';

/// Widget for displaying the 'Create' and 'Create and Save' area/buttons/input
class SaveGroupWidget extends StatelessWidget {
  final String saveItemName;
  final TextEditingController projectNameController;
  final TextEditingController itemNameController;
  final VoidCallback createRunFunction;
  final VoidCallback createRunSaveFunction;
  final VoidCallback createSaveFunction;

  const SaveGroupWidget(
      {Key? key,
      required this.saveItemName,
      required this.projectNameController,
      required this.itemNameController,
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
                        onPressed: createRunFunction,
                        child: Text('Create $saveItemName')),
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
                                // Need sized box so DropDownButton is correct height to match Text button
                                SizedBox(
                                  height: 28,
                                  child: Button(
                                      onPressed: createRunSaveFunction,
                                      child: const Text('Save and Run')),
                                ),
                                SizedBox(
                                  height: 28,
                                  // TODO just use a button without dropdown until fix
                                  child: Button(
                                    onPressed: createSaveFunction,
                                    child: const Text("Save Only")),
                                  // child: DropDownButton(
                                  //     items: [
                                  //       // TODO this goes below the window,
                                  //       // TODO DropDown in Web Example works correctly 7-2022
                                  //       MenuFlyoutItem(
                                  //           text: const Text('Save Only'),
                                  //           onPressed: createSaveFunction),
                                  //       // DropDownButtonItem(
                                  //       //     title: const Text('Save Only'),
                                  //       //     onTap: createSaveFunction ),
                                  //     ],
                                  // ),
                                )
                              ]
                          ),
                        ),
                        Flexible(
                            child: Padding(
                                padding: const EdgeInsets.only(left: 16, right: 8),
                                child: InfoLabel(
                                  label: "Project Name",
                                  child: TextBox(
                                    controller: projectNameController,
                                  ),
                                )
                            )),
                        Flexible(
                            child: Padding(
                                padding: const EdgeInsets.only(left: 8, right: 0),
                                child: InfoLabel(
                                  label: "Name",
                                  child:TextBox(
                                    controller: itemNameController,
                                  )
                                )
                            )),
                      ]),
                  ]),
          ),
        ),
    );
  }
}
