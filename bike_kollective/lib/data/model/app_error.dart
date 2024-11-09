// General source of the error
enum ErrorCategory { user, database, location, ui, state }

// Error data
class AppError {
  DateTime? timestamp;
  ErrorCategory category;
  String? displayMessage;
  String? logMessage;

  AppError({
    required this.category,
    this.displayMessage,
    this.logMessage
  }) {
    timestamp = DateTime.now();
  }

  bool shouldDisplay() {
    return (displayMessage != null);
  }

  bool shouldLog() {
    return (logMessage != null);
  }
}
