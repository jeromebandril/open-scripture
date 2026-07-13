import '../../error/failure.dart';

class InvalidInputFailure extends Failure {
  const InvalidInputFailure({super.details});
  @override
  String get message => 'Invalid input';
}
