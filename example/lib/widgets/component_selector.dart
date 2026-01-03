import 'package:flutter/widgets.dart';
import '../screens/showcase_screen.dart';

/// Left sidebar component selector
class ComponentSelector extends StatelessWidget {
  final ComponentCategory selectedCategory;
  final String selectedComponent;
  final ValueChanged<ComponentCategory> onCategoryChanged;
  final ValueChanged<String> onComponentChanged;

  const ComponentSelector({
    super.key,
    required this.selectedCategory,
    required this.selectedComponent,
    required this.onCategoryChanged,
    required this.onComponentChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'COMPONENTS',
            style: TextStyle(
              fontFamily: 'Geist',
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
              color: Color(0xFF666666),
            ),
          ),
          const SizedBox(height: 16),
          ...ComponentCategory.values.map((category) {
            final isExpanded = category == selectedCategory;
            final components = componentsByCategory[category] ?? [];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category header
                GestureDetector(
                  onTap: () => onCategoryChanged(category),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isExpanded
                          ? const Color(0xFF1A1A1A)
                          : const Color(0x00000000),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        Text(
                          isExpanded ? '▼' : '▶',
                          style: TextStyle(
                            fontSize: 8,
                            color: isExpanded
                                ? const Color(0xFFFFFFFF)
                                : const Color(0xFF666666),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            category.label,
                            style: TextStyle(
                              fontFamily: 'Geist',
                              fontSize: 13,
                              fontWeight:
                                  isExpanded ? FontWeight.w500 : FontWeight.w400,
                              color: isExpanded
                                  ? const Color(0xFFFFFFFF)
                                  : const Color(0xFF888888),
                            ),
                          ),
                        ),
                        Text(
                          '${components.length}',
                          style: const TextStyle(
                            fontFamily: 'Geist',
                            fontSize: 11,
                            color: Color(0xFF444444),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Component list (when expanded)
                if (isExpanded)
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 4, bottom: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: components.map((component) {
                        final isSelected = component == selectedComponent;
                        return GestureDetector(
                          onTap: () => onComponentChanged(component),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFFFFFFFF)
                                  : const Color(0x00000000),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              component,
                              style: TextStyle(
                                fontFamily: 'Geist',
                                fontSize: 13,
                                fontWeight: isSelected
                                    ? FontWeight.w500
                                    : FontWeight.w400,
                                color: isSelected
                                    ? const Color(0xFF000000)
                                    : const Color(0xFF888888),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                const SizedBox(height: 4),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }
}
