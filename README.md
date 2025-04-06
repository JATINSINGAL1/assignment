# Assignment App

A Flutter application demonstrating authentication, persistent login, and user management using REST APIs.

---

## 🚀 Features

### ✅ Authentication
- **Registration and Login** functionality using a provided API.
- After successful login, the user is redirected to the **User Management** screen.

### 🔐 Persistent Login
- Authentication state is securely stored using `shared_preferences`.
- Users stay logged in even after restarting the app.
- Logout feature clears the stored session securely.

### 👥 User Management (CRUD)
Full CRUD operations are supported through API integration:
- **Create**: Add new users with a form.
- **Read**: View a list of users with all related fields displayed.
- **Update**: Edit and update user information.
- **Delete**: Remove users from the list.

### 🧠 Interactivity Enhancements
- **Search & Filter**: Search users by name or email.
- **Confirmation Dialogs**: Shown before update/delete actions to prevent accidental operations.
- **Toast Notifications**: Real-time feedback with `SnackBar` on all CRUD operations.
- **Form Validation**: Ensures required fields are filled with helpful error messages.

---

## 📦 State Management & Storage

- **State Management Tool**: `provider`
  - Used to manage authentication state, loading indicators, and API response handling.
- **Storage Tool**: `shared_preferences`
  - Used to persist login tokens or session data across app restarts.

---

## 🛠️ Getting Started

1. Clone the repository:
   ```bash
   git clone <your-repo-url>
   cd assignment
