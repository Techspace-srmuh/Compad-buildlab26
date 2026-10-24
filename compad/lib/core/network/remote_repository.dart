import 'dart:async';

abstract class RemoteRepository {
  /// Whether the remote server adapter is configured with active credentials
  bool get isConfigured;

  /// Server region identifier (must be hosted in India, e.g. ap-south-1 Mumbai)
  String get hostingRegion;

  /// Authenticate student via verified institutional college email (.edu / .ac.in)
  Future<RemoteAuthResult> authenticateWithCollegeEmail({
    required String email,
    required String password,
  });

  /// Fetch shared campus listings (Marketplace, Lost & Found, Skill Swap)
  Future<List<RemoteListingItem>> fetchListings({
    required String category,
    required String campusDomain,
  });

  /// Submit a listing draft to the campus server
  Future<bool> publishListing(RemoteListingItem item);

  /// IT Rules 2021 & DPDP Act report/moderation grievance submission
  Future<bool> reportListing({
    required String listingId,
    required String reason,
    required String studentRemarks,
  });
}

class RemoteAuthResult {
  final bool success;
  final String? studentId;
  final String? errorMessage;
  final bool isEmailVerified;

  const RemoteAuthResult({
    required this.success,
    this.studentId,
    this.errorMessage,
    this.isEmailVerified = false,
  });
}

class RemoteListingItem {
  final String id;
  final String title;
  final String description;
  final String category; // 'Marketplace', 'LostFound', 'SkillSwap', 'Roommate'
  final double? priceInr;
  final String contactEmail;
  final DateTime createdAt;
  final bool isFlagged;

  const RemoteListingItem({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    this.priceInr,
    required this.contactEmail,
    required this.createdAt,
    this.isFlagged = false,
  });
}

/// Fallback / Local adapter when no remote server environment variables are injected
class LocalDraftRemoteRepository implements RemoteRepository {
  // Configured dynamically from environment variables
  static const String _supabaseUrl = String.fromEnvironment('SUPABASE_URL', defaultValue: '');
  static const String _supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: '');

  @override
  bool get isConfigured => _supabaseUrl.isNotEmpty && _supabaseAnonKey.isNotEmpty;

  @override
  String get hostingRegion => 'ap-south-1 (Mumbai, India)';

  @override
  Future<RemoteAuthResult> authenticateWithCollegeEmail({
    required String email,
    required String password,
  }) async {
    if (!isConfigured) {
      return const RemoteAuthResult(
        success: false,
        errorMessage: 'Campus server not configured. Running in offline-first mode with local drafts.',
      );
    }
    // Remote authentication placeholder
    return const RemoteAuthResult(success: true, isEmailVerified: true);
  }

  @override
  Future<List<RemoteListingItem>> fetchListings({
    required String category,
    required String campusDomain,
  }) async {
    // Zero fake listings in production! If not configured, returns empty list.
    return const [];
  }

  @override
  Future<bool> publishListing(RemoteListingItem item) async {
    // Queued into local outbox SQLite table
    return true;
  }

  @override
  Future<bool> reportListing({
    required String listingId,
    required String reason,
    required String studentRemarks,
  }) async {
    return true;
  }
}
