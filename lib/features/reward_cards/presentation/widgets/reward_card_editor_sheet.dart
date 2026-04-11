import 'package:flutter/material.dart';

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
    final viewInsets = MediaQuery.of(context).viewInsets;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + viewInsets.bottom),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.initialContent.isEmpty ? 'New reward' : 'Edit reward',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contentController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Reward content',
                  hintText: 'Order bubble tea',
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter reward content.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              if (widget.lockedRarity == null)
                DropdownButtonFormField<RewardRarity>(
                  initialValue: _selectedRarity,
                  decoration: const InputDecoration(labelText: 'Rarity'),
                  items: RewardRarity.values
                      .map((rarity) {
                        return DropdownMenuItem<RewardRarity>(
                          value: rarity,
                          child: Text(_rewardRarityLabel(rarity)),
                        );
                      })
                      .toList(growable: false),
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }
                    setState(() {
                      _selectedRarity = value;
                    });
                  },
                )
              else
                InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Rarity',
                    helperText: 'Rarity stays fixed after creation.',
                  ),
                  child: Text(_rewardRarityLabel(_selectedRarity)),
                ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _submit,
                  child: Text(widget.submitLabel),
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
