import 'package:fluent_ui/fluent_ui.dart';

ContentDialog messageDialog(BuildContext context, String title, String message){
  return ContentDialog(
    title: Text(title),
    content: Text(message),
    actions: [
      SizedBox(
          width: 80,
          child: Button(
            child: const Text('Ok'),
            onPressed: () => Navigator.pop(context), // close dialog
          ))],
  );
}