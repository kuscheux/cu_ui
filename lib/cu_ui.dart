/// CU UI Design Language
///
/// A comprehensive Flutter UI design language inspired by Geist UI with:
/// - Fully tokenized design system
/// - 50+ components
/// - Animation system with particle grids and wave effects
/// - Light and dark theme support
library cu_ui;

// Theme
export 'src/theme/cu_theme.dart';
export 'src/theme/cu_theme_data.dart';
export 'src/theme/presets/light_theme.dart';
export 'src/theme/presets/dark_theme.dart';

// Tokens
export 'src/tokens/cu_tokens.dart';

// Base
export 'src/components/_base/cu_component.dart';

// Components - Buttons
export 'src/components/buttons/cu_button.dart';
export 'src/components/buttons/cu_button_group.dart';

// Components - Inputs
export 'src/components/inputs/cu_input.dart';
export 'src/components/inputs/cu_textarea.dart';
export 'src/components/inputs/cu_select.dart';
export 'src/components/inputs/cu_checkbox.dart';
export 'src/components/inputs/cu_radio.dart';
export 'src/components/inputs/cu_toggle.dart';
export 'src/components/inputs/cu_slider.dart';
export 'src/components/inputs/cu_auto_complete.dart';

// Components - Layout
export 'src/components/layout/cu_grid.dart';
export 'src/components/layout/cu_row.dart';
export 'src/components/layout/cu_col.dart';
export 'src/components/layout/cu_spacer.dart';
export 'src/components/layout/cu_page.dart';
export 'src/components/layout/cu_divider.dart';
export 'src/components/layout/cu_fieldset.dart';

// Components - Surfaces
export 'src/components/surfaces/cu_card.dart';
export 'src/components/surfaces/cu_modal.dart';
export 'src/components/surfaces/cu_drawer.dart';
export 'src/components/surfaces/cu_popover.dart';
export 'src/components/surfaces/cu_tooltip.dart';
export 'src/components/surfaces/cu_collapse.dart';

// Components - Navigation
export 'src/components/navigation/cu_tabs.dart';
export 'src/components/navigation/cu_breadcrumbs.dart';
export 'src/components/navigation/cu_pagination.dart';
export 'src/components/navigation/cu_link.dart';

// Components - Typography
export 'src/components/typography/cu_text.dart';
export 'src/components/typography/cu_code.dart';

// Components - Data Display
export 'src/components/data_display/cu_table.dart';
export 'src/components/data_display/cu_avatar.dart';
export 'src/components/data_display/cu_badge.dart';
export 'src/components/data_display/cu_tag.dart';
export 'src/components/data_display/cu_rating.dart';
export 'src/components/data_display/cu_user.dart';
export 'src/components/data_display/cu_capacity.dart';
export 'src/components/data_display/cu_dot.dart';
export 'src/components/data_display/cu_description.dart';
export 'src/components/data_display/cu_display.dart';
export 'src/components/data_display/cu_image.dart';

// Components - Feedback
export 'src/components/feedback/cu_loading.dart';
export 'src/components/feedback/cu_spinner.dart';
export 'src/components/feedback/cu_progress.dart';
export 'src/components/feedback/cu_note.dart';
export 'src/components/feedback/cu_toast.dart';

// Animations
export 'src/animations/core/animation_constants.dart';
export 'src/animations/core/easing_curves.dart';
export 'src/animations/models/particle.dart';
export 'src/animations/models/wave.dart';
export 'src/animations/widgets/animated_text.dart';

// Screens - Pre-built screens for Credit Union apps
export 'src/screens/cu_login_screen.dart';
export 'src/screens/cu_dashboard_screen.dart';
export 'src/screens/cu_transfer_screen.dart';
export 'src/screens/cu_settings_screen.dart';
export 'src/screens/cu_account_detail_screen.dart';
