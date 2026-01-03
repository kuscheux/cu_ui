import 'package:flutter/widgets.dart';
import 'package:cu_ui/cu_ui.dart';
import '../widgets/property_panel.dart';

/// Showcase builders for each component
final Map<String, Widget Function(Map<String, dynamic>)> showcases = {
  'CuButton': (props) => _buttonShowcase(props),
  'CuInput': (props) => _inputShowcase(props),
  'CuTextarea': (props) => _textareaShowcase(props),
  'CuCheckbox': (props) => _checkboxShowcase(props),
  'CuToggle': (props) => _toggleShowcase(props),
  'CuText': (props) => _textShowcase(props),
  'CuBadge': (props) => _badgeShowcase(props),
  'CuAvatar': (props) => _avatarShowcase(props),
  'CuSpinner': (props) => _spinnerShowcase(props),
  'CuProgress': (props) => _progressShowcase(props),
  'CuNote': (props) => _noteShowcase(props),
  'CuCard': (props) => _cardShowcase(props),
  'CuDivider': (props) => _dividerShowcase(props),
  'CuTag': (props) => _tagShowcase(props),
  'CuDot': (props) => _dotShowcase(props),
  'CuLink': (props) => _linkShowcase(props),
  'CuCode': (props) => _codeShowcase(props),
  'CuKeyboard': (props) => _keyboardShowcase(props),
  'CuCapacity': (props) => _capacityShowcase(props),
  'CuRating': (props) => _ratingShowcase(props),
  'CuLoading': (props) => _loadingShowcase(props),
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
    'rows': 4,
  },
  'CuCheckbox': {
    'label': 'Accept terms',
    'value': false,
    'disabled': false,
  },
  'CuToggle': {
    'value': false,
    'disabled': false,
  },
  'CuText': {
    'text': 'The quick brown fox jumps over the lazy dog.',
    'element': 'p',
    'type': 'default',
  },
  'CuBadge': {
    'text': 'NEW',
    'type': 'default_',
  },
  'CuAvatar': {
    'text': 'JD',
    'size': 40.0,
    'isSquare': false,
  },
  'CuSpinner': {
    'size': 24.0,
  },
  'CuProgress': {
    'value': 65.0,
    'max': 100.0,
  },
  'CuNote': {
    'text': 'This is an informational note.',
    'type': 'default_',
    'filled': false,
    'label': '',
  },
  'CuCard': {
    'hoverable': false,
    'shadow': false,
  },
  'CuDivider': {
    'text': '',
  },
  'CuTag': {
    'text': 'Tag',
    'type': 'default_',
  },
  'CuDot': {
    'type': 'default_',
  },
  'CuLink': {
    'text': 'Link text',
    'underline': true,
  },
  'CuCode': {
    'text': 'const x = 42;',
  },
  'CuKeyboard': {
    'text': '⌘ + K',
  },
  'CuCapacity': {
    'value': 75.0,
  },
  'CuRating': {
    'value': 3,
    'count': 5,
  },
  'CuLoading': {},
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
  'CuCheckbox': [
    const PropertyConfig(
      name: 'label',
      type: PropertyType.string,
      defaultValue: 'Accept terms',
    ),
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
      defaultValue: 40.0,
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
};

// ============================================
// SHOWCASE BUILDERS
// ============================================

Widget _buttonShowcase(Map<String, dynamic> props) {
  final type = _parseButtonType(props['type'] as String? ?? 'default_');
  final size = _parseSize(props['size'] as String? ?? 'medium');

  return Center(
    child: CuButton(
      type: type,
      size: size,
      disabled: props['disabled'] as bool? ?? false,
      loading: props['loading'] as bool? ?? false,
      ghost: props['ghost'] as bool? ?? false,
      onPressed: () {},
      child: Text(props['text'] as String? ?? 'Click me'),
    ),
  );
}

Widget _inputShowcase(Map<String, dynamic> props) {
  return CuInput(
    placeholder: props['placeholder'] as String? ?? 'Enter text...',
    label: props['label'] as String?,
    disabled: props['disabled'] as bool? ?? false,
  );
}

Widget _textareaShowcase(Map<String, dynamic> props) {
  return CuTextarea(
    placeholder: props['placeholder'] as String? ?? 'Enter longer text...',
  );
}

