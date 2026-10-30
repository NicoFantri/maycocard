import 'package:flutter/material.dart';

class ExpenseItem {
  final IconData icon;
  final String title;
  final String date;
  final String amount;
  final Color color;

  const ExpenseItem({
    required this.icon,
    required this.title,
    required this.date,
    required this.amount,
    required this.color,
  });
}

const List<ExpenseItem> defaultExpenses = [
  ExpenseItem(
    icon: Icons.home_rounded,
    title: 'Sewa Rumah & Properti',
    date: '12 Sep 2025 • 09:00 WIB',
    amount: '- Rp 3.500.000',
    color: Color(0xFF7C4DFF), // Ungu Violet
  ),
  ExpenseItem(
    icon: Icons.wifi_rounded,
    title: 'Tagihan Wifi Indihome',
    date: '11 Sep 2025 • 14:21 WIB',
    amount: '- Rp 450.000',
    color: Color(0xFF00B0FF), // Biru Cyan
  ),
  ExpenseItem(
    icon: Icons.shopping_cart_rounded,
    title: 'Belanja Supermarket',
    date: '10 Sep 2025 • 10:30 WIB',
    amount: '- Rp 680.000',
    color: Color(0xFFFF6D00), // Oranye
  ),
  ExpenseItem(
    icon: Icons.receipt_long_rounded,
    title: 'Pajak & Retribusi',
    date: '09 Sep 2025 • 08:15 WIB',
    amount: '- Rp 850.000',
    color: Color(0xFFFFAB00), // Emas Kuning
  ),
  ExpenseItem(
    icon: Icons.bolt_rounded,
    title: 'Listrik & Token PLN',
    date: '08 Sep 2025 • 19:05 WIB',
    amount: '- Rp 300.000',
    color: Color(0xFF00E676), // Hijau Neon
  ),
];
