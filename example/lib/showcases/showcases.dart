import 'package:flutter/widgets.dart';
import 'package:cu_ui/cu_ui.dart';
import '../widgets/property_panel.dart';

/// Showcase builders for each component
final Map<String, Widget Function(Map<String, dynamic>)> showcases = {
  // Buttons
  'CuButton': (props) => _buttonShowcase(props),

  // Inputs
  'CuInput': (props) => _inputShowcase(props),
  'CuTextarea': (props) => _textareaShowcase(props),
  'CuCheckbox': (props) => _checkboxShowcase(props),
  'CuRadio': (props) => _radioShowcase(props),
  'CuToggle': (props) => _toggleShowcase(props),
  'CuSlider': (props) => _sliderShowcase(props),
  'CuSelect': (props) => _selectShowcase(props),
  'CuAutoComplete': (props) => _autoCompleteShowcase(props),

  // Layout
  'CuGrid': (props) => _gridShowcase(props),
  'CuRow': (props) => _rowShowcase(props),
  'CuCol': (props) => _colShowcase(props),
  'CuSpacer': (props) => _spacerShowcase(props),
  'CuDivider': (props) => _dividerShowcase(props),
  'CuPage': (props) => _pageShowcase(props),
  'CuFieldset': (props) => _fieldsetShowcase(props),

  // Surfaces
  'CuCard': (props) => _cardShowcase(props),
  'CuModal': (props) => _modalShowcase(props),
  'CuDrawer': (props) => _drawerShowcase(props),
  'CuPopover': (props) => _popoverShowcase(props),
  'CuTooltip': (props) => _tooltipShowcase(props),
  'CuCollapse': (props) => _collapseShowcase(props),

  // Navigation
  'CuTabs': (props) => _tabsShowcase(props),
  'CuBreadcrumbs': (props) => _breadcrumbsShowcase(props),
  'CuPagination': (props) => _paginationShowcase(props),
  'CuLink': (props) => _linkShowcase(props),
  'CuBottomNav': (props) => _bottomNavShowcase(props),
  'CuAppBar': (props) => _appBarShowcase(props),
  'CuAdaptiveNav': (props) => _adaptiveNavShowcase(props),

  // Typography
  'CuText': (props) => _textShowcase(props),
  'CuCode': (props) => _codeShowcase(props),
  'CuSnippet': (props) => _snippetShowcase(props),
  'CuKeyboard': (props) => _keyboardShowcase(props),
  'CuShimmerText': (props) => _shimmerTextShowcase(props),

  // Data Display
  'CuAvatar': (props) => _avatarShowcase(props),
  'CuBadge': (props) => _badgeShowcase(props),
  'CuTag': (props) => _tagShowcase(props),
  'CuTable': (props) => _tableShowcase(props),
  'CuUser': (props) => _userShowcase(props),
  'CuDot': (props) => _dotShowcase(props),
  'CuCapacity': (props) => _capacityShowcase(props),
  'CuDescription': (props) => _descriptionShowcase(props),
  'CuDisplay': (props) => _displayShowcase(props),
  'CuImage': (props) => _imageShowcase(props),
  'CuRating': (props) => _ratingShowcase(props),
  'CuListTile': (props) => _listTileShowcase(props),

  // Feedback
  'CuSpinner': (props) => _spinnerShowcase(props),
  'CuLoading': (props) => _loadingShowcase(props),
  'CuProgress': (props) => _progressShowcase(props),
  'CuNote': (props) => _noteShowcase(props),
  'CuToast': (props) => _toastShowcase(props),
  'CuShimmer': (props) => _shimmerShowcase(props),
  'CuSkeleton': (props) => _skeletonShowcase(props),

  // Screens
  'CuLoadingScreen': (props) => _loadingScreenShowcase(props),
  'CuLoginScreen': (props) => _loginScreenShowcase(props),
  'CuDashboardScreen': (props) => _dashboardScreenShowcase(props),
  'CuTransferScreen': (props) => _transferScreenShowcase(props),
  'CuSettingsScreen': (props) => _settingsScreenShowcase(props),
  'CuAccountDetailScreen': (props) => _accountDetailScreenShowcase(props),
};

/// Default property values for each component
final Map<String, Map<String, dynamic>> showcaseDefaults = {
  'CuButton': {
    'text': 'Click me',
    'type': 'default_',
    'size': 'medium',
    'disabled': false,
    'loading': false,
    'ghost': false,
  },
  'CuInput': {
    'placeholder': 'Enter text...',
    'label': 'Input Label',
    'disabled': false,
  },
  'CuTextarea': {
    'placeholder': 'Enter longer text...',
  },
  'CuCheckbox': {
    'label': 'Accept terms',
    'value': false,
    'disabled': false,
  },
  'CuRadio': {
    'value': 'option1',
  },
  'CuToggle': {
    'value': false,
    'disabled': false,
  },
  'CuSlider': {
    'value': 50.0,
  },
  'CuSelect': {
    'placeholder': 'Select an option...',
  },
  'CuAutoComplete': {
    'placeholder': 'Search...',
  },
  'CuGrid': {},
  'CuRow': {},
  'CuCol': {},
  'CuSpacer': {},
  'CuDivider': {
    'text': '',
  },
  'CuPage': {},
  'CuFieldset': {
    'title': 'Fieldset Title',
  },
  'CuCard': {
    'hoverable': false,
    'shadow': false,
  },
  'CuModal': {},
  'CuDrawer': {},
  'CuPopover': {},
  'CuTooltip': {
    'text': 'Tooltip text',
  },
  'CuCollapse': {
    'title': 'Click to expand',
  },
  'CuTabs': {},
  'CuBreadcrumbs': {},
  'CuPagination': {
    'page': 1,
    'count': 10,
  },
  'CuLink': {
    'text': 'Link text',
    'underline': true,
  },
  'CuBottomNav': {},
  'CuAppBar': {
    'title': 'App Bar Title',
  },
  'CuAdaptiveNav': {},
  'CuText': {
    'text': 'The quick brown fox jumps over the lazy dog.',
    'element': 'p',
  },
  'CuCode': {
    'text': 'const x = 42;',
  },
  'CuSnippet': {
    'text': 'npm install cu_ui',
  },
  'CuKeyboard': {
    'text': '⌘ + K',
  },
  'CuShimmerText': {
    'text': 'Shimmering Text',
  },
  'CuAvatar': {
    'text': 'JD',
    'size': 48.0,
    'isSquare': false,
  },
  'CuBadge': {
    'text': 'NEW',
    'type': 'default_',
  },
  'CuTag': {
    'text': 'Tag',
    'type': 'default_',
  },
  'CuTable': {},
  'CuUser': {
    'name': 'John Doe',
    'description': 'Software Engineer',
  },
  'CuDot': {
    'type': 'default_',
  },
  'CuCapacity': {
    'value': 75.0,
  },
  'CuDescription': {
    'title': 'Description Title',
    'content': 'This is the description content.',
  },
  'CuDisplay': {
    'value': '\$12,543.00',
    'caption': 'Total Balance',
  },
  'CuImage': {},
  'CuRating': {
    'value': 3,
    'count': 5,
  },
  'CuListTile': {
    'title': 'List Item Title',
    'subtitle': 'Subtitle text',
  },
  'CuSpinner': {},
  'CuLoading': {},
  'CuProgress': {
    'value': 65.0,
    'max': 100.0,
  },
  'CuNote': {
    'text': 'This is an informational note.',
    'type': 'default_',
    'filled': false,
  },
  'CuToast': {
    'message': 'This is a toast message',
    'type': 'default_',
  },
  'CuShimmer': {},
  'CuSkeleton': {},
  'CuLoadingScreen': {
    'message': 'Loading your account...',
    'showSkeleton': true,
    'skeletonType': 'dashboard',
  },
  'CuLoginScreen': {},
  'CuDashboardScreen': {},
  'CuTransferScreen': {},
  'CuSettingsScreen': {},
  'CuAccountDetailScreen': {},
};

