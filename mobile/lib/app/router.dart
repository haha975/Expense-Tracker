import 'package:go_router/go_router.dart';


import 'package:mobile/core/constants/route_paths.dart';


import 'package:mobile/features/onboarding/presentation/pages/splash_onboarding_page.dart';
import 'package:mobile/features/onboarding/presentation/pages/welcome_page.dart';

import 'package:mobile/features/auth/presentation/pages/login_page.dart';
import 'package:mobile/features/auth/presentation/pages/create_account_page.dart';
import 'package:mobile/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:mobile/features/auth/presentation/pages/verify_email_page.dart';
import 'package:mobile/features/auth/presentation/pages/set_new_password_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mobile/app/di/injection.dart';
import 'package:mobile/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:mobile/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:mobile/features/dashboard/presentation/pages/dashboard_page.dart';

import 'package:mobile/features/budgets/presentation/pages/budget_detail_page.dart';
import 'package:mobile/features/budgets/presentation/bloc/budget_detail_bloc.dart';
import 'package:mobile/features/budgets/domain/usecases/get_budget_detail.dart';
import 'package:mobile/features/budgets/data/repositories/budget_repository_impl.dart';
final GoRouter appRouter = GoRouter(
  initialLocation: RoutePaths.home,
  routes: [
    GoRoute(
      path: RoutePaths.splash,
      builder: (context, state) => const SplashOnboardingPage(),
    ),
    GoRoute(
      path: RoutePaths.welcome,
      builder: (context, state) => const WelcomePage(),
    ),

    // Authentication routes
    GoRoute(
      path: RoutePaths.login,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: RoutePaths.register,
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: RoutePaths.forgotPassword,
      builder: (context, state) => const ForgotPasswordPage(),
    ),
    GoRoute(
      path: RoutePaths.verifyEmail,
      builder: (context, state) => const EmailVerificationPage(),
    ),
    GoRoute(
      path: RoutePaths.resetPassword,
      builder: (context, state) => const ResetPasswordPage(),
    ),

    // Temporary destination until the home feature is implemented
        GoRoute(
      path: RoutePaths.home,
      builder: (context, state) => BlocProvider<DashboardBloc>(
        create: (_) => getIt<DashboardBloc>()
          ..add(LoadDashboardSummaryEvent()),
        child: const DashboardPage(),
      ),
    ),
    GoRoute(
  path: '/budget-detail',
  builder: (context, state) {
    return BlocProvider<BudgetDetailBloc>(
      create: (_) => BudgetDetailBloc(
        getBudgetDetail: GetBudgetDetail(
          BudgetRepositoryImpl(),
        ),
      )..add(LoadBudgetDetail('food')),
      child: const BudgetDetailPage(),
    );
  },
),
  ],
);

