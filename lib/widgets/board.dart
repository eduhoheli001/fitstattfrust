import 'package:flutter/material.dart';
import './ludo_row.dart';

class BoardWidget extends StatelessWidget {
  final List<List<GlobalKey>> keyRefrences;
  const BoardWidget(this.keyRefrences, {super.key});

  bool isDesktop(BuildContext context)=> MediaQuery.of(context).size.width >= 600;

  List<Container> _getRows() {
    List<Container> rows = [];
    for (var i = 0; i < 15; i++) {
      rows.add(
        Container(
          decoration: BoxDecoration(
            border: Border(
              //top: BorderSide(color: Colors.grey),
              bottom:
                  i == 14 ? BorderSide(color: Colors.grey) : BorderSide.none,
            ),
            color: Colors.transparent,
          ),
          child: CustomRow(i,keyRefrences[i]),
        ),
      );
    }
    return rows;
  }


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 10,
        child: Container(
          width: isDesktop(context) ? 600 : null,//fix für größe bei web
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/test.png"),//Ludo_board
              alignment: Alignment.center,
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[..._getRows()],
          ),
        ),
      )
    );
  }
}
