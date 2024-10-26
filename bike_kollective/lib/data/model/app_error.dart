// General source of the error
enum ErrorCategory { user, database, location, ui }

// Error data
class AppErrorModel {
  final ErrorCategory category;
  final String? displayMessage;
  final String? logMessage;

  const AppErrorModel({
    required this.category,
    this.displayMessage,
    this.logMessage
  });

  bool shouldDisplay() {
    return (displayMessage != null);
  }

  bool shouldLog() {
    return (logMessage != null);
  }
}
