import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

import 'image_helper.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Picker & Cropper'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          vertical: 80,
          horizontal: 20,
        ),
        children: const [
          ProfileImage(initials: 'AB'),
          MultipleImage(),
        ],
      ),
    );
  }
}

final imageHelper = ImageHelper();

class ProfileImage extends StatefulWidget {
  const ProfileImage({
    Key? key,
    required this.initials,
  }) : super(key: key);

  final String initials;

  @override
  State<ProfileImage> createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
  File? _image;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: FittedBox(
            fit: BoxFit.contain,
            child: CircleAvatar(
              backgroundColor: Colors.grey[300],
              radius: 64,
              foregroundImage: _image != null ? FileImage(_image!) : null,
              child: Text(
                widget.initials,
                style: const TextStyle(
                  fontSize: 68,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () async {
            final files = await imageHelper.pickImage();
            if (files.isNotEmpty) {
              final croppedFile = await imageHelper.crop(
                filePath: files.first.path,
                cropStyle: CropStyle.circle,
              );
              if (croppedFile != null) {
                setState(() {
                  _image = File(croppedFile.path);
                });
              }
            }
          },
          child: const Text('Select Photo'),
        ),
      ],
    );
  }
}

class MultipleImage extends StatefulWidget {
  const MultipleImage({super.key});

  @override
  State<MultipleImage> createState() => _MultipleImageState();
}

class _MultipleImageState extends State<MultipleImage> {
  List<File> _images = [];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          spacing: 4,
          runSpacing: 4,
          children: List.generate(_images.length, (index) {
            final e = _images[index];
            return InkWell(
              onTap: () async {
                final croppedFile = await imageHelper.crop(
                  filePath: e.path,
                  cropStyle: CropStyle.circle,
                );
                if (croppedFile != null) {
                  setState(() {
                    _images[index] = File(croppedFile.path);
                  });
                }
              },
              child: Ink.image(
                height: 100,
                width: 100,
                fit: BoxFit.cover,
                image: FileImage(e),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () async {
            final files = await imageHelper.pickImage(multiple: true);

            setState(() {
              _images = files.map((e) => File(e.path)).toList();
            });
          },
          child: const Text('Select Multiple Photos'),
        ),
      ],
    );
  }
}
