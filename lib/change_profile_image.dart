import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class ChangeProfileImageScreen extends StatefulWidget {
  final String email;
  const ChangeProfileImageScreen({super.key, required this.email});

  @override
  State<ChangeProfileImageScreen> createState() =>
      _ChangeProfileImageScreenState();
}

class _ChangeProfileImageScreenState extends State<ChangeProfileImageScreen> {
  File? image;
  String? iamgeURl;

  var storage = FirebaseStorage.instance;
  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
      uploadFile();
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future uploadFile() async {
    var snapshot =
        await storage.ref().child('${widget.email}.jpg').putFile(image!);

    setState(() {});
  }

  @override
  void initState() {
    storage.ref().child('${widget.email}.jpg').getDownloadURL().then((value) {
      iamgeURl = value;
      print(value);
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var editedEmail = widget.email.replaceAll("@", "%40");

    return Scaffold(
      appBar: AppBar(
        title: const Text("Change Profile Image"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("choose image"),
            iamgeURl != null
                ? Image.network(
                    iamgeURl!,
                    height: 200,
                  )
                : Container(),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () async {
                  await pickImage();
                },
                child: Text("Change Image"))
          ],
        ),
      ),
    );
  }
}
