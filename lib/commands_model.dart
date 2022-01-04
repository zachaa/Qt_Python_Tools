// table names
const String tableUic = 'uic';
const String tableRcc = 'rcc';
const String tableLUpdate = 'lupdate';
const String tableLRelease = 'lrelease';

class QtCmdFields {
  static final List<String> values = [
    id, projectName, itemName, pathInput, pathOutput, cmdExtraArgs
  ];

  static const String id = '_id';
  static const String projectName = 'projectName';
  static const String itemName = 'itemName';
  static const String pathInput = 'pathInput';
  static const String pathOutput = 'pathOutput';
  static const String cmdExtraArgs = 'cmdExtraArgs';
}


/// Class for holding Qt Commands that need to be loaded from a local database
class QtCommand {
  final int? id;
  final String projectName;
  final String itemName;
  final String pathInput;
  final String pathOutput;
  final String cmdExtraArgs;

  const QtCommand({
    this.id,
    required this.projectName,
    required this.itemName,
    required this.pathInput,
    required this.pathOutput,
    required this.cmdExtraArgs});

  QtCommand copy({
    int? id,
    String? projectName,
    String? itemName,
    String? pathInput,
    String? pathOutput,
    String? cmdExtraArgs,}) =>
      QtCommand(
          id: id ?? this.id,
          projectName: projectName ?? this.projectName,
          itemName: itemName ?? this.itemName,
          pathInput: pathInput ?? this.pathInput,
          pathOutput: pathOutput ?? this.pathOutput,
          cmdExtraArgs: cmdExtraArgs ?? this.cmdExtraArgs);

  Map<String, dynamic> toMap() =>
    {
      'id': id,
      'projectName': projectName,
      'itemName': itemName,
      'pathInput': pathInput,
      'pathOutput': pathOutput,
      'extraArgs': cmdExtraArgs,
    };

  static QtCommand fromMap(Map<String, dynamic> map) =>
      QtCommand(
        id: map[QtCmdFields.id] as int?,
        projectName: map[QtCmdFields.projectName] as String,
        itemName: map[QtCmdFields.itemName] as String,
        pathInput: map[QtCmdFields.pathInput] as String,
        pathOutput: map[QtCmdFields.pathOutput] as String,
        cmdExtraArgs: map[QtCmdFields.cmdExtraArgs] as String);

  @override
  String toString() {
    bool inputExits = pathInput.isNotEmpty;
    bool outputExits = pathOutput.isNotEmpty;
    return 'QtCommand{id: $id, projectName: $projectName, itemName: $itemName, cmdExtraArgs: $cmdExtraArgs, pathInput: $inputExits, pathOutput: $outputExits}';
  }
}