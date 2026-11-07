
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import 'package:mobile/core/database/app_database.dart';
import 'package:mobile/core/network/dio_client.dart';
import 'package:mobile/core/network/network_info.dart';
import 'package:mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:mobile/features/auth/domain/usecases/login_usecase.dart';
import 'package:mobile/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:mobile/features/dashboard/data/data_sources/dashboard_local_data_source.dart';
import 'package:mobile/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:mobile/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:mobile/features/dashboard/domain/usecases/get_dashboard_summary.dart';
import 'package:mobile/features/dashboard/presentation/bloc/dashboard_bloc.dart';

final GetIt getIt = GetIt.instance;

Future<void> configureDependencies({bool reset = false}) async {
  if (reset) {
    await getIt.reset();
  }

  if (getIt.isRegistered<DioClient>()) {
    return;
  }

  getIt
    ..registerLazySingleton<FlutterSecureStorage>(
      () => const FlutterSecureStorage(),
    )
    ..registerLazySingleton<NetworkInfo>(NetworkInfoImpl.new)
    ..registerLazySingleton<DioClient>(
      () => DioClient(
        secureStorage: getIt<FlutterSecureStorage>(),
      ),
    )
    ..registerLazySingleton<AppDatabase>(AppDatabase.new)
    ..registerLazySingleton<AuthRepository>(
      AuthRepositoryImpl.new,
    )
    ..registerLazySingleton<LoginUseCase>(
      () => LoginUseCase(getIt<AuthRepository>()),
    )
        ..registerFactory<AuthBloc>(
      () => AuthBloc(loginUseCase: getIt<LoginUseCase>()),
    )
    ..registerLazySingleton<DashboardLocalDataSource>(
      DashboardLocalDataSourceImpl.new,
    )
    ..registerLazySingleton<DashboardRepository>(
      () => DashboardRepositoryImpl(
        localDataSource: getIt<DashboardLocalDataSource>(),
      ),
    )
    ..registerLazySingleton<GetDashboardSummary>(
      () => GetDashboardSummary(getIt<DashboardRepository>()),
    )
    ..registerFactory<DashboardBloc>(
      () => DashboardBloc(
        getDashboardSummary: getIt<GetDashboardSummary>(),
      ),
    );
}
