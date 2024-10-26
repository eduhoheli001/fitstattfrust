import 'package:flutter/material.dart';
import './ludo_row.dart';

class Board extends StatelessWidget {
  List<List<GlobalKey>> keyRefrences;
  Board(this.keyRefrences);

  bool isDesktop(BuildContext context)=> MediaQuery.of(context).size.width >= 600;
  //bool isMobile(BuildContext context)=> MediaQuery.of(context).size.width < 600;



  List<Container> _getRows() {
    List<Container> rows = [];
    for (var i = 0; i < 15; i++) {
      rows.add(
        Container(
          child: LudoRow(i,keyRefrences[i]),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.grey),
              bottom:
                  i == 14 ? BorderSide(color: Colors.grey) : BorderSide.none,
            ),
            color: Colors.transparent,
          ),
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
              image: AssetImage("assets/Ludo_board.png"),//Ludo_board
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