/// Property configurations for each component
final Map<String, List<PropertyConfig>> showcaseProperties = {
  'CuButton': [
    const PropertyConfig(
      name: 'text',
      type: PropertyType.string,
      defaultValue: 'Click me',
      description: 'Button label text',
    ),
    const PropertyConfig(
      name: 'type',
      type: PropertyType.select,
      defaultValue: 'default_',
      options: ['default_', 'secondary', 'success', 'warning', 'error', 'abort'],
      description: 'Button variant',
    ),
    const PropertyConfig(
      name: 'size',
      type: PropertyType.select,
      defaultValue: 'medium',
      options: ['small', 'medium', 'large'],
      description: 'Button size',
    ),
    const PropertyConfig(
      name: 'disabled',
      type: PropertyType.boolean,
      defaultValue: false,
    ),
    const PropertyConfig(
      name: 'loading',
      type: PropertyType.boolean,
      defaultValue: false,
    ),
    const PropertyConfig(
      name: 'ghost',
      type: PropertyType.boolean,
      defaultValue: false,
      description: 'Transparent background',
    ),
  ],
  'CuInput': [
    const PropertyConfig(
      name: 'placeholder',
      type: PropertyType.string,
      defaultValue: 'Enter text...',
    ),
    const PropertyConfig(
      name: 'label',
      type: PropertyType.string,
      defaultValue: 'Input Label',
    ),
    const PropertyConfig(
      name: 'disabled',
      type: PropertyType.boolean,
      defaultValue: false,
    ),
  ],
  'CuToggle': [
    const PropertyConfig(
      name: 'value',
      type: PropertyType.boolean,
      defaultValue: false,
    ),
    const PropertyConfig(
      name: 'disabled',
      type: PropertyType.boolean,
      defaultValue: false,
    ),
  ],
  'CuSlider': [
    const PropertyConfig(
      name: 'value',
      type: PropertyType.number,
      defaultValue: 50.0,
      min: 0,
      max: 100,
    ),
  ],
  'CuText': [
    const PropertyConfig(
      name: 'text',
      type: PropertyType.string,
      defaultValue: 'The quick brown fox jumps over the lazy dog.',
    ),
    const PropertyConfig(
      name: 'element',
      type: PropertyType.select,
      defaultValue: 'p',
      options: ['h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'p', 'b', 'small', 'i', 'span'],
    ),
  ],
  'CuBadge': [
    const PropertyConfig(
      name: 'text',
      type: PropertyType.string,
      defaultValue: 'NEW',
    ),
    const PropertyConfig(
      name: 'type',
      type: PropertyType.select,
      defaultValue: 'default_',
      options: ['default_', 'secondary', 'success', 'warning', 'error'],
    ),
  ],
  'CuAvatar': [
    const PropertyConfig(
      name: 'text',
      type: PropertyType.string,
      defaultValue: 'JD',
    ),
    const PropertyConfig(
      name: 'size',
      type: PropertyType.number,
      defaultValue: 48.0,
      min: 24,
      max: 120,
    ),
    const PropertyConfig(
      name: 'isSquare',
      type: PropertyType.boolean,
      defaultValue: false,
    ),
  ],
  'CuProgress': [
    const PropertyConfig(
      name: 'value',
      type: PropertyType.number,
      defaultValue: 65.0,
      min: 0,
      max: 100,
    ),
  ],
  'CuNote': [
    const PropertyConfig(
      name: 'text',
      type: PropertyType.string,
      defaultValue: 'This is an informational note.',
    ),
    const PropertyConfig(
      name: 'type',
      type: PropertyType.select,
      defaultValue: 'default_',
      options: ['default_', 'secondary', 'success', 'warning', 'error'],
    ),
    const PropertyConfig(
      name: 'filled',
      type: PropertyType.boolean,
      defaultValue: false,
    ),
  ],
  'CuCapacity': [
    const PropertyConfig(
      name: 'value',
      type: PropertyType.number,
      defaultValue: 75.0,
      min: 0,
      max: 100,
    ),
  ],
  'CuRating': [
    const PropertyConfig(
      name: 'value',
      type: PropertyType.number,
      defaultValue: 3,
      min: 0,
      max: 5,
    ),
  ],
  'CuPagination': [
    const PropertyConfig(
      name: 'page',
      type: PropertyType.number,
      defaultValue: 1,
      min: 1,
      max: 10,
    ),
    const PropertyConfig(
      name: 'count',
      type: PropertyType.number,
      defaultValue: 10,
      min: 1,
      max: 100,
    ),
  ],
};

// ============================================
// BUTTON SHOWCASES
// ============================================

Widget _buttonShowcase(Map<String, dynamic> props) {
  final type = _parseButtonType(props['type'] as String? ?? 'default_');
  final size = _parseSize(props['size'] as String? ?? 'medium');

  return Padding(
    padding: const EdgeInsets.all(24),
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CuButton(
            type: type,
            size: size,
            auto: true,
            disabled: props['disabled'] as bool? ?? false,
            loading: props['loading'] as bool? ?? false,
            ghost: props['ghost'] as bool? ?? false,
            onPressed: () {},
            child: Text(props['text'] as String? ?? 'Click me'),
          ),
          const SizedBox(height: 24),
          // Show all button types
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              CuButton(auto: true, onPressed: () {}, child: const Text('Default')),
              CuButton.secondary(auto: true, onPressed: () {}, child: const Text('Secondary')),
              CuButton.success(auto: true, onPressed: () {}, child: const Text('Success')),
              CuButton.warning(auto: true, onPressed: () {}, child: const Text('Warning')),
              CuButton.error(auto: true, onPressed: () {}, child: const Text('Error')),
            ],
          ),
        ],
      ),
    ),
  );
}

