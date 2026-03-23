import 'package:appwrite/appwrite.dart';

class AppwriteService {
  static final Client _client = Client();
  static late Account _account;
  static late Databases _databases;

  // ============================================================
  // TODO: Replace these with your actual Appwrite project values
  // ============================================================
  static const String endpoint = 'https://cloud.appwrite.io/v1'; // or your self-hosted URL
  static const String projectId = 'YOUR_PROJECT_ID';
  static const String databaseId = 'YOUR_DATABASE_ID';
  static const String profilesCollectionId = 'profiles';
  static const String notesheetsCollectionId = 'notesheets';

  /// Call this once in main() before runApp()
  static void init() {
    _client
        .setEndpoint(endpoint)
        .setProject(projectId)
        .setSelfSigned(status: true); // Remove in production

    _account = Account(_client);
    _databases = Databases(_client);
  }

  static Client get client => _client;
  static Account get account => _account;
  static Databases get databases => _databases;
}
