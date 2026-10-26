import 'package:flutter/material.dart';
import 'package:shop/view/desktop/widget/form_dialog.dart';

class CouponsScreen extends StatefulWidget {
  const CouponsScreen({super.key});

  @override
  State<CouponsScreen> createState() => _CouponsScreenState();
}

class _CouponsScreenState extends State<CouponsScreen> {
  String _selectedType = 'Percentage';

  void _showAddCouponForm() {
    final codeController = TextEditingController();
    final discountController = TextEditingController();
    final minOrderController = TextEditingController();
    final maxDiscountController = TextEditingController();
    final expiryDateController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => FormDialog(
          title: 'Create Coupon',
          saveButtonText: 'Create Coupon',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                label: 'Coupon Code',
                hintText: 'e.g., SAVE20',
                controller: codeController,
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Discount Type',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _TypeOption('Percentage', _selectedType == 'Percentage', () {
                        setDialogState(() {
                          _selectedType = 'Percentage';
                        });
                      }),
                      const SizedBox(width: 12),
                      _TypeOption('Flat', _selectedType == 'Flat', () {
                        setDialogState(() {
                          _selectedType = 'Flat';
                        });
                      }),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      label: 'Discount Value',
                      hintText: _selectedType == 'Percentage' ? '10' : '50',
                      controller: discountController,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomTextField(
                      label: 'Min Order',
                      hintText: '₹0',
                      controller: minOrderController,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (_selectedType == 'Percentage')
                CustomTextField(
                  label: 'Max Discount (Optional)',
                  hintText: '₹200',
                  controller: maxDiscountController,
                  keyboardType: TextInputType.number,
                ),
              if (_selectedType == 'Percentage') const SizedBox(height: 16),
              CustomTextField(
                label: 'Expiry Date',
                hintText: 'YYYY-MM-DD',
                controller: expiryDateController,
                keyboardType: TextInputType.datetime,
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

  static const List<Map<String, dynamic>> _coupons = [
    {
      'code': 'SAVE10',
      'discount': '10%',
      'type': 'Percentage',
      'minOrder': '₹500',
      'maxDiscount': '₹200',
      'usageCount': 156,
      'expiryDate': '2024-06-30',
      'status': 'active',
    },
    {
      'code': 'FLAT50',
      'discount': '₹50',
      'type': 'Flat',
      'minOrder': '₹1000',
      'maxDiscount': '₹50',
      'usageCount': 89,
      'expiryDate': '2024-05-15',
      'status': 'active',
    },
    {
      'code': 'FIRST20',
      'discount': '20%',
      'type': 'Percentage',
      'minOrder': '₹1',
      'maxDiscount': '₹500',
      'usageCount': 423,
      'expiryDate': '2024-12-31',
      'status': 'active',
    },
    {
      'code': 'EXPIRED10',
      'discount': '10%',
      'type': 'Percentage',
      'minOrder': '₹500',
      'maxDiscount': '₹200',
      'usageCount': 234,
      'expiryDate': '2024-04-01',
      'status': 'expired',
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
                'Coupons Management',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              ElevatedButton.icon(
                onPressed: _showAddCouponForm,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Create Coupon', style: TextStyle(fontSize: 13)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
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
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 2.2,
              ),
              itemCount: _coupons.length,
              itemBuilder: (context, index) {
                final coupon = _coupons[index];
                final isActive = coupon['status'] == 'active';
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
                  child: Row(
                    children: [
                      Container(
                        width: 120,
                        decoration: BoxDecoration(
                          color: isActive ? const Color(0xFF2E7D32) : Colors.grey[400],
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(14),
                            bottomLeft: Radius.circular(14),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              coupon['discount'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'OFF',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      coupon['code'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: isActive ? const Color(0xFF2E7D32).withOpacity(0.1) : const Color(0xFFC62828).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      isActive ? 'Active' : 'Expired',
                                      style: TextStyle(
                                        color: isActive ? const Color(0xFF2E7D32) : const Color(0xFFC62828),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Icon(Icons.shopping_bag_outlined, size: 16, color: Colors.grey[600]),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Min Order: ${coupon['minOrder']}',
                                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Expires: ${coupon['expiryDate']}',
                                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Icon(Icons.people_outline, size: 16, color: Colors.grey[600]),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Used: ${coupon['usageCount']} times',
                                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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

class _TypeOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TypeOption(this.label, this.isSelected, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF2E7D32).withOpacity(0.1) : Colors.grey[100],
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: isSelected ? const Color(0xFF2E7D32) : Colors.transparent),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? const Color(0xFF2E7D32) : Colors.grey[700],
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}
