import 'package:flutter/material.dart';
import 'package:projet_indus/views/profile/update_profile_view.dart';

import '../../models/client.dart';

class ProfileView extends StatelessWidget {
  final Client client;

  const ProfileView({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              radius: 50.0,
              backgroundImage: AssetImage('assets/profile_logo.png'),
            ),
            const SizedBox(height: 20.0),
            Text('Name: ${client.name}'),
            Text('Email: ${client.email}'),
            Text('Instagram: ${client.instagram ?? "Not available"}'),
            Text('DoB: ${client.dob}'),
            const SizedBox(height: 20.0),
            ElevatedButton(
              child: const Text('Update Profile'),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => UpdateProfileView(client: client),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
