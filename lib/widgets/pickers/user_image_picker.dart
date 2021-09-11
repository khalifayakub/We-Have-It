import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  UserImagePicker(this.imagePickFn);

  final void Function(File pickedImage) imagePickFn;

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _pickedImage;

  void _pickImage() async {
    FocusScope.of(context).unfocus();
    var picker = ImagePicker();
    var imageSource = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ImageSourceButton(
            imageSource: ImageSource.camera,
            text: 'Take a Picture',
          ),
          ImageSourceButton(
            imageSource: ImageSource.gallery,
            text: 'Choose from Gallery',
          ),
        ],
      ),
    );
    if (imageSource == null) {
      return;
    }
    final pickedImageFile = await picker.getImage(
      source: imageSource,
      imageQuality: 50,
      maxWidth: 150,
    );
    setState(() {
      _pickedImage = File(pickedImageFile.path);
    });
    widget.imagePickFn(_pickedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.grey,
          backgroundImage: _pickedImage != null ? FileImage(_pickedImage) : null,
        ),
        FlatButton.icon(
          onPressed: _pickImage,
          icon: Icon(Icons.image),
          label: Text('Add Image'),
          textColor: Theme.of(context).primaryColor,
        )
      ],
    );
  }
}

class ImageSourceButton extends StatelessWidget {
  const ImageSourceButton({
    Key key,
    @required this.imageSource,
    @required this.text,
  }) : super(key: key);

  final ImageSource imageSource;
  final String text;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        Navigator.of(context).pop(imageSource);
      },
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: const EdgeInsets.all(20),
      textColor: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      child: Text(text),
    );
  }
}
