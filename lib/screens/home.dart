import 'package:fluent_ui/fluent_ui.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart' as sf;
import 'package:syncfusion_flutter_core/theme.dart' as sf;
import '/theme.dart';
import '/command_db.dart';
import '/commands_model.dart';


/// This should come from some external source
List<QtCommand> getQtCommands() {
  return <QtCommand>[
    const QtCommand(
        id: 1,
        projectName: "Amtz2",
        itemName: "ui_Settings",
        pathInput:
            r"C:\Users\Zachary\PycharmProjects\Amortization-V2\dark_planet\gui\core_widgets\ui\ui_settings.ui",
        pathOutput:
            r"C:\Users\Zachary\PycharmProjects\Amortization-V2\dark_planet\gui\core_widgets\ui\ui_settings.py",
        cmdExtraArgs: "-x"),
    const QtCommand(
        id: 2,
        projectName: "Amtz2",
        itemName: "ui_main_page",
        pathInput:
            r"C:\Users\Zachary\PycharmProjects\Amortization-V2\dark_planet\gui\core_widgets\ui\data_table_widget.ui",
        pathOutput:
            r"C:\Users\Zachary\PycharmProjects\Amortization-V2\dark_planet\gui\core_widgets\ui\ui_settings.py",
        cmdExtraArgs: "-x"),
    const QtCommand(
        id: 3,
        projectName: "Amtz2",
        itemName: "ui_dates",
        pathInput:
            r"C:\Users\Zachary\PycharmProjects\Amortization-V2\dark_planet\gui\core_widgets\ui\data_table_widget.ui",
        pathOutput:
            r"C:\Users\Zachary\PycharmProjects\Amortization-V2\dark_planet\gui\core_widgets\ui\ui_settings.py",
        cmdExtraArgs: "-x"),
    const QtCommand(
        id: 4,
        projectName: "Amtz2",
        itemName: "ui_combo_widget_box",
        pathInput:
            r"C:\Users\Zachary\PycharmProjects\Amortization-V2\dark_planet\gui\core_widgets\ui\data_table_widget.ui",
        pathOutput:
            r"C:\Users\Zachary\PycharmProjects\Amortization-V2\dark_planet\gui\core_widgets\ui\ui_settings.py",
        cmdExtraArgs: "-x"),
    const QtCommand(
        id: 5,
        projectName: "Amtz2",
        itemName: "ui_table",
        pathInput:
            r"C:\Users\Zachary\PycharmProjects\Amortization-V2\dark_planet\gui\core_widgets\ui\data_table_widget.ui",
        pathOutput:
            r"C:\Users\Zachary\PycharmProjects\Amortization-V2\dark_planet\gui\core_widgets\ui\ui_settings.py",
        cmdExtraArgs: "-x"),
  ];
}

