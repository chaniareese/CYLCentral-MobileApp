class Config {
  // Base URL for API calls
  static String get apiBaseUrl {
    // Use different URLs based on platform or environment
    // For Flutter Web running on localhost
    const bool isWeb = bool.fromEnvironment('dart.library.js_util');
    if (isWeb) {
      return 'http://localhost:8000/api';
    }

    // For Android emulator, use 10.0.2.2 to connect to host machine
    return 'http://10.0.2.2:8000/api';
  }

  // Other config parameters
  static const String appName = 'CYL Central';

  // Helper method to get user-friendly error messages
  static String getUserFriendlyErrorMessage(dynamic error) {
    if (error == null) {
      return 'An unknown error occurred';
    }

    String errorMessage = error.toString();

    // Check for common network errors
    if (errorMessage.contains('SocketException') ||
        errorMessage.contains('Connection refused')) {
      return 'Cannot connect to the server. Please check your internet connection and try again.';
    } else if (errorMessage.contains('timed out')) {
      return 'The connection timed out. Please try again later.';
    } else if (errorMessage.contains('HttpException')) {
      return 'There was a problem with the network request. Please try again.';
    }

    // Return the original error message if no specific handling
    return errorMessage;
  }
}
