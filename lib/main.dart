import 'dart:io';  // for platform info
import 'package:window_size/window_size.dart';
import 'package:fluent_ui/fluent_ui.dart';

import 'globals.dart';
import 'theme.dart';
import 'data/command_db.dart';
import 'screens/screens.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await App.init(); // load from globals
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle("Qt Tools for Python");
    setWindowMinSize(const Size(970, 670));
    setWindowFrame(const Rect.fromLTWH(200, 50, 1020, 710));
  }

  // set user default Qt Implementation
  selectedQtImplementation = App.localStorage.getInt('default_qt_implementation') ?? 0;

  runApp(const QtPythonApp());
}

class QtPythonApp extends StatefulWidget {
  const QtPythonApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return QtPythonAppState();
  }
}

class QtPythonAppState extends State<QtPythonApp> {
  // index used by the Side Navigation
  int navIndex = 0;

  @override
  void dispose() {
    // only close database at very end
    QtCommandDatabase.instance.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FluentApp(
        theme: ThemeData(
            brightness: Brightness.dark,
            accentColor: QtToolThemeColors.qtGreenAccent, // This is not a Color but an AccentColor
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
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  PillButtonBar(
                    selected: selectedQtImplementation,
                    onChanged: (i) => setState(() => selectedQtImplementation = i),
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
                icon: const Icon(FluentIcons.home,
                    color: QtToolThemeColors.qtGreenBase),
                body: const HomePage(),
                title: const Text("Home")),
              PaneItemSeparator(),
              PaneItemHeader(header: const Text("Tools")),
              PaneItem(
                icon: const Icon(FluentIcons.translate,
                    color: QtToolThemeColors.lreleaseColor),
                body: const LReleasePage(),
                title: const Text("LRelease")),
              PaneItem(
                icon: const Icon(FluentIcons.locale_language,
                    color: QtToolThemeColors.lupdateColor),
                body: const LUpdatePage(),
                title: const Text("LUpdate")),
              PaneItem(
                icon: const Icon(FluentIcons.folder_open,
                    color: QtToolThemeColors.rccColor),
                body: const RccPage(),
                title: const Text("Rcc")),
              PaneItem(
                icon: const Icon(FluentIcons.devices2,
                    color: QtToolThemeColors.uicColor),
                body: const UicPage(),
                title: const Text("Uic")),
              ],
            footerItems: [
              PaneItemSeparator(),
              PaneItem(
                icon: const Icon(FluentIcons.settings,
                    color: QtToolThemeColors.qtGreenBase),
                body: const SettingsPage(),
                title: const Text('Settings')),
              PaneItemHeader(
                  header: Text('Version 0.1.0',
                    style: TextStyle(fontSize: 10, color: Colors.grey[80]))),
            ]
          ),
        )
    );
  }
}
