import 'package:flutter/material.dart';
import 'package:shop/view/desktop/widget/form_dialog.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  IconData? _selectedIcon;

  void _showAddCategoryForm() {
    final nameController = TextEditingController();
    _selectedIcon = Icons.eco;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => FormDialog(
          title: 'Add New Category',
          saveButtonText: 'Create Category',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                label: 'Category Name',
                hintText: 'Enter category name',
                controller: nameController,
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Icon',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _IconOption(Icons.eco, _selectedIcon == Icons.eco, () {
                        setDialogState(() {
                          _selectedIcon = Icons.eco;
                        });
                      }),
                      _IconOption(
                        Icons.bug_report,
                        _selectedIcon == Icons.bug_report,
                        () {
                          setDialogState(() {
                            _selectedIcon = Icons.bug_report;
                          });
                        },
                      ),
                      _IconOption(
                        Icons.grass,
                        _selectedIcon == Icons.grass,
                        () {
                          setDialogState(() {
                            _selectedIcon = Icons.grass;
                          });
                        },
                      ),
                      _IconOption(
                        Icons.build,
                        _selectedIcon == Icons.build,
                        () {
                          setDialogState(() {
                            _selectedIcon = Icons.build;
                          });
                        },
                      ),
                      _IconOption(Icons.pets, _selectedIcon == Icons.pets, () {
                        setDialogState(() {
                          _selectedIcon = Icons.pets;
                        });
                      }),
                      _IconOption(
                        Icons.agriculture,
                        _selectedIcon == Icons.agriculture,
                        () {
                          setDialogState(() {
                            _selectedIcon = Icons.agriculture;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          onSave: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  static const List<Map<String, dynamic>> _categories = [
    {
      'id': 'fertilizer',
      'title': 'Fertilizers',
      'icon': Icons.eco,
      'color': Color(0xFF2E7D32),
      'bgColor': Color(0xFFE8F5E9),
      'productCount': 45,
    },
    {
      'id': 'pesticide',
      'title': 'Pesticides',
      'icon': Icons.bug_report,
      'color': Color(0xFFFF9800),
      'bgColor': Color(0xFFFFF3E0),
      'productCount': 28,
    },
    {
      'id': 'seeds',
      'title': 'Seeds',
      'icon': Icons.grass,
      'color': Color(0xFF8BC34A),
      'bgColor': Color(0xFFF1F8E9),
      'productCount': 62,
    },
    {
      'id': 'tools',
      'title': 'Tools',
      'icon': Icons.build,
      'color': Color(0xFF795548),
      'bgColor': Color(0xFFEFEBE9),
      'productCount': 35,
    },
    {
      'id': 'organic',
      'title': 'Organic',
      'icon': Icons.eco_rounded,
      'color': Color(0xFFFF5722),
      'bgColor': Color(0xFFFBE9E7),
      'productCount': 18,
    },
    {
      'id': 'cattle',
      'title': 'Cattle Feed',
      'icon': Icons.pets,
      'color': Color(0xFFFFC107),
      'bgColor': Color(0xFFFFF8E1),
      'productCount': 22,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F6FA),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Categories Management',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              ElevatedButton.icon(
                onPressed: _showAddCategoryForm,
                icon: const Icon(Icons.add, size: 18),
                label: const Text(
                  'Add Category',
                  style: TextStyle(fontSize: 13),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 1.5,
              ),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: category['bgColor'],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                category['icon'],
                                color: category['color'],
                                size: 28,
                              ),
                            ),
                            PopupMenuButton(
                              icon: const Icon(
                                Icons.more_vert,
                                color: Colors.grey,
                              ),
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  child: ListTile(
                                    leading: Icon(Icons.edit, size: 18),
                                    title: Text(
                                      'Edit',
                                      style: TextStyle(fontSize: 13),
                                    ),
                                  ),
                                ),
                                const PopupMenuItem(
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.delete,
                                      size: 18,
                                      color: Colors.red,
                                    ),
                                    title: Text(
                                      'Delete',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          category['title'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${category['productCount']} Products',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _IconOption extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _IconOption(this.icon, this.isSelected, this.onTap);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF2E7D32).withOpacity(0.1)
              : Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? const Color(0xFF2E7D32) : Colors.transparent,
          ),
        ),
        child: Icon(
          icon,
          color: isSelected ? const Color(0xFF2E7D32) : Colors.grey[600],
          size: 24,
        ),
      ),
    );
  }
}