// ============================================
// INPUT SHOWCASES
// ============================================

Widget _inputShowcase(Map<String, dynamic> props) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CuInput(
          placeholder: props['placeholder'] as String? ?? 'Enter text...',
          label: props['label'] as String?,
          disabled: props['disabled'] as bool? ?? false,
        ),
        const SizedBox(height: 16),
        const CuInput(
          placeholder: 'With prefix',
          prefix: Padding(
            padding: EdgeInsets.only(left: 12),
            child: Text('\$', style: TextStyle(color: Color(0xFF666666))),
          ),
        ),
      ],
    ),
  );
}

Widget _textareaShowcase(Map<String, dynamic> props) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: CuTextarea(
      placeholder: props['placeholder'] as String? ?? 'Enter longer text...',
    ),
  );
}

Widget _checkboxShowcase(Map<String, dynamic> props) {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CuCheckbox(
          label: props['label'] as String? ?? 'Accept terms',
          value: props['value'] as bool? ?? false,
          disabled: props['disabled'] as bool? ?? false,
          onChanged: (_) {},
        ),
        const SizedBox(height: 12),
        CuCheckbox(
          label: 'Checked checkbox',
          value: true,
          onChanged: (_) {},
        ),
        const SizedBox(height: 12),
        CuCheckbox(
          label: 'Disabled checkbox',
          value: false,
          disabled: true,
          onChanged: (_) {},
        ),
      ],
    ),
  );
}

Widget _radioShowcase(Map<String, dynamic> props) {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CuRadio<String>(
          value: 'option1',
          groupValue: props['value'] as String? ?? 'option1',
          label: 'Option 1',
          onChanged: (_) {},
        ),
        const SizedBox(height: 8),
        CuRadio<String>(
          value: 'option2',
          groupValue: props['value'] as String? ?? 'option1',
          label: 'Option 2',
          onChanged: (_) {},
        ),
        const SizedBox(height: 8),
        CuRadio<String>(
          value: 'option3',
          groupValue: props['value'] as String? ?? 'option1',
          label: 'Option 3',
          onChanged: (_) {},
        ),
      ],
    ),
  );
}

Widget _toggleShowcase(Map<String, dynamic> props) {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Off', style: TextStyle(fontFamily: 'Geist', fontSize: 14)),
            const SizedBox(width: 12),
            CuToggle(
              value: props['value'] as bool? ?? false,
              disabled: props['disabled'] as bool? ?? false,
              onChanged: (_) {},
            ),
            const SizedBox(width: 12),
            const Text('On', style: TextStyle(fontFamily: 'Geist', fontSize: 14)),
          ],
        ),
        const SizedBox(height: 16),
        CuToggle(
          value: true,
          onChanged: (_) {},
        ),
        const SizedBox(height: 8),
        CuToggle(
          value: false,
          disabled: true,
          onChanged: (_) {},
        ),
      ],
    ),
  );
}

Widget _sliderShowcase(Map<String, dynamic> props) {
  return Padding(
    padding: const EdgeInsets.all(24),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CuSlider(
          value: (props['value'] as num?)?.toDouble() ?? 50.0,
          onChanged: (_) {},
        ),
        const SizedBox(height: 24),
        CuSlider(
          value: 25.0,
          min: 0,
          max: 100,
          onChanged: (_) {},
        ),
        const SizedBox(height: 24),
        CuSlider(
          value: 75.0,
          disabled: true,
          onChanged: (_) {},
        ),
      ],
    ),
  );
}

Widget _selectShowcase(Map<String, dynamic> props) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CuSelect<String>(
          options: const [
            CuSelectOption(value: 'opt1', label: 'Option 1'),
            CuSelectOption(value: 'opt2', label: 'Option 2'),
            CuSelectOption(value: 'opt3', label: 'Option 3'),
          ],
          placeholder: props['placeholder'] as String? ?? 'Select an option...',
          label: 'Select Field',
          onChange: (_) {},
        ),
        const SizedBox(height: 16),
        const Text(
          'Tap to open bottom sheet selector',
          style: TextStyle(fontFamily: 'Geist', fontSize: 12, color: Color(0xFF666666)),
        ),
      ],
    ),
  );
}

Widget _autoCompleteShowcase(Map<String, dynamic> props) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: CuAutoComplete(
      options: const [
        CuAutoCompleteOption(label: 'Apple', value: 'apple'),
        CuAutoCompleteOption(label: 'Banana', value: 'banana'),
        CuAutoCompleteOption(label: 'Cherry', value: 'cherry'),
        CuAutoCompleteOption(label: 'Date', value: 'date'),
        CuAutoCompleteOption(label: 'Elderberry', value: 'elderberry'),
        CuAutoCompleteOption(label: 'Fig', value: 'fig'),
        CuAutoCompleteOption(label: 'Grape', value: 'grape'),
      ],
      placeholder: props['placeholder'] as String? ?? 'Search fruits...',
      label: 'Fruit Search',
      onSelect: (_) {},
    ),
  );
}

// ============================================
// LAYOUT SHOWCASES
// ============================================

Widget _gridShowcase(Map<String, dynamic> props) {
  return Padding(
    padding: const EdgeInsets.all(8),
    child: CuGrid(
      columns: 3,
      gap: 8,
      children: List.generate(6, (index) => Container(
        height: 60,
        decoration: BoxDecoration(
          color: const Color(0xFF333333),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            '${index + 1}',
            style: const TextStyle(
              fontFamily: 'Geist',
              color: Color(0xFFFFFFFF),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      )),
    ),
  );
}

Widget _rowShowcase(Map<String, dynamic> props) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CuRow(
          gap: 8,
          children: [
            Container(width: 60, height: 40, color: const Color(0xFF333333)),
            Container(width: 60, height: 40, color: const Color(0xFF555555)),
            Container(width: 60, height: 40, color: const Color(0xFF777777)),
          ],
        ),
        const SizedBox(height: 16),
        CuRow(
          gap: 8,
          justify: CuJustify.spaceBetween,
          children: [
            Container(width: 60, height: 40, color: const Color(0xFF333333)),
            Container(width: 60, height: 40, color: const Color(0xFF555555)),
          ],
        ),
      ],
    ),
  );
}

Widget _colShowcase(Map<String, dynamic> props) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: CuCol(
      gap: 8,
      children: [
        Container(height: 30, color: const Color(0xFF333333)),
        Container(height: 30, color: const Color(0xFF555555)),
        Container(height: 30, color: const Color(0xFF777777)),
      ],
    ),
  );
}

