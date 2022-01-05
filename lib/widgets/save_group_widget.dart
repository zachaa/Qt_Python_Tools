import 'package:fluent_ui/fluent_ui.dart';

/// Widget for displaying the 'Create' and 'Create and Save' area/buttons/input
class SaveGroupWidget extends StatelessWidget {
  final String saveItemName;
  final TextEditingController projectNameController;
  final TextEditingController itemNameController;
  final VoidCallback createRunFunction;
  final VoidCallback createRunSaveFunction;

  const SaveGroupWidget(
      {Key? key,
      required this.saveItemName,
      required this.projectNameController,
      required this.itemNameController,
      required this.createRunFunction,
      required this.createRunSaveFunction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Mica(
      child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Button(
                    child: Text('Create $saveItemName'),
                    onPressed: createRunFunction),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    const InfoLabel(label: 'Save as:'),
                    SizedBox(
                        width: 150,
                        child: TextBox(
                          header: 'Project Name',
                          controller: projectNameController,
                        )),
                    SizedBox(
                        width: 200,
                        child: TextBox(
                          header: 'Name',
                          controller: itemNameController,
                        )),
                    Button(
                        child: const Text('Create and Save'),
                        onPressed: createRunSaveFunction),
                  ],
                ),
              ]),
      ),
    );
  }
}
