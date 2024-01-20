import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({Key? key, required this.onSelectedImage}) : super(key: key);
  final Function(File image) onSelectedImage;

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? imageFile;
  void _pickImage() {
    final ImagePicker imagePicker = ImagePicker();
    imagePicker.pickImage(source: ImageSource.camera).then((value) {
      setState(() {
        imageFile = File(value!.path);
      });
      widget.onSelectedImage(imageFile!);
      return imageFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = TextButton.icon(
      onPressed: _pickImage,
      icon: const Icon(Icons.camera),
      label: const Text('Pick Image'),
    );
    if (imageFile != null) {
      setState(() {
        content = GestureDetector(
          onTap: () {
            _pickImage();
          },
          child: Image.file(
            imageFile!,
            height: 280,
            width: double.infinity,
            fit: BoxFit.fill,
          ),
        );
      });
    }

    return Container(
      alignment: Alignment.center,
      height: 250,
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.primary.withOpacity(.2),
      ),
      child: content,
    );
  }
}