Widget _spacerShowcase(Map<String, dynamic> props) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 40, color: const Color(0xFF333333)),
            CuSpacer.horizontal(16),
            Container(width: 40, height: 40, color: const Color(0xFF333333)),
            CuSpacer.horizontal(16),
            Container(width: 40, height: 40, color: const Color(0xFF333333)),
          ],
        ),
        CuSpacer.vertical(16),
        const Text('Spacers add consistent spacing', style: TextStyle(fontFamily: 'Geist', fontSize: 12)),
      ],
    ),
  );
}

Widget _dividerShowcase(Map<String, dynamic> props) {
  return Padding(
    padding: const EdgeInsets.all(24),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Above divider', style: TextStyle(fontFamily: 'Geist')),
        const SizedBox(height: 16),
        const CuDivider(),
        const SizedBox(height: 16),
        const Text('Below divider', style: TextStyle(fontFamily: 'Geist')),
        const SizedBox(height: 24),
        const CuDivider(child: Text('OR')),
      ],
    ),
  );
}

Widget _pageShowcase(Map<String, dynamic> props) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(8),
    child: SizedBox(
      height: 200,
      child: CuPage(
        child: Column(
          children: [
            const Text('Page Content', style: TextStyle(fontFamily: 'Geist', fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('CuPage provides consistent padding and background', style: TextStyle(fontFamily: 'Geist', fontSize: 12)),
          ],
        ),
      ),
    ),
  );
}

Widget _fieldsetShowcase(Map<String, dynamic> props) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: CuFieldset(
      title: props['title'] as String? ?? 'Fieldset Title',
      subtitle: 'Optional subtitle',
      child: Column(
        children: [
          const CuInput(placeholder: 'First field'),
          const SizedBox(height: 12),
          const CuInput(placeholder: 'Second field'),
        ],
      ),
    ),
  );
}

// ============================================
// SURFACES SHOWCASES
// ============================================

Widget _cardShowcase(Map<String, dynamic> props) {
  return Center(
    child: CuCard(
      hoverable: props['hoverable'] as bool? ?? false,
      shadow: props['shadow'] as bool? ?? false,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Card Title',
              style: TextStyle(fontFamily: 'Geist', fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'This is a card component with customizable content.',
              style: TextStyle(fontFamily: 'Geist', fontSize: 14),
            ),
            const SizedBox(height: 12),
            CuButton(onPressed: () {}, child: const Text('Action')),
          ],
        ),
      ),
    ),
  );
}

Widget _modalShowcase(Map<String, dynamic> props) {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Modal Preview',
          style: TextStyle(fontFamily: 'Geist', fontSize: 14),
        ),
        const SizedBox(height: 16),
        Container(
          width: 280,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF333333)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF000000).withValues(alpha: 0.3),
                blurRadius: 20,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Modal Title',
                style: TextStyle(fontFamily: 'Geist', fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF)),
              ),
              const SizedBox(height: 12),
              const Text(
                'Modal content goes here. This is a preview of how modals look.',
                style: TextStyle(fontFamily: 'Geist', fontSize: 14, color: Color(0xFFAAAAAA)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: CuButton.secondary(onPressed: () {}, child: const Text('Cancel'))),
                  const SizedBox(width: 8),
                  Expanded(child: CuButton(onPressed: () {}, child: const Text('Confirm'))),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _drawerShowcase(Map<String, dynamic> props) {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Drawer Preview', style: TextStyle(fontFamily: 'Geist', fontSize: 14)),
        const SizedBox(height: 16),
        Container(
          width: 240,
          height: 300,
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF333333)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Color(0xFF333333))),
                ),
                child: const Text(
                  'Drawer Menu',
                  style: TextStyle(fontFamily: 'Geist', fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF)),
                ),
              ),
              _drawerItem('\u{25C9}', 'Home'),
              _drawerItem('\u{2261}', 'Analytics'),
              _drawerItem('\u{2699}', 'Settings'),
              _drawerItem('\u{25CB}', 'Profile'),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _drawerItem(String icon, String label) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: Row(
      children: [
        Text(icon, style: const TextStyle(fontSize: 18)),
        const SizedBox(width: 12),
        Text(label, style: const TextStyle(fontFamily: 'Geist', fontSize: 14, color: Color(0xFFCCCCCC))),
      ],
    ),
  );
}

Widget _popoverShowcase(Map<String, dynamic> props) {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Popover Preview', style: TextStyle(fontFamily: 'Geist', fontSize: 14)),
        const SizedBox(height: 24),
        Stack(
          clipBehavior: Clip.none,
          children: [
            CuButton(onPressed: () {}, child: const Text('Trigger')),
            Positioned(
              top: -60,
              left: -30,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF333333)),
                  boxShadow: [
                    BoxShadow(color: const Color(0xFF000000).withValues(alpha: 0.2), blurRadius: 8),
                  ],
                ),
                child: const Text(
                  'Popover content',
                  style: TextStyle(fontFamily: 'Geist', fontSize: 12, color: Color(0xFFFFFFFF)),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _tooltipShowcase(Map<String, dynamic> props) {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Hover/tap for tooltip', style: TextStyle(fontFamily: 'Geist', fontSize: 14)),
        const SizedBox(height: 16),
        CuTooltip(
          content: Text(props['text'] as String? ?? 'Tooltip text'),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF333333),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Hover me',
              style: TextStyle(fontFamily: 'Geist', fontSize: 14, color: Color(0xFFFFFFFF)),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _collapseShowcase(Map<String, dynamic> props) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CuCollapse(
          title: props['title'] as String? ?? 'Click to expand',
          child: const Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              'This content is hidden by default and shown when the collapse is expanded.',
              style: TextStyle(fontFamily: 'Geist', fontSize: 14),
            ),
          ),
        ),
        const SizedBox(height: 8),
        CuCollapse(
          title: 'Another section',
          initialExpanded: true,
          child: const Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              'This section starts expanded.',
              style: TextStyle(fontFamily: 'Geist', fontSize: 14),
            ),
          ),
        ),
      ],
    ),
  );
}

// ============================================
// NAVIGATION SHOWCASES
// ============================================

Widget _tabsShowcase(Map<String, dynamic> props) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CuTabs(
          tabs: const [
            CuTab(value: 'overview', label: 'Overview'),
            CuTab(value: 'settings', label: 'Settings'),
            CuTab(value: 'activity', label: 'Activity'),
          ],
          onChange: (_) {},
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF333333)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            'Tab content area',
            style: TextStyle(fontFamily: 'Geist', fontSize: 14),
          ),
        ),
      ],
    ),
  );
}

