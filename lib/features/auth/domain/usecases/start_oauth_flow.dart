import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/i_auth_repository.dart';

@injectable
class StartOAuthFlow implements UseCase<String, NoParams> {
  final IAuthRepository repository;

  StartOAuthFlow(this.repository);

  @override
  Future<Either<Failure, String>> call(NoParams params) async {
    return await repository.startOAuthFlow();
  }
}
