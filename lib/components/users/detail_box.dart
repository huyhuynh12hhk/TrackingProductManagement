import 'package:flutter/material.dart';

class DetailBox extends StatefulWidget {
  final String section;
  final String content;
  final void Function()? onPressed;
  final bool editable;

  const DetailBox(
      {super.key,
      required this.section,
      required this.content,
      required this.onPressed,
      this.editable = true});

  @override
  State<DetailBox> createState() => _DetailBoxState();
}

class _DetailBoxState extends State<DetailBox> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.only(left: 15, bottom: 15),
      margin: EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
          color: Colors.grey[300], borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //section
          SizedBox(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.section,
                  style: TextStyle(color: Colors.grey[600]),
                ),
                if (widget.editable)
                  IconButton(
                      onPressed: widget.onPressed,
                      icon: Icon(
                        Icons.edit_note,
                        color: Colors.blue[300],
                      ))
              ],
            ),
          ),

          //content
          Text(
            widget.content,
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