Widget _breadcrumbsShowcase(Map<String, dynamic> props) {
  return Center(
    child: CuBreadcrumbs(
      items: [
        CuBreadcrumbItem(label: 'Home', onTap: () {}),
        CuBreadcrumbItem(label: 'Products', onTap: () {}),
        CuBreadcrumbItem(label: 'Electronics', onTap: () {}),
        const CuBreadcrumbItem(label: 'Phones'),
      ],
    ),
  );
}

Widget _paginationShowcase(Map<String, dynamic> props) {
  return Center(
    child: CuPagination(
      page: (props['page'] as num?)?.toInt() ?? 1,
      count: (props['count'] as num?)?.toInt() ?? 10,
      onChange: (_) {},
    ),
  );
}

Widget _linkShowcase(Map<String, dynamic> props) {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CuLink(
          underline: props['underline'] as bool? ?? true,
          onTap: () {},
          child: Text(props['text'] as String? ?? 'Link text'),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Check out our ', style: TextStyle(fontFamily: 'Geist', fontSize: 14)),
            CuLink(
              onTap: () {},
              child: const Text('documentation'),
            ),
            const Text(' for more info.', style: TextStyle(fontFamily: 'Geist', fontSize: 14)),
          ],
        ),
      ],
    ),
  );
}

Widget _bottomNavShowcase(Map<String, dynamic> props) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      const Text('Bottom Navigation with Balance', style: TextStyle(fontFamily: 'Geist', fontSize: 14)),
      const SizedBox(height: 16),
      ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: 80,
          child: CuBottomNav(
            currentIndex: 0,
            balance: 12543.67,
            showBalance: true,
            items: const [
              CuBottomNavItem(icon: '\u{25C9}', label: 'Home'),
              CuBottomNavItem(icon: '\u{21C4}', label: 'Transfer'),
              CuBottomNavItem(icon: '\u{2261}', label: 'Activity'),
              CuBottomNavItem(icon: '\u{2699}', label: 'Settings'),
            ],
            onTap: (_) {},
          ),
        ),
      ),
    ],
  );
}

Widget _appBarShowcase(Map<String, dynamic> props) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CuAppBar(
          title: props['title'] as String? ?? 'App Bar',
          leading: CuAppBar.backButton(),
          actions: [
            CuAppBar.action(icon: '\u{25CF}', badge: '3'),
            CuAppBar.action(icon: '\u{2699}'),
          ],
          useSafeArea: false,
        ),
      ),
    ],
  );
}

Widget _adaptiveNavShowcase(Map<String, dynamic> props) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      const Text(
        'One-Two Transition',
        style: TextStyle(fontFamily: 'Geist', fontSize: 16, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      const Text(
        'Resize window to see navigation transform',
        style: TextStyle(fontFamily: 'Geist', fontSize: 12, color: Color(0xFF666666)),
      ),
      const SizedBox(height: 16),
      // Mobile preview
      Container(
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF333333)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xFF333333))),
              ),
              child: Row(
                children: const [
                  Text('\u{25A1}', style: TextStyle(fontSize: 14)),
                  SizedBox(width: 8),
                  Text('Mobile: Bottom Nav', style: TextStyle(fontFamily: 'Geist', fontSize: 11, color: Color(0xFF888888))),
                ],
              ),
            ),
            ClipRRect(
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
              child: SizedBox(
                height: 80,
                child: CuBottomNav(
                  currentIndex: 0,
                  items: const [
                    CuBottomNavItem(icon: '\u{25C9}', label: 'Home'),
                    CuBottomNavItem(icon: '\u{21C4}', label: 'Transfer'),
                    CuBottomNavItem(icon: '\u{2261}', label: 'Activity'),
                    CuBottomNavItem(icon: '\u{2699}', label: 'Settings'),
                  ],
                  onTap: (_) {},
                ),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 16),
      // Desktop preview
      Container(
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF333333)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xFF333333))),
              ),
              child: Row(
                children: const [
                  Text('\u{25A0}', style: TextStyle(fontSize: 14)),
                  SizedBox(width: 8),
                  Text('Desktop: Side Nav', style: TextStyle(fontFamily: 'Geist', fontSize: 11, color: Color(0xFF888888))),
                ],
              ),
            ),
            ClipRRect(
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
              child: SizedBox(
                height: 180,
                child: Row(
                  children: [
                    // Side nav preview
                    Container(
                      width: 140,
                      decoration: const BoxDecoration(
                        border: Border(right: BorderSide(color: Color(0xFF333333))),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sideNavItem('\u{25C9}', 'Home', true),
                          _sideNavItem('\u{21C4}', 'Transfer', false),
                          _sideNavItem('\u{2261}', 'Activity', false),
                          _sideNavItem('\u{2699}', 'Settings', false),
                        ],
                      ),
                    ),
                    // Content area
                    const Expanded(
                      child: Center(
                        child: Text(
                          'Content',
                          style: TextStyle(fontFamily: 'Geist', fontSize: 12, color: Color(0xFF666666)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget _sideNavItem(String icon, String label, bool isActive) {
  return Container(
    margin: const EdgeInsets.only(bottom: 4),
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
    decoration: BoxDecoration(
      color: isActive ? const Color(0xFF222222) : const Color(0x00000000),
      borderRadius: BorderRadius.circular(6),
    ),
    child: Row(
      children: [
        Text(icon, style: const TextStyle(fontSize: 14)),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Geist',
            fontSize: 12,
            color: isActive ? const Color(0xFFFFFFFF) : const Color(0xFF888888),
          ),
        ),
      ],
    ),
  );
}

// ============================================
// TYPOGRAPHY SHOWCASES
// ============================================

Widget _textShowcase(Map<String, dynamic> props) {
  final element = _parseTextElement(props['element'] as String? ?? 'p');
  return Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CuText(
          props['text'] as String? ?? 'Sample text',
          element: element,
        ),
        const SizedBox(height: 24),
        const CuText('Heading 1', element: CuTextElement.h1),
        const CuText('Heading 2', element: CuTextElement.h2),
        const CuText('Heading 3', element: CuTextElement.h3),
        const SizedBox(height: 8),
        const CuText('Paragraph text for body content.', element: CuTextElement.p),
        const CuText('Small text', element: CuTextElement.small),
      ],
    ),
  );
}

Widget _codeShowcase(Map<String, dynamic> props) {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CuCode(text: props['text'] as String? ?? 'const x = 42;'),
        const SizedBox(height: 16),
        const CuCode(text: 'npm install cu_ui'),
        const SizedBox(height: 16),
        const CuCode(text: 'flutter pub add cu_ui'),
      ],
    ),
  );
}

