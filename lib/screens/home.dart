import 'package:fluent_ui/fluent_ui.dart';
import 'package:qt_python_tools/globals.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart' as sf;
import 'package:syncfusion_flutter_core/theme.dart' as sf_t;

import '/input_checks.dart';
import '/run_process.dart';
import '/theme.dart';
import '/data/command_db.dart';
import '/data/commands_model.dart';
import '/process/command_uic.dart';
import '/process/command_rcc.dart';


class QtCommandDataSource extends sf.DataGridSource {
  QtCommandDataSource({required List<QtCommand> commands}) {
    buildDataGridRows(commands);
  }

  void buildDataGridRows(List<QtCommand> commands) {
    _commands = commands
        .map<sf.DataGridRow>((e) => sf.DataGridRow(cells: [
            sf.DataGridCell<int>(columnName: 'id', value: e.id),
            sf.DataGridCell<String>(
                columnName: 'project_name', value: e.projectName),
            sf.DataGridCell<String>(
                columnName: 'item_name', value: e.itemName),
            sf.DataGridCell<String>(
                columnName: 'cmdOptions', value: e.cmdOptions),
            sf.DataGridCell<String>(
                columnName: 'cmdPyQtOptions', value: e.cmdPyQtOptions),
            sf.DataGridCell<String>(
                columnName: 'cmdPySideOptions', value: e.cmdPySideOptions),
            sf.DataGridCell<String>(
                columnName: 'output_path', value: e.pathOutput),
            sf.DataGridCell<String>(
                columnName: 'input_path', value: e.pathInput),
            ]))
        .toList();
  }

  List<sf.DataGridRow> _commands = [];

  @override
  List<sf.DataGridRow> get rows => _commands;

