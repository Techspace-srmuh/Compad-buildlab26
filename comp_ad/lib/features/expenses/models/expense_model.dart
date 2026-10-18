import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ExpenseModel {
  final String id;
  final String title;
  final double amount;
  final String category; // 'Food', 'Stationery', 'Travel', 'Fees', 'Entertainment', 'Others'
  final DateTime date;
  final String paymentMode; // 'UPI', 'Cash', 'Card', 'Other'
  final String note;

  const ExpenseModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    this.paymentMode = 'UPI',
    this.note = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'category': category,
      'date': date.toIso8601String(),
      'payment_mode': paymentMode,
      'note': note,
    };
  }

  factory ExpenseModel.fromMap(Map<String, dynamic> map) {
    return ExpenseModel(
      id: map['id'] as String,
      title: map['title'] as String,
      amount: (map['amount'] as num).toDouble(),
      category: map['category'] as String? ?? 'Others',
      date: DateTime.tryParse(map['date'] as String? ?? '') ?? DateTime.now(),
      paymentMode: map['payment_mode'] as String? ?? 'UPI',
      note: map['note'] as String? ?? '',
    );
  }

  IconData get icon {
    switch (category.toLowerCase()) {
      case 'food':
      case 'canteen':
      case 'mess':
        return LucideIcons.utensils;
      case 'stationery':
      case 'books':
      case 'study':
        return LucideIcons.bookOpen;
      case 'travel':
      case 'commute':
        return LucideIcons.bus;
      case 'fees':
      case 'bills':
        return LucideIcons.receipt;
      case 'entertainment':
      case 'hangout':
        return LucideIcons.film;
      default:
        return LucideIcons.wallet;
    }
  }

  Color get categoryColor {
    switch (category.toLowerCase()) {
      case 'food':
      case 'canteen':
      case 'mess':
        return const Color(0xFFF59E0B); // Amber
      case 'stationery':
      case 'books':
      case 'study':
        return const Color(0xFF06B6D4); // Cyan
      case 'travel':
      case 'commute':
        return const Color(0xFF10B981); // Emerald
      case 'fees':
      case 'bills':
        return const Color(0xFFEF4444); // Coral Red
      case 'entertainment':
      case 'hangout':
        return const Color(0xFFEC4899); // Pink
      default:
        return const Color(0xFF6366F1); // Indigo
    }
  }
}