Widget _snippetShowcase(Map<String, dynamic> props) {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF333333)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Terminal',
                style: TextStyle(fontFamily: 'Geist', fontSize: 12, color: Color(0xFF666666)),
              ),
              const SizedBox(height: 8),
              Text(
                props['text'] as String? ?? 'npm install cu_ui',
                style: const TextStyle(fontFamily: 'GeistMono', fontSize: 14, color: Color(0xFF00FF00)),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _keyboardShowcase(Map<String, dynamic> props) {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CuKeyboard(text: props['text'] as String? ?? '⌘ + K'),
        const SizedBox(height: 16),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CuKeyboard(text: '⌘'),
            const SizedBox(width: 4),
            const Text('+', style: TextStyle(fontFamily: 'Geist')),
            const SizedBox(width: 4),
            const CuKeyboard(text: 'Shift'),
            const SizedBox(width: 4),
            const Text('+', style: TextStyle(fontFamily: 'Geist')),
            const SizedBox(width: 4),
            const CuKeyboard(text: 'P'),
          ],
        ),
      ],
    ),
  );
}

Widget _shimmerTextShowcase(Map<String, dynamic> props) {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CuShimmerText(
          props['text'] as String? ?? 'Shimmering Text',
          style: const TextStyle(fontFamily: 'Geist', fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        CuShimmerText.gold(
          'Premium Account',
          style: const TextStyle(fontFamily: 'Geist', fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        CuShimmerText.silver(
          'Silver Member',
          style: const TextStyle(fontFamily: 'Geist', fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}

// ============================================
// DATA DISPLAY SHOWCASES
// ============================================

Widget _avatarShowcase(Map<String, dynamic> props) {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CuAvatar(
          text: props['text'] as String? ?? 'JD',
          customSize: (props['size'] as num?)?.toDouble() ?? 48.0,
          isSquare: props['isSquare'] as bool? ?? false,
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CuAvatar(text: 'A', size: CuAvatarSize.small),
            const SizedBox(width: 8),
            const CuAvatar(text: 'B', size: CuAvatarSize.medium),
            const SizedBox(width: 8),
            const CuAvatar(text: 'C', size: CuAvatarSize.large),
            const SizedBox(width: 8),
            const CuAvatar(text: 'D', isSquare: true),
          ],
        ),
      ],
    ),
  );
}

Widget _badgeShowcase(Map<String, dynamic> props) {
  final type = _parseBadgeType(props['type'] as String? ?? 'default_');
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CuBadge(
          text: props['text'] as String? ?? 'NEW',
          type: type,
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: const [
            CuBadge(text: 'Default'),
            CuBadge(text: 'Success', type: CuBadgeType.success),
            CuBadge(text: 'Warning', type: CuBadgeType.warning),
            CuBadge(text: 'Error', type: CuBadgeType.error),
            CuBadge(text: 'Secondary', type: CuBadgeType.secondary),
          ],
        ),
      ],
    ),
  );
}

Widget _tagShowcase(Map<String, dynamic> props) {
  final type = _parseTagType(props['type'] as String? ?? 'default_');
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CuTag(
          text: props['text'] as String? ?? 'Tag',
          type: type,
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: const [
            CuTag(text: 'React'),
            CuTag(text: 'Flutter', type: CuTagType.success),
            CuTag(text: 'Dart', type: CuTagType.warning),
            CuTag(text: 'TypeScript', type: CuTagType.error),
          ],
        ),
      ],
    ),
  );
}

Widget _tableShowcase(Map<String, dynamic> props) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: CuTable<Map<String, String>>(
      columns: const [
        CuTableColumn(title: 'Name', prop: 'name', width: 120),
        CuTableColumn(title: 'Status', prop: 'status', width: 100),
        CuTableColumn(title: 'Amount', prop: 'amount', width: 100),
      ],
      data: const [
        {'name': 'John Doe', 'status': 'Active', 'amount': '\$1,234'},
        {'name': 'Jane Smith', 'status': 'Pending', 'amount': '\$567'},
        {'name': 'Bob Wilson', 'status': 'Active', 'amount': '\$890'},
      ],
    ),
  );
}

Widget _userShowcase(Map<String, dynamic> props) {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CuUser(
          name: props['name'] as String? ?? 'John Doe',
          description: props['description'] as String? ?? 'Software Engineer',
        ),
        const SizedBox(height: 24),
        const CuUser(
          name: 'Jane Smith',
          description: 'Product Manager',
          text: 'JS',
        ),
      ],
    ),
  );
}

Widget _dotShowcase(Map<String, dynamic> props) {
  final type = _parseDotType(props['type'] as String? ?? 'default_');
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CuDot(type: type),
        const SizedBox(height: 24),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CuDot(),
            const SizedBox(width: 8),
            const Text('Default', style: TextStyle(fontFamily: 'Geist', fontSize: 14)),
            const SizedBox(width: 24),
            const CuDot(type: CuDotType.success),
            const SizedBox(width: 8),
            const Text('Success', style: TextStyle(fontFamily: 'Geist', fontSize: 14)),
            const SizedBox(width: 24),
            const CuDot(type: CuDotType.error),
            const SizedBox(width: 8),
            const Text('Error', style: TextStyle(fontFamily: 'Geist', fontSize: 14)),
          ],
        ),
      ],
    ),
  );
}

Widget _capacityShowcase(Map<String, dynamic> props) {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CuCapacity(value: (props['value'] as num?)?.toDouble() ?? 75.0),
        const SizedBox(height: 24),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            CuCapacity(value: 20),
            SizedBox(width: 16),
            CuCapacity(value: 50),
            SizedBox(width: 16),
            CuCapacity(value: 80),
            SizedBox(width: 16),
            CuCapacity(value: 100),
          ],
        ),
      ],
    ),
  );
}

Widget _descriptionShowcase(Map<String, dynamic> props) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CuDescription(
          title: props['title'] as String? ?? 'Description Title',
          text: props['content'] as String? ?? 'This is the description content.',
        ),
        const SizedBox(height: 16),
        CuDescription.text(
          title: 'Account Type',
          content: 'Premium Checking',
        ),
        const SizedBox(height: 8),
        CuDescription.text(
          title: 'Account Number',
          content: '****1234',
        ),
      ],
    ),
  );
}

