import 'package:flutter/material.dart';

class DropdownBottomSheet extends StatefulWidget {
  final String title;
  final List<String> items;
  final Function(String) onSelected;

  const DropdownBottomSheet({
    super.key,
    required this.title,
    required this.items,
    required this.onSelected,
  });

  @override
  State<DropdownBottomSheet> createState() => _DropdownBottomSheetState();
}

class _DropdownBottomSheetState extends State<DropdownBottomSheet> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    final filteredItems = widget.items
        .where((e) => e.toLowerCase().contains(query.toLowerCase()))
        .toList();
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      minChildSize: 0.4,
      maxChildSize: 0.95,

      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),

          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurface.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  widget.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),

              /// SEARCH FIELD (AMAN DARI OVERFLOW)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.search,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    hintText: "Cari...",
                    filled: true,
                    fillColor: theme.colorScheme.surfaceVariant,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: TextStyle(color: theme.colorScheme.onSurface),
                  onChanged: (val) => setState(() => query = val),
                ),
              ),

              const SizedBox(height: 8),

              /// LIST HARUS FLEXIBLE
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: filteredItems.length,
                  itemBuilder: (_, index) {
                    final item = filteredItems[index];
                    return ListTile(
                      title: Text(
                        item,
                        style: TextStyle(color: theme.colorScheme.onSurface),
                      ),
                      onTap: () => widget.onSelected(item),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
