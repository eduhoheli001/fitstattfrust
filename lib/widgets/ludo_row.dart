import 'package:flutter/material.dart';
import '../utility.dart';

class LudoRow extends StatelessWidget {

  final int row;
  final List<GlobalKey> keyRow;
  LudoRow(this.row,this.keyRow);

  List<Flexible> _getColumns() {
    List<Flexible> columns = [];
    for (var i = 0; i < 15; i++) {
      columns.add(Flexible(//
        key: keyRow[i],
        child: AspectRatio(
          aspectRatio: 1,
          child: Container(

            decoration: BoxDecoration(
              //borderRadius: BorderRadius.circular(50),
              border: Border(
                left: BorderSide(color: Colors.black,width:1.0),
                right:
                    i == 14 ? BorderSide(color: Colors.grey) : BorderSide.none,
              ),
              color: Colors.white,//Utility.getColor(row, i)
            ),
            child: Text('${row},${i}',style:TextStyle(color:Colors.black,fontSize: 10)),
          ),
        ),
      ));
    }
    return columns;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[..._getColumns()],
    );
  }

}
