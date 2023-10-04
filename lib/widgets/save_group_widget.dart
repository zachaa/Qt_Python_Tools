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
                          child: SplitButton(
                              flyout: FlyoutContent(
                                child:Button(
                                      onPressed: createSaveFunction,
                                      child: const Text("Save Only")),
                              ),
                              child: SizedBox(
                                height: 28,
                                child: Button(
                                    onPressed: createRunSaveFunction,
                                    child: const Text('Save and Run')),
                              )
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
