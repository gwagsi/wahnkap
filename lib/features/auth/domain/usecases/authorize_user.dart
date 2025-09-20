import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/auth_user.dart';
import '../repositories/i_auth_repository.dart';

class AuthorizeUserParams {
  final String token;

  AuthorizeUserParams({required this.token});
}

@injectable
class AuthorizeUser implements UseCase<AuthUser, AuthorizeUserParams> {
  final IAuthRepository repository;

  AuthorizeUser(this.repository);

  @override
  Future<Either<Failure, AuthUser>> call(AuthorizeUserParams params) async {
    return await repository.authorizeUser(params.token);
  }
}
