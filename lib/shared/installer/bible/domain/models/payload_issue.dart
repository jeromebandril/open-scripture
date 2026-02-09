import 'package:equatable/equatable.dart';

enum IssueSeverity {
  info,
  warning,
  error,
}

/// Represents a non-fatal or fatal problem encountered during import.
/// Importers SHOULD prefer emitting issues over throwing,
/// unless import cannot continue at all.
class PayloadIssue extends Equatable {
  final IssueSeverity severity;
  final String code;
  final String message;
  final String? pointer;
  final Map<String, String> details;

  const PayloadIssue({
    required this.severity,
    required this.code,
    required this.message,
    this.pointer,
    this.details = const {},
  });

  @override
  List<Object?> get props => [
        severity,
        code,
        message,
        pointer,
        details,
      ];
}
