import 'package:flutter/material.dart';

import '../constants/app_strings.dart';

/// A compact selector for existing backend entities.  The selected [id] is
/// deliberately kept separate from the human-friendly text shown to a user.
class EntityPickerOption {
  final String id;
  final String label;
  final String subtitle;

  const EntityPickerOption({
    required this.id,
    required this.label,
    required this.subtitle,
  });
}

class SearchableEntityPicker extends StatelessWidget {
  final String label;
  final String? value;
  final List<EntityPickerOption> options;
  final ValueChanged<String?> onChanged;
  final bool isRequired;

  const SearchableEntityPicker({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
    this.isRequired = true,
  });

  @override
  Widget build(BuildContext context) {
    EntityPickerOption? selected;
    for (final option in options) {
      if (option.id == value) {
        selected = option;
        break;
      }
    }
    return FormField<String>(
      initialValue: value,
      validator: isRequired ? (value) => value == null || value.isEmpty ? 'Required' : null : null,
      builder: (field) => InkWell(
        onTap: () async {
          final result = await showModalBottomSheet<String>(
            context: context,
            isScrollControlled: true,
            builder: (_) => _EntityPickerSheet(label: label, options: options),
          );
          if (result != null) {
            field.didChange(result);
            onChanged(result);
          }
        },
        child: InputDecorator(
          decoration: InputDecoration(labelText: label, errorText: field.errorText),
          child: selected == null
              ? Text(AppStrings.tr('Select an option'))
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(selected.label),
                    if (selected.subtitle.isNotEmpty)
                      Text(selected.subtitle, style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
        ),
      ),
    );
  }
}

class _EntityPickerSheet extends StatefulWidget {
  final String label;
  final List<EntityPickerOption> options;
  const _EntityPickerSheet({required this.label, required this.options});

  @override
  State<_EntityPickerSheet> createState() => _EntityPickerSheetState();
}

class _EntityPickerSheetState extends State<_EntityPickerSheet> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    final options = widget.options.where((option) {
      final value = query.toLowerCase();
      return option.label.toLowerCase().contains(value) || option.subtitle.toLowerCase().contains(value);
    }).toList();
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                autofocus: true,
                decoration: InputDecoration(labelText: widget.label, prefixIcon: const Icon(Icons.search)),
                onChanged: (value) => setState(() => query = value.trim()),
              ),
            ),
            SizedBox(
              height: 360,
              child: ListView.builder(
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final option = options[index];
                  return ListTile(
                    title: Text(option.label),
                    subtitle: option.subtitle.isEmpty ? null : Text(option.subtitle),
                    onTap: () => Navigator.pop(context, option.id),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
