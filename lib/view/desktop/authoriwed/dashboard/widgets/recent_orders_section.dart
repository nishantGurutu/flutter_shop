import 'package:flutter/material.dart';

class RecentOrdersSection extends StatelessWidget {
  const RecentOrdersSection({super.key});

  static const _orders = [
    {
      'id': '#ORD1234',
      'name': 'Mohit Kumar',
      'amount': '₹2,450',
      'status': 'Delivered',
      'date': 'May 01, 2026',
    },
    {
      'id': '#ORD1233',
      'name': 'Seeta Devi',
      'amount': '₹1,850',
      'status': 'Processing',
      'date': 'May 01, 2026',
    },
    {
      'id': '#ORD1232',
      'name': 'Ramlal Yadav',
      'amount': '₹3,200',
      'status': 'Shipped',
      'date': 'Apr 30, 2026',
    },
    {
      'id': '#ORD1231',
      'name': 'Sunil Kumar',
      'amount': '₹950',
      'status': 'Cancelled',
      'date': 'Apr 30, 2026',
    },
    {
      'id': '#ORD1230',
      'name': 'Kavita Sharma',
      'amount': '₹1,650',
      'status': 'Delivered',
      'date': 'Apr 29, 2026',
    },
  ];

  Color _statusColor(String status) {
    switch (status) {
      case 'Delivered':
        return const Color(0xFF2E7D32);
      case 'Processing':
        return const Color(0xFF1565C0);
      case 'Shipped':
        return const Color(0xFFE65100);
      case 'Cancelled':
        return const Color(0xFFC62828);
      default:
        return Colors.grey;
    }
  }

  Color _statusBg(String status) {
    switch (status) {
      case 'Delivered':
        return const Color(0xFFE8F5E9);
      case 'Processing':
        return const Color(0xFFE3F2FD);
      case 'Shipped':
        return const Color(0xFFFFF3E0);
      case 'Cancelled':
        return const Color(0xFFFFEBEE);
      default:
        return Colors.grey.shade100;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Recent Orders',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A))),
          const SizedBox(height: 16),

          // Table header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F6FA),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Expanded(
                    flex: 2,
                    child: Text('Order ID',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey))),
                Expanded(
                    flex: 2,
                    child: Text('Customer',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey))),
                Expanded(
                    flex: 2,
                    child: Text('Amount',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey))),
                Expanded(
                    flex: 2,
                    child: Text('Status',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey))),
                Expanded(
                    flex: 2,
                    child: Text('Date',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey))),
                Expanded(
                    flex: 1,
                    child: Text('Action',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey))),
              ],
            ),
          ),

          // Rows
          ..._orders.map((order) => _OrderRow(
                order: order,
                statusColor: _statusColor(order['status']!),
                statusBg: _statusBg(order['status']!),
              )),

          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                onPressed: () {},
                icon: const Text('View All Orders',
                    style: TextStyle(
                        color: Color(0xFF2E7D32), fontSize: 13)),
                label: const Icon(Icons.arrow_forward,
                    size: 14, color: Color(0xFF2E7D32)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OrderRow extends StatelessWidget {
  final Map<String, String> order;
  final Color statusColor;
  final Color statusBg;

  const _OrderRow({
    required this.order,
    required this.statusColor,
    required this.statusBg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFFF0F0F0)))),
      child: Row(
        children: [
          Expanded(
              flex: 2,
              child: Text(order['id']!,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A)))),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: Colors.green.shade100,
                  child: Text(order['name']![0],
                      style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF2E7D32),
                          fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 6),
                Flexible(
                    child: Text(order['name']!,
                        style: const TextStyle(fontSize: 13))),
              ],
            ),
          ),
          Expanded(
              flex: 2,
              child: Text(order['amount']!,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600))),
          Expanded(
            flex: 2,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(20)),
              child: Text(order['status']!,
                  style: TextStyle(
                      fontSize: 12,
                      color: statusColor,
                      fontWeight: FontWeight.w600)),
            ),
          ),
          Expanded(
              flex: 2,
              child: Text(order['date']!,
                  style: const TextStyle(
                      fontSize: 12, color: Colors.grey))),
          Expanded(
              flex: 1,
              child: IconButton(
                  icon: const Icon(Icons.more_vert,
                      size: 18, color: Colors.grey),
                  onPressed: () {})),
        ],
      ),
    );
  }
}