  @override
  sf.DataGridRowAdapter? buildRow(sf.DataGridRow row) {
    return sf.DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      Container c;
      // Give different widgets for different columns
      switch (dataGridCell.columnName) {
        case 'project_name':
        case 'item_name':
          {
            c = Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 4),
                  child: Tooltip(
                    message: dataGridCell.value.toString(),
                    child:  Text(
                      dataGridCell.value.toString().replaceAll("", "\u{200B}"),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      softWrap: false,
                      style: const TextStyle(
                        fontSize: 12, color: QtToolThemeColors.tableTextColor),
                    )));
          }
          break;
        case 'cmdOptions':
        case 'cmdPyQtOptions':
        case 'cmdPySideOptions':
          {
            c = Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 2),
                  child: Tooltip(
                    message: dataGridCell.value.toString(),
                    child: Text(
                      dataGridCell.value.toString().replaceAll("", "\u{200B}"),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      softWrap: false,
                      style: const TextStyle(
                        fontSize: 12, color: QtToolThemeColors.tableTextColor),
                  )));
          }
          break;
        case 'output_path':
        case 'input_path':
          {
            c = Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 4),
                  // to make ellipsis happen since flutter devs don't care
                  // https://github.com/flutter/flutter/issues/18761
                  child: Tooltip(
                    message: dataGridCell.value.toString(),
                    child: Text(
                      dataGridCell.value.toString().replaceAll("", "\u{200B}"),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      softWrap: false,
                      style: const TextStyle(
                        fontSize: 12, color: QtToolThemeColors.tableTextColor),
                  )));
          }
          break;
        default:
          {
            c = Container(
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 4),
                child: Text(
                  dataGridCell.value.toString(),
                  style: const TextStyle(
                      fontSize: 12, color: QtToolThemeColors.tableTextColor),
                ));
          }
          break;
      }
      return c;
    }).toList());
  }

  /// For updating the data table when a row is deleted.
  /// https://help.syncfusion.com/flutter/datagrid/data-binding
  void updateDataGridSource() {
    notifyListeners();
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _uicDataGridController = sf.DataGridController();
  final _rccDataGridController = sf.DataGridController();
  final _lupdateDataGridController = sf.DataGridController();

  late List<QtCommand> uicCommands = <QtCommand>[];
  late QtCommandDataSource _uicCommandsDataSource;
  late Map<String, double> uicColumnWidths = {
    // for user column resizing
    'id': double.nan,   // should never be visible
    'project_name': double.nan,
    'item_name': double.nan,
    'input_path': double.nan,
    'output_path': double.nan,
    'cmdOptions': double.nan,
    'cmdPyQtOptions': double.nan,
    'cmdPySideOptions': double.nan,
  };

  late List<QtCommand> rccCommands = <QtCommand>[];
  late QtCommandDataSource _rccCommandsDataSource;
  late Map<String, double> rccColumnWidths = {
    // for user column resizing
    'id': double.nan,   // should never be visible
    'project_name': double.nan,
    'item_name': double.nan,
    'input_path': double.nan,
    'output_path': double.nan,
    'cmdOptions': double.nan,
    'cmdPyQtOptions': double.nan,
    'cmdPySideOptions': double.nan,
  };

  late List<QtCommand> lupdateCommands = <QtCommand>[];
  late QtCommandDataSource _lupdateCommandsDataSource;
  late Map<String, double> lupdateColumnWidths = {
    // for user column resizing
    'id': double.nan,   // should never be visible
    'project_name': double.nan,
    'item_name': double.nan,
    'input_path': double.nan,
    'output_path': double.nan,
    'cmdOptions': double.nan,
    'cmdPyQtOptions': double.nan,
    'cmdPySideOptions': double.nan,
  };

  /// --------------------------------------------------
  /// Future Lists (unique for each table) for FutureBuilder
  /// --------------------------------------------------
  Future<List<QtCommand>> getUicCommands() async{
    uicCommands =  await QtCommandDatabase.instance.readAllCommands(tableUic);
    _uicCommandsDataSource = QtCommandDataSource(commands: uicCommands);
    return uicCommands;
  }

  Future<List<QtCommand>> getRccCommands() async{
    rccCommands =  await QtCommandDatabase.instance.readAllCommands(tableRcc);
    _rccCommandsDataSource = QtCommandDataSource(commands: rccCommands);
    return rccCommands;
  }

  Future<List<QtCommand>> getLUpdateCommands() async{
    List<QtCommand> lupdateCommands =  await QtCommandDatabase.instance.readAllCommands(tableLUpdate);
    _lupdateCommandsDataSource = QtCommandDataSource(commands: lupdateCommands);
    return lupdateCommands;
  }

  // https://stackoverflow.com/questions/67063174/how-to-use-initstate-when-using-future-function-and-future-builder-in-flutter
  var uicCommandsForFuture;
  var rccCommandsForFuture;
  var lupdateCommandsForFuture;

  @override
  void initState() {
    // Load Future<List> here to prevent loading each time on table resize
    // since table data does not change
    // TODO what happens if item is deleted though?
    uicCommandsForFuture = getUicCommands();
    rccCommandsForFuture = getRccCommands();
    lupdateCommandsForFuture = getLUpdateCommands();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
        header: const PageHeader(title: Text('Home')),
        content: Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 6, 0),
            child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(  // prevent scroller overlap
                    padding: const EdgeInsets.fromLTRB(0, 0, 12, 0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // giveFutureBuilderTable(
                          //     uicCommandsFinal,
                          //     'Uic',
                          //     uicCommands,
                          //     _uicCommandsDataSource,
                          //     _uicDataGridController,
                          //     uicColumnWidths,
                          //     runExistingUic,
                          //     deleteExistingUic,
                          //     QtToolThemeColors.uicColor),
                          FutureBuilder( // Database may not have loaded yet
                              future: uicCommandsForFuture,
                              builder: (context, data) {
                                return data.connectionState != ConnectionState.done
                                  ? const Center(child: ProgressRing(
                                      activeColor: QtToolThemeColors.uicColor))
                                  : data.hasError
                                    ? Text(data.error.toString())
                                    : data.hasData
                                      ? uicCommands.isEmpty
                                        ? const Center(
                                            child: Text('No Uic Commands',
                                            style: TextStyle(fontSize: 20)))
                                        : Column(
                                          children: [
                                            ConstrainedBox(
                                              constraints: const BoxConstraints(
                                                  minHeight: 60, maxHeight: 140),
                                              child:
                                                  giveSfCommandDataTable(
                                                      _uicCommandsDataSource,
                                                      _uicDataGridController,
                                                      uicColumnWidths,
                                                      QtToolThemeColors.uicColor),
                                            ),
                                            const SizedBox(height: 10),
                                            giveTableButtonsRow('Uic',
                                                runExistingUic,
                                                deleteExistingUic,
                                                QtToolThemeColors.uicColor),
                                          ])
                                      : const Text('No Data, Should not see');
                              }),
                          const SizedBox(height: 20),
                          // giveFutureBuilderTable(
                          //     getRccCommands(),
                          //     'Rcc',
                          //     rccCommands,
                          //     _rccCommandsDataSource,
                          //     _rccDataGridController,
                          //     rccColumnWidths,
                          //     runExistingRcc,
                          //     deleteExistingRcc,
                          //     QtToolThemeColors.rccColor),
                          FutureBuilder( // Database may not have loaded yet
                              future: rccCommandsForFuture,
                              builder: (context, data) {
                                return data.connectionState != ConnectionState.done
                                  ? const Center(child: ProgressRing(
                                      activeColor: QtToolThemeColors.rccColor))
                                  : data.hasError
                                    ? Text(data.error.toString())
                                    : data.hasData
                                      ? rccCommands.isEmpty
                                        ? const Center(
                                            child: Text('No Rcc Commands',
                                            style: TextStyle(fontSize: 20)))
                                        : Column(
                                          children: [
                                            ConstrainedBox(
                                              constraints: const BoxConstraints(
                                                  minHeight: 60, maxHeight: 140),
                                              child:
                                                  giveSfCommandDataTable(
                                                      _rccCommandsDataSource,
                                                      _rccDataGridController,
                                                      rccColumnWidths,
                                                      QtToolThemeColors.rccColor),
                                            ),
                                            const SizedBox(height: 10),
                                            giveTableButtonsRow('Rcc',
                                                runExistingRcc,
                                                deleteExistingRcc,
                                                QtToolThemeColors.rccColor),
                                          ])
                                      : const Text('No Data, Should not see');
                              }),
                          const SizedBox(height: 20),
                          // giveFutureBuilderTable(
                          //     getLUpdateCommands(),
                          //     'LUpdate',
                          //     lupdateCommands,
                          //     _lupdateCommandsDataSource,
                          //     _lupdateDataGridController,
                          //     lupdateColumnWidths,
                          //     runExistingLUpdate,
                          //     deleteExistingLUpdate,
                          //     QtToolThemeColors.lupdateColor),
                          FutureBuilder( // Database may not have loaded yet
                              future: lupdateCommandsForFuture,
                              builder: (context, data) {
                                return data.connectionState != ConnectionState.done
                                  ? const Center(child: ProgressRing(
                                      activeColor: QtToolThemeColors.lupdateColor))
                                  : data.hasError
                                    ? Text(data.error.toString())
                                    : data.hasData
                                      ? lupdateCommands.isEmpty
                                        ? const Center(
                                            child: Text('No LUpdate Commands',
                                            style: TextStyle(fontSize: 20)))
                                        : Column(
                                          children: [
                                            ConstrainedBox(
                                              constraints: const BoxConstraints(
                                                  minHeight: 40, maxHeight: 140),
                                              child:
                                                  giveSfCommandDataTable(
                                                      _lupdateCommandsDataSource,
                                                      _lupdateDataGridController,
                                                      lupdateColumnWidths,
                                                      QtToolThemeColors.lupdateColor),
                                            ),
                                            const SizedBox(height: 10),
                                            giveTableButtonsRow('Lupdate',
                                                runExistingLUpdate,
                                                deleteExistingLUpdate,
                                                QtToolThemeColors.lupdateColor),
                                          ])
                                      : const Text('No Data, Should not see');
                              }),
                        ],
                    ),
                )),
        ));
  }

  /// Gives a DataTable displaying the data from the given [dataSource].
  /// The [dataController] is used to get the selected row.
  /// Adjustable columns with [columnWidthsMap] and the color of the table
  /// is determined by [primaryColor] which is faded for the
  /// selected row and hovered row.
  SingleChildScrollView giveSfCommandDataTable(
      sf.DataGridSource dataSource,
      sf.DataGridController dataController,
      Map<String, double> columnWidthsMap,
      Color primaryColor) {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding( // prevent scroller overlap
            padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: sf_t.SfDataGridTheme(
                data: sf_t.SfDataGridThemeData(
                  headerColor: primaryColor,
                  rowHoverColor: primaryColor.withOpacity(0.2),
                  selectionColor: primaryColor.withOpacity(0.6),
                  rowHoverTextStyle: const TextStyle(fontSize: 12),
                  gridLineColor: QtToolThemeColors.tableGridLineColor,
                  sortIconColor: QtToolThemeColors.tableTextColor,
                ),
                child: sf.SfDataGrid(
                  source: dataSource,
                  controller: dataController,
                  selectionMode: sf.SelectionMode.single,
                  navigationMode: sf.GridNavigationMode.row,
                  rowHeight: 20,
                  headerRowHeight: 22,
                  gridLinesVisibility: sf.GridLinesVisibility.vertical,
                  allowColumnsResizing: true,
                  allowSorting: true,
                  allowMultiColumnSorting: true,
                  shrinkWrapRows: true,  // get rid of extra space below table
                  onColumnResizeUpdate: (sf.ColumnResizeUpdateDetails details) {
                    setState(() {
                      columnWidthsMap[details.column.columnName] =
                          details.width;
                    });
                    return true;
                  },
                  columns: <sf.GridColumn>[
                    giveSfGridColumn('id', 'Id', columnWidthsMap,  // INVISIBLE
                        15, 30, sf.ColumnWidthMode.auto, true, visible: false),
                    giveSfGridColumn('project_name', 'Project', columnWidthsMap,
                        50, 90, sf.ColumnWidthMode.fitByCellValue, true),
                    giveSfGridColumn('item_name', 'Name', columnWidthsMap,
                        80, 180, sf.ColumnWidthMode.fitByCellValue, true),
                    giveSfGridColumn('cmdOptions', 'Options', columnWidthsMap,
                        50, 200, sf.ColumnWidthMode.fitByColumnName, false),
                    giveSfGridColumn('cmdPyQtOptions', 'PyQt Opt',
                        columnWidthsMap, 50, 200,
                        sf.ColumnWidthMode.fitByColumnName, false),
                    giveSfGridColumn('cmdPySideOptions', 'PySide Opt',
                        columnWidthsMap, 50, 200,
                        sf.ColumnWidthMode.fitByColumnName, false),
                    giveSfGridColumn('output_path', 'Output Path',
                        columnWidthsMap, 100, double.nan,
                        sf.ColumnWidthMode.fitByColumnName, true, visible: true),
                    giveSfGridColumn('input_path', 'Input Path',
                        columnWidthsMap, 100, double.nan,
                        sf.ColumnWidthMode.lastColumnFill, true),
                  ],
                )),
        ));
  }

  /// Give the grid columns used in all the tables
  ///
  /// - [colName] = identifier
  /// - [colTitle] = Displayed title string
  /// - [columnWidthsMap] = map with [colName] and double.nan for each column
  /// - [minWidth] & [maxWidth] = min and max column width, use double.nan for any
  /// - [widthMode] = sf.ColumnWidthMode
  sf.GridColumn giveSfGridColumn(String colName, String colTitle,
      Map<String, double> columnWidthsMap, double minWidth, double maxWidth,
      sf.ColumnWidthMode widthMode, bool allowSort, {bool visible = true}) {
    return sf.GridColumn(
      columnName: colName,
      width: columnWidthsMap[colName]!,
      autoFitPadding: const EdgeInsets.all(1),
      allowSorting: allowSort,
      columnWidthMode: widthMode,
      minimumWidth: minWidth,
      maximumWidth: maxWidth,
      visible: visible,
      label: Container(
        padding: const EdgeInsets.all(2.0),
        alignment: Alignment.center,
        child: Text(colTitle,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: QtToolThemeColors.tableTextColor)),
      ),
    );
  }

  /// Gives a row with 2 buttons for running and deleting commands for the table
  ///
  /// Each button displays text with [name] in it. The left button
  /// uses [runFunction] and the right button uses [deleteFunction].
  /// The run button is accented with [color].
  Row giveTableButtonsRow(
      String name,
      VoidCallback runFunction,
      VoidCallback deleteFunction,
      Color color) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
            Mica(
              backgroundColor: color.withOpacity(0.8),
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              child: Padding(padding: const EdgeInsets.all(1),
                  child: Button(
                      onPressed: runFunction,
                      child: Text('Run $name Command')),
              )),
            const SizedBox(width: 10),
            Mica(
              backgroundColor: QtToolThemeColors.deleteColor.withOpacity(0.8),
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              child: Padding(padding: const EdgeInsets.all(1),
                  child: Button(
                      onPressed: deleteFunction,
                      child: Text('Delete $name Command')),
              )),
    ]);
  }

  /// The main widget for each table of commands.
  ///
  /// Returns a FutureBuilder with with [futureFunction] giving [commandsList]
  /// that is used in [dataSource]. Selected row is determined from
  /// [dataController]. Table widths are user adjustable with [columnWidths].
  /// Two buttons are below the table (if data exists) that connect to
  /// [runFunction] and [deleteFunction]. [name] and [color] tells user
  /// what table it is.
  ///
  /// While data is loading a spinner is displayed.
  /// If no data is found a message is show in place of the table.
  FutureBuilder giveFutureBuilderTable(
      Future<dynamic> futureFunction,
      String name,
      List<QtCommand> commandsList,
      QtCommandDataSource dataSource,
      sf.DataGridController dataController,
      Map<String, double> columnWidths,
      VoidCallback runFunction,
      VoidCallback deleteFunction,
      Color color) {
    return FutureBuilder(
        future: futureFunction,
        builder: (context, data) {
          return data.connectionState != ConnectionState.done
            ? Center(child: ProgressRing(activeColor: color))
            : data.hasError
                ? Text(data.error.toString())
                : data.hasData
                  ? commandsList.isEmpty //|| _uicCommandsDataSource == null
                      ? Center(
                          child: Text('No $name Commands',
                          style: const TextStyle(fontSize: 20)))
                      : Column(
                          children: [
                            ConstrainedBox(
                              constraints: const BoxConstraints(
                                  minHeight: 60, maxHeight: 140),
                              child:
                                  giveSfCommandDataTable(
                                      dataSource,
                                      dataController,
                                      columnWidths,
                                      color),
                            ),
                            const SizedBox(height: 10),
                            giveTableButtonsRow(name,
                                runFunction,
                                deleteFunction,
                                color),
                          ])
                  : const Text('No Data, Should not see');
        });
  }

  /// Checks to see if the command to be run is valid
  /// (in case input has been deleted or Qt Python path is invalid).
  ///
  /// [qtTool] should be 'uic' 'rcc' 'lupdate' or 'lrelease'
  bool _runCommandCheck(String inputPath, int qtImplementation, String qtTool) {
    if (!checkInputFilePathExist(inputPath, context)) {return false;}
    if (!checkQtImplementationDirectory(qtImplementation, context)) {return false;}
    if (!checkIfValidTool(qtImplementation, qtTool, context)) {return false;}
    return true;
  }

  /// Run the selected command for UIC
  void runExistingUic() async {
    sf.DataGridRow? selectedRow = _uicDataGridController.selectedRow;
    if (selectedRow == null) {return;}
    // Have to get around sorting index vs index in uicCommands list.
    int dbId = selectedRow.getCells()[0].value;   // get _id from invisible cell
    // Get command directly from database
    QtCommand currentCommand = await QtCommandDatabase.instance.readCommand(dbId, 'uic');

    // This only works without sorting.
    // int index = _uicDataGridController.selectedIndex;
    // if (index == -1) {return;}
    // QtCommand currentCommand = uicCommands[index];
    if (!_runCommandCheck(
        currentCommand.pathInput,
        selectedQtImplementation,
        'uic')) {
      return;}
    CommandUIC command = CommandUIC.fromQtCommand(currentCommand);
    runCommandProcess(command, 'uic',
        selectedQtImplementation,
        'Running UIC',
        QtToolThemeColors.uicColor, context);
  }

  /// Run the selected command for RCC
  void runExistingRcc() async {
    sf.DataGridRow? selectedRow = _rccDataGridController.selectedRow;
    if (selectedRow == null) {return;}
    // Have to get around sorting index vs index in rccCommands list.
    int dbId = selectedRow.getCells()[0].value;   // get _id from invisible cell
    // Get command directly from database
    QtCommand currentCommand = await QtCommandDatabase.instance.readCommand(dbId, 'rcc');

    if (!_runCommandCheck(
        currentCommand.pathInput,
        selectedQtImplementation,
        'rcc')) {
      return;}
    CommandRCC command = CommandRCC.fromQtCommand(currentCommand);
    runCommandProcess(command, 'rcc',
        selectedQtImplementation,
        'Running RCC',
        QtToolThemeColors.rccColor, context);
  }

  void runExistingLUpdate() {
    print('run existing lupdate command');
  }

  /// Deletes the selected row and recreates the list containing the commands.
  ///
  /// There is probably a better way rather than rereading the database
  /// Since the item is deleted from the database directly, maybe deleting
  /// the item from the list directly is also good?
  /// Due to sorting, we need to directly get the id and delete from the DB.
  void deleteExistingUic() async{
    sf.DataGridRow? selectedRow = _uicDataGridController.selectedRow;
    if (selectedRow == null) {return;}

    // Have to get around sorting index not necessarily being actual index
    int dbId = selectedRow.getCells()[0].value;   // get _id from invisible cell
    await QtCommandDatabase.instance.deleteQtCommand(dbId, 'uic');
    uicCommands = await QtCommandDatabase.instance.readAllCommands(tableUic);
    _uicCommandsDataSource.buildDataGridRows(uicCommands);
    _uicCommandsDataSource.updateDataGridSource();
    //int index = _uicDataGridController.selectedIndex;
    //String itemName = selectedRow.getCells()[2].value.toString();
    //print('deleted uic _id=$dbId name=$itemName at index=$index');
  }

  /// Deletes the selected row and recreates the list containing the commands.
  void deleteExistingRcc() async {
    sf.DataGridRow? selectedRow = _rccDataGridController.selectedRow;
    if (selectedRow == null) {return;}

    // Have to get around sorting index not necessarily being actual index
    int dbId = selectedRow.getCells()[0].value;   // get _id from invisible cell
    await QtCommandDatabase.instance.deleteQtCommand(dbId, 'rcc');
    rccCommands = await QtCommandDatabase.instance.readAllCommands(tableRcc);
    _rccCommandsDataSource.buildDataGridRows(rccCommands);
    _rccCommandsDataSource.updateDataGridSource();
    //int index = _rccDataGridController.selectedIndex;
    //String itemName = selectedRow.getCells()[2].value.toString();
    //print('deleted rcc _id=$dbId name=$itemName at index=$index');
  }

  /// Deletes the selected row and recreates the list containing the commands.
  void deleteExistingLUpdate() async {
    sf.DataGridRow? selectedRow = _lupdateDataGridController.selectedRow;
    if (selectedRow == null) {return;}

    // Have to get around sorting index not necessarily being actual index
    int dbId = selectedRow.getCells()[0].value;   // get _id from invisible cell
    await QtCommandDatabase.instance.deleteQtCommand(dbId, 'lupdate');
    lupdateCommands = await QtCommandDatabase.instance.readAllCommands(tableLUpdate);
    _lupdateCommandsDataSource.buildDataGridRows(lupdateCommands);
    _lupdateCommandsDataSource.updateDataGridSource();
    //int index = _lupdateDataGridController.selectedIndex;
    //String itemName = selectedRow.getCells()[2].value.toString();
    //print('deleted lupdate _id=$dbId name=$itemName at index=$index');
  }
}
