import 'package:flutter/material.dart';

import '../../../services/apiservice.dart';

class UserProvider with ChangeNotifier {
  late Future<Map<String, dynamic>> usersFuture;
  int currentPage = 1;
  int totalPages = 1;
  String searchQuery = '';
  List<dynamic> allUsers = [];
  List<dynamic> filteredUsers = [];
  bool isSearching = false;
  final TextEditingController searchController = TextEditingController();

  UserProvider(){
    usersFuture = ApiService.getUsers(page: currentPage);
  }
 
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void loadPage(int page) {
    currentPage = page;
    usersFuture = ApiService.getUsers(page: page);
    isSearching = false;
    searchQuery = '';
    searchController.clear();
    notifyListeners();
  }

  void filterUsers(String query) {
    searchQuery = query.toLowerCase();
    if (searchQuery.isEmpty) {
      filteredUsers = List.from(allUsers);
    } else {
      filteredUsers =
          allUsers.where((user) {
            final fullName =
                '${user['first_name']} ${user['last_name']}'.toLowerCase();
            final email = user['email'].toString().toLowerCase();
            return fullName.contains(searchQuery) ||
                email.contains(searchQuery);
          }).toList();
    }
    notifyListeners();
  }

  void toggleSearch() {
    if (isSearching) {
      isSearching = false;
      searchQuery = '';
      searchController.clear();
      filteredUsers = List.from(allUsers);
    } else {
      isSearching = true;
      filteredUsers = List.from(allUsers);
    }
    notifyListeners();
  }

  Future<void> refreshUsers() async {
    usersFuture = ApiService.getUsers(page: currentPage);
    isSearching = false;
    searchQuery = '';
    searchController.clear();
    notifyListeners();
  }
}
