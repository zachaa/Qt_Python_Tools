import 'package:fluent_ui/fluent_ui.dart';
import '/globals.dart';


class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int _currentRadioButtonIndex = -1;
  final _pathPyqt5Controller = TextEditingController();
  final _pathPyqt6Controller = TextEditingController();
  final _pathPyside2Controller = TextEditingController();
  final _pathPyside6Controller = TextEditingController();

  @override
  void initState() {
    _readSettings();
    super.initState();
  }

  @override
  void dispose() {
    _pathPyqt5Controller.dispose();
    _pathPyqt6Controller.dispose();
    _pathPyside2Controller.dispose();
    _pathPyside6Controller.dispose();
    super.dispose();
  }

  final List<String> radioButtons = <String>[
    'PyQt5',
    'PyQt6',
    'PySide2',
    'PySide6',
  ];

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
        header: const PageHeader(
            title: Text('Settings')
        ),
        content: Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
            child:Wrap( // use wrap instead of Column to use spacing
                spacing: 20,     // the horizontal spacing
                runSpacing: 20,  // the vertical spacing
                children: [
                  TextBox(
                    header: 'PyQt5 Path',
                    controller: _pathPyqt5Controller,
                    placeholder: 'C:/...',
                  ),
                  TextBox(
                    header: 'PyQt6 Path',
                    controller: _pathPyqt6Controller,
                    placeholder: 'C:/...',
                  ),
                  TextBox(
                    header: 'PySide2 Path',
                    controller: _pathPyside2Controller,
                    placeholder: 'C:/...',
                  ),
                  TextBox(
                    header: 'PySide6 Path',
                    controller: _pathPyside6Controller,
                    placeholder: 'C:/...',
                  ),
                  SizedBox(
                    width: 440,
                    child: Mica( // Mica is like a group box, it's a different color
                        child: InfoLabel(
                            label: 'Default Python Qt Package',
                            child: Padding(
                                padding:const EdgeInsets.all(8),
                                child:Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: List.generate(radioButtons.length, (index) {
                                    return RadioButton(
                                      checked: _currentRadioButtonIndex == index,
                                      // set onChanged to null to disable the button
                                      onChanged: (value) => setState(() => _currentRadioButtonIndex = index),
                                      content: Text(radioButtons[index]),
                                    );
                                  }),
                                )
                            )
                        )
                    ),
                  ),
                  const SizedBox(height: 40),
                  Button(child: const Text('Save Settings'), onPressed: _saveSettings,)
                ]
            )
        )
    );
  }

  _readSettings() {
    _pathPyqt5Controller.text = App.localStorage.getString('path_pyqt5') ?? '';
    _pathPyqt6Controller.text = App.localStorage.getString('path_pyqt6') ?? '';
    _pathPyside2Controller.text = App.localStorage.getString('path_pyside2') ?? '';
    _pathPyside6Controller.text = App.localStorage.getString('path_pyside6') ?? '';
    _currentRadioButtonIndex = App.localStorage.getInt('default_qt_implementation') ?? 0;
  }

  _saveSettings() {
    App.localStorage.setString('path_pyqt5', _pathPyqt5Controller.text);
    App.localStorage.setString('path_pyqt6', _pathPyqt6Controller.text);
    App.localStorage.setString('path_pyside2', _pathPyside2Controller.text);
    App.localStorage.setString('path_pyside6', _pathPyside6Controller.text);
    App.localStorage.setInt('default_qt_implementation', _currentRadioButtonIndex);
  }

}