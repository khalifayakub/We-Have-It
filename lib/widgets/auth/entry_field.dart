import 'package:flutter/material.dart';

class EntryField extends StatelessWidget {
  EntryField({
    this.title,
    this.obsecure = false,
    this.read = false,
    this.validator,
    this.onSaved,
    this.tap,
    this.textEditingController,
  });
  final String title;
  final FormFieldSetter<String> onSaved;
  final Function tap;
  final bool obsecure;
  final FormFieldValidator<String> validator;
  final TextEditingController textEditingController;
  final bool read;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
              readOnly: false,
              controller: textEditingController,
              onTap: tap,
              onSaved: onSaved,
              autofocus: true,
              validator: validator,
              obscureText: obsecure,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true))
        ],
      ),
    );
  }
}
