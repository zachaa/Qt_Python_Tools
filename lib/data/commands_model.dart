import 'dart:ui';

// table names
const String tableUic = 'uic';
const String tableRcc = 'rcc';
const String tableLUpdate = 'lupdate';
const String tableLRelease = 'lrelease';

class QtCmdFields {
  static final List<String> values = [
    id, projectName, itemName, pathInput, pathOutput, cmdOptions
  ];

  static const String id = '_id';
  static const String projectName = 'projectName';
  static const String itemName = 'itemName';
  static const String pathInput = 'pathInput';
  static const String pathOutput = 'pathOutput';
  static const String cmdOptions = 'cmdOptions';
  static const String cmdPyQtOptions = 'cmdPyQtOptions';
  static const String cmdPySideOptions = 'cmdPySideOptions';
}


/// Class for holding Qt Commands that need to be loaded from a local database
class QtCommand {
  final int? id;
  final String projectName;
  final String itemName;
  final String pathInput;
  final String pathOutput;
  final String cmdOptions;
  final String cmdPyQtOptions;
  final String cmdPySideOptions;

  const QtCommand({
    this.id,
    required this.projectName,
    required this.itemName,
    required this.pathInput,
    required this.pathOutput,
    required this.cmdOptions,
    required this.cmdPyQtOptions,
    required this.cmdPySideOptions});

  QtCommand copy({
    int? id,
    String? projectName,
    String? itemName,
    String? pathInput,
    String? pathOutput,
    String? cmdOptions,
    String? cmdPyQtOptions,
    String? cmdPySideOptions}) =>
      QtCommand(
          id: id ?? this.id,
          projectName: projectName ?? this.projectName,
          itemName: itemName ?? this.itemName,
          pathInput: pathInput ?? this.pathInput,
          pathOutput: pathOutput ?? this.pathOutput,
          cmdOptions: cmdOptions ?? this.cmdOptions,
          cmdPyQtOptions: cmdPyQtOptions ?? this.cmdPyQtOptions,
          cmdPySideOptions: cmdPySideOptions ?? this.cmdPySideOptions);

  Map<String, dynamic> toMap() =>
    {
      '_id': id,
      'projectName': projectName,
      'itemName': itemName,
      'pathInput': pathInput,
      'pathOutput': pathOutput,
      'cmdOptions': cmdOptions,
      'cmdPyQtOptions': cmdPyQtOptions,
      'cmdPySideOptions': cmdPySideOptions
    };

  static QtCommand fromMap(Map<String, dynamic> map) =>
      QtCommand(
        id: map[QtCmdFields.id] as int?,
        projectName: map[QtCmdFields.projectName] as String,
        itemName: map[QtCmdFields.itemName] as String,
        pathInput: map[QtCmdFields.pathInput] as String,
        pathOutput: map[QtCmdFields.pathOutput] as String,
        cmdOptions: map[QtCmdFields.cmdOptions] ?? '', // Even though they are supposed to be NOT NULL, they may be null
        cmdPyQtOptions: map[QtCmdFields.cmdPyQtOptions] ?? '',
        cmdPySideOptions: map[QtCmdFields.cmdPySideOptions] ?? '');

  @override
  String toString() {
    bool inputExits = pathInput.isNotEmpty;
    bool outputExits = pathOutput.isNotEmpty;
    return 'QtCommand{_id: $id, projectName: $projectName, itemName: $itemName,'
    'cmdOptions: $cmdOptions, cmdPyQtOptions: $cmdPyQtOptions, cmdPySideOptions: $cmdPySideOptions,'
    'pathInput: $inputExits, pathOutput: $outputExits}';
  }

  @override
  bool operator ==(Object other) =>
      (other is QtCommand) ?
          (id == other.id &&
          pathInput == other.pathInput &&
          pathOutput == other.pathOutput &&
          projectName == other.projectName &&
          itemName == other.itemName &&
          cmdOptions == other.cmdOptions &&
          cmdPyQtOptions == other.cmdPyQtOptions &&
          cmdPySideOptions == other.cmdPySideOptions)
          : false;

  @override
  int get hashCode => hashValues(
      id, pathInput, pathOutput,
      projectName, itemName,
      cmdOptions, cmdPyQtOptions, cmdPySideOptions);
}