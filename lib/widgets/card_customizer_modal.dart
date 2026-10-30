import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/text_styles.dart';
import '../core/utils/image_file_picker.dart';
import '../models/card_item.dart';

/// Modal untuk kustomisasi warna kartu dan unggah gambar latar belakang dari galeri perangkat
/// Mendukung seluruh kartu yang tersimpan dalam sistem secara terpadu
class CardCustomizerModal extends StatefulWidget {
  final AppColors colors;
  final String initialCard; // 'mandiri', 'bri', atau ID kartu spesifik

  const CardCustomizerModal({
    super.key,
    required this.colors,
    this.initialCard = 'mandiri',
  });

  static Future<void> show(
    BuildContext context, {
    required AppColors colors,
    String initialCard = 'mandiri',
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => CardCustomizerModal(
        colors: colors,
        initialCard: initialCard,
      ),
    );
  }

  @override
  State<CardCustomizerModal> createState() => _CardCustomizerModalState();
}

class _CardCustomizerModalState extends State<CardCustomizerModal> {
  bool _isUploading = false;
  late String _selectedCard;

  @override
  void initState() {
    super.initState();
    _selectedCard = widget.initialCard;
  }

  // Preset tema warna dan desain resmi
  final List<Map<String, dynamic>> _colorThemes = [
    {
      'id': 'purple',
      'title': 'Mandiri Royal Purple (Default)',
      'subtitle': 'Gradien ungu khas MaycoCard',
      'colors': [const Color(0xFF6C5CE7), const Color(0xFF3B2A82)],
      'isAsset': false,
    },
    {
      'id': 'yellow_prioritas',
      'title': 'Kuning Emas Prioritas (Default BRI)',
      'subtitle': 'Gradien emas berkilau khas kartu prioritas',
      'colors': [const Color(0xFFFFB300), const Color(0xFFF57C00)],
      'isAsset': false,
    },
    {
      'id': 'gold_wayang',
      'title': 'Mandiri Debit Gold Asli',
      'subtitle': 'Batik Wayang Tari Tradisional',
      'assetPath': 'assets/images/mandiri_gold_card.png',
      'isAsset': true,
    },
    {
      'id': 'theme_ocean',
      'title': 'Deep Ocean Sapphire',
      'subtitle': 'Gradien biru laut metalik',
      'colors': [const Color(0xFF0F2027), const Color(0xFF203A43), const Color(0xFF2C5364)],
      'isAsset': false,
    },
    {
      'id': 'theme_emerald',
      'title': 'Emerald Royal Green',
      'subtitle': 'Gradien hijau zamrud mewah',
      'colors': [const Color(0xFF0A5C36), const Color(0xFF148F4C), const Color(0xFF0D3E24)],
      'isAsset': false,
    },
    {
      'id': 'theme_ruby',
      'title': 'Crimson Ruby Velvet',
      'subtitle': 'Gradien merah rubi elegan',
      'colors': [const Color(0xFF8A1327), const Color(0xFFB71C1C), const Color(0xFF56000E)],
      'isAsset': false,
    },
    {
      'id': 'theme_obsidian',
      'title': 'Dark Titanium Obsidian',
      'subtitle': 'Hitam pekat eksklusif',
      'colors': [const Color(0xFF1F1F24), const Color(0xFF121215)],
      'isAsset': false,
    },
    {
      'id': 'theme_sunset',
      'title': 'Sunset Coral Gradient',
      'subtitle': 'Kombinasi oranye hangat dan magenta',
      'colors': [const Color(0xFFFF5E62), const Color(0xFFFF9966)],
      'isAsset': false,
    },
  ];

  // Swatches palet warna cepat untuk custom sendiri
  final List<List<Color>> _customColorPalettes = [
    [const Color(0xFF6C5CE7), const Color(0xFF4834DF)], // Purple
    [const Color(0xFFFFB300), const Color(0xFFE65100)], // Gold Orange
    [const Color(0xFF227093), const Color(0xFF2C2C54)], // Midnight Navy
    [const Color(0xFF1B8C5A), const Color(0xFF104B30)], // Forest
    [const Color(0xFFB3392B), const Color(0xFF67140B)], // Garnet
    [const Color(0xFFD4AC0D), const Color(0xFF9A7D0A)], // Bronze Gold
    [const Color(0xFF2C3E50), const Color(0xFF000000)], // Noir
    [const Color(0xFF8E44AD), const Color(0xFFC0392B)], // Twilight
    [const Color(0xFF16A085), const Color(0xFF2980B9)], // Teal Cyan
  ];

