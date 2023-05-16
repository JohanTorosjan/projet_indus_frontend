import 'package:flutter/material.dart';

import '../../models/client.dart';

class UpdateProfileView extends StatefulWidget {
  final Client client;

  const UpdateProfileView({super.key, required this.client});

  @override
  UpdateProfileViewState createState() => UpdateProfileViewState();
}

class UpdateProfileViewState extends State<UpdateProfileView> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _instagramController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.client.name);
    _emailController = TextEditingController(text: widget.client.email);
    _instagramController = TextEditingController(text: widget.client.instagram);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _instagramController,
              decoration: const InputDecoration(labelText: 'Instagram'),
            ),
            ElevatedButton(
              onPressed: () {
                // Call your update profile API here
              },
              child: const Text('Update Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
