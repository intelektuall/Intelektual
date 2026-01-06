import 'package:flutter/material.dart';
import '../Widget/custom_dropdown.dart';
import '../EventDataList/event_constants.dart';

class EventFilterSection extends StatelessWidget {
  final String? selectedLocation;
  final String? selectedCategory;
  final bool showJoinedOnly;
  final ValueChanged<String?> onLocationChanged;
  final ValueChanged<String?> onCategoryChanged;
  final ValueChanged<bool> onJoinedToggle;

  const EventFilterSection({
    super.key,
    required this.selectedLocation,
    required this.selectedCategory,
    required this.showJoinedOnly,
    required this.onLocationChanged,
    required this.onCategoryChanged,
    required this.onJoinedToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: CustomDropdown(
                hint: "Pilih Provinsi",
                value: selectedLocation,
                items: provinces,
                onChanged: (val) {
                  onLocationChanged(val == 'None' ? null : val);
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomDropdown(
                hint: "Pilih Kategori",
                value: selectedCategory,
                items: eventCategories,
                onChanged: (val) {
                  onCategoryChanged(val == 'None' ? null : val);
                },
              ),
            ),
          ],
        ),
        Row(
          children: [
            Switch(value: showJoinedOnly, onChanged: onJoinedToggle),
            const Text("Tampilkan yang diikuti"),
          ],
        ),
      ],
    );
  }
}