  Future<void> _pickImageFromGallery() async {
    try {
      setState(() => _isUploading = true);
      final Uint8List? bytes = await pickCustomCardImage();

      if (bytes != null) {
        final cardList = List<CardItem>.from(cardsRegistryNotifier.value);
        int targetIdx = -1;

        if (_selectedCard == 'mandiri') {
          targetIdx = cardList.indexWhere((c) => c.isMandiri);
          cardCustomImageBytesNotifier.value = bytes;
          cardBackgroundNotifier.value = 'custom_image';
        } else if (_selectedCard == 'bri') {
          targetIdx = cardList.indexWhere((c) => c.isBri);
          briCardCustomImageBytesNotifier.value = bytes;
          briCardBackgroundNotifier.value = 'custom_image';
        } else {
          targetIdx = cardList.indexWhere((c) => c.id == _selectedCard);
        }

        if (targetIdx != -1) {
          cardList[targetIdx] = cardList[targetIdx].copyWith(
            bgType: 'custom_image',
            customImageBytes: bytes,
          );
          cardsRegistryNotifier.value = cardList;
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: widget.colors.panel,
              content: Row(
                children: [
                  const Icon(Icons.check_circle_rounded, color: Color(0xFF00E676), size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Foto kartu berhasil diterapkan dari galeri!',
                      style: poppins(12.5, widget.colors.text, w: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          );
          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: widget.colors.panel,
            content: Text('Gagal memilih gambar: $e', style: poppins(12, Colors.redAccent)),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  void _applyTheme(String id, {List<Color>? colors}) {
    final cardList = List<CardItem>.from(cardsRegistryNotifier.value);
    int targetIdx = -1;

    if (_selectedCard == 'mandiri') {
      targetIdx = cardList.indexWhere((c) => c.isMandiri);
      if (colors != null) cardCustomColorsNotifier.value = colors;
      cardBackgroundNotifier.value = id;
    } else if (_selectedCard == 'bri') {
      targetIdx = cardList.indexWhere((c) => c.isBri);
      if (colors != null) briCardCustomColorsNotifier.value = colors;
      briCardBackgroundNotifier.value = id;
    } else {
      targetIdx = cardList.indexWhere((c) => c.id == _selectedCard);
    }

    if (targetIdx != -1) {
      cardList[targetIdx] = cardList[targetIdx].copyWith(
        bgType: id,
        gradientColors: colors,
      );
      cardsRegistryNotifier.value = cardList;
    }

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: widget.colors.panel,
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Color(0xFF00E676), size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Desain kartu berhasil diperbarui!',
                style: poppins(12.5, widget.colors.text, w: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _applyCustomPalette(List<Color> palette) {
    final cardList = List<CardItem>.from(cardsRegistryNotifier.value);
    int targetIdx = -1;

    if (_selectedCard == 'mandiri') {
      targetIdx = cardList.indexWhere((c) => c.isMandiri);
      cardCustomColorsNotifier.value = palette;
      cardBackgroundNotifier.value = 'custom_color';
    } else if (_selectedCard == 'bri') {
      targetIdx = cardList.indexWhere((c) => c.isBri);
      briCardCustomColorsNotifier.value = palette;
      briCardBackgroundNotifier.value = 'custom_color';
    } else {
      targetIdx = cardList.indexWhere((c) => c.id == _selectedCard);
    }

    if (targetIdx != -1) {
      cardList[targetIdx] = cardList[targetIdx].copyWith(
        bgType: 'custom_color',
        gradientColors: palette,
      );
      cardsRegistryNotifier.value = cardList;
    }

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: widget.colors.panel,
        content: Row(
          children: [
            const Icon(Icons.palette_rounded, color: Color(0xFF00E676), size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Warna kustom kartu berhasil diterapkan!',
                style: poppins(12.5, widget.colors.text, w: FontWeight.w500),
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

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: c.panel,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border.all(color: c.border, width: 1),
          ),
          child: Column(
            children: [
              // Handle Bar
              const SizedBox(height: 12),
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: c.sub.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Header Modal
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kustomisasi Desain Kartu',
                          style: poppins(18, c.text, w: FontWeight.w600),
                        ),
                        Text(
                          'Pilih palet warna kustom atau unggah dari galeri',
                          style: poppins(11, c.sub, w: FontWeight.w400),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: c.iconCircle,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.close_rounded, size: 19, color: c.text),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Selector Tab Dinamis untuk Seluruh Kartu di Registry
              ValueListenableBuilder<List<CardItem>>(
                valueListenable: cardsRegistryNotifier,
                builder: (context, cardList, _) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        children: cardList.map((card) {
                          final isSel = (_selectedCard == 'mandiri' && card.isMandiri) ||
                              (_selectedCard == 'bri' && card.isBri) ||
                              (_selectedCard == card.id);

                          final dotColor = card.isMandiri
                              ? const Color(0xFF6C5CE7)
                              : card.isBri
                                  ? const Color(0xFFFFB300)
                                  : const Color(0xFF00E676);

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if (card.isMandiri) {
                                  _selectedCard = 'mandiri';
                                } else if (card.isBri) {
                                  _selectedCard = 'bri';
                                } else {
                                  _selectedCard = card.id;
                                }
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSel ? c.panel : c.iconCircle,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSel ? AppColors.purple : c.border.withValues(alpha: 0.6),
                                  width: isSel ? 1.5 : 1,
                                ),
                                boxShadow: isSel
                                    ? [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: c.dark ? 0.3 : 0.08),
                                          blurRadius: 4,
                                          offset: const Offset(0, 1),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: dotColor,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    card.bankName,
                                    style: poppins(
                                      11.5,
                                      isSel ? c.text : c.sub,
                                      w: isSel ? FontWeight.w600 : FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 14),
              Divider(color: c.border.withValues(alpha: 0.5), height: 1),

              // Content List
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                  children: [
                    // Bagian 1: Unggah dari Galeri Perangkat
                    Row(
                      children: [
                        Icon(Icons.photo_library_outlined, size: 18, color: c.text),
                        const SizedBox(width: 8),
                        Text(
                          'UNGGAH GAMBAR DARI GALERI',
                          style: poppins(11.5, c.text, w: FontWeight.w700),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Pilih foto langsung dari galeri atau komputer tanpa menggunakan tautan URL',
                      style: poppins(10.5, c.sub, w: FontWeight.w400),
                    ),
                    const SizedBox(height: 12),

                    // Kotak Upload Galeri Interaktif (Kompatibel Web & Mobile)
                    InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: _isUploading ? null : _pickImageFromGallery,
                      child: Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: c.dark
                              ? Colors.white.withValues(alpha: 0.05)
                              : (_selectedCard == 'mandiri'
                                  ? const Color(0xFF6C5CE7).withValues(alpha: 0.05)
                                  : const Color(0xFFFFB300).withValues(alpha: 0.08)),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: _selectedCard == 'mandiri'
                                ? const Color(0xFF6C5CE7).withValues(alpha: 0.4)
                                : const Color(0xFFFFB300).withValues(alpha: 0.5),
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          children: [
                            ValueListenableBuilder<List<CardItem>>(
                              valueListenable: cardsRegistryNotifier,
                              builder: (context, cardList, _) {
                                final currentCard = cardList.firstWhere(
                                  (card) =>
                                      (_selectedCard == 'mandiri' && card.isMandiri) ||
                                      (_selectedCard == 'bri' && card.isBri) ||
                                      (_selectedCard == card.id),
                                  orElse: () => cardList.first,
                                );

                                final customBytes = currentCard.customImageBytes;

                                if (customBytes != null) {
                                  return Column(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: SizedBox(
                                          height: 90,
                                          width: double.infinity,
                                          child: Image.memory(
                                            customBytes,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          ElevatedButton.icon(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: AppColors.purple,
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                              elevation: 0,
                                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                            ),
                                            onPressed: () => _applyTheme('custom_image'),
                                            icon: const Icon(Icons.check_rounded, size: 16),
                                            label: Text('Gunakan Foto Ini', style: poppins(11.5, Colors.white, w: FontWeight.w600)),
                                          ),
                                          const SizedBox(width: 8),
                                          OutlinedButton.icon(
                                            style: OutlinedButton.styleFrom(
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                            ),
                                            onPressed: _pickImageFromGallery,
                                            icon: const Icon(Icons.refresh_rounded, size: 16),
                                            label: Text('Ganti Foto', style: poppins(11.5, c.text, w: FontWeight.w500)),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                }

                                return Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: (_selectedCard == 'mandiri'
                                                ? AppColors.purple
                                                : const Color(0xFFFFB300))
                                            .withValues(alpha: 0.15),
                                        shape: BoxShape.circle,
                                      ),
                                      child: _isUploading
                                          ? const SizedBox(
                                              width: 24,
                                              height: 24,
                                              child: CircularProgressIndicator(strokeWidth: 2),
                                            )
                                          : Icon(
                                              Icons.add_photo_alternate_outlined,
                                              size: 26,
                                              color: _selectedCard == 'mandiri'
                                                  ? AppColors.purple
                                                  : const Color(0xFFF57C00),
                                            ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Ketuk untuk Memilih Foto dari Galeri',
                                      style: poppins(13, c.text, w: FontWeight.w600),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      'Mendukung JPG, PNG, WEBP (Otomatis pas dengan kartu)',
                                      style: poppins(10.5, c.sub, w: FontWeight.w400),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Bagian 2: Kustomisasi Palet Warna Cepat (Pilih Warna Sendiri)
                    Row(
                      children: [
                        Icon(Icons.palette_outlined, size: 18, color: c.text),
                        const SizedBox(width: 8),
                        Text(
                          'PILIH PALET WARNA SENDIRI',
                          style: poppins(11.5, c.text, w: FontWeight.w700),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Pilih kombinasi warna gradien favorit Anda untuk kartu perbankan',
                      style: poppins(10.5, c.sub, w: FontWeight.w400),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _customColorPalettes.map((palette) {
                        return GestureDetector(
                          onTap: () => _applyCustomPalette(palette),
                          child: Container(
                            width: 62,
                            height: 42,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: LinearGradient(
                                colors: palette,
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.3),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: palette.first.withValues(alpha: 0.3),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Icon(Icons.colorize_rounded, size: 14, color: Colors.white),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),

                    // Bagian 3: Pilihan Tema & Desain Kartu Resmi
                    Row(
                      children: [
                        Icon(Icons.style_outlined, size: 18, color: c.text),
                        const SizedBox(width: 8),
                        Text(
                          'PILIHAN TEMA RESMI & DEFAULT',
                          style: poppins(11.5, c.text, w: FontWeight.w700),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ValueListenableBuilder<List<CardItem>>(
                      valueListenable: cardsRegistryNotifier,
                      builder: (context, cardList, _) {
                        final currentCard = cardList.firstWhere(
                          (card) =>
                              (_selectedCard == 'mandiri' && card.isMandiri) ||
                              (_selectedCard == 'bri' && card.isBri) ||
                              (_selectedCard == card.id),
                          orElse: () => cardList.first,
                        );

                        final currentBg = currentCard.bgType;

                        return Column(
                          children: _colorThemes.map((theme) {
                            final id = theme['id'] as String;
                            final isSelected = currentBg == id;

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: () => _applyTheme(
                                  id,
                                  colors: theme['colors'] as List<Color>?,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? (c.dark
                                            ? Colors.white.withValues(alpha: 0.08)
                                            : AppColors.purple.withValues(alpha: 0.08))
                                        : c.iconCircle,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: isSelected
                                          ? AppColors.purple
                                          : c.border.withValues(alpha: 0.5),
                                      width: isSelected ? 1.6 : 1,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      // Preview Thumbnail
                                      Container(
                                        width: 50,
                                        height: 32,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          gradient: theme['isAsset'] == true
                                              ? null
                                              : LinearGradient(
                                                  colors: theme['colors'] as List<Color>,
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                ),
                                          border: Border.all(
                                            color: Colors.white.withValues(alpha: 0.25),
                                            width: 1,
                                          ),
                                        ),
                                        child: theme['isAsset'] == true
                                            ? ClipRRect(
                                                borderRadius: BorderRadius.circular(8),
                                                child: Image.asset(
                                                  theme['assetPath'] as String,
                                                  fit: BoxFit.cover,
                                                ),
                                              )
                                            : null,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              theme['title'] as String,
                                              style: poppins(
                                                12.5,
                                                c.text,
                                                w: isSelected ? FontWeight.w600 : FontWeight.w500,
                                              ),
                                            ),
                                            Text(
                                              theme['subtitle'] as String,
                                              style: poppins(10, c.sub, w: FontWeight.w400),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (isSelected)
                                        const Icon(
                                          Icons.check_circle_rounded,
                                          color: AppColors.purple,
                                          size: 20,
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
