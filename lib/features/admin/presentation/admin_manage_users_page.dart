import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminManageUsersPage extends StatefulWidget {
  const AdminManageUsersPage({super.key});

  @override
  State<AdminManageUsersPage> createState() => _AdminManageUsersPageState();
}

class _AdminManageUsersPageState extends State<AdminManageUsersPage> {
  final _roles = const ['standard', 'trainer', 'admin'];

  String _displayName(Map<String, dynamic> data) {
    final name = (data['name'] as String?)?.trim() ?? '';
    final email = (data['email'] as String?)?.trim() ?? '';
    if (name.isNotEmpty) return name;
    return email.isNotEmpty ? email : '(no name)';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Users')),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .orderBy('email')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final docs = snapshot.data?.docs ?? const [];
          if (docs.isEmpty) {
            return const Center(child: Text('No users found'));
          }
          return ListView.separated(
            itemCount: docs.length,
            separatorBuilder: (_, __) => const Divider(height: 0),
            itemBuilder: (context, i) {
              final d = docs[i];
              final data = d.data();
              final title = _displayName(data);
              final email = (data['email'] as String?) ?? '';
              final currentRole = (data['role'] as String?) ?? 'standard';
              return ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: Text(title),
                subtitle: Text(email),
                trailing: DropdownButton<String>(
                  value: currentRole,
                  items: _roles
                      .map((r) => DropdownMenuItem(
                            value: r,
                            child: Text(r[0].toUpperCase() + r.substring(1)),
                          ))
                      .toList(),
                  onChanged: (val) async {
                    if (val == null) return;
                    try {
                      await d.reference.update({'role': val});
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Updated role to "$val"')),
                        );
                      }
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text('Failed to update role: ${e.toString()}')),
                        );
                      }
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