Widget _displayShowcase(Map<String, dynamic> props) {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CuDisplay(
          caption: props['caption'] as String? ?? 'Total Balance',
          child: Text(
            props['value'] as String? ?? '\$12,543.00',
            style: const TextStyle(
              fontFamily: 'Geist',
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            CuDisplay(
              caption: 'Transactions',
              child: Text(
                '256',
                style: TextStyle(fontFamily: 'Geist', fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(width: 32),
            CuDisplay(
              caption: 'Success Rate',
              child: Text(
                '98.5%',
                style: TextStyle(fontFamily: 'Geist', fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _imageShowcase(Map<String, dynamic> props) {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 200,
          height: 150,
          decoration: BoxDecoration(
            color: const Color(0xFF333333),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(
            child: Text(
              '\u{25A1}',
              style: TextStyle(fontSize: 48),
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'CuImage placeholder',
          style: TextStyle(fontFamily: 'Geist', fontSize: 12, color: Color(0xFF666666)),
        ),
      ],
    ),
  );
}

Widget _ratingShowcase(Map<String, dynamic> props) {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CuRating(
          value: (props['value'] as num?)?.toDouble() ?? 3.0,
          count: (props['count'] as num?)?.toInt() ?? 5,
        ),
        const SizedBox(height: 24),
        const CuRating(value: 1),
        const SizedBox(height: 8),
        const CuRating(value: 2.5),
        const SizedBox(height: 8),
        const CuRating(value: 4),
        const SizedBox(height: 8),
        const CuRating(value: 5),
      ],
    ),
  );
}

Widget _listTileShowcase(Map<String, dynamic> props) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      // Account tiles for Credit Unions
      const Text(
        'Account Tiles',
        style: TextStyle(fontFamily: 'Geist', fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF888888)),
      ),
      const SizedBox(height: 8),
      CuListTile.account(
        accountName: 'Primary Checking',
        balance: 4523.67,
        availableBalance: 4123.67,
        accountNumber: '...4521',
        onTap: () {},
      ),
      CuListTile.account(
        accountName: 'Savings',
        balance: 12847.32,
        availableBalance: 12847.32,
        accountNumber: '...8834',
        onTap: () {},
      ),
      CuListTile.accountWithIcon(
        accountName: 'Credit Card',
        balance: -1234.56,
        icon: '\u{25CB}',
        onTap: () {},
        showDivider: false,
      ),
      const SizedBox(height: 16),

      // Transaction tiles
      const Text(
        'Transaction Tiles',
        style: TextStyle(fontFamily: 'Geist', fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF888888)),
      ),
      const SizedBox(height: 8),
      CuListTile.transaction(
        description: 'Payroll Deposit',
        amount: 2450.00,
        date: 'Today',
        onTap: () {},
      ),
      CuListTile.transaction(
        description: 'Coffee Shop',
        amount: -5.75,
        date: 'Yesterday',
        category: 'Food & Drink',
        onTap: () {},
      ),
      CuListTile.transaction(
        description: 'Pending Transfer',
        amount: -100.00,
        date: 'Processing',
        isPending: true,
        onTap: () {},
        showDivider: false,
      ),
      const SizedBox(height: 16),

      // Standard tiles
      const Text(
        'Standard Tiles',
        style: TextStyle(fontFamily: 'Geist', fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF888888)),
      ),
      const SizedBox(height: 8),
      CuListTile.settings(
        title: 'Settings Item',
        subtitle: 'With chevron',
        onTap: () {},
      ),
      CuListTile.switchTile(
        title: 'Toggle Setting',
        subtitle: 'Enable feature',
        value: true,
        onChanged: (_) {},
      ),
    ],
  );
}

// ============================================
// FEEDBACK SHOWCASES
// ============================================

Widget _spinnerShowcase(Map<String, dynamic> props) {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: const [
        CuSpinner(),
        SizedBox(height: 24),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CuSpinner(size: 16),
            SizedBox(width: 16),
            CuSpinner(size: 24),
            SizedBox(width: 16),
            CuSpinner(size: 32),
            SizedBox(width: 16),
            CuSpinner(size: 48),
          ],
        ),
      ],
    ),
  );
}

Widget _loadingShowcase(Map<String, dynamic> props) {
  return const Center(child: CuLoading());
}

Widget _progressShowcase(Map<String, dynamic> props) {
  return Padding(
    padding: const EdgeInsets.all(24),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CuProgress(
          value: (props['value'] as num?)?.toDouble() ?? 65.0,
          max: (props['max'] as num?)?.toDouble() ?? 100.0,
        ),
        const SizedBox(height: 24),
        const CuProgress(value: 25),
        const SizedBox(height: 12),
        const CuProgress(value: 50),
        const SizedBox(height: 12),
        const CuProgress(value: 75),
        const SizedBox(height: 12),
        const CuProgress(value: 100),
      ],
    ),
  );
}

Widget _noteShowcase(Map<String, dynamic> props) {
  final type = _parseNoteType(props['type'] as String? ?? 'default_');
  return Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CuNote(
          text: props['text'] as String? ?? 'This is a note.',
          type: type,
          filled: props['filled'] as bool? ?? false,
        ),
        const SizedBox(height: 16),
        const CuNote(text: 'Default note', type: CuNoteType.default_),
        const SizedBox(height: 8),
        const CuNote(text: 'Success note', type: CuNoteType.success),
        const SizedBox(height: 8),
        const CuNote(text: 'Warning note', type: CuNoteType.warning),
        const SizedBox(height: 8),
        const CuNote(text: 'Error note', type: CuNoteType.error),
      ],
    ),
  );
}

Widget _toastShowcase(Map<String, dynamic> props) {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Toast Previews', style: TextStyle(fontFamily: 'Geist', fontSize: 14)),
        const SizedBox(height: 16),
        _toastPreview('Success! Your changes were saved.', const Color(0xFF0070F3)),
        const SizedBox(height: 8),
        _toastPreview('Warning: Check your input.', const Color(0xFFF5A623)),
        const SizedBox(height: 8),
        _toastPreview('Error: Something went wrong.', const Color(0xFFEE0000)),
      ],
    ),
  );
}

Widget _toastPreview(String message, Color color) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: BoxDecoration(
      color: const Color(0xFF1A1A1A),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: const Color(0xFF333333)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          message,
          style: const TextStyle(fontFamily: 'Geist', fontSize: 14, color: Color(0xFFFFFFFF)),
        ),
      ],
    ),
  );
}

Widget _shimmerShowcase(Map<String, dynamic> props) {
  return Center(
    child: CuShimmer(
      child: Container(
        width: 200,
        height: 100,
        decoration: BoxDecoration(
          color: const Color(0xFF333333),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
  );
}

Widget _skeletonShowcase(Map<String, dynamic> props) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      CuSkeleton.heading(width: 180),
      const SizedBox(height: 12),
      CuSkeleton.text(),
      const SizedBox(height: 8),
      CuSkeleton.text(width: 250),
      const SizedBox(height: 8),
      CuSkeleton.text(width: 180),
      const SizedBox(height: 16),
      Row(
        children: [
          CuSkeleton.avatar(size: 40),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CuSkeleton.text(width: 120),
                const SizedBox(height: 4),
                CuSkeleton.text(width: 80, height: 12),
              ],
            ),
          ),
        ],
      ),
    ],
  );
}

