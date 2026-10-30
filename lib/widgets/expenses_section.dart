import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/text_styles.dart';
import '../models/expense_item.dart';

class ExpensesSection extends StatefulWidget {
  final AppColors colors;
  final List<ExpenseItem> items;
  final VoidCallback? onViewAll;

  const ExpensesSection({
    super.key,
    required this.colors,
    this.items = defaultExpenses,
    this.onViewAll,
  });

  @override
  State<ExpensesSection> createState() => _ExpensesSectionState();
}

class _ExpensesSectionState extends State<ExpensesSection> {
  void _showExpenseDetail(BuildContext context, ExpenseItem item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: widget.colors.panel,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          border: Border.all(color: widget.colors.border, width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: widget.colors.sub.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: item.color.withValues(alpha: widget.colors.dark ? 0.22 : 0.14),
                shape: BoxShape.circle,
                border: Border.all(color: item.color.withValues(alpha: 0.35), width: 1.5),
              ),
              child: Icon(item.icon, size: 28, color: item.color),
            ),
            const SizedBox(height: 12),
            Text(
              item.title,
              style: poppins(16.5, widget.colors.text, w: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              item.date,
              style: poppins(12, widget.colors.sub, w: FontWeight.w400),
            ),
            const SizedBox(height: 16),
            Text(
              item.amount,
              style: poppins(24, widget.colors.text, w: FontWeight.w700),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: widget.colors.iconCircle,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Status Transaksi',
                    style: poppins(12, widget.colors.sub, w: FontWeight.w400),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.check_circle_rounded,
                        color: Color(0xFF00E676),
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Berhasil Terpotong',
                        style: poppins(12, widget.colors.text, w: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: widget.colors.border),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () => Navigator.pop(ctx),
                child: Text('Tutup', style: poppins(13.5, widget.colors.text, w: FontWeight.w500)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.colors;

    return Container(
      decoration: BoxDecoration(
        color: c.panel,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: c.border.withValues(alpha: 0.6), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: c.dark ? 0.35 : 0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Kelola Pengeluaran',
                        style: poppins(
                          14.5,
                          c.text,
                          w: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Riwayat transaksi keuanganmu',
                        style: poppins(10.5, c.sub, w: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: widget.onViewAll ??
                        () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: c.panel,
                              content: Text('Menampilkan seluruh riwayat pengeluaran', style: poppins(12, c.text)),
                            ),
                          );
                        },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: c.iconCircle,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: c.border.withValues(alpha: 0.5),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Lihat Semua',
                            style: poppins(
                              11,
                              c.text,
                              w: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 10,
                            color: c.sub,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 2),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              children: widget.items.map((e) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => _showExpenseDetail(context, e),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 6),
                        child: Row(
                          children: [
                            // Ikon Berwarna
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: e.color.withValues(alpha: c.dark ? 0.2 : 0.12),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: e.color.withValues(alpha: c.dark ? 0.35 : 0.25),
                                  width: 1.2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: e.color.withValues(alpha: 0.12),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Icon(e.icon, size: 21, color: e.color),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    e.title,
                                    style: poppins(
                                      13,
                                      c.text,
                                      w: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    e.date,
                                    style: poppins(10, c.sub, w: FontWeight.w400),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  e.amount,
                                  style: poppins(
                                    13,
                                    c.text,
                                    w: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFF5252).withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    'Keluar',
                                    style: poppins(
                                      8.5,
                                      const Color(0xFFFF5252),
                                      w: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
