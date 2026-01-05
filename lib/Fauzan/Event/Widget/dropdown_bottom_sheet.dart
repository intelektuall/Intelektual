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

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              /// SEARCH FIELD (AMAN DARI OVERFLOW)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: "Cari...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
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
                      title: Text(item),
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
