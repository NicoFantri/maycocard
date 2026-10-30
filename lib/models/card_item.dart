import 'dart:typed_data';
import 'package:flutter/material.dart';

/// Model terpusat untuk kartu dan sumber dana MaycoCard
class CardItem {
  final String id;
  String bankName;
  String type;
  String number;
  String prefix;
  String holder;
  String exp;
  double balance;
  String bgType; // 'purple', 'yellow_prioritas', 'gold_wayang', 'custom_image', 'custom_color', dsb.
  List<Color>? gradientColors;
  Uint8List? customImageBytes;
  bool isMandiri;
  bool isBri;
  bool isCash;

  CardItem({
    required this.id,
    required this.bankName,
    required this.type,
    required this.number,
    required this.prefix,
    this.holder = 'NICO',
    required this.exp,
    required this.balance,
    this.bgType = 'purple',
    this.gradientColors,
    this.customImageBytes,
    this.isMandiri = false,
    this.isBri = false,
    this.isCash = false,
  });

  String get formattedBalance {
    final val = balance.toInt();
    final str = val.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
    return 'Rp $str';
  }

  CardItem copyWith({
    String? bankName,
    String? type,
    String? number,
    String? prefix,
    String? holder,
    String? exp,
    double? balance,
    String? bgType,
    List<Color>? gradientColors,
    Uint8List? customImageBytes,
    bool? isMandiri,
    bool? isBri,
    bool? isCash,
  }) {
    return CardItem(
      id: id,
      bankName: bankName ?? this.bankName,
      type: type ?? this.type,
      number: number ?? this.number,
      prefix: prefix ?? this.prefix,
      holder: holder ?? this.holder,
      exp: exp ?? this.exp,
      balance: balance ?? this.balance,
      bgType: bgType ?? this.bgType,
      gradientColors: gradientColors ?? this.gradientColors,
      customImageBytes: customImageBytes ?? this.customImageBytes,
      isMandiri: isMandiri ?? this.isMandiri,
      isBri: isBri ?? this.isBri,
      isCash: isCash ?? this.isCash,
    );
  }
}

/// Registry global kartu tersinkronisasi antara Beranda dan Dompet
final ValueNotifier<List<CardItem>> cardsRegistryNotifier = ValueNotifier<List<CardItem>>([
  CardItem(
    id: 'mandiri_gold',
    bankName: 'Mandiri Debit Gold',
    type: 'Rekening Utama Mandiri',
    number: '4616   0088   0000   4364',
    prefix: '4616',
    holder: 'NICO',
    exp: '08/28',
    balance: 4850000.0,
    bgType: 'purple',
    isMandiri: true,
  ),
  CardItem(
    id: 'bri_prioritas',
    bankName: 'BRI World Prioritas',
    type: 'Tabungan Harian BRI',
    number: '5221   8800   1245   7216',
    prefix: '5221',
    holder: 'NICO',
    exp: '11/27',
    balance: 2450000.0,
    bgType: 'yellow_prioritas',
    isBri: true,
  ),
  CardItem(
    id: 'cash_wallet',
    bankName: 'Dompet Tunai Fisik',
    type: 'Kas & Uang Saku',
    number: 'Uang Tunai di Dompet',
    prefix: 'CASH',
    holder: 'NICO',
    exp: 'Aktif',
    balance: 450000.0,
    bgType: 'custom_color',
    gradientColors: [const Color(0xFF1B8C5A), const Color(0xFF104B30)],
    isCash: true,
  ),
]);
