// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;
import 'package:wahnkap/core/api/api_client.dart' as _i568;
import 'package:wahnkap/core/di/register_module.dart' as _i626;
import 'package:wahnkap/core/services/deep_link_service.dart' as _i809;
import 'package:wahnkap/features/auth/data/datasources/auth_local_data_source.dart'
    as _i336;
import 'package:wahnkap/features/auth/data/datasources/auth_local_data_source_impl.dart'
    as _i1007;
import 'package:wahnkap/features/auth/data/datasources/auth_remote_data_source.dart'
    as _i954;
import 'package:wahnkap/features/auth/data/datasources/auth_remote_data_source_impl.dart'
    as _i267;
import 'package:wahnkap/features/auth/data/repositories/auth_repository_impl.dart'
    as _i669;
import 'package:wahnkap/features/auth/data/services/oauth_service.dart' as _i57;
import 'package:wahnkap/features/auth/domain/repositories/i_auth_repository.dart'
    as _i496;
import 'package:wahnkap/features/auth/domain/usecases/authorize_user.dart'
    as _i700;
import 'package:wahnkap/features/auth/domain/usecases/handle_oauth_callback.dart'
    as _i463;
import 'package:wahnkap/features/auth/domain/usecases/logout.dart' as _i79;
import 'package:wahnkap/features/auth/domain/usecases/start_oauth_flow.dart'
    as _i938;
import 'package:wahnkap/features/auth/presentation/bloc/auth_bloc.dart'
    as _i1032;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.factory<_i809.DeepLinkService>(() => _i809.DeepLinkService());
    gh.factory<_i57.OAuthService>(() => _i57.OAuthService());
    gh.singleton<_i568.ApiClient>(() => _i568.ApiClient());
    gh.factory<_i954.IAuthRemoteDataSource>(
        () => _i267.AuthRemoteDataSourceImpl(gh<_i57.OAuthService>()));
    gh.factory<_i336.IAuthLocalDataSource>(
        () => _i1007.AuthLocalDataSourceImpl(gh<_i460.SharedPreferences>()));
    gh.factory<_i496.IAuthRepository>(() => _i669.AuthRepositoryImpl(
          remoteDataSource: gh<_i954.IAuthRemoteDataSource>(),
          localDataSource: gh<_i336.IAuthLocalDataSource>(),
        ));
    gh.factory<_i938.StartOAuthFlow>(
        () => _i938.StartOAuthFlow(gh<_i496.IAuthRepository>()));
    gh.factory<_i79.Logout>(() => _i79.Logout(gh<_i496.IAuthRepository>()));
    gh.factory<_i700.AuthorizeUser>(
        () => _i700.AuthorizeUser(gh<_i496.IAuthRepository>()));
    gh.factory<_i463.HandleOAuthCallback>(
        () => _i463.HandleOAuthCallback(gh<_i496.IAuthRepository>()));
    gh.factory<_i1032.AuthBloc>(() => _i1032.AuthBloc(
          startOAuthFlow: gh<_i938.StartOAuthFlow>(),
          handleOAuthCallback: gh<_i463.HandleOAuthCallback>(),
          authorizeUser: gh<_i700.AuthorizeUser>(),
          logout: gh<_i79.Logout>(),
        ));
    return this;
  }
}

class _$RegisterModule extends _i626.RegisterModule {}
