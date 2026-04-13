import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/config/domain_enums.dart';

final class RewardCardEditorSheet extends StatefulWidget {
  const RewardCardEditorSheet({
    super.key,
    this.initialContent = '',
    this.lockedRarity,
    this.submitLabel = 'Save reward',
  });

  final String initialContent;
  final RewardRarity? lockedRarity;
  final String submitLabel;

  @override
  State<RewardCardEditorSheet> createState() => _RewardCardEditorSheetState();
}

final class _RewardCardEditorSheetState extends State<RewardCardEditorSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _contentController;
  late RewardRarity _selectedRarity;

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController(text: widget.initialContent);
    _selectedRarity = widget.lockedRarity ?? RewardRarity.white;
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final viewInsets = MediaQuery.of(context).viewInsets;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + viewInsets.bottom),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sheet handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),
              Text(
                widget.initialContent.isEmpty ? 'New reward' : 'Edit reward',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _contentController,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Reward content',
                  hintText: 'Order bubble tea',
                  filled: true,
                  fillColor: colorScheme.surfaceContainerLow,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: colorScheme.outlineVariant,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: colorScheme.primary,
                      width: 1.5,
                    ),
                  ),
                ),
                maxLines: 3,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter reward content.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              if (widget.lockedRarity == null) ...[
                Text(
                  'Rarity',
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: RewardRarity.values
                      .map(
                        (rarity) => ChoiceChip(
                          label: Text(_rewardRarityLabel(rarity)),
                          selected: _selectedRarity == rarity,
                          onSelected: (_) {
                            setState(() {
                              _selectedRarity = rarity;
                            });
                          },
                          labelStyle: GoogleFonts.beVietnamPro(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                      .toList(growable: false),
                ),
              ] else ...[
                Text(
                  'Rarity',
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${_rewardRarityLabel(_selectedRarity)} — fixed after creation',
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 13,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _submit,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF92552C),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    widget.submitLabel,
                    style: GoogleFonts.beVietnamPro(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    Navigator.of(context).pop(
      RewardCardEditorResult(
        content: _contentController.text.trim(),
        rarity: _selectedRarity,
      ),
    );
  }
}

final class RewardCardEditorResult {
  const RewardCardEditorResult({required this.content, required this.rarity});

  final String content;
  final RewardRarity rarity;
}

String _rewardRarityLabel(RewardRarity rarity) {
  return switch (rarity) {
    RewardRarity.white => 'White',
    RewardRarity.purple => 'Purple',
    RewardRarity.golden => 'Golden',
    RewardRarity.red => 'Red',
  };
}
