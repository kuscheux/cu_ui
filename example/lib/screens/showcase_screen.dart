import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:cu_ui/cu_ui.dart';
import '../widgets/component_selector.dart';
import '../widgets/property_panel.dart';
import '../widgets/device_frame.dart';
import '../showcases/showcases.dart';

/// Component category for organization
enum ComponentCategory {
  buttons('Buttons'),
  inputs('Inputs'),
  layout('Layout'),
  surfaces('Surfaces'),
  navigation('Navigation'),
  typography('Typography'),
  dataDisplay('Data Display'),
  feedback('Feedback'),
  screens('Screens');

  final String label;
  const ComponentCategory(this.label);
}

/// Main showcase screen with component browser and property controls
class ShowcaseScreen extends StatefulWidget {
  const ShowcaseScreen({super.key});

  @override
  State<ShowcaseScreen> createState() => _ShowcaseScreenState();
}

class _ShowcaseScreenState extends State<ShowcaseScreen> {
  ComponentCategory _selectedCategory = ComponentCategory.buttons;
  String _selectedComponent = 'CuButton';
  bool _isDarkTheme = true;
  bool _showDeviceFrame = true;
  double _canvasScale = 1.0;

  // Property states for current component
  Map<String, dynamic> _propertyValues = {};

  // Focus node for keyboard events
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _propertyValues = _getDefaultProperties(_selectedComponent);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    final isMetaOrControl = HardwareKeyboard.instance.isMetaPressed ||
        HardwareKeyboard.instance.isControlPressed;

    if (!isMetaOrControl) return KeyEventResult.ignored;

    // Cmd/Ctrl + Plus (= key, since + is shift+=)
    if (event.logicalKey == LogicalKeyboardKey.equal ||
        event.logicalKey == LogicalKeyboardKey.numpadAdd) {
      setState(() {
        _canvasScale = (_canvasScale + 0.1).clamp(0.5, 2.0);
      });
      return KeyEventResult.handled;
    }

    // Cmd/Ctrl + Minus
    if (event.logicalKey == LogicalKeyboardKey.minus ||
        event.logicalKey == LogicalKeyboardKey.numpadSubtract) {
      setState(() {
        _canvasScale = (_canvasScale - 0.1).clamp(0.5, 2.0);
      });
      return KeyEventResult.handled;
    }

    // Cmd/Ctrl + 0 (reset)
    if (event.logicalKey == LogicalKeyboardKey.digit0 ||
        event.logicalKey == LogicalKeyboardKey.numpad0) {
      setState(() {
        _canvasScale = 1.0;
      });
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  Map<String, dynamic> _getDefaultProperties(String component) {
    return showcaseDefaults[component] ?? {};
  }

  void _updateProperty(String key, dynamic value) {
    setState(() {
      _propertyValues[key] = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = _isDarkTheme ? CuThemeData.dark() : CuThemeData.light();

    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _handleKeyEvent,
      child: CuTheme(
        theme: CuThemeData.dark(), // Always dark for the shell
        child: SizedBox.expand(
          child: Container(
            color: const Color(0xFF0A0A0A),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Top bar with logo and theme toggle
                  _buildTopBar(),

                  // Main content
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Left sidebar - Component list
                        _buildComponentSidebar(),

                        // Center - Preview area with device frame
                        Expanded(
                          flex: 3,
                          child: _buildPreviewArea(theme),
                        ),

                        // Right sidebar - Property controls
                        _buildPropertySidebar(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFF222222), width: 1),
        ),
      ),
      child: Row(
        children: [
          // Logo
          const Text(
            'cu',
            style: TextStyle(
              fontFamily: 'Cyrovoid',
              fontSize: 24,
              letterSpacing: 2,
              color: Color(0xFFFFFFFF),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            'design language',
            style: TextStyle(
              fontFamily: 'Geist',
              fontSize: 14,
              color: const Color(0xFF666666),
            ),
          ),

          const Spacer(),

          // Zoom indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: const Color(0xFF333333)),
            ),
            child: Text(
              '${(_canvasScale * 100).round()}%',
              style: const TextStyle(
                fontFamily: 'Geist',
                fontSize: 12,
                color: Color(0xFF888888),
              ),
            ),
          ),
          const SizedBox(width: 24),

          // Device frame toggle
          _buildToggle(
            'Device Frame',
            _showDeviceFrame,
            (v) => setState(() => _showDeviceFrame = v),
          ),
          const SizedBox(width: 24),

          // Theme toggle
          _buildToggle(
            'Dark Theme',
            _isDarkTheme,
            (v) => setState(() => _isDarkTheme = v),
          ),
        ],
      ),
    );
  }

  Widget _buildToggle(String label, bool value, ValueChanged<bool> onChanged) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Geist',
              fontSize: 12,
              color: Color(0xFF888888),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 36,
            height: 20,
            decoration: BoxDecoration(
              color: value ? const Color(0xFFFFFFFF) : const Color(0xFF333333),
              borderRadius: BorderRadius.circular(10),
            ),
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 150),
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 16,
                height: 16,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: value ? const Color(0xFF000000) : const Color(0xFF666666),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComponentSidebar() {
    return Container(
      width: 240,
      decoration: const BoxDecoration(
        border: Border(
          right: BorderSide(color: Color(0xFF222222), width: 1),
        ),
      ),
      child: ComponentSelector(
        selectedCategory: _selectedCategory,
        selectedComponent: _selectedComponent,
        onCategoryChanged: (category) {
          setState(() {
            _selectedCategory = category;
            _selectedComponent = _getFirstComponent(category);
            _propertyValues = _getDefaultProperties(_selectedComponent);
          });
        },
        onComponentChanged: (component) {
          setState(() {
            _selectedComponent = component;
            _propertyValues = _getDefaultProperties(component);
          });
        },
      ),
    );
  }

