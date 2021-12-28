import 'package:flutter/material.dart';

class AppBarIcon extends StatelessWidget {
  final IconData iconData;
  final VoidCallback onPressed;
  const AppBarIcon({
    required this.iconData,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RawMaterialButton(
        onPressed: onPressed,
        child: Icon(
          iconData,
          color: Theme.of(context).appBarTheme.iconTheme!.color,
          size: Theme.of(context).appBarTheme.iconTheme!.size,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        constraints: const BoxConstraints.tightFor(
          width: 45.0,
          height: 45.0,
        ),
        fillColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
