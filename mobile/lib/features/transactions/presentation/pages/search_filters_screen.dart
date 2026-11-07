import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Optional, but makes date formatting easy

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Search & Filters',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F0E13),
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFF9D65FF),
          surface: const Color(0xFF1B1A22),
        ),
      ),
      home: const SearchAndFiltersScreen(),
    );
  }
}

class TransactionModel {
  final String title;
  final String category;
  final DateTime date;
  final double amount;
  final bool isExpense;
  final IconData icon;

  TransactionModel({
    required this.title,
    required this.category,
    required this.date,
    required this.amount,
    required this.isExpense,
    required this.icon,
  });
}

class SearchAndFiltersScreen extends StatefulWidget {
  const SearchAndFiltersScreen({super.key});

  @override
  State<SearchAndFiltersScreen> createState() => _SearchAndFiltersScreenState();
}

class _SearchAndFiltersScreenState extends State<SearchAndFiltersScreen> {
  // Controllers & State
  final TextEditingController _searchController = TextEditingController(text: 'market');
  final TextEditingController _minAmountController = TextEditingController(text: '0.00');
  final TextEditingController _maxAmountController = TextEditingController(text: '100.00');

  String _selectedType = 'Expenses'; // 'All types', 'Expenses', 'Income'
  String _selectedCategory = 'Food & dining'; // 'Food & dining', 'Shopping', 'Transport'
  
  // Date Range State
  DateTime _startDate = DateTime(2026, 10, 1);
  DateTime _endDate = DateTime(2026, 10, 8);

  // Mock Transactions Data
  final List<TransactionModel> _allTransactions = [
    TransactionModel(
      title: 'Whole Foods Market',
      category: 'Food & dining',
      date: DateTime(2026, 10, 8),
      amount: 84.50,
      isExpense: true,
      icon: Icons.shopping_basket_outlined,
    ),
    TransactionModel(
      title: 'Farmers Market',
      category: 'Food & dining',
      date: DateTime(2026, 10, 2),
      amount: 70.00,
      isExpense: true,
      icon: Icons.eco_outlined,
    ),
    TransactionModel(
      title: 'Target Shopping',
      category: 'Shopping',
      date: DateTime(2026, 10, 5),
      amount: 45.20,
      isExpense: true,
      icon: Icons.shopping_bag_outlined,
    ),
    TransactionModel(
      title: 'Monthly Salary',
      category: 'Income',
      date: DateTime(2026, 10, 1),
      amount: 2500.00,
      isExpense: false,
      icon: Icons.account_balance_wallet_outlined,
    ),
  ];

