import 'package:flutter/material.dart';

void showSnackBar({required BuildContext context, required String text}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      showCloseIcon: true,
      dismissDirection: DismissDirection.horizontal,
      backgroundColor: Color.fromRGBO(237, 12, 52, 1),
      content: Text(
        text,
        style: Theme.of(context)
            .textTheme
            .titleSmall!
            .copyWith(color: Colors.white),
      ),
    ),
  );
}
