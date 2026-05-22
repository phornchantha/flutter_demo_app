// API Configuration
class AppConstants {
  static const String baseUrl = 'https://meal-db-sandy.vercel.app';
  
  // Custom GUID provided by user
  static const String dbName = 'd175c09f-10f9-432c-9e17-6ab4f32e9ee2';
  
  // Headers for API data calls (JSON)
  static const Map<String, String> apiHeaders = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
    'X-DB-NAME': dbName,
  };

  // Headers for Image requests
  static const Map<String, String> imageHeaders = {
    'X-DB-NAME': dbName,
  };

  // Default headers
  static const Map<String, String> headers = apiHeaders;

  /// Smart helper to only send security headers to our specific server
  static Map<String, String>? getHeadersForUrl(String url) {
    // Only send private database key if the URL belongs to our Vercel server
    if (url.contains('vercel.app')) {
      return {
        ...imageHeaders,
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36',
      };
    }
    // Return null for external sites like themealdb.com to ensure they load perfectly
    return null;
  }
}

// Local Storage Keys
const String favoritesKey = 'favorites';
const String userPreferencesKey = 'user_preferences';
