import 'package:flutter/widgets.dart';
import 'package:cu_ui/cu_ui.dart';
import '../showcases/showcases.dart';

/// PropertyPanel - Right sidebar control panel for the showcase app
///
/// Displays configurable properties for the currently selected component.
/// Uses cu_ui design system components for all controls:
/// - CuInput: Text input fields with proper styling and padding
/// - CuToggle: Boolean on/off switches with animation
/// - CuSlider: Numeric range inputs with visual feedback
/// - Custom select chips: Multi-option selection with active states
///
/// The panel automatically rebuilds when [component] changes,
/// loading the appropriate [PropertyConfig] from [showcaseProperties].
class PropertyPanel extends StatefulWidget {
  /// The currently selected component name (e.g., 'CuButton', 'CuInput')
  final String component;

  /// Current property values for the component
  final Map<String, dynamic> values;

  /// Callback when any property value changes
  final void Function(String key, dynamic value) onPropertyChanged;

  const PropertyPanel({
    super.key,
    required this.component,
    required this.values,
    required this.onPropertyChanged,
  });

  @override
  State<PropertyPanel> createState() => _PropertyPanelState();
}

class _PropertyPanelState extends State<PropertyPanel> with CuComponentMixin {
  /// Text controllers for string inputs - managed to prevent recreating on rebuild
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, FocusNode> _focusNodes = {};

  @override
  void dispose() {
    // Clean up all controllers and focus nodes
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    for (final node in _focusNodes.values) {
      node.dispose();
    }
    super.dispose();
  }

  /// Gets or creates a TextEditingController for a property
  TextEditingController _getController(String name, String initialValue) {
    if (!_controllers.containsKey(name)) {
      _controllers[name] = TextEditingController(text: initialValue);
    }
    return _controllers[name]!;
  }

  /// Gets or creates a FocusNode for a property
  FocusNode _getFocusNode(String name) {
    if (!_focusNodes.containsKey(name)) {
      _focusNodes[name] = FocusNode();
    }
    return _focusNodes[name]!;
  }

