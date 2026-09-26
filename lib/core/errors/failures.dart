/// Base failure class for Clean Architecture error handling
abstract class Failure {
  final String message;
  const Failure(this.message);

  @override
  String toString() => message;
}

class StorageFailure extends Failure {
  const StorageFailure([super.message = 'Local storage operation failed']);
}

class NoteNotFoundFailure extends Failure {
  const NoteNotFoundFailure([super.message = 'Note was not found']);
}

class BackupFailure extends Failure {
  const BackupFailure([super.message = 'Backup or export failed']);
}

class RestoreFailure extends Failure {
  const RestoreFailure([super.message = 'Restore from file failed']);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}
