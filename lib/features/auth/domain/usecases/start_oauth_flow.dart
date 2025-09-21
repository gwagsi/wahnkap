import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/oauth_session.dart';
import '../repositories/i_auth_repository.dart';

@injectable
class StartOAuthFlow implements UseCase<List<OAuthSession>, NoParams> {
  final IAuthRepository repository;

  StartOAuthFlow(this.repository);

  @override
  Future<Either<Failure, List<OAuthSession>>> call(NoParams params) async {
    debugPrint('🚀 UseCase: Starting complete OAuth flow...');
    return await repository.startCompleteOAuthFlow();
  }
}
