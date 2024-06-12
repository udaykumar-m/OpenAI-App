import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class InternetConnection extends StatelessWidget {
  const InternetConnection({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('AlertDialog Title'),
      content: const Text('AlertDialog description'),
      actions: <Widget>[
        ElevatedButton(onPressed: () => {
        }, child: const Row(
          children: [
            Icon(FontAwesomeIcons.rotateRight),
            Text("Retry"),
          ],
        ))
      ],
    );
  }
}
