import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/oauth_session.dart';
import '../repositories/i_auth_repository.dart';

class HandleOAuthCallbackParams {
  final String redirectUrl;

  HandleOAuthCallbackParams({required this.redirectUrl});
}

@injectable
class HandleOAuthCallback
    implements UseCase<List<OAuthSession>, HandleOAuthCallbackParams> {
  final IAuthRepository repository;

  HandleOAuthCallback(this.repository);

  @override
  Future<Either<Failure, List<OAuthSession>>> call(
    HandleOAuthCallbackParams params,
  ) async {
    return await repository.handleOAuthCallback(params.redirectUrl);
  }
}