class QtCommandDataSource extends sf.DataGridSource {
  QtCommandDataSource({required List<QtCommand> commands}) {
    _commands = commands
        .map<sf.DataGridRow>((e) => sf.DataGridRow(cells: [
              sf.DataGridCell<String>(columnName: 'project_name', value: e.projectName),
              sf.DataGridCell<String>(columnName: 'item_name', value: e.itemName),
              sf.DataGridCell<String>(
                  columnName: 'extra_args', value: e.cmdExtraArgs),
              sf.DataGridCell<String>(
                  columnName: 'input_path', value: e.pathInput),
            ])
        ).toList();
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
        case 'item_name': {
            c = Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 4),
                child: Text(
                  dataGridCell.value.toString().replaceAll("", "\u{200B}"),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  softWrap: false,
                  style: const TextStyle(
                      fontSize: 12,
                      color: QtToolThemeColors.tableTextColor),
                ));
          }
          break;
        case 'extra_args': {
            c = Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 2),
                child: Text(
                  dataGridCell.value.toString().replaceAll("", "\u{200B}"),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  softWrap: false,
                  style: const TextStyle(
                      fontSize: 12,
                      color: QtToolThemeColors.tableTextColor),
                ));
          }
          break;
        case 'input_path': {
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
                      fontSize: 12,
                      color: QtToolThemeColors.tableTextColor),
                ));
          }
          break;
        default: {
            c = Container(
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 4),
                child: Text(
                  dataGridCell.value.toString(),
                  style: const TextStyle(
                      fontSize: 12,
                      color: QtToolThemeColors.tableTextColor),
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
  List<QtCommand> uicCommands = <QtCommand>[];
  late QtCommandDataSource _uicCommandsDataSource;
  late Map<String, double> uicColumnWidths = {
    // for user column resizing
    'project_name': double.nan,
    'item_name': double.nan,
    'input_path': double.nan,
    'output_path': double.nan,
    'extra_args': double.nan,
  };

  List<QtCommand> rccCommands = <QtCommand>[];
  late QtCommandDataSource _rccCommandsDataSource;
  late Map<String, double> rccColumnWidths = {
    // for user column resizing
    'project_name': double.nan,
    'item_name': double.nan,
    'input_path': double.nan,
    'output_path': double.nan,
    'extra_args': double.nan,
  };

  @override
  void initState() {
    uicCommands = getQtCommands();
    _uicCommandsDataSource = QtCommandDataSource(commands: uicCommands);
    rccCommands = getQtCommands();
    _rccCommandsDataSource = QtCommandDataSource(commands: rccCommands);
    super.initState();
    // refreshTables();
  }

  // Future refreshTables() async {
  //   this.uicCommands = QtCommandDatabase.instance.readAllCommands(tableUic)
  //   _uicCommandsDataSource = QtCommandDataSource(commands: uicCommands);
  //   rccCommands = getQtCommands();
  //   _rccCommandsDataSource = QtCommandDataSource(commands: rccCommands);
  // }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
        header: const PageHeader(title: Text('Home')),
        content: Padding(
            padding: const EdgeInsets.fromLTRB(14, 8, 6, 8),
            child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 12, 0), // prevent scroller overlap
                  child:Column(
                    //mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ConstrainedBox(
                          constraints: const BoxConstraints(minHeight: 80, maxHeight: 140),
                          child: giveSfCommandDataTable(
                              _uicCommandsDataSource,
                              uicColumnWidths,
                              QtToolThemeColors.uicColor)),
                      Button(child: const Text('Run Uic'), onPressed: runExistingUic),
                      const SizedBox(height: 10),
                      ConstrainedBox(
                          constraints: const BoxConstraints(minHeight: 80, maxHeight: 140),
                          child:giveSfCommandDataTable(
                              _rccCommandsDataSource,
                              rccColumnWidths,
                              QtToolThemeColors.rccColor)),
                      Button(child: const Text('Run Rcc'), onPressed: runExistingRcc),
                      const SizedBox(height: 10),
                    ]
                  )
                )
            )
        ));
  }

  /// Gives a DataTable displaying the data from the given dataSource
  SingleChildScrollView giveSfCommandDataTable(sf.DataGridSource dataSource,
                                               Map<String, double> columnWidthsMap,
                                               Color primaryColor) {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),  // so scroller does not overlap
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
                  columnWidthsMap[details.column.columnName] = details.width;
                });
                return true;
              },
              columns: <sf.GridColumn>[
                sf.GridColumn(
                    columnName: 'project_name',
                    width: columnWidthsMap['project_name']!,
                    columnWidthMode: sf.ColumnWidthMode.fitByCellValue,
                    minimumWidth: 50,
                    maximumWidth: 90,
                    label: Container(
                      padding: const EdgeInsets.all(2.0),
                      alignment: Alignment.center,
                      child: const Text('Project',
                          style: TextStyle(fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: QtToolThemeColors.tableTextColor)),
                    )),
                sf.GridColumn(
                    columnName: 'item_name',
                    width: columnWidthsMap['item_name']!,
                    columnWidthMode: sf.ColumnWidthMode.fitByCellValue,
                    minimumWidth: 80,
                    maximumWidth: 180,
                    label: Container(
                        padding: const EdgeInsets.all(2.0),
                        alignment: Alignment.center,
                        child: const Text('Name',
                            style: TextStyle(fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: QtToolThemeColors.tableTextColor)),
                    )),
                sf.GridColumn(
                    columnName: 'extra_args',
                    width: columnWidthsMap['extra_args']!,
                    columnWidthMode: sf.ColumnWidthMode.fitByColumnName,
                    minimumWidth: 70,
                    maximumWidth: 150,
                    label: Container(
                        padding: const EdgeInsets.all(2.0),
                        alignment: Alignment.center,
                        child: const Text('Extra Args',
                            style: TextStyle(fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: QtToolThemeColors.tableTextColor)),
                    )),
                sf.GridColumn(
                    columnName: 'input_path',
                    width: columnWidthsMap['input_path']!,
                    columnWidthMode: sf.ColumnWidthMode.lastColumnFill,
                    minimumWidth: 100,
                    label: Container(
                        padding: const EdgeInsets.all(2.0),
                        alignment: Alignment.center,
                        child: const Text('Input Path',
                            style: TextStyle(fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: QtToolThemeColors.tableTextColor)),
                    )),
              ],
            ))
        ));
  }

  void runExistingUic() {
    print('run existing uic command');
  }

  void runExistingRcc() {
    print('run existing rcc command');
  }
}
