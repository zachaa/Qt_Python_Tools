import 'package:fluent_ui/fluent_ui.dart';


class LReleasePage extends StatefulWidget {
  const LReleasePage({Key? key}) : super(key: key);

  @override
  _LReleasePageState createState() => _LReleasePageState();
}

class _LReleasePageState extends State<LReleasePage> {

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
        header: const PageHeader(
            title: Text('LRelease')
        ),
        content: SizedBox(
          width: double.infinity,
        )
    );
  }
}