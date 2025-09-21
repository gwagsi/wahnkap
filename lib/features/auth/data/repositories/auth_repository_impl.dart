import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exception.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/entities/oauth_session.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';

@Injectable(as: IAuthRepository)
class AuthRepositoryImpl implements IAuthRepository {
  final IAuthRemoteDataSource remoteDataSource;
  final IAuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, String>> startOAuthFlow() async {
    try {
      final result = await remoteDataSource.startOAuthFlow();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<OAuthSession>>> startCompleteOAuthFlow() async {
    try {
      final sessions = await remoteDataSource.startCompleteOAuthFlow();
      return Right(sessions);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<OAuthSession>>> handleOAuthCallback(
    String redirectUrl,
  ) async {
    try {
      final result = await remoteDataSource.handleOAuthCallback(redirectUrl);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, AuthUser>> authorizeUser(String token) async {
    try {
      final result = await remoteDataSource.authorizeUser(token);

      // Store the user session locally after successful authorization
      await localDataSource.storeUserSession(result, token);

      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, AuthUser?>> getCurrentUser() async {
    try {
      final result = await localDataSource.getCurrentUser();
      return Right(result);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.clearUserSession();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    try {
      return await localDataSource.hasUserSession();
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Either<Failure, void>> storeUserSession(
    AuthUser user,
    String token,
  ) async {
    try {
      await localDataSource.storeUserSession(user, token);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> clearUserSession() async {
    try {
      await localDataSource.clearUserSession();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(message: 'Unexpected error: $e'));
    }
  }
}
