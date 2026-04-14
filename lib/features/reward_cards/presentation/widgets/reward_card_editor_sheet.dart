import 'package:flutter/material.dart';

import '../../../../app/widgets/app_rarity_badge.dart';
import '../../../../app/widgets/app_section_card.dart';
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
    final isEditing = widget.initialContent.isNotEmpty;

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20, 12, 20, 20 + viewInsets.bottom),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEditing ? 'Edit reward' : 'New reward',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                isEditing
                    ? 'Adjust the reward wording while keeping the existing rarity intact.'
                    : 'Create a reward that feels personal, motivating, and worth unlocking later.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 18),
              AppSectionCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Reward preview'),
                    const SizedBox(height: 10),
                    AppRarityBadge(rarity: _selectedRarity),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _contentController,
                      autofocus: true,
                      decoration: const InputDecoration(
                        labelText: 'Reward content',
                        hintText: 'Order bubble tea',
                        helperText:
                            'Keep it specific enough to feel satisfying when it unlocks.',
                      ),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Enter reward content.';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              if (widget.lockedRarity == null)
                AppSectionCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Rarity',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Pick the feeling you want the reward to carry. This will stay fixed after creation.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: RewardRarity.values
                            .map((rarity) {
                              final selected = rarity == _selectedRarity;
                              return ChoiceChip(
                                selected: selected,
                                label: Text(_rewardRarityLabel(rarity)),
                                avatar: selected
                                    ? const Icon(Icons.check)
                                    : null,
                                onSelected: (_) {
                                  setState(() {
                                    _selectedRarity = rarity;
                                  });
                                },
                              );
                            })
                            .toList(growable: false),
                      ),
                    ],
                  ),
                )
              else
                AppSectionCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Rarity',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 10),
                      AppRarityBadge(rarity: _selectedRarity),
                      const SizedBox(height: 10),
                      Text(
                        'Rarity stays fixed after creation so existing pool probabilities remain trustworthy.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
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