  // Open Date Range Picker
  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF9D65FF),
              onPrimary: Colors.white,
              surface: Color(0xFF1B1A22),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  // Filter Logic
  List<TransactionModel> get _filteredTransactions {
    double minAmount = double.tryParse(_minAmountController.text) ?? 0.0;
    double maxAmount = double.tryParse(_maxAmountController.text) ?? double.infinity;

    return _allTransactions.where((tx) {
      // Search query filter
      final matchesSearch = tx.title.toLowerCase().contains(_searchController.text.toLowerCase());
      
      // Type filter
      bool matchesType = true;
      if (_selectedType == 'Expenses') {
        matchesType = tx.isExpense;
      } else if (_selectedType == 'Income') {
        matchesType = !tx.isExpense;
      }

      // Category filter
      final matchesCategory = _selectedCategory.isEmpty || tx.category == _selectedCategory;

      // Date range filter
      // Normalize dates to ignore time component
      final txDate = DateTime(tx.date.year, tx.date.month, tx.date.day);
      final start = DateTime(_startDate.year, _startDate.month, _startDate.day);
      final end = DateTime(_endDate.year, _endDate.month, _endDate.day);
      final matchesDate = (txDate.isAtSameMomentAs(start) || txDate.isAfter(start)) &&
                          (txDate.isAtSameMomentAs(end) || txDate.isBefore(end));

      // Amount range filter
      final matchesAmount = tx.amount >= minAmount && tx.amount <= maxAmount;

      return matchesSearch && matchesType && matchesCategory && matchesDate && matchesAmount;
    }).toList();
  }

  double get _totalFilteredAmount {
    return _filteredTransactions.fold(0.0, (sum, item) => sum + item.amount);
  }

  void _resetAll() {
    setState(() {
      _searchController.clear();
      _minAmountController.text = '0.00';
      _maxAmountController.text = '100.00';
      _selectedType = 'All types';
      _selectedCategory = '';
      _startDate = DateTime(2026, 10, 1);
      _endDate = DateTime(2026, 10, 8);
    });
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredTransactions;
    final dateFormat = DateFormat('MMM d');
    final dateRangeString = '${dateFormat.format(_startDate)} – ${dateFormat.format(_endDate)}, ${_endDate.year}';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0E13),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'TRANSACTIONS',
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Search & filters',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: CircleAvatar(
              backgroundColor: const Color(0xFF222129),
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 18),
                onPressed: () => Navigator.maybePop(context),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            TextField(
              controller: _searchController,
              onChanged: (val) => setState(() {}),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search...',
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Color(0xFF9D65FF)),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey, size: 18),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {});
                  },
                ),
                filled: true,
                fillColor: const Color(0xFF1B1A22),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Colors.purple.shade900.withOpacity(0.4)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Colors.purple.shade900.withOpacity(0.4)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFF9D65FF), width: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Filters Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filters',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                GestureDetector(
                  onTap: _resetAll,
                  child: const Text(
                    'Reset all',
                    style: TextStyle(fontSize: 14, color: Color(0xFF9D65FF), fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Segmented Type Selector
            Container(
              height: 48,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFF1B1A22),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: ['All types', 'Expenses', 'Income'].map((type) {
                  final isSelected = _selectedType == type;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedType = type),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF2C2A36) : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          type,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.grey,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),

            // Date Range Section (Interactive)
            const Text('Date range', style: TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _selectDateRange(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B1A22),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(dateRangeString, style: const TextStyle(color: Colors.white, fontSize: 14)),
                    const Icon(Icons.calendar_today_outlined, color: Colors.grey, size: 18),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Category Section
            const Text('Category', style: TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: ['Food & dining', 'Shopping', 'Transport'].map((category) {
                final isSelected = _selectedCategory == category;
                return ChoiceChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(category),
                      if (isSelected) ...[
                        const SizedBox(width: 6),
                        const Icon(Icons.check, size: 14, color: Colors.white),
                      ]
                    ],
                  ),
                  selected: isSelected,
                  selectedColor: const Color(0xFF32274A),
                  backgroundColor: const Color(0xFF1B1A22),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey.shade400,
                    fontSize: 13,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: isSelected ? const Color(0xFF9D65FF) : Colors.white10,
                    ),
                  ),
                  onSelected: (selected) {
                    setState(() {
                      _selectedCategory = selected ? category : '';
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Minimum & Maximum Amount Row (Interactive TextFields)
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Minimum amount', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _minAmountController,
                        onChanged: (val) => setState(() {}),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          prefixText: '\$',
                          prefixStyle: const TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: const Color(0xFF1B1A22),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Maximum amount', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _maxAmountController,
                        onChanged: (val) => setState(() {}),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          prefixText: '\$',
                          prefixStyle: const TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: const Color(0xFF1B1A22),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Matches counter & Sorting
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${filtered.length} matches · \$${_totalFilteredAmount.toStringAsFixed(2)}',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const Text(
                  'Newest first',
                  style: TextStyle(color: Color(0xFF9D65FF), fontWeight: FontWeight.w600, fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Transactions List View
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filtered.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final tx = filtered[index];
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1B1A22),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2C2A36),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(tx.icon, color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tx.title,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              '${tx.category} · ${dateFormat.format(tx.date)}',
                              style: const TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${tx.isExpense ? '-' : '+'}\$${tx.amount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 20),

            // Footer info text
            const Center(
              child: Text(
                'Searching merchant names and notes in your saved transactions.',
                style: TextStyle(color: Colors.grey, fontSize: 11),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      // Sticky Bottom Action Button safely placed above system navigation
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          color: const Color(0xFF0F0E13),
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9D65FF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              onPressed: () {
                // Handle submission with filtered transactions list
              },
              child: Text(
                'Show ${filtered.length} transactions',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}