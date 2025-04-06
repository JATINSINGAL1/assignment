import 'package:assignment/Screens/Data/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/apiservice.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => UserProvider(),
      child: UserScreenContent(),
    );
  }
}

class UserScreenContent extends StatelessWidget {
  const UserScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title:
            userController.isSearching
                ? TextField(
                  controller: userController.searchController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Search by name or email',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.black),
                  ),
                  style: const TextStyle(color: Colors.black),
                  onChanged: userController.filterUsers,
                )
                : const Text('Users List'),
        actions: [
          IconButton(
            icon: Icon(userController.isSearching ? Icons.close : Icons.search),
            onPressed: userController.toggleSearch,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: userController.refreshUsers,
        child: FutureBuilder<Map<String, dynamic>>(
          future: userController.usersFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.data!['data'].isEmpty) {
              return const Center(child: Text('No users found'));
            }

            if (!userController.isSearching) {
              userController.allUsers = snapshot.data!['data'] as List;
              userController.filteredUsers = List.from(userController.allUsers);
            }

            userController.totalPages = snapshot.data!['total_pages'];

            final users =
                userController.isSearching
                    ? userController.filteredUsers
                    : userController.allUsers;

            if (users.isEmpty) {
              return Center(
                child: Text('No users match "$userController.searchQuery"'),
              );
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(user['avatar']),
                        ),
                        title: Text(
                          '${user['first_name']} ${user['last_name']}',
                        ),
                        subtitle: Text(user['email']),
                        onTap: () {
                          _showUserDetailsDialog(context, user);
                        },
                        trailing: PopupMenuButton(
                          itemBuilder:
                              (context) => [
                                const PopupMenuItem(
                                  value: 'edit',
                                  child: Text('Edit'),
                                ),
                                const PopupMenuItem(
                                  value: 'delete',
                                  textStyle: TextStyle(color: Colors.red),
                                  child: Text('Delete'),
                                ),
                              ],
                          onSelected: (value) {
                            if (value == 'edit') {
                              _showEditUserDialog(context, user);
                            } else if (value == 'delete') {
                              _showDeleteConfirmationDialog(
                                context,
                                user,
                                userController,
                              );
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
                if (!userController.isSearching)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed:
                              userController.currentPage > 1
                                  ? () => userController.loadPage(
                                    userController.currentPage - 1,
                                  )
                                  : null,
                        ),
                        Text(
                          'Page ${userController.currentPage} of ${userController.totalPages}',
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_forward),
                          onPressed:
                              userController.currentPage <
                                      userController.totalPages
                                  ? () => userController.loadPage(
                                    userController.currentPage + 1,
                                  )
                                  : null,
                        ),
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showUserDetailsDialog(BuildContext context, dynamic user) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('${user['first_name']} ${user['last_name']}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(user['avatar']),
                radius: 50,
              ),
              const SizedBox(height: 16),
              Text('Email: ${user['email']}'),
              const SizedBox(height: 8),
              Text('ID: ${user['id']}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showEditUserDialog(BuildContext context, dynamic user) {
    final nameController = TextEditingController(text: user['first_name']);
    final jobController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit ${user['first_name']}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: jobController,
                decoration: const InputDecoration(labelText: 'Job'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  final result = await ApiService.updateUser(
                    user['id'],
                    nameController.text,
                    jobController.text,
                  );
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('User updated: ${result['name']}'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(
    BuildContext context,
    dynamic user,
    UserProvider usercontroller,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete User'),
          content: Text(
            'Are you sure you want to delete ${user['first_name']} ${user['last_name']}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  final success = await ApiService.deleteUser(user['id']);
                  if (success && context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('User deleted successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    usercontroller.refreshUsers();
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
