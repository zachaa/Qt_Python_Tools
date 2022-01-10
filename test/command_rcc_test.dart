import 'package:flutter_test/flutter_test.dart' as ft;
import 'package:test/test.dart';
import 'package:qt_python_tools/process/command_rcc.dart';
import 'package:qt_python_tools/data/commands_model.dart';

void main(){
  String inputPath = r"C:\Users\Zachary\IdeaProjects\qt_python_tools\trial_files\logo_icons.qrc";
  String outputPath = r"C:\Users\Zachary\IdeaProjects\qt_python_tools\trial_files\logo_icons.py";
  var qtCommand_A = QtCommand( // Use no compression
      projectName: 'Test',
      itemName: 'test item A',
      pathInput: inputPath,
      pathOutput: outputPath,
      cmdOptions: '-no-compress',
      cmdPyQtOptions: '',
      cmdPySideOptions: '');
  var commandRCC_A = CommandRCC(
      inputpath: inputPath,
      outputpath: outputPath,
      useCompressionOptions: true,
      useNoCompression: true,
      compressionThreshold: '80',
      compressionValue: '-1');
  var qtCommand_B = QtCommand( // Use compression values
      projectName: 'Test',
      itemName: 'test item A',
      pathInput: inputPath,
      pathOutput: outputPath,
      cmdOptions: '-threshold 60 -compress 2',
      cmdPyQtOptions: '',
      cmdPySideOptions: '');
  var commandRCC_B = CommandRCC(
      inputpath: inputPath,
      outputpath: outputPath,
      useCompressionOptions: true,
      useNoCompression: false,
      compressionThreshold: '60',
      compressionValue: '2');
  var qtCommand_C = QtCommand( // No compression options
      projectName: 'Test',
      itemName: 'test item C',
      pathInput: inputPath,
      pathOutput: outputPath,
      cmdOptions: '',
      cmdPyQtOptions: '',
      cmdPySideOptions: '');
  var commandRCC_C = CommandRCC(
      inputpath: inputPath,
      outputpath: outputPath,
      useCompressionOptions: false,
      useNoCompression: false,
      compressionThreshold: '35',
      compressionValue: '9');
  // print(CommandRCC.fromQtCommand(qtCommand_A).toString());
  // print(commandRCC_A.toString());
  group('QtCommand to CommandRCC', () {
    test('generate a CommandRCC fromQtCommand with no-compress', () {
      expect(CommandRCC.fromQtCommand(qtCommand_A), equals(
          CommandRCC(
              inputpath: inputPath,
              outputpath: outputPath,
              useCompressionOptions: true,
              useNoCompression: true,     // Since this is true lower values are ignored
              compressionThreshold: '70',
              compressionValue: '-1')));
    });
    test('generate a CommandRCC fromQtCommand with compression values', () {
      expect(CommandRCC.fromQtCommand(qtCommand_B), equals(commandRCC_B));
    });
    test('generate a CommandRCC fromQtCommand with no compression options', () {
      expect(CommandRCC.fromQtCommand(qtCommand_C), equals(
          CommandRCC(
              inputpath: inputPath,
              outputpath: outputPath,
              useCompressionOptions: false, // Since this is false lower values are ignored
              useNoCompression: false,
              compressionThreshold: '70',
              compressionValue: '-1')));
    });
  });

  group('argsList from CommandRCC', (){
    test('argsList from pyqt5 with no-compress', (){
      expect(commandRCC_A.getArgumentsList(0), equals([inputPath, '-no-compress', '-o', outputPath]));
    });
    test('argsList from pyqt5 with compress values', (){
      expect(commandRCC_B.getArgumentsList(0), equals([inputPath, '-threshold', '60', '-compress', '2', '-o', outputPath]));
    });
    test('argsList from pyqt5 with No compress options', (){
      expect(commandRCC_C.getArgumentsList(0), equals([inputPath, '-o', outputPath]));
    });
    test('argsList from pyqt6 with with no-compress SHOULD ERROR', (){
      expect(() => commandRCC_A.getArgumentsList(1), ft.throwsAssertionError);
      // expect(commandRCC_A.getArgumentsList(1), equals([inputPath, '-o', outputPath]));
    });
    test('argsList from pySide2 with no-compress', (){
      expect(commandRCC_A.getArgumentsList(2), equals([inputPath, '-no-compress', '-o', outputPath]));
    });
    test('argsList from pySide2 with compress values', (){
      expect(commandRCC_B.getArgumentsList(2), equals([inputPath, '-threshold', '60', '-compress', '2', '-o', outputPath]));
    });
    test('argsList from pySide2 with No compress options', (){
      expect(commandRCC_C.getArgumentsList(2), equals([inputPath, '-o', outputPath]));
    });
    test('argsList from pySide6 with no-compress', (){
      expect(commandRCC_A.getArgumentsList(3), equals([inputPath, '-no-compress', '-o', outputPath]));
    });
    test('argsList from pySide6 with compress values', (){
      expect(commandRCC_B.getArgumentsList(3), equals([inputPath, '-threshold', '60', '-compress', '2', '-o', outputPath]));
    });
    test('argsList from pySide6 with No compress options', (){
      expect(commandRCC_C.getArgumentsList(3), equals([inputPath, '-o', outputPath]));
    });
  });
}