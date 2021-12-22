import 'package:flutter/material.dart';

class PostButton extends StatelessWidget {
  final String name;
  final Color textColor;
  final VoidCallback onPressed;
  final Color color;
  const PostButton(
      {Key? key,
      required this.name,
      required this.textColor,
      required this.onPressed,
      required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(30.0),
      clipBehavior: Clip.antiAlias,
      child: MaterialButton(
        color: color,
        minWidth: double.infinity,
        height: 50,
        onPressed: onPressed,
        child: Text(
          name,
          style: TextStyle(
            color: textColor,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
