import 'package:flutter/material.dart';
import '../../data/datasources/category_local_data_source.dart';
import '../../data/repositories/category_repository_impl.dart';
import '../../domain/entities/category_entity.dart';
import '../provider/category_provider.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  late final CategoryProvider _provider;

  @override
  void initState() {
    super.initState();
    final dataSource = CategoryLocalDataSourceImpl();
    final repository = CategoryRepositoryImpl(localDataSource: dataSource);
    _provider = CategoryProvider(repository: repository);
  }

  @override
  void dispose() {
    _provider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _provider,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: const Color(0xFF0F0F13),
          body: SafeArea(
            child: Column(
              children: [
                // Header Navigation
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () => Navigator.of(context).maybePop(),
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            'SETTINGS / ORGANIZATION',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.1,
                            ),
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 12),
                        child: Text(
                          'Categories',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Segmented Tabs
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Container(
                    height: 46,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A22),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _provider.setTab(CategoryType.expense),
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: _provider.selectedTab == CategoryType.expense
                                    ? const Color(0xFF262635)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Text(
                                'Expense categories',
                                style: TextStyle(
                                  color: _provider.selectedTab == CategoryType.expense
                                      ? Colors.white
                                      : Colors.grey,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _provider.setTab(CategoryType.income),
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: _provider.selectedTab == CategoryType.income
                                    ? const Color(0xFF262635)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Text(
                                'Income categories',
                                style: TextStyle(
                                  color: _provider.selectedTab == CategoryType.income
                                      ? Colors.white
                                      : Colors.grey,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Scrollable Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Custom Categories Header & Counter
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Custom categories',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${_provider.categories.length} categories',
                              style: const TextStyle(
                                color: Color(0xFF9D84ED),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // List of Custom Categories
                        ..._provider.categories.map((cat) => Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF171721),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: ListTile(
                                leading: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: cat.color.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(cat.icon, color: cat.color, size: 20),
                                ),
                                title: Text(
                                  cat.name,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15),
                                ),
                                subtitle: Text(
                                  '${cat.transactionCount} transactions',
                                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                                ),
                                trailing: const Icon(Icons.edit_outlined, color: Colors.grey, size: 20),
                              ),
                            )),

                        const SizedBox(height: 12),

                        // New Category Input Draft Card
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF171721),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFF5B34E3), width: 1.5),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'New category',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'DRAFT',
                                    style: TextStyle(
                                        color: Color(0xFF9D84ED),
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Category name',
                                style: TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                              const SizedBox(height: 6),
                              TextField(
                                controller: _provider.nameController,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xFF111118),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Choose an icon',
                                style: TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                              const SizedBox(height: 10),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: _provider.availableIcons.map((icon) {
                                    final isSelected = _provider.selectedIcon == icon;
                                    return GestureDetector(
                                      onTap: () => _provider.selectIcon(icon),
                                      child: Container(
                                        margin: const EdgeInsets.only(right: 10),
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF111118),
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                            color: isSelected
                                                ? const Color(0xFF8B5CF6)
                                                : Colors.transparent,
                                            width: 1.5,
                                          ),
                                        ),
                                        child: Icon(
                                          icon,
                                          color: isSelected ? const Color(0xFF9D84ED) : Colors.grey,
                                          size: 22,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Row(
                                children: [
                                  CircleAvatar(radius: 4, backgroundColor: Color(0xFF8B5CF6)),
                                  SizedBox(width: 8),
                                  Text(
                                    'Violet · Expense category',
                                    style: TextStyle(color: Colors.grey, fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Default Categories Card
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF171721),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const ListTile(
                            leading: Icon(Icons.layers_outlined, color: Colors.white, size: 22),
                            title: Text(
                              'Default categories',
                              style: TextStyle(
                                  color: Colors.white, fontWeight: FontWeight.w500, fontSize: 15),
                            ),
                            subtitle: Text(
                              '6 expense categories · 1 income category',
                              style: TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                            trailing: Icon(Icons.chevron_right, color: Colors.grey),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Footer syncing text
                        const Center(
                          child: Text(
                            'Your categories stay with you on every synced device.',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),

                // Bottom CTA Button Container
                Container(
                  padding: const EdgeInsets.all(16),
                  color: const Color(0xFF0F0F13),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () => _provider.createCategory(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8B5CF6),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Create category',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}