// ============================================
// SCREEN SHOWCASES
// ============================================

Widget _loadingScreenShowcase(Map<String, dynamic> props) {
  final skeletonType = _parseSkeletonType(props['skeletonType'] as String? ?? 'dashboard');
  return ClipRRect(
    borderRadius: BorderRadius.circular(8),
    child: SizedBox(
      height: 400,
      child: CuLoadingScreen(
        logo: const Text(
          'cu',
          style: TextStyle(
            fontFamily: 'Cyrovoid',
            fontSize: 32,
            letterSpacing: 2,
            color: Color(0xFFFFFFFF),
          ),
        ),
        message: props['message'] as String? ?? 'Loading...',
        showSkeleton: props['showSkeleton'] as bool? ?? true,
        skeletonType: skeletonType,
      ),
    ),
  );
}

Widget _loginScreenShowcase(Map<String, dynamic> props) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(8),
    child: const SizedBox(
      height: 500,
      child: CuLoginScreen(),
    ),
  );
}

Widget _dashboardScreenShowcase(Map<String, dynamic> props) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(8),
    child: SizedBox(
      height: 500,
      child: CuDashboardScreen(
        userName: 'John',
        totalBalance: 17932.10,
        accounts: const [
          CuAccountInfo(
            name: 'Checking Account',
            balance: 5432.10,
            type: 'checking',
            accountNumber: '****1234',
          ),
          CuAccountInfo(
            name: 'Savings Account',
            balance: 12500.00,
            type: 'savings',
            accountNumber: '****5678',
          ),
        ],
        recentTransactions: const [
          CuTransactionInfo(
            description: 'Coffee Shop',
            amount: -4.50,
            date: 'Today, 2:30 PM',
          ),
          CuTransactionInfo(
            description: 'Payroll Deposit',
            amount: 2500.00,
            date: 'Yesterday',
          ),
        ],
      ),
    ),
  );
}

Widget _transferScreenShowcase(Map<String, dynamic> props) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(8),
    child: SizedBox(
      height: 500,
      child: CuTransferScreen(
        accounts: const [
          CuTransferAccount(
            id: '1',
            name: 'Checking',
            balance: 5432.10,
            accountNumber: '****1234',
          ),
          CuTransferAccount(
            id: '2',
            name: 'Savings',
            balance: 12500.00,
            accountNumber: '****5678',
          ),
        ],
      ),
    ),
  );
}

Widget _settingsScreenShowcase(Map<String, dynamic> props) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(8),
    child: const SizedBox(
      height: 500,
      child: CuSettingsScreen(),
    ),
  );
}

Widget _accountDetailScreenShowcase(Map<String, dynamic> props) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(8),
    child: SizedBox(
      height: 500,
      child: CuAccountDetailScreen(
        accountName: 'Checking Account',
        accountNumber: '****1234',
        balance: 5432.10,
        availableBalance: 5000.00,
        accountType: 'checking',
        transactions: [
          CuTransaction(
            id: '1',
            description: 'Coffee Shop',
            amount: -4.50,
            date: DateTime.now().subtract(const Duration(hours: 2)),
            category: 'Food & Drink',
          ),
          CuTransaction(
            id: '2',
            description: 'Grocery Store',
            amount: -85.32,
            date: DateTime.now().subtract(const Duration(days: 1)),
            category: 'Shopping',
          ),
          CuTransaction(
            id: '3',
            description: 'Payroll Deposit',
            amount: 2500.00,
            date: DateTime.now().subtract(const Duration(days: 3)),
            category: 'Income',
          ),
        ],
      ),
    ),
  );
}

// ============================================
// HELPERS
// ============================================

CuButtonType _parseButtonType(String type) {
  switch (type) {
    case 'secondary':
      return CuButtonType.secondary;
    case 'success':
      return CuButtonType.success;
    case 'warning':
      return CuButtonType.warning;
    case 'error':
      return CuButtonType.error;
    case 'abort':
      return CuButtonType.abort;
    default:
      return CuButtonType.default_;
  }
}

CuSize _parseSize(String size) {
  switch (size) {
    case 'small':
      return CuSize.small;
    case 'large':
      return CuSize.large;
    default:
      return CuSize.medium;
  }
}

CuTextElement _parseTextElement(String element) {
  switch (element) {
    case 'h1':
      return CuTextElement.h1;
    case 'h2':
      return CuTextElement.h2;
    case 'h3':
      return CuTextElement.h3;
    case 'h4':
      return CuTextElement.h4;
    case 'h5':
      return CuTextElement.h5;
    case 'h6':
      return CuTextElement.h6;
    case 'b':
      return CuTextElement.b;
    case 'small':
      return CuTextElement.small;
    case 'i':
      return CuTextElement.i;
    case 'span':
      return CuTextElement.span;
    default:
      return CuTextElement.p;
  }
}

CuBadgeType _parseBadgeType(String type) {
  switch (type) {
    case 'secondary':
      return CuBadgeType.secondary;
    case 'success':
      return CuBadgeType.success;
    case 'warning':
      return CuBadgeType.warning;
    case 'error':
      return CuBadgeType.error;
    default:
      return CuBadgeType.default_;
  }
}

CuNoteType _parseNoteType(String type) {
  switch (type) {
    case 'secondary':
      return CuNoteType.secondary;
    case 'success':
      return CuNoteType.success;
    case 'warning':
      return CuNoteType.warning;
    case 'error':
      return CuNoteType.error;
    default:
      return CuNoteType.default_;
  }
}

CuTagType _parseTagType(String type) {
  switch (type) {
    case 'secondary':
      return CuTagType.secondary;
    case 'success':
      return CuTagType.success;
    case 'warning':
      return CuTagType.warning;
    case 'error':
      return CuTagType.error;
    default:
      return CuTagType.default_;
  }
}

CuDotType _parseDotType(String type) {
  switch (type) {
    case 'secondary':
      return CuDotType.secondary;
    case 'success':
      return CuDotType.success;
    case 'warning':
      return CuDotType.warning;
    case 'error':
      return CuDotType.error;
    default:
      return CuDotType.default_;
  }
}

LoadingSkeletonType _parseSkeletonType(String type) {
  switch (type) {
    case 'list':
      return LoadingSkeletonType.list;
    case 'profile':
      return LoadingSkeletonType.profile;
    case 'article':
      return LoadingSkeletonType.article;
    case 'form':
      return LoadingSkeletonType.form;
    default:
      return LoadingSkeletonType.dashboard;
  }
}
