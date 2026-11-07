
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/transaction.dart';
import '../bloc/transaction_cubit.dart';

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  bool isExpense = true;

  DateTime selectedDate = DateTime.now();
  String selectedCategory = 'Food & dining';
  String selectedCurrency = 'US Dollar';
  String selectedAccount = 'Main account';

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _merchantController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  final List<Map<String, dynamic>> categories = [
    {'name': 'Food & dining', 'icon': Icons.restaurant},
    {'name': 'Shopping', 'icon': Icons.shopping_bag_outlined},
    {'name': 'Transport', 'icon': Icons.directions_car_outlined},
    {'name': 'Housing', 'icon': Icons.home_outlined},
    {'name': 'Subscriptions', 'icon': Icons.sync},
    {'name': 'Other', 'icon': Icons.more_horiz},
  ];

  final List<String> currencies = [
    'US Dollar',
    'Ethiopian Birr',
    'Euro',
    'British Pound',
    'Canadian Dollar',
    'Kenyan Shilling',
  ];

  final List<String> accounts = [
    'Main account',
    'Cash',
    'Bank account',
    'Savings account',
    'Mobile money',
  ];

  static const Color _background = Color(0xFF0F0F13);
  static const Color _surface = Color(0xFF191922);
  static const Color _purple = Color(0xFF9C6BFF);

  @override
  void dispose() {
    _amountController.dispose();
    _merchantController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];

    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: _purple,
              surface: _surface,
            ),
            dialogTheme: const DialogThemeData(
              backgroundColor: _background,
            ),
          ),
          child: child!,
        );
      },
    );

    if (!mounted || picked == null) return;

    setState(() {
      selectedDate = picked;
    });
  }

  Future<void> _chooseOption({
    required String title,
    required List<String> options,
    required String currentValue,
    required ValueChanged<String> onSelected,
  }) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: _surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ...options.map((option) {
                  final selected = option == currentValue;

                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      option,
                      style: TextStyle(
                        color: selected ? _purple : Colors.white,
                      ),
                    ),
                    trailing: selected
                        ? const Icon(Icons.check, color: _purple)
                        : const Icon(
                            Icons.chevron_right,
                            color: Colors.grey,
                          ),
                    onTap: () => Navigator.of(sheetContext).pop(option),
                  );
                }),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );

    if (!mounted || result == null) return;

    setState(() {
      onSelected(result);
    });
  }

  Future<void> _manageCategories() async {
    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return SimpleDialog(
          backgroundColor: _surface,
          title: const Text(
            'Choose a category',
            style: TextStyle(color: Colors.white),
          ),
          children: categories.map((category) {
            final name = category['name'] as String;

            return SimpleDialogOption(
              onPressed: () => Navigator.pop(dialogContext, name),
              child: Row(
                children: [
                  Icon(
                    category['icon'] as IconData,
                    color: name == selectedCategory ? _purple : Colors.grey,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      name,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  if (name == selectedCategory)
                    const Icon(Icons.check, color: _purple),
                ],
              ),
            );
          }).toList(),
        );
      },
    );

    if (!mounted || result == null) return;

    setState(() {
      selectedCategory = result;
    });
  }

  Future<void> _saveTransaction() async {
    final title = _merchantController.text.trim();
    final amountText = _amountController.text.trim().replaceAll(',', '');
    final enteredAmount = double.tryParse(amountText);

    if (title.isEmpty ||
        enteredAmount == null ||
        !enteredAmount.isFinite ||
        enteredAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter a valid positive amount and transaction title.'),
        ),
      );
      return;
    }

    final now = DateTime.now();

    final transaction = TransactionEntity(
      id: now.microsecondsSinceEpoch.toString(),
      title: title,
      category: selectedCategory,
      time:
          '${now.hour.toString().padLeft(2, '0')}:'
          '${now.minute.toString().padLeft(2, '0')}',
      amount: isExpense ? -enteredAmount : enteredAmount,
      date: selectedDate,
      type: isExpense ? TransactionType.expense : TransactionType.income,
      syncStatus: SyncStatus.pending,
    );

    context.read<TransactionCubit>().addTransaction(transaction);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'NEW ENTRY',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            Text(
              'Add transaction',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),

                    // Expense / Income selector
                    Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: _surface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          _typeButton('Expense', true),
                          _typeButton('Income', false),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Amount
                    Center(
                      child: Column(
                        children: [
                          Text(
                            '${isExpense ? 'Expense' : 'Income'} amount · '
                            '${_currencyCode()}',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 4),
                          SizedBox(
                            width: 240,
                            child: TextField(
                              controller: _amountController,
                              textAlign: TextAlign.center,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: const InputDecoration(
                                hintText: '0.00',
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () => _chooseOption(
                              title: 'Choose currency',
                              options: currencies,
                              currentValue: selectedCurrency,
                              onSelected: (value) {
                                selectedCurrency = value;
                              },
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    selectedCurrency,
                                    style: const TextStyle(
                                      color: _purple,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.keyboard_arrow_down,
                                    color: _purple,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    _sectionLabel('Merchant / title'),
                    const SizedBox(height: 8),
                    _textField(
                      controller: _merchantController,
                      hint: 'e.g. Grocery shopping',
                    ),
                    const SizedBox(height: 20),

                    // Category
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _sectionLabel('Category'),
                        TextButton(
                          onPressed: _manageCategories,
                          child: const Text(
                            'Manage',
                            style: TextStyle(color: _purple),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: categories.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 1.2,
                      ),
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        final name = category['name'] as String;
                        final selected = selectedCategory == name;

                        return InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            setState(() => selectedCategory = name);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: _surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: selected
                                    ? _purple
                                    : Colors.transparent,
                                width: 1.5,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  category['icon'] as IconData,
                                  color: selected ? _purple : Colors.grey,
                                  size: 22,
                                ),
                                const SizedBox(height: 6),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 2),
                                  child: Text(
                                    name,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color:
                                          selected ? Colors.white : Colors.grey,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),

                    // Date and account
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _selectionField(
                            label: 'Date',
                            value: _formatDate(selectedDate),
                            icon: Icons.calendar_today_outlined,
                            onTap: _pickDate,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _selectionField(
                            label: 'Account',
                            value: selectedAccount,
                            icon: Icons.keyboard_arrow_down,
                            onTap: () => _chooseOption(
                              title: 'Choose account',
                              options: accounts,
                              currentValue: selectedAccount,
                              onSelected: (value) {
                                selectedAccount = value;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    _sectionLabel('Note (optional)'),
                    const SizedBox(height: 8),
                    _textField(
                      controller: _noteController,
                      hint: 'Add a note',
                      maxLines: 2,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Saved on this device first. Syncs when you are online.',
                      style: TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Save button
            Container(
              padding: const EdgeInsets.all(16),
              color: _background,
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _saveTransaction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _purple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    isExpense ? 'Save expense' : 'Save income',
                    style: const TextStyle(
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
  }

  Widget _typeButton(String label, bool expenseButton) {
    final selected = isExpense == expenseButton;

    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => setState(() => isExpense = expenseButton),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF242433) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String label) {
    return Text(
      label,
      style: const TextStyle(color: Colors.grey, fontSize: 13),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Widget _selectionField({
    required String label,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel(label),
        const SizedBox(height: 8),
        Material(
          color: _surface,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      value,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Icon(icon, color: Colors.grey, size: 18),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _currencyCode() {
    switch (selectedCurrency) {
      case 'US Dollar':
        return 'USD';
      case 'Ethiopian Birr':
        return 'ETB';
      case 'Euro':
        return 'EUR';
      case 'British Pound':
        return 'GBP';
      case 'Canadian Dollar':
        return 'CAD';
      case 'Kenyan Shilling':
        return 'KES';
      default:
        return 'USD';
    }
  }
}
