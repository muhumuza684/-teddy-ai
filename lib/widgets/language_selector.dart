import 'package:flutter/material.dart';
import '../services/sunbird_service.dart';
import '../theme.dart';

class LanguageSelector extends StatelessWidget {
  final String selectedCode;
  final ValueChanged<String> onChanged;

  const LanguageSelector({super.key, required this.selectedCode, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: SunbirdService.languages.entries.map((entry) {
          final active = entry.value == selectedCode;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => onChanged(entry.value),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: active ? TeddyTheme.primary : Colors.transparent,
                  border: Border.all(
                    color: active ? TeddyTheme.primary : Colors.grey.shade300,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  entry.key,
                  style: TextStyle(
                    color: active ? Colors.white : Colors.grey.shade600,
                    fontSize: 12,
                    fontWeight: active ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
