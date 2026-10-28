import 'package:shop/features/daily/voice_entry_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:shop/config/theme/app_theme.dart';
import 'package:shop/model/khata_model.dart';
import 'package:shop/services/farmer_profile_service.dart';

class KhataScreen extends StatefulWidget {
  const KhataScreen({super.key});

  @override
  State<KhataScreen> createState() => _KhataScreenState();
}

class _KhataScreenState extends State<KhataScreen> {
  final _service = FarmerProfileService();
  String _selectedFilter = 'सभी (All)';

  final List<String> _filters = ['सभी (All)', 'खर्च (Kharcha)', 'कमाई (Kamai)'];

  @override
  void initState() {
    super.initState();
    _service.addListener(_onServiceUpdate);
  }

  @override
  void dispose() {
    _service.removeListener(_onServiceUpdate);
    super.dispose();
  }

  void _onServiceUpdate() {
    if (mounted) setState(() {});
  }

  // --- Voice Input Bottom Sheet Modal ---
  void _showVoiceInputDialog() => showVoiceEntry(context);

  // --- Manual Add Entry Dialog ---
  void _showAddManualEntryDialog() {
    KhataType selectedType = KhataType.kharcha;
    String selectedCategory = 'खाद व उर्वरक';
    final amountController = TextEditingController();
    final noteController = TextEditingController();

    final kharchaCategories = [
      'खाद व उर्वरक',
      'बीज (Seeds)',
      'डीजल व मशीन',
      'मजदूरी (Labour)',
      'कीटनाशक व स्प्रे',
      'सिंचाई व बिजली',
      'अन्य खर्च',
    ];

    final kamaiCategories = [
      'फसल बिक्री',
      'दूध बिक्री',
      'ट्रैक्टर/मशीन किराया',
      'सरकारी सब्सिडी',
      'अन्य आमदनी',
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final categories = selectedType == KhataType.kharcha
                ? kharchaCategories
                : kamaiCategories;
            return Padding(
              padding: EdgeInsets.only(
                left: 20.w,
                right: 20.w,
                top: 20.h,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24.h,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'खाते में नई प्रविष्टि जोड़ें',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),

                  // Type Selector: Kharcha or Kamai
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setModalState(() {
                              selectedType = KhataType.kharcha;
                              selectedCategory = kharchaCategories[0];
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            decoration: BoxDecoration(
                              color: selectedType == KhataType.kharcha
                                  ? AppTheme.error.withValues(alpha: 0.15)
                                  : Colors.grey[100],
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: selectedType == KhataType.kharcha
                                    ? AppTheme.error
                                    : Colors.transparent,
                                width: 1.5,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '➖ खर्च (Expense)',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: selectedType == KhataType.kharcha
                                      ? AppTheme.error
                                      : Colors.grey[700],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setModalState(() {
                              selectedType = KhataType.kamai;
                              selectedCategory = kamaiCategories[0];
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            decoration: BoxDecoration(
                              color: selectedType == KhataType.kamai
                                  ? AppTheme.success.withValues(alpha: 0.15)
                                  : Colors.grey[100],
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: selectedType == KhataType.kamai
                                    ? AppTheme.success
                                    : Colors.transparent,
                                width: 1.5,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '➕ कमाई (Income)',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: selectedType == KhataType.kamai
                                      ? AppTheme.success
                                      : Colors.grey[700],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16.h),

                  // Amount Input
                  Text(
                    'रकम दर्ज करें (Amount ₹):',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      prefixText: '₹ ',
                      hintText: '1000',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),

                  SizedBox(height: 14.h),

                  // Category Selector
                  Text(
                    'श्रेणी चुनें (Category):',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  DropdownButtonFormField<String>(
                    initialValue: selectedCategory,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 12.h,
                      ),
                    ),
                    items: categories.map((cat) {
                      return DropdownMenuItem<String>(
                        value: cat,
                        child: Text(cat),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setModalState(() => selectedCategory = val);
                      }
                    },
                  ),

                  SizedBox(height: 14.h),

                  // Notes Input
                  Text(
                    'विवरण (Note / Crop):',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  TextField(
                    controller: noteController,
                    decoration: InputDecoration(
                      hintText: 'उदा. यूरिया 2 बैग या गेहूं 10 क्विंटल',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),

                  SizedBox(height: 20.h),

                  SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      onPressed: () {
                        final amt = double.tryParse(amountController.text) ?? 0;
                        if (!amt.isFinite || amt <= 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('कृपया सही रकम दर्ज करें'),
                            ),
                          );
                          return;
                        }

                        final entry = KhataEntryModel(
                          id: 'khata_${DateTime.now().microsecondsSinceEpoch}',
                          title: noteController.text.trim().isEmpty
                              ? selectedCategory
                              : noteController.text.trim(),
                          category: selectedCategory,
                          amount: amt,
                          type: selectedType,
                          date: DateTime.now(),
                          note: noteController.text.trim(),
                        );
                        _service.addKhataEntry(entry);
                        Navigator.pop(context);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '₹${amt.toStringAsFixed(0)} ${selectedType == KhataType.kharcha ? "खर्च" : "कमाई"} खाते में जुड़ा!',
                            ),
                            backgroundColor: AppTheme.success,
                          ),
                        );
                      },
                      child: Text(
                        'खाते में सहेजें (Save to Khata)',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredEntries = _selectedFilter == 'सभी (All)'
        ? _service.khataEntries
        : (_selectedFilter == 'खर्च (Kharcha)'
              ? _service.khataEntries.where((e) => e.isKharcha).toList()
              : _service.khataEntries.where((e) => e.isKamai).toList());

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('किसान दैनिक खाता'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.mic, color: AppTheme.primaryColor),
            tooltip: 'बोलकर लिखें',
            onPressed: _showVoiceInputDialog,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'नया जोड़ें',
            onPressed: _showAddManualEntryDialog,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Balance Summary Card (कुल खर्च, कुल कमाई, बचत)
            _buildKhataSummaryCard(),

            SizedBox(height: 16.h),

            // 2. Big Voice Input CTA Card
            _buildVoiceInputBanner(),

            SizedBox(height: 16.h),

            // 3. Filter Chips
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: _filters.map((f) {
                    final isSel = _selectedFilter == f;
                    return Padding(
                      padding: EdgeInsets.only(right: 8.w),
                      child: ChoiceChip(
                        label: Text(f),
                        selected: isSel,
                        selectedColor: AppTheme.primaryColor,
                        backgroundColor: Colors.white,
                        side: BorderSide(
                          color: isSel
                              ? AppTheme.primaryColor
                              : const Color(0xFFE0E0E0),
                        ),
                        labelStyle: TextStyle(
                          color: isSel ? Colors.white : AppTheme.textPrimary,
                          fontWeight: isSel
                              ? FontWeight.bold
                              : FontWeight.normal,
                          fontSize: 12.sp,
                        ),
                        onSelected: (val) {
                          if (val) setState(() => _selectedFilter = f);
                        },
                      ),
                    );
                  }).toList(),
                ),
                Text(
                  '${filteredEntries.length} एंट्री',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),

            SizedBox(height: 12.h),

            // 4. Entries List
            if (filteredEntries.isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 40.h),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.menu_book,
                        size: 50.sp,
                        color: Colors.grey[400],
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        'इस श्रेणी में कोई एंट्री नहीं है',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              ...filteredEntries.map((e) => _buildKhataEntryTile(e)),

            SizedBox(height: 70.h),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppTheme.primaryColor,
        icon: const Icon(Icons.mic, color: Colors.white),
        label: Text(
          'बोलकर लिखें 🎙️',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 13.sp,
          ),
        ),
        onPressed: _showVoiceInputDialog,
      ),
    );
  }

  Widget _buildKhataSummaryCard() {
    final currency = NumberFormat.currency(
      locale: 'HI',
      symbol: '₹',
      decimalDigits: 0,
    );

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'अक्टूबर माह का हिसाब',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondary,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: _service.netMunafa >= 0
                      ? AppTheme.success.withValues(alpha: 0.15)
                      : AppTheme.error.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  _service.netMunafa >= 0 ? 'मुनाफ़े में 📈' : 'घाटा 📉',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                    color: _service.netMunafa >= 0
                        ? AppTheme.success
                        : AppTheme.error,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEBEE),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.arrow_downward,
                            color: AppTheme.error,
                            size: 14.sp,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            'कुल खर्च (Debit)',
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: AppTheme.error,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        currency.format(_service.totalKharcha),
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.error,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.arrow_upward,
                            color: AppTheme.success,
                            size: 14.sp,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            'कुल कमाई (Credit)',
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: AppTheme.success,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        currency.format(_service.totalKamai),
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.success,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FBF9),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: const Color(0xFFE8F5E9)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'शुद्ध बचत / मुनाफ़ा (Net Balance)',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Text(
                  currency.format(_service.netMunafa),
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: _service.netMunafa >= 0
                        ? AppTheme.primaryDark
                        : AppTheme.error,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVoiceInputBanner() {
    return GestureDetector(
      onTap: _showVoiceInputDialog,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF2E7D32), Color(0xFF388E3C)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: AppTheme.elevatedShadow,
        ),
        child: Row(
          children: [
            Container(
              width: 46.w,
              height: 46.w,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.mic,
                color: AppTheme.primaryColor,
                size: 26,
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'बोलकर खाता लिखें (Voice Khata)',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6.w,
                          vertical: 1.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.secondaryColor,
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          'नया',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'माइक दबाएं और बोलें: "₹2700 DAP खाद ली"',
                    style: TextStyle(color: Colors.white70, fontSize: 11.sp),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white70,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKhataEntryTile(KhataEntryModel entry) {
    IconData getCategoryIcon(String cat) {
      if (cat.contains('खाद') || cat.contains('dap') || cat.contains('यूरिया')) {
        return Icons.eco_outlined;
      }
      if (cat.contains('बीज')) return Icons.grass;
      if (cat.contains('डीजल') || cat.contains('मशीन')) {
        return Icons.local_gas_station;
      }
      if (cat.contains('मजदूरी')) return Icons.groups;
      if (cat.contains('कीटनाशक') || cat.contains('स्प्रे')) {
        return Icons.sanitizer;
      }
      if (cat.contains('फसल')) return Icons.agriculture;
      if (cat.contains('दूध')) return Icons.water_drop;
      return Icons.receipt_long;
    }

    final dateStr = DateFormat('dd MMM, hh:mm a').format(entry.date);

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Row(
        children: [
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: entry.isKharcha
                  ? AppTheme.error.withValues(alpha: 0.1)
                  : AppTheme.success.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              getCategoryIcon(entry.category),
              color: entry.isKharcha ? AppTheme.error : AppTheme.success,
              size: 22.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        entry.title,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (entry.isVoiceEntry) ...[
                      SizedBox(width: 4.w),
                      const Icon(
                        Icons.mic,
                        size: 14,
                        color: AppTheme.primaryColor,
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 3.h),
                Row(
                  children: [
                    Text(
                      entry.category,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    Text(' • ', style: TextStyle(color: Colors.grey[400])),
                    Text(
                      dateStr,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppTheme.textHint,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${entry.isKharcha ? "-" : "+"} ₹${entry.amount.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: entry.isKharcha ? AppTheme.error : AppTheme.success,
                ),
              ),
              GestureDetector(
                onTap: () => _service.deleteKhataEntry(entry.id),
                child: Padding(
                  padding: EdgeInsets.only(top: 4.h),
                  child: Icon(
                    Icons.close,
                    size: 16.sp,
                    color: Colors.grey[400],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