Widget _checkboxShowcase(Map<String, dynamic> props) {
  return CuCheckbox(
    label: props['label'] as String? ?? 'Accept terms',
    value: props['value'] as bool? ?? false,
    disabled: props['disabled'] as bool? ?? false,
    onChanged: (_) {},
  );
}

Widget _toggleShowcase(Map<String, dynamic> props) {
  return Center(
    child: CuToggle(
      value: props['value'] as bool? ?? false,
      disabled: props['disabled'] as bool? ?? false,
      onChanged: (_) {},
    ),
  );
}

Widget _textShowcase(Map<String, dynamic> props) {
  final element = _parseTextElement(props['element'] as String? ?? 'p');
  return CuText(
    props['text'] as String? ?? 'Sample text',
    element: element,
  );
}

Widget _badgeShowcase(Map<String, dynamic> props) {
  final type = _parseBadgeType(props['type'] as String? ?? 'default_');
  return Center(
    child: CuBadge(
      text: props['text'] as String? ?? 'NEW',
      type: type,
    ),
  );
}

Widget _avatarShowcase(Map<String, dynamic> props) {
  return Center(
    child: CuAvatar(
      text: props['text'] as String? ?? 'JD',
      customSize: (props['size'] as num?)?.toDouble() ?? 40.0,
      isSquare: props['isSquare'] as bool? ?? false,
    ),
  );
}

Widget _spinnerShowcase(Map<String, dynamic> props) {
  return const Center(child: CuSpinner());
}

Widget _progressShowcase(Map<String, dynamic> props) {
  return CuProgress(
    value: (props['value'] as num?)?.toDouble() ?? 65.0,
    max: (props['max'] as num?)?.toDouble() ?? 100.0,
  );
}

Widget _noteShowcase(Map<String, dynamic> props) {
  final type = _parseNoteType(props['type'] as String? ?? 'default_');
  return CuNote(
    text: props['text'] as String? ?? 'This is a note.',
    type: type,
    filled: props['filled'] as bool? ?? false,
    label: (props['label'] as String?)?.isNotEmpty == true
        ? props['label'] as String
        : null,
  );
}

Widget _cardShowcase(Map<String, dynamic> props) {
  return CuCard(
    hoverable: props['hoverable'] as bool? ?? false,
    shadow: props['shadow'] as bool? ?? false,
    child: const Padding(
      padding: EdgeInsets.all(16),
      child: Text(
        'Card content goes here',
        style: TextStyle(fontFamily: 'Geist', fontSize: 14),
      ),
    ),
  );
}

Widget _dividerShowcase(Map<String, dynamic> props) {
  final text = props['text'] as String?;
  return CuDivider(
    child: text?.isNotEmpty == true ? Text(text!) : null,
  );
}

Widget _tagShowcase(Map<String, dynamic> props) {
  final type = _parseTagType(props['type'] as String? ?? 'default_');
  return Center(
    child: CuTag(
      text: props['text'] as String? ?? 'Tag',
      type: type,
    ),
  );
}

Widget _dotShowcase(Map<String, dynamic> props) {
  final type = _parseDotType(props['type'] as String? ?? 'default_');
  return Center(child: CuDot(type: type));
}

Widget _linkShowcase(Map<String, dynamic> props) {
  return Center(
    child: CuLink(
      underline: props['underline'] as bool? ?? true,
      onTap: () {},
      child: Text(props['text'] as String? ?? 'Link text'),
    ),
  );
}

Widget _codeShowcase(Map<String, dynamic> props) {
  return Center(
    child: CuCode(text: props['text'] as String? ?? 'const x = 42;'),
  );
}

Widget _keyboardShowcase(Map<String, dynamic> props) {
  return Center(
    child: CuKeyboard(text: props['text'] as String? ?? '⌘ + K'),
  );
}

Widget _capacityShowcase(Map<String, dynamic> props) {
  return Center(
    child: CuCapacity(
      value: (props['value'] as num?)?.toDouble() ?? 75.0,
    ),
  );
}

Widget _ratingShowcase(Map<String, dynamic> props) {
  return Center(
    child: CuRating(
      value: (props['value'] as num?)?.toDouble() ?? 3.0,
      count: (props['count'] as num?)?.toInt() ?? 5,
    ),
  );
}

Widget _loadingShowcase(Map<String, dynamic> props) {
  return const Center(child: CuLoading());
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