  String _getFirstComponent(ComponentCategory category) {
    return componentsByCategory[category]?.first ?? 'CuButton';
  }

  Widget _buildPreviewArea(CuThemeData theme) {
    final previewContent = _showDeviceFrame
        ? DeviceFrame(
            key: ValueKey('$_selectedComponent-$_isDarkTheme'),
            child: CuTheme(
              theme: theme,
              child: _buildComponentPreview(),
            ),
          )
        : Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: theme.colors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF333333)),
            ),
            child: CuTheme(
              theme: theme,
              child: _buildComponentPreview(),
            ),
          );

    return Container(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Transform.scale(
          scale: _canvasScale,
          child: previewContent,
        ),
      ),
    );
  }

  Widget _buildComponentPreview() {
    final showcase = showcases[_selectedComponent];
    if (showcase == null) {
      return Center(
        child: Text(
          'No preview available for $_selectedComponent',
          style: const TextStyle(
            fontFamily: 'Geist',
            fontSize: 14,
            color: Color(0xFF666666),
          ),
        ),
      );
    }
    return showcase(_propertyValues);
  }

  Widget _buildPropertySidebar() {
    return Container(
      width: 280,
      decoration: const BoxDecoration(
        border: Border(
          left: BorderSide(color: Color(0xFF222222), width: 1),
        ),
      ),
      child: PropertyPanel(
        component: _selectedComponent,
        values: _propertyValues,
        onPropertyChanged: _updateProperty,
      ),
    );
  }
}

/// Component list by category
const Map<ComponentCategory, List<String>> componentsByCategory = {
  ComponentCategory.buttons: ['CuButton'],
  ComponentCategory.inputs: [
    'CuInput',
    'CuTextarea',
    'CuCheckbox',
    'CuRadio',
    'CuToggle',
    'CuSlider',
    'CuSelect',
    'CuAutoComplete',
  ],
  ComponentCategory.layout: [
    'CuGrid',
    'CuRow',
    'CuCol',
    'CuSpacer',
    'CuDivider',
    'CuPage',
    'CuFieldset',
  ],
  ComponentCategory.surfaces: [
    'CuCard',
    'CuModal',
    'CuDrawer',
    'CuPopover',
    'CuTooltip',
    'CuCollapse',
  ],
  ComponentCategory.navigation: [
    'CuTabs',
    'CuBreadcrumbs',
    'CuPagination',
    'CuLink',
    'CuBottomNav',
    'CuAppBar',
    'CuAdaptiveNav',
  ],
  ComponentCategory.typography: [
    'CuText',
    'CuCode',
    'CuSnippet',
    'CuKeyboard',
    'CuShimmerText',
  ],
  ComponentCategory.dataDisplay: [
    'CuAvatar',
    'CuBadge',
    'CuTag',
    'CuTable',
    'CuUser',
    'CuDot',
    'CuCapacity',
    'CuDescription',
    'CuDisplay',
    'CuImage',
    'CuRating',
    'CuListTile',
  ],
  ComponentCategory.feedback: [
    'CuSpinner',
    'CuLoading',
    'CuProgress',
    'CuNote',
    'CuToast',
    'CuShimmer',
    'CuSkeleton',
  ],
  ComponentCategory.screens: [
    'CuLoadingScreen',
    'CuLoginScreen',
    'CuDashboardScreen',
    'CuTransferScreen',
    'CuSettingsScreen',
    'CuAccountDetailScreen',
  ],
};
