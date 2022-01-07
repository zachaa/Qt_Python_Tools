import 'package:qt_python_tools/commands_model.dart';

abstract class Command{
  const Command();
  QtCommand getQtCommand(String projectName, String itemName);
  List<String> getArgumentsList(int qtImplementation);

  @override
  String toString();
}