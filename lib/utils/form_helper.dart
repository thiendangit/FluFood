import 'package:flutter/material.dart';

class FormHelper {
  static Widget textInput(
      BuildContext context, Object initialValue, Function onChanged,
      {dynamic isTextArea = false,
      dynamic isNumberInput = false,
      obscureText: false,
      required Function onValidate,
      dynamic prefixIcon,
      dynamic suffixIcon}) {
    return Container(
      alignment: Alignment.center,
      child: Container(
        width: MediaQuery.of(context).size.width - 40,
        child: TextFormField(
          initialValue: initialValue != null ? initialValue.toString() : "",
          decoration: fieldDecoration(context, "", "", prefixIcon, suffixIcon),
          obscureText: obscureText,
          maxLines: !isTextArea ? 1 : 3,
          keyboardType:
              isNumberInput ? TextInputType.number : TextInputType.text,
          onChanged: (String value) {
            return onChanged(value);
          },
          validator: (value) {
            return onValidate(value);
          },
        ),
      ),
    );
  }

  static InputDecoration fieldDecoration(BuildContext context, String hintText,
      String helperText, dynamic suffixIcon, dynamic prefixIcon) {
    return InputDecoration(
      contentPadding: EdgeInsets.only(right: 10, left: 10),
      hintText: hintText,
      helperText: helperText,
      prefixIcon: prefixIcon ?? null,
      suffixIcon: suffixIcon ?? null,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).focusColor,
          width: 1,
        ),
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).accentColor,
          width: 1,
        ),
      ),
    );
  }

  static Widget fieldLabel(String labelName) {
    return new Padding(
      padding: EdgeInsets.fromLTRB(20, 5, 0, 10),
      child: Text(
        labelName,
        style: new TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15.0,
        ),
      ),
    );
  }

  static Widget saveButton(String buttonText, Function onTap,
      {required BuildContext context,
      required String color,
      required String textColor,
      required dynamic fullWidth,
      dynamic isLoading = false}) {
    return Container(
      height: 50.0,
      width: 170,
      child: GestureDetector(
        onTap: () {
          onTap();
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).accentColor,
              style: BorderStyle.solid,
              width: 1.0,
            ),
            color: Theme.of(context).accentColor,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: isLoading
                    ? SizedBox(
                        height: 25,
                        width: 25,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : Text(
                        buttonText,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void showMessage(
    BuildContext context,
    String title,
    String message,
    String buttonText,
    Function onPressed,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(title),
          content: new Text(message),
          actions: [
            new MaterialButton(
              onPressed: () {
                return onPressed();
              },
              child: new Text(buttonText),
            )
          ],
        );
      },
    );
  }
}
