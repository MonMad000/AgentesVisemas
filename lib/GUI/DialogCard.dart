import 'package:flutter/material.dart';

class DialogCard extends StatelessWidget {
  const DialogCard({super.key,required this.txt});
  final String txt;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45,
        ),
        child:  Card(

          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15), side: BorderSide(color: Colors.black87, width: 1.0)),
          color: Colors.white,
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Padding(
            padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
            child: Text(
              txt,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
