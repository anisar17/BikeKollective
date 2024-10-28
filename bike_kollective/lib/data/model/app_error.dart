// General source of the error
enum ErrorCategory { user, database, location, ui }

// Error data
class AppErrorModel {
  DateTime? timestamp;
  ErrorCategory category;
  String? displayMessage;
  String? logMessage;

  AppErrorModel({
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