  @override
  Widget build(BuildContext context) {
    final properties = showcaseProperties[widget.component] ?? [];

    return SingleChildScrollView(
      padding: EdgeInsets.all(spacing.space4), // 16px using design system
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header using design system typography
          Text(
            'PROPERTIES',
            style: typography.label.copyWith(
              letterSpacing: 1.2,
              color: colors.accents5,
            ),
          ),
          SizedBox(height: spacing.space4),

          // Show message if no configurable properties
          if (properties.isEmpty)
            Text(
              'No configurable properties',
              style: typography.bodySmall.copyWith(color: colors.accents5),
            )
          else
            // Build each property control
            ...properties.map((prop) => _buildProperty(prop)),
        ],
      ),
    );
  }

  /// Builds a single property control with label and optional description
  Widget _buildProperty(PropertyConfig prop) {
    return Padding(
      padding: EdgeInsets.only(bottom: spacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Property label
          Text(
            prop.name,
            style: typography.bodySmall.copyWith(
              fontWeight: typography.weightMedium,
              color: colors.accents7,
            ),
          ),
          SizedBox(height: spacing.space2),

          // Property control (input, toggle, slider, etc.)
          _buildControl(prop),

          // Optional description below control
          if (prop.description != null) ...[
            SizedBox(height: spacing.space1),
            Text(
              prop.description!,
              style: typography.label.copyWith(color: colors.accents5),
            ),
          ],
        ],
      ),
    );
  }

  /// Builds the appropriate control widget based on property type
  Widget _buildControl(PropertyConfig prop) {
    final value = widget.values[prop.name] ?? prop.defaultValue;

    switch (prop.type) {
      case PropertyType.boolean:
        return _buildToggle(prop.name, value as bool);

      case PropertyType.string:
        return _buildTextInput(prop.name, value as String);

      case PropertyType.number:
        return _buildSlider(
          prop.name,
          (value as num).toDouble(),
          prop.min ?? 0,
          prop.max ?? 100,
        );

      case PropertyType.select:
        return _buildSelect(prop.name, value, prop.options ?? []);

      case PropertyType.color:
        return _buildColorPicker(prop.name, value as int);
    }
  }

  /// CuToggle - Boolean on/off switch
  ///
  /// Uses the cu_ui CuToggle component with:
  /// - Smooth animation on state change
  /// - Hover states
  /// - Design system colors (foreground when on, accents2 when off)
  Widget _buildToggle(String name, bool value) {
    return CuToggle(
      value: value,
      size: CuSize.small,
      onChanged: (v) => widget.onPropertyChanged(name, v),
    );
  }

  /// CuInput - Text input field
  ///
  /// Uses the cu_ui CuInput component with:
  /// - Proper padding from spacing tokens (space3 horizontal, space2 vertical)
  /// - Border styling from design system
  /// - Focus states with foreground color border
  /// - Small size variant for compact property panel
  Widget _buildTextInput(String name, String value) {
    final controller = _getController(name, value);
    final focusNode = _getFocusNode(name);

    // Update controller if value changed externally
    if (controller.text != value) {
      controller.text = value;
    }

    return CuInput(
      controller: controller,
      focusNode: focusNode,
      size: CuSize.small,
      onChanged: (v) => widget.onPropertyChanged(name, v),
    );
  }

  /// CuSlider - Numeric range input
  ///
  /// Uses the cu_ui CuSlider component with:
  /// - Visual track showing current value
  /// - Draggable thumb with hover/active states
  /// - Value display on the right
  /// - Min/max bounds
  Widget _buildSlider(String name, double value, double min, double max) {
    return Row(
      children: [
        Expanded(
          child: CuSlider(
            value: value.clamp(min, max),
            min: min,
            max: max,
            size: CuSize.small,
            step: 1,
            onChanged: (v) => widget.onPropertyChanged(name, v),
          ),
        ),
        SizedBox(width: spacing.space3),
        SizedBox(
          width: 36,
          child: Text(
            value.toStringAsFixed(0),
            style: typography.label.copyWith(color: colors.accents6),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  /// Select chips - Multi-option selection
  ///
  /// Custom implementation using design system tokens:
  /// - Wrap layout for automatic line breaking
  /// - Active state: white background, black text
  /// - Inactive state: dark background, muted text with border
  /// - Hover-like visual feedback via GestureDetector
  Widget _buildSelect(String name, dynamic value, List<String> options) {
    return Wrap(
      spacing: spacing.space2,
      runSpacing: spacing.space2,
      children: options.map((option) {
        final isSelected = option == value;
        return GestureDetector(
          onTap: () => widget.onPropertyChanged(name, option),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: spacing.space3,
                vertical: spacing.space2,
              ),
              decoration: BoxDecoration(
                color: isSelected ? colors.foreground : colors.accents1,
                borderRadius: radius.smBorder,
                border: Border.all(
                  color: isSelected ? colors.foreground : colors.accents3,
                ),
              ),
              child: Text(
                option,
                style: typography.label.copyWith(
                  fontWeight: typography.weightMedium,
                  color: isSelected ? colors.background : colors.accents6,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  /// Color picker - Visual color selection
  ///
  /// Displays current color as a swatch.
  /// Uses design system radius and border styling.
  /// TODO: Implement full color picker dialog
  Widget _buildColorPicker(String name, int value) {
    final color = Color(value);
    return GestureDetector(
      onTap: () {
        // TODO: Implement color picker dialog using CuModal
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color,
            borderRadius: radius.mdBorder,
            border: Border.all(color: colors.accents3),
          ),
        ),
      ),
    );
  }
}

/// PropertyConfig - Configuration for a single property control
///
/// Defines metadata about a component property including:
/// - [name]: The property key and display label
/// - [type]: Control type (boolean, string, number, select, color)
/// - [defaultValue]: Initial value when component is selected
/// - [description]: Optional help text shown below control
/// - [options]: For select type - list of valid options
/// - [min]/[max]: For number type - value bounds
class PropertyConfig {
  final String name;
  final PropertyType type;
  final dynamic defaultValue;
  final String? description;
  final List<String>? options;
  final double? min;
  final double? max;

  const PropertyConfig({
    required this.name,
    required this.type,
    required this.defaultValue,
    this.description,
    this.options,
    this.min,
    this.max,
  });
}

/// PropertyType - Enum defining available property control types
///
/// Each type maps to a specific cu_ui component:
/// - [boolean]: CuToggle - on/off switch
/// - [string]: CuInput - text field
/// - [number]: CuSlider - range slider
/// - [select]: Custom chips - option selection
/// - [color]: Color swatch - visual color picker
enum PropertyType {
  boolean,
  string,
  number,
  select,
  color,
}
