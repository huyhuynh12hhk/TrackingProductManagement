import 'package:flutter/material.dart';

void showValidateError(BuildContext context, String title, String content){
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        title,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      content: Text(
        content,
        style: const TextStyle(fontSize: 15),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Ok", style: TextStyle(color: Colors.black87),)),
            ),
          ],
        )
      ],
    ),
  );
}

void showNotificationMessage(BuildContext context, String content) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text(
        "Notification",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      content: Text(
        content,
        style: const TextStyle(fontSize: 15),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Ok", style: TextStyle(color: Colors.black87),)),
            ),
          ],
        )
      ],
    ),
  );
}


void showOnMaintainFeature(BuildContext context){
  showNotificationMessage(context, "Sorry, this feature still not support now!");
}