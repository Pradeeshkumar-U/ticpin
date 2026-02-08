import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticpin_dining/services/diningformprovider.dart';

class DiningFiltersPage extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  const DiningFiltersPage({required this.formKey, super.key});

  @override
  State<DiningFiltersPage> createState() => _DiningFiltersPageState();
}

class _DiningFiltersPageState extends State<DiningFiltersPage> {
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _dishController = TextEditingController();
  final TextEditingController _cuisineController = TextEditingController();

  @override
  void dispose() {
    _categoryController.dispose();
    _dishController.dispose();
    _cuisineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<DiningFormProvider>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: widget.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel("FILTER CATEGORIES"),
            const SizedBox(height: 8),
            Text(
              'Add categories for filtering (e.g., Family Dining, Fine Dining)',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 16),

            _buildListInput(
              controller: _categoryController,
              onAdd: () {
                if (_categoryController.text.trim().isNotEmpty) {
                  prov.addToList('filterCategories', _categoryController.text.trim());
                  _categoryController.clear();
                }
              },
            ),

            const SizedBox(height: 12),

            if (prov.filterCategories.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: prov.filterCategories.asMap().entries.map((entry) {
                  return Chip(
                    label: Text(entry.value),
                    deleteIcon: const Icon(Icons.close, size: 18),
                    onDeleted: () => prov.removeFromList('filterCategories', entry.key),
                    backgroundColor: const Color(0xFF1E1E82).withOpacity(0.1),
                    deleteIconColor: const Color(0xFF1E1E82),
                  );
                }).toList(),
              ),

            const SizedBox(height: 24),
            const Divider(thickness: 1.5),
            const SizedBox(height: 24),

            _buildLabel("FILTER DISHES"),
            const SizedBox(height: 8),
            Text(
              'Add popular dishes (e.g., Biryani, Pizza, Pasta)',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 16),

            _buildListInput(
              controller: _dishController,
              onAdd: () {
                if (_dishController.text.trim().isNotEmpty) {
                  prov.addToList('filterDishes', _dishController.text.trim());
                  _dishController.clear();
                }
              },
            ),

            const SizedBox(height: 12),

            if (prov.filterDishes.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: prov.filterDishes.asMap().entries.map((entry) {
                  return Chip(
                    label: Text(entry.value),
                    deleteIcon: const Icon(Icons.close, size: 18),
                    onDeleted: () => prov.removeFromList('filterDishes', entry.key),
                    backgroundColor: const Color(0xFF1E1E82).withOpacity(0.1),
                    deleteIconColor: const Color(0xFF1E1E82),
                  );
                }).toList(),
              ),

            const SizedBox(height: 24),
            const Divider(thickness: 1.5),
            const SizedBox(height: 24),

            _buildLabel("FILTER CUISINES"),
            const SizedBox(height: 8),
            Text(
              'Add cuisine types (e.g., Indian, Chinese, Italian)',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 16),

            _buildListInput(
              controller: _cuisineController,
              onAdd: () {
                if (_cuisineController.text.trim().isNotEmpty) {
                  prov.addToList('filterCuisines', _cuisineController.text.trim());
                  _cuisineController.clear();
                }
              },
            ),

            const SizedBox(height: 12),

            if (prov.filterCuisines.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: prov.filterCuisines.asMap().entries.map((entry) {
                  return Chip(
                    label: Text(entry.value),
                    deleteIcon: const Icon(Icons.close, size: 18),
                    onDeleted: () => prov.removeFromList('filterCuisines', entry.key),
                    backgroundColor: const Color(0xFF1E1E82).withOpacity(0.1),
                    deleteIconColor: const Color(0xFF1E1E82),
                  );
                }).toList(),
              ),

            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue.shade700),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'These filters help users find your dining easily',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue.shade900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1E1E82),
          letterSpacing: 1.2,
        ),
      );

  Widget _buildListInput({
    required TextEditingController controller,
    required VoidCallback onAdd,
  }) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              labelText: "Add item",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: onAdd,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1E1E82),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            "Add",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}