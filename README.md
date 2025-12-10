# 📝 Notesheet Tracker

> A comprehensive Flutter application integrated with Supabase that streamlines the notesheet submission and approval workflow for educational institutions, enabling students to submit notesheets digitally and faculty/HODs to review them efficiently.

A mobile-first solution that digitizes and automates the traditional notesheet approval process, making it faster, more transparent, and paperless.

## 🌟 Features

### 👨‍🎓 For Students
- **Easy Submission**: Submit notesheets digitally with all required information
- **Track Status**: Monitor the approval status of submitted notesheets in real-time
- **View History**: Access complete history of all submitted notesheets
- **Notifications**: Receive updates when notesheets are approved or rejected
- **Profile Management**: Manage student profile and details

### 👨‍🏫 For Faculty
- **Review Queue**: View all pending notesheets requiring approval
- **Quick Actions**: Approve or reject notesheets with comments
- **Filter & Sort**: Organize notesheets by date, student, or status
- **Detailed View**: Access complete notesheet information before decision
- **Bulk Operations**: Handle multiple notesheets efficiently

### 👔 For HODs (Head of Department)
- **Final Approval**: Review and approve notesheets after faculty approval
- **Department Overview**: View all notesheets across the department
- **Analytics Dashboard**: Track approval statistics and trends
- **User Management**: Manage faculty and student access
- **Report Generation**: Generate reports for administrative purposes

## 🎯 Core Functionality

### Multi-Level Approval Workflow
```
Student Submission → Faculty Review → HOD Approval → Completed
                          ↓                ↓
                      Rejected        Rejected
```

### Role-Based Access Control
- **Students**: Can only submit and view their own notesheets
- **Faculty**: Can review notesheets from their assigned courses/classes
- **HODs**: Have full access to all department notesheets and analytics

## 🛠️ Technologies Used

### Frontend
- **Flutter** (Dart 47.8%) - Cross-platform mobile app development
- **Material Design** - Modern, intuitive UI/UX
- **Provider/Riverpod** - State management

### Backend
- **Supabase** - Backend-as-a-Service
  - PostgreSQL Database
  - Real-time subscriptions
  - Row Level Security (RLS)
  - Authentication & Authorization
  - Storage for attachments

### Platform Support
- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ Windows
- ✅ macOS
- ✅ Linux

## 📁 Project Structure

```
Notesheet_Tracker/
│
├── android/                 # Android-specific files
├── ios/                     # iOS-specific files
├── web/                     # Web-specific files
├── windows/                 # Windows-specific files
├── macos/                   # macOS-specific files
├── linux/                   # Linux-specific files
│
├── lib/                     # Main application code
│   ├── models/             # Data models
│   ├── screens/            # UI screens
│   ├── widgets/            # Reusable widgets
│   ├── services/           # Business logic & API calls
│   ├── providers/          # State management
│   └── main.dart           # App entry point
│
├── test/                    # Unit and widget tests
├── pubspec.yaml            # Flutter dependencies
└── README.md               # This file
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)
- Android Studio / Xcode / VS Code
- Supabase account and project
- Git

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/khushidhir3/Notesheet_Tracker.git
cd Notesheet_Tracker
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Configure Supabase**

Create a `.env` file in the root directory:
```env
SUPABASE_URL=your_supabase_project_url
SUPABASE_ANON_KEY=your_supabase_anon_key
```

Or configure directly in your Supabase service file.

4. **Set up Supabase Database**

Create the following tables in your Supabase project:
- `users` - User profiles with role information
- `notesheets` - Notesheet records
- `approvals` - Approval history and comments
- `notifications` - Push notification records

5. **Run the app**
```bash
# For Android/iOS
flutter run

# For Web
flutter run -d chrome

# For Desktop
flutter run -d windows  # or macos/linux
```

## 📱 Screenshots

*Add screenshots of your app here showcasing:*
- Student submission screen
- Faculty review dashboard
- HOD analytics panel
- Approval workflow

## 🔐 Authentication & Security

- **Secure Authentication**: Email/password authentication via Supabase Auth
- **Role-Based Access**: Different permissions for students, faculty, and HODs
- **Row Level Security**: Database-level security policies
- **Data Encryption**: All sensitive data encrypted in transit and at rest
- **Session Management**: Secure token-based session handling

## 📊 Database Schema

### Users Table
```sql
- id (uuid, primary key)
- email (text)
- full_name (text)
- role (enum: student, faculty, hod)
- department (text)
- created_at (timestamp)
```

### Notesheets Table
```sql
- id (uuid, primary key)
- student_id (uuid, foreign key)
- title (text)
- description (text)
- status (enum: pending, approved, rejected)
- faculty_approved (boolean)
- hod_approved (boolean)
- created_at (timestamp)
- updated_at (timestamp)
```

### Approvals Table
```sql
- id (uuid, primary key)
- notesheet_id (uuid, foreign key)
- approver_id (uuid, foreign key)
- action (enum: approve, reject)
- comments (text)
- created_at (timestamp)
```

## 🧪 Testing

Run tests with:
```bash
# Unit tests
flutter test

# Integration tests
flutter test integration_test/
```

## 🔄 Workflow Example

1. **Student submits notesheet** with required information
2. **Faculty receives notification** about new submission
3. **Faculty reviews and approves/rejects** with comments
4. **HOD receives notification** if faculty approved
5. **HOD makes final decision** on the notesheet
6. **Student gets notification** about final status
7. **Notesheet is archived** in history with complete audit trail

## 🎨 UI/UX Features

- Clean, modern interface following Material Design
- Dark mode support
- Responsive design for all screen sizes
- Smooth animations and transitions
- Intuitive navigation
- Accessibility features

## 🚧 Future Enhancements

- [ ] PDF generation for approved notesheets
- [ ] Email notifications for approvals
- [ ] Document attachment support
- [ ] Advanced analytics and reporting
- [ ] Mobile push notifications
- [ ] Bulk import/export functionality
- [ ] Multi-language support
- [ ] Offline mode with sync
- [ ] Calendar integration
- [ ] Custom approval workflows

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is open source and available under the [MIT License](LICENSE).

## 👤 Author

**Khushi Dhir**

- GitHub: [@khushidhir3](https://github.com/khushidhir3)
- Project Link: [Notesheet Tracker](https://github.com/khushidhir3/Notesheet_Tracker)

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Supabase for the powerful backend platform
- Material Design for UI/UX guidelines
- All contributors and testers

## 📞 Support

For issues, questions, or suggestions:
- Open an [issue](https://github.com/khushidhir3/Notesheet_Tracker/issues)
- Contact via GitHub profile

## ⭐ Show Your Support

Give a ⭐️ if this project helped you streamline your notesheet approval process!

---

**Built with ❤️ using Flutter and Supabase**
