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

ContentDialog processingDialog(BuildContext context, String title, Color color){
  return ContentDialog(
    title: Center(child: Text(title, style: TextStyle(color: color))),
    content: Center(child: ProgressRing(activeColor: color)),
    // Center maximizes the area so we need to limit width
    constraints: const BoxConstraints(minHeight: 120, maxWidth: 220),
  );
}