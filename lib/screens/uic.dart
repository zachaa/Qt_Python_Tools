import 'package:fluent_ui/fluent_ui.dart';

class UicPage extends StatefulWidget {
  const UicPage({Key? key}) : super(key: key);

  @override
  _UicPageState createState() => _UicPageState();
}

class _UicPageState extends State<UicPage> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
        header: const PageHeader(title: Text('Uic')),
        content: Padding(
          padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
          child:Wrap( // use wrap instead of Column to use spacing
            spacing: 20,     // the horizontal spacing
            runSpacing: 20,  // the vertical spacing
            children: [
              const TextBox(
                header: '.ui file input path',
                placeholder: 'C:/...',
              ),
              const TextBox(
                header: '.py file output path',
                placeholder: 'C:/...',
              ),
              SizedBox(
                width: 320,
                child: Mica( // Mica is like a group box, it's a different color
                    child: InfoLabel(
                        label: 'PyQt Options',
                        child: Padding(
                            padding:const EdgeInsets.all(8),
                            child:Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Checkbox(
                                      checked: true,
                                      onChanged: null,  // TODO change this
                                      content: const Text('-x: Run Ui from file')),
                                  SizedBox(height: 12,),  // Spacing between items
                                  SizedBox(
                                      width: 300,
                                      child: TextBox(header: 'Resources extension')),
                              ],
                            )
                        )
                    )
                ),
              ),
              SizedBox(
                width: 600,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Button(
                        child: const Text('Create Ui'),
                        onPressed: checkAndRunCommandUic),
                    const SizedBox(width: 30),
                    const InfoLabel(label: 'Save as:'),
                    SizedBox(
                        width: 200,
                        child: TextBox()),
                    Button(
                        child: const Text('Create and Save'),
                        onPressed: saveCommandUic),
                  ],
                ),
              ),
            ]
          )
        )
    );
  }

  void checkAndRunCommandUic() {
    // TODO
    return;}

  void saveCommandUic(){
    // TODO
    return;}

}
