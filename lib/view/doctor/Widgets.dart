
import 'package:flutter/material.dart';

class Widgets {
  static Widget textFormField(
      {@required TextEditingController controller,
        @required bool darkBackground,
        String labelText,
        String suffixText,
        bool obscureText = false,
        TextInputType inputType = TextInputType.text,
        FormFieldValidator<String> validator}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Theme(
        data: ThemeData(
          primaryColor:
          Colors.blueAccent,
          cursorColor:
          Colors.indigo,
          hintColor:
          Colors.grey,
        ),
        child: TextFormField(
          decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.amber)),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.blue)),
              labelText: labelText,
              suffixText: suffixText),
          keyboardType: inputType,
          controller: controller,
          autocorrect: false,
          obscureText: obscureText,


          validator: validator,
        ),
      ),
    );
  }

  static Widget maxWidthRaisedButton(
      {@required String text, @required VoidCallback onPressed}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: RaisedButton(
          textColor: Colors.white,
          color: Colors.grey,
          onPressed: onPressed,
          child: Text(text),
        ),
      ),
    );
  }

  static Widget textWithPadding(
      {@required String text,
        Color textColor,
        double fontSize,
        double verticalPadding = 0.0,
        double horizontalPadding = 0.0}) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: verticalPadding, horizontal: horizontalPadding),
      child: Text(
        text,
        style: TextStyle(color: textColor, fontSize: fontSize),
      ),
    );
  }

  static Widget iconButton(
      {@required IconData icon,
        @required Color color,
        @required String tooltip,
        @required VoidCallback onPressed}) {
    return Ink(
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: CircleBorder(),
      ),
      child: IconButton(
        onPressed: onPressed,
        iconSize: 40,
        icon: Icon(
          icon,
          color: color,
        ),
        tooltip: tooltip,
      ),
    );
  }
}