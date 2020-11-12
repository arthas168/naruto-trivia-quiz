import "package:flutter/material.dart";

class OptionTile extends StatefulWidget {
  final String identifier, label, correctAnswer, selectedOption;

  const OptionTile(
      {Key key,
      @required this.identifier,
      @required this.label,
      @required this.correctAnswer,
      @required this.selectedOption})
      : super(key: key);

  @override
  _OptionTileState createState() => _OptionTileState();
}

class _OptionTileState extends State<OptionTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
      children: [
        Container(
          child: Text("${widget.identifier}",
              style: TextStyle(
                  color: widget.selectedOption == widget.label
                      ? widget.correctAnswer == widget.selectedOption
                          ? Colors.green
                          : Colors.red
                      : Colors.black54)),
          width: 28,
          height: 28,
          decoration: BoxDecoration(
              border: Border.all(
                  color: widget.label == widget.selectedOption
                      ? widget.selectedOption == widget.correctAnswer
                          ? Colors.green
                          : Colors.red
                      : Colors.grey,
                  width: 1.5),
              borderRadius: BorderRadius.circular(30)),
          alignment: Alignment.center,
        ),
        SizedBox(
          width: 8,
        ),
        Text(widget.label,
            style: TextStyle(fontSize: 16, color: Colors.black54))
      ],
    ));
  }
}
