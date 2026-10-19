import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/spatial_colors.dart';
import '../../../core/theme/spatial_neumorphic.dart';
import '../../../core/widgets/spatial_button.dart';
import '../../../core/widgets/spatial_glass.dart';
import '../models/card_model.dart';

class AddCardSheet extends StatefulWidget {
  final Function(CardModel card) onSave;

  const AddCardSheet({super.key, required this.onSave});

  @override
  State<AddCardSheet> createState() => _AddCardSheetState();
}

class _AddCardSheetState extends State<AddCardSheet> {
  final TextEditingController _titleCtrl = TextEditingController();
  final TextEditingController _studentNameCtrl = TextEditingController();
  final TextEditingController _rollNumberCtrl = TextEditingController();
  final TextEditingController _barcodeValueCtrl = TextEditingController();
  String _selectedFormat = 'CODE_128';

  @override
  void dispose() {
    _titleCtrl.dispose();
    _studentNameCtrl.dispose();
    _rollNumberCtrl.dispose();
    _barcodeValueCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SpatialGlass(
        radius: 28,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Add Campus Credential',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: SpatialColors.onSurface,
                  ),
                ),
                IconButton(
                  icon: const Icon(LucideIcons.x, color: SpatialColors.outline),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Card Title
            const Text(
              'PASS / CREDENTIAL TITLE',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.8,
                color: SpatialColors.outline,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: SpatialDecorations.inset(
                radius: 12,
                base: SpatialColors.surfaceContainerLowest,
              ),
              child: TextField(
                controller: _titleCtrl,
                style: const TextStyle(color: SpatialColors.onSurface),
                decoration: const InputDecoration(
                  hintText: 'e.g. Sports Complex Gate Pass',
                  hintStyle: TextStyle(color: SpatialColors.outline),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Student Name & Roll Number
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'STUDENT NAME',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                          color: SpatialColors.outline,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: SpatialDecorations.inset(
                          radius: 12,
                          base: SpatialColors.surfaceContainerLowest,
                        ),
                        child: TextField(
                          controller: _studentNameCtrl,
                          style: const TextStyle(color: SpatialColors.onSurface),
                          decoration: const InputDecoration(border: InputBorder.none),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'ROLL / ID NUMBER',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                          color: SpatialColors.outline,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: SpatialDecorations.inset(
                          radius: 12,
                          base: SpatialColors.surfaceContainerLowest,
                        ),
                        child: TextField(
                          controller: _rollNumberCtrl,
                          style: const TextStyle(
                            fontFamily: 'JetBrainsMono',
                            color: SpatialColors.onSurface,
                          ),
                          decoration: const InputDecoration(border: InputBorder.none),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Barcode Value
            const Text(
              'OPTICAL CODE VALUE',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.8,
                color: SpatialColors.outline,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: SpatialDecorations.inset(
                radius: 12,
                base: SpatialColors.surfaceContainerLowest,
              ),
              child: TextField(
                controller: _barcodeValueCtrl,
                style: const TextStyle(
                  fontFamily: 'JetBrainsMono',
                  color: SpatialColors.accentCyan,
                ),
                decoration: const InputDecoration(
                  hintText: 'e.g. 2023-CS-0842-AX9 or https://...',
                  hintStyle: TextStyle(color: SpatialColors.outline),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Format Selector
            const Text(
              'BARCODE TYPE',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.8,
                color: SpatialColors.outline,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: SpatialButton(
                    label: 'Code 128 (1D)',
                    icon: LucideIcons.scanLine,
                    accentColor: SpatialColors.accentCyan,
                    isSelected: _selectedFormat == 'CODE_128',
                    onPressed: () => setState(() => _selectedFormat = 'CODE_128'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SpatialButton(
                    label: 'QR Code (2D)',
                    icon: LucideIcons.qrCode,
                    accentColor: SpatialColors.accentCyan,
                    isSelected: _selectedFormat == 'QR_CODE',
                    onPressed: () => setState(() => _selectedFormat = 'QR_CODE'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: SpatialButton(
                label: 'Save Digital Pass to Vault',
                icon: LucideIcons.shieldCheck,
                accentColor: SpatialColors.accentEmerald,
                isSelected: true,
                onPressed: () {
                  if (_titleCtrl.text.isEmpty || _barcodeValueCtrl.text.isEmpty) return;
                  final card = CardModel(
                    id: 'card_${DateTime.now().millisecondsSinceEpoch}',
                    title: _titleCtrl.text.trim(),
                    studentName: _studentNameCtrl.text.trim(),
                    rollNumber: _rollNumberCtrl.text.trim(),
                    barcodeValue: _barcodeValueCtrl.text.trim(),
                    barcodeFormat: _selectedFormat,
                  );
                  widget.onSave(card);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
