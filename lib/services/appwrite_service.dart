import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';

class AppwriteService {
  static final Client _client = Client();
  static late Account _account;
  static late Databases _databases;

  // ============================================================
  // TODO: Replace these with your actual Appwrite Database/Collection values
  // ============================================================
  static const String endpoint = 'https://fra.cloud.appwrite.io/v1'; 
  static const String projectId = '69bfe2e300309503f192';
  
  // Note: These IDs will need to be updated after you create them in Appwrite
  static const String databaseId = 'Jaishreeram1000';
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

  // ── Authentication ──

  static Future<User> signUp({
    required String email,
    required String password,
    required String name,
    required String role,
  }) async {
    try {
      // 1. Create Appwrite Auth Account
      final user = await _account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: name,
      );

      // 2. Create Email Session
      await _account.createEmailPasswordSession(
        email: email,
        password: password,
      );

      // 3. Create Profile Document
      await _databases.createDocument(
        databaseId: databaseId,
        collectionId: profilesCollectionId,
        documentId: user.$id,
        data: {
          'role': role,
          'name': name,
          'email': email,
        },
      );

      return user;
    } catch (e) {
      rethrow;
    }
  }

  static Future<Session> login(String email, String password) async {
    try {
      return await _account.createEmailPasswordSession(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> logout() async {
    try {
      await _account.deleteSession(sessionId: 'current');
    } catch (e) {
      rethrow;
    }
  }

  static Future<Document?> getCurrentProfile() async {
    try {
      final user = await _account.get();
      return await _databases.getDocument(
        databaseId: databaseId,
        collectionId: profilesCollectionId,
        documentId: user.$id,
      );
    } catch (e) {
      return null;
    }
  }

  // ── Notesheets Database ──

  static Future<Document> submitNotesheet({
    required String venue,
    required String content,
    required DateTime date,
  }) async {
    try {
      final user = await _account.get();
      return await _databases.createDocument(
        databaseId: databaseId,
        collectionId: notesheetsCollectionId,
        documentId: ID.unique(),
        data: {
          'userId': user.$id,
          'venue': venue,
          'content': content,
          'date': date.toIso8601String(),
          'status': 'pending',
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<Document>> getNotesheetsByStatus(String status) async {
    try {
      final response = await _databases.listDocuments(
        databaseId: databaseId,
        collectionId: notesheetsCollectionId,
        queries: [
          Query.equal('status', status),
          Query.orderDesc('date'),
        ],
      );
      return response.documents;
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<Document>> getUserNotesheets() async {
    try {
      final user = await _account.get();
      final response = await _databases.listDocuments(
        databaseId: databaseId,
        collectionId: notesheetsCollectionId,
        queries: [
          Query.equal('userId', user.$id),
          Query.orderDesc('date'),
        ],
      );
      return response.documents;
    } catch (e) {
      rethrow;
    }
  }

  static Future<Document> updateNotesheetStatus(
      String documentId, String newStatus) async {
    try {
      return await _databases.updateDocument(
        databaseId: databaseId,
        collectionId: notesheetsCollectionId,
        documentId: documentId,
        data: {
          'status': newStatus,
        },
      );
    } catch (e) {
      rethrow;
    }
  }
}
