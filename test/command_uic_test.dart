import 'package:test/test.dart';
import 'package:qt_python_tools/process/command_uic.dart';
import 'package:qt_python_tools/commands_model.dart';

void main(){
  String inputPath = r"C:\Users\Zachary\PycharmProjects\First_Project\4input-1output.ui";
  String outputPath = r"C:\Users\Zachary\PycharmProjects\First_Project\4input-1output.py";
  var qtCommand_pyqtA = QtCommand(
      projectName: 'Test',
      itemName: 'test item A',
      pathInput: inputPath,
      pathOutput: outputPath,
      cmdOptions: '',
      cmdPyQtOptions: '-x --resource-suffix="_rc"',
      cmdPySideOptions: '');
  var commandUIC_pyqtA = CommandUIC(
      inputpath: inputPath,
      outputpath: outputPath,
      pyqtXOption: true,
      pyqtResourceExtension: '_rc');
  var qtCommand_pyqtB = QtCommand(
      projectName: 'Test',
      itemName: 'test item A',
      pathInput: inputPath,
      pathOutput: outputPath,
      cmdOptions: '',
      cmdPyQtOptions: '-x --resources-suffix=""',
      cmdPySideOptions: '');
  var commandUIC_pyqtB = CommandUIC(
      inputpath: inputPath,
      outputpath: outputPath,
      pyqtXOption: true,
      pyqtResourceExtension: '');
  var qtCommand_pyqtC = QtCommand(
      projectName: 'Test',
      itemName: 'test item C',
      pathInput: inputPath,
      pathOutput: outputPath,
      cmdOptions: '',
      cmdPyQtOptions: '--resources-suffix=""',
      cmdPySideOptions: '');
  var commandUIC_pyqtC = CommandUIC(
      inputpath: inputPath,
      outputpath: outputPath,
      pyqtXOption: false,
      pyqtResourceExtension: '');
  // print(CommandUIC.fromQtCommand(qtCommand_pyqtA).toString());
  // print(commandUIC_pyqtA.toString());
  group('QtCommand to CommandUIC', () {
    test('generate a CommandUIC fromQtCommand with 2 pyqtOptions', () {
      expect(CommandUIC.fromQtCommand(qtCommand_pyqtA), equals(commandUIC_pyqtA));
    });
    test('generate a CommandUIC fromQtCommand with 2 pyqtOptions with empty resource suffix', () {
      expect(CommandUIC.fromQtCommand(qtCommand_pyqtB), equals(commandUIC_pyqtB));
    });
    test('generate a CommandUIC fromQtCommand with 1 pyqtOptions with empty resource suffix', () {
      expect(CommandUIC.fromQtCommand(qtCommand_pyqtC), equals(commandUIC_pyqtC));
    });
  });
  group('argsList from CommandUIC', (){
    test('argsList from pyqt5 with 2 pyqtOptions', (){
      expect(commandUIC_pyqtA.getArgumentsList(0), equals([inputPath, '-x', '--resource-suffix="_rc"', '-o $outputPath']));
    });
    test('argsList from pyqt5 with 2 pyqtOptions with empty resource suffix', (){
      expect(commandUIC_pyqtB.getArgumentsList(0), equals([inputPath, '-x', '--resource-suffix=""', '-o $outputPath']));
    });
    test('argsList from pyqt5 with 1 pyqtOptions with empty resource suffix', (){
      expect(commandUIC_pyqtC.getArgumentsList(0), equals([inputPath, '--resource-suffix=""', '-o $outputPath']));
    });
    test('argsList from pyqt6 with 1 pyqtOptions with empty resource suffix', (){
      expect(commandUIC_pyqtC.getArgumentsList(1), equals([inputPath, '-o $outputPath']));
    });
    test('argsList from pySide2 with 1 pyqtOptions with empty resource suffix', (){
      expect(commandUIC_pyqtC.getArgumentsList(2), equals([inputPath, '-o $outputPath']));
    });
    test('argsList from pySide2 with 2 pyqtOptions', (){
      expect(commandUIC_pyqtA.getArgumentsList(2), equals([inputPath, '-o $outputPath']));
    });
    test('argsList from pySide6 with 2 pyqtOptions with empty resource suffix', (){
      expect(commandUIC_pyqtB.getArgumentsList(3), equals([inputPath, '-o $outputPath']));
    });
  });
}