import 'package:bike_kollective/data/provider/active_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class UserAccountScreen extends ConsumerWidget {

  const UserAccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeUser = ref.watch(activeUserProvider);

    final TextEditingController nameController = TextEditingController(
      text: activeUser?.name ?? '',
    ); // Controller for name input

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(
              child: Icon(
                Icons.account_circle,
                size: 100,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Name',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Email Address',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              enabled: false, // Email field is not editable
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                final newName = nameController.text.trim();
                if (newName.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Name cannot be empty")),
                  );
                  return;
                }
                await ref.read(activeUserProvider.notifier).setName(newName);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Name successfully updated.")),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: const Text('Save'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await ref.read(activeUserProvider.notifier).signOut();

                Navigator.pushReplacementNamed(context, '/auth');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              child: const Text('Sign Out'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                bool? confirmDelete = await showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Are you sure you want to delete your account?"),
                      actions: <Widget>[
                        TextButton(
                          child: const Text("No"),
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: const Text("Yes"),
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                        )
                      ],
                    );
                  }
                );

                if (confirmDelete == true) {
                  await ref.read(activeUserProvider.notifier).setDelete();
                }

                Navigator.pushReplacementNamed(context, '/');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Delete Account'),
            ),
          ],
        ),
      ),
    );
  }
}