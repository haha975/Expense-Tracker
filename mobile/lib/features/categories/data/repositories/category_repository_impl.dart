import '../../domain/entities/category_entity.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/category_local_data_source.dart';
import '../models/category_model.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryLocalDataSource localDataSource;

  CategoryRepositoryImpl({required this.localDataSource});

  @override
  Future<List<CategoryEntity>> getCategories() async {
    return await localDataSource.getCategories();
  }

  @override
  Future<void> addCategory(CategoryEntity category) async {
    final model = CategoryModel.fromEntity(category);
    await localDataSource.cacheCategory(model);
  }
}