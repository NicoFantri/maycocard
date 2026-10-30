import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/text_styles.dart';

class QuickActions extends StatelessWidget {
  final AppColors colors;
  final void Function(String action)? onActionTap;

  const QuickActions({
    super.key,
    required this.colors,
    this.onActionTap,
  });

  void _showActionModal(BuildContext context, String action, String description, IconData icon) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: colors.panel,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          border: Border.all(color: colors.border, width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.sub.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colors.iconCircle,
                    shape: BoxShape.circle,
                    border: Border.all(color: colors.border, width: 1),
                  ),
                  child: Icon(icon, color: colors.text, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Layanan $action',
                        style: poppins(17, colors.text, w: FontWeight.w600),
                      ),
                      Text(
                        'Transaksi instan & aman',
                        style: poppins(11, colors.sub),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              description,
              style: poppins(13, colors.sub, height: 1.45),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.text,
                  foregroundColor: colors.dark ? Colors.black : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                onPressed: () => Navigator.pop(ctx),
                child: Text(
                  'Lanjutkan $action',
                  style: poppins(
                    13.5,
                    colors.dark ? Colors.black : Colors.white,
                    w: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _item(
    BuildContext context,
    IconData icon,
    String label,
    String description,
  ) =>
      InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () {
          if (onActionTap != null) {
            onActionTap!(label);
          } else {
            _showActionModal(context, label, description, icon);
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: colors.iconCircle,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colors.dark
                        ? Colors.white.withValues(alpha: 0.08)
                        : Colors.black.withValues(alpha: 0.06),
                    width: 1,
                  ),
                ),
                child: Icon(icon, size: 21, color: colors.text),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: poppins(
                  11.5,
                  colors.text,
                  w: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      decoration: BoxDecoration(
        color: colors.panel,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: colors.border.withValues(alpha: 0.6),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: colors.dark ? 0.25 : 0.03),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _item(
            context,
            Icons.north_east_rounded,
            'Kirim',
            'Transfer dana instan ke sesama MaycoCard, Bank BRI, Mandiri, BCA, atau bank lain tanpa biaya admin.',
          ),
          _item(
            context,
            Icons.south_west_rounded,
            'Minta',
            'Buat tautan atau kode QR tagihan untuk menerima pembayaran langsung ke saldo rekening utama Anda.',
          ),
          _item(
            context,
            Icons.credit_card_outlined,
            'Isi Saldo',
            'Isi saldo dompet digital Anda melalui Virtual Account Bank BRI, Mandiri, atau gerai mitra terdekat.',
          ),
          _item(
            context,
            Icons.more_horiz_rounded,
            'Lainnya',
            'Akses pembayaran tagihan BPJS, PLN, PDAM, Pulsa, dan asuransi dalam satu aplikasi.',
          ),
        ],
      ),
    );
  }
}
