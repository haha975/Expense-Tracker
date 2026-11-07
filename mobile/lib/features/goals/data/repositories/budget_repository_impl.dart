import '../../domain/entities/budget_category_entity.dart';
import '../../domain/repositories/budget_repository.dart';
import '../datasources/budget_local_data_source.dart';

class BudgetRepositoryImpl implements BudgetRepository {
  final BudgetLocalDataSource localDataSource;

  BudgetRepositoryImpl({
    required this.localDataSource,
  });

  @override
  Future<List<BudgetCategoryEntity>> getBudgetCategories() {
    return localDataSource.getBudgetCategories();
  }
}