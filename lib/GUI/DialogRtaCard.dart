import 'package:flutter/material.dart';

class DialogRtaCard extends StatelessWidget {
  const DialogRtaCard({super.key,required this.txt, required this.callback});
  final String txt;
  final Function(String) callback;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45,
        ),
        child: GestureDetector(
          onTap: (){
            callback(txt);
          },
          child: Card(
            elevation: 2,
            color: Colors.grey[900],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),

            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 7, 10,7),
              child: Text(
                txt,
                style: TextStyle(
                  fontFamily: "Courier Prime",
                    fontSize: 16,
                color: Colors.white),

              ),
            ),
          ),
        ),
      ),
    );
  }
}
