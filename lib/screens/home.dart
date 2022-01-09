import 'package:fluent_ui/fluent_ui.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart' as sf;
import 'package:syncfusion_flutter_core/theme.dart' as sf;

import '/theme.dart';
import '/data/command_db.dart';
import '/data/commands_model.dart';


class QtCommandDataSource extends sf.DataGridSource {
  QtCommandDataSource({required List<QtCommand> commands}) {
    _commands = commands
        .map<sf.DataGridRow>((e) => sf.DataGridRow(cells: [
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
                child: Text(
                  dataGridCell.value.toString().replaceAll("", "\u{200B}"),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  softWrap: false,
                  style: const TextStyle(
                      fontSize: 12, color: QtToolThemeColors.tableTextColor),
                ));
          }
          break;
        case 'cmdOptions':
        case 'cmdPyQtOptions':
        case 'cmdPySideOptions':
          {
            c = Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 2),
                child: Text(
                  dataGridCell.value.toString().replaceAll("", "\u{200B}"),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  softWrap: false,
                  style: const TextStyle(
                      fontSize: 12, color: QtToolThemeColors.tableTextColor),
                ));
          }
          break;
        case 'input_path':
          {
            c = Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 4),
                // to make ellipsis happen since flutter devs don't care
                // https://github.com/flutter/flutter/issues/18761
                child: Text(
                  dataGridCell.value.toString().replaceAll("", "\u{200B}"),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  softWrap: false,
                  style: const TextStyle(
                      fontSize: 12, color: QtToolThemeColors.tableTextColor),
                ));
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
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<QtCommand> uicCommands = <QtCommand>[];
  late QtCommandDataSource _uicCommandsDataSource;
  late Map<String, double> uicColumnWidths = {
    // for user column resizing
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
  Future<List> getUicCommands() async{
    await Future.delayed(const Duration(seconds: 1)); // TODO remove test
    uicCommands =  await QtCommandDatabase.instance.readAllCommands(tableUic);
    _uicCommandsDataSource = QtCommandDataSource(commands: uicCommands);
    return uicCommands;
  }

  Future<List> getRccCommands() async{
    await Future.delayed(const Duration(seconds: 2));
    rccCommands =  await QtCommandDatabase.instance.readAllCommands(tableRcc);
    _rccCommandsDataSource = QtCommandDataSource(commands: rccCommands);
    return rccCommands;
  }

  Future<List> getLUpdateCommands() async{
    await Future.delayed(const Duration(seconds: 3));
    List<QtCommand> lupdateCommands =  await QtCommandDatabase.instance.readAllCommands(tableLUpdate);
    _lupdateCommandsDataSource = QtCommandDataSource(commands: lupdateCommands);
    return lupdateCommands;
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
                          FutureBuilder( // Database may not have loaded yet
                              future: getUicCommands(),
                              builder: (context, data) {
                                return data.hasData
                                    ? uicCommands.isEmpty
                                      ? const Center(
                                          child: Text('No Uic Commands',
                                          style: TextStyle(fontSize: 20)))
                                      : ConstrainedBox(
                                            constraints: const BoxConstraints(
                                                minHeight: 80, maxHeight: 140),
                                            child: giveSfCommandDataTable(
                                                _uicCommandsDataSource,
                                                uicColumnWidths,
                                                QtToolThemeColors.uicColor))
                                    : const Center(
                                        child: ProgressRing(
                                          activeColor: QtToolThemeColors.uicColor,));
                              }),
                          Button(
                              child: const Text('Run Uic'),
                              onPressed: runExistingUic),
                          const SizedBox(height: 10),
                          FutureBuilder( // Database may not have loaded yet
                              future: getRccCommands(),
                              builder: (context, data) {
                                return data.hasData
                                    ? rccCommands.isEmpty
                                    ? const Center(
                                    child: Text('No Rcc Commands',
                                        style: TextStyle(fontSize: 20)))
                                    : ConstrainedBox(
                                    constraints: const BoxConstraints(
                                        minHeight: 80, maxHeight: 140),
                                    child: giveSfCommandDataTable(
                                        _rccCommandsDataSource,
                                        rccColumnWidths,
                                        QtToolThemeColors.rccColor))
                                    : const Center(
                                    child: ProgressRing(
                                      activeColor: QtToolThemeColors.rccColor,));
                              }),
                          Button(
                              child: const Text('Run Rcc'),
                              onPressed: runExistingRcc),
                          const SizedBox(height: 10),
                          FutureBuilder( // Database may not have loaded yet
                              future: getLUpdateCommands(),
                              builder: (context, data) {
                                return data.hasData
                                    ? lupdateCommands.isEmpty
                                    ? const Center(
                                    child: Text('No LUpdate Commands',
                                        style: TextStyle(fontSize: 20)))
                                    : ConstrainedBox(
                                    constraints: const BoxConstraints(
                                        minHeight: 80, maxHeight: 140),
                                    child: giveSfCommandDataTable(
                                        _lupdateCommandsDataSource,
                                        lupdateColumnWidths,
                                        QtToolThemeColors.lupdateColor))
                                    : const Center(
                                    child: ProgressRing(
                                        activeColor: QtToolThemeColors.lupdateColor));
                              }),
                          Button(
                              child: const Text('Run LUpdate'),
                              onPressed: runExistingLUpdate),
                        ],
                    ),
                )),
        ));
  }

  /// Gives a DataTable displaying the data from the given dataSource
  SingleChildScrollView giveSfCommandDataTable(sf.DataGridSource dataSource,
      Map<String, double> columnWidthsMap, Color primaryColor) {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
            padding: const EdgeInsets.fromLTRB(
                0, 0, 10, 0), // so scroller does not overlap
            child: sf.SfDataGridTheme(
                data: sf.SfDataGridThemeData(
                  headerColor: primaryColor,
                  rowHoverColor: primaryColor.withOpacity(0.4),
                  selectionColor: primaryColor.withOpacity(0.8),
                  rowHoverTextStyle: const TextStyle(fontSize: 12),
                  gridLineColor: QtToolThemeColors.tableGridLineColor,
                ),
                child: sf.SfDataGrid(
                  source: dataSource,
                  selectionMode: sf.SelectionMode.single,
                  navigationMode: sf.GridNavigationMode.row,
                  rowHeight: 20,
                  headerRowHeight: 22,
                  gridLinesVisibility: sf.GridLinesVisibility.vertical,
                  allowColumnsResizing: true,
                  onColumnResizeUpdate: (sf.ColumnResizeUpdateDetails details) {
                    setState(() {
                      columnWidthsMap[details.column.columnName] =
                          details.width;
                    });
                    return true;
                  },
                  columns: <sf.GridColumn>[
                    giveSfGridColumn('project_name', 'Project', columnWidthsMap,
                        50, 90, sf.ColumnWidthMode.fitByCellValue),
                    giveSfGridColumn('item_name', 'Name', columnWidthsMap, 80,
                        180, sf.ColumnWidthMode.fitByCellValue),
                    giveSfGridColumn('cmdOptions', 'Extra Opt', columnWidthsMap,
                        50, 120, sf.ColumnWidthMode.fitByColumnName),
                    giveSfGridColumn(
                        'cmdPyQtOptions',
                        'PyQt Opt',
                        columnWidthsMap,
                        50,
                        120,
                        sf.ColumnWidthMode.fitByColumnName),
                    giveSfGridColumn(
                        'cmdPySideOptions',
                        'PySide Opt',
                        columnWidthsMap,
                        50,
                        120,
                        sf.ColumnWidthMode.fitByColumnName),
                    giveSfGridColumn(
                        'input_path',
                        'Input Path',
                        columnWidthsMap,
                        100,
                        double.nan,
                        sf.ColumnWidthMode.lastColumnFill),
                  ],
                )),
        ));
  }

  /// Give the grid columns used in all the tables
  sf.GridColumn giveSfGridColumn(
      String colName,
      String colTitle,
      Map<String, double> columnWidthsMap,
      double minWidth,
      double maxWidth,
      sf.ColumnWidthMode widthMode) {
    return sf.GridColumn(
      columnName: colName,
      width: columnWidthsMap[colName]!,
      autoFitPadding: const EdgeInsets.all(3),
      columnWidthMode: widthMode,
      minimumWidth: minWidth,
      maximumWidth: maxWidth,
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

  void runExistingUic() {
    print('run existing uic command');
  }

  void runExistingRcc() {
    print('run existing rcc command');
  }

  void runExistingLUpdate() {
    print('run existing lupdate command');
  }
}
