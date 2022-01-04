import 'dart:io';  // for platform info
import 'package:window_size/window_size.dart';  // for controlling window size
import 'package:fluent_ui/fluent_ui.dart';
import 'screens/screens.dart';
import 'theme.dart';  // theme and accent colors
import 'command_db.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle("Qt Tools for Python");
    setWindowMinSize(const Size(970, 670));
    setWindowFrame(const Rect.fromLTWH(50, 200, 1020, 710));
  }
  // TODO use database
  // final database = openDatabase(
  //     path.join(await getDatabasesPath(), 'python_qt_tools.db'),
  //     onCreate: (db, version) => dbOnCreate(db, version),
  //     version: 1);
  runApp(QtPythonApp());
}

class QtPythonApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return QtPythonAppState();
  }
}

class QtPythonAppState extends State<QtPythonApp> {
  int navIndex = 0;
  int qtpyBarIndex = 0;

  @override
  Widget build(BuildContext context) {
    return FluentApp(
        theme: ThemeData(
            brightness: Brightness.dark,
            accentColor: QtToolThemeColors.qtGreenAccent, // This is not a Color but and AccentColor
            iconTheme: const IconThemeData(size: 26),
            pillButtonBarTheme: PillButtonBarThemeData(
              selectedColor: ButtonState.all(QtToolThemeColors.qtGreenBase), // can't just set a Color here
             ),
        ),
        home: NavigationView(
          appBar: NavigationAppBar(
            title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    child: Text("Python Qt Tools",
                      style: TextStyle(
                          fontSize: 20,
                          color: QtToolThemeColors.qtGreenBase,
                          fontWeight: FontWeight.bold))
                  )],
            ),
            automaticallyImplyLeading: false,
            actions: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  PillButtonBar(
                    selected: qtpyBarIndex,
                    onChanged: (i) => setState(() => qtpyBarIndex = i),
                    items: const [
                      PillButtonBarItem(text: Text('PyQt5')),
                      PillButtonBarItem(text: Text('PyQt6')),
                      PillButtonBarItem(text: Text('PySide2')),
                      PillButtonBarItem(text: Text('PySide6')),
                    ]
                  )
                ],
            ),
          ),
          pane: NavigationPane(
            selected: navIndex,
            onChanged: (newIndex){setState(() {navIndex = newIndex;});},
            size: const NavigationPaneSize(
              openMinWidth: 100,
              openMaxWidth: 150,
            ),
            displayMode: PaneDisplayMode.open,  //TODO auto?
            items: [
              PaneItem(
                icon: const Icon(FluentIcons.home, color: QtToolThemeColors.qtGreenBase),
                title: const Text("Home")),
              PaneItemSeparator(),
              PaneItemHeader(header: const Text("Tools")),
              PaneItem(
                icon: const Icon(FluentIcons.translate, color: QtToolThemeColors.lreleaseColor),
                title: const Text("LRelease")),
              PaneItem(
                icon: const Icon(FluentIcons.locale_language, color: QtToolThemeColors.lupdateColor), // Colors.pink does not exist in fluent Colors
                title: const Text("LUpdate")),
              PaneItem(
                icon: const Icon(FluentIcons.folder_open, color: QtToolThemeColors.rccColor),
                title: const Text("Rcc")),
              PaneItem(
                icon: const Icon(FluentIcons.devices2, color: QtToolThemeColors.uicColor),
                title: const Text("Uic")),
              ],
            footerItems: [
              PaneItemSeparator(),
              PaneItem(
                icon: const Icon(FluentIcons.settings, color: QtToolThemeColors.qtGreenBase),
                title: const Text('Settings')),
              PaneItemHeader(
                  header: Text('Version 0.1.0',
                    style: TextStyle(fontSize: 10, color: Colors.grey[80]))),
            ]
          ),
          content: NavigationBody(
            index: navIndex,
            children: [
              const HomePage(), /// probably not going to be const
              const LReleasePage(),
              const LUpdatePage(),
              const RccPage(),
              const UicPage(),
              const SettingsPage(), /// probably not going to be const
            ],
          ),
        )
    );
  }
}
