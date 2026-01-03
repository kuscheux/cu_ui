import 'package:flutter/widgets.dart';
import '../theme/cu_theme.dart';
import '../components/_base/cu_component.dart';
import '../components/inputs/cu_toggle.dart';
import '../components/surfaces/cu_card.dart';
import '../components/layout/cu_spacer.dart';
import '../components/data_display/cu_avatar.dart';

/// CuSettingsScreen - Pre-built settings/preferences screen
///
/// A complete settings screen with:
/// - User profile section with avatar
/// - Grouped settings sections
/// - Toggle switches for boolean settings
/// - Navigation items for sub-screens
/// - Logout/danger zone actions
///
/// ## Example
/// ```dart
/// CuSettingsScreen(
///   userName: 'John Doe',
///   userEmail: 'john@example.com',
///   userAvatar: NetworkImage('https://...'),
///   sections: [
///     CuSettingsSection(
///       title: 'Security',
///       items: [
///         CuSettingsToggle(
///           title: 'Face ID',
///           value: true,
///           onChanged: (v) => updateFaceId(v),
///         ),
///         CuSettingsNavItem(
///           title: 'Change Password',
///           onTap: () => Navigator.pushNamed(context, '/password'),
///         ),
///       ],
///     ),
///   ],
///   onLogout: () => authService.logout(),
/// )
/// ```
class CuSettingsScreen extends StatefulWidget {
  /// User's display name
  final String? userName;

  /// User's email address
  final String? userEmail;

  /// User's avatar image
  final ImageProvider? userAvatar;

  /// Settings sections to display
  final List<CuSettingsSection> sections;

  /// Called when back/close is pressed
  final VoidCallback? onBack;

  /// Called when profile section is tapped
  final VoidCallback? onProfileTap;

  /// Called when logout is pressed
  final VoidCallback? onLogout;

  /// Screen title
  final String title;

  /// Logout button text
  final String logoutText;

  /// Custom header widget
  final Widget? customHeader;

  /// Show version info at bottom
  final String? versionText;

  const CuSettingsScreen({
    super.key,
    this.userName,
    this.userEmail,
    this.userAvatar,
    this.sections = const [],
    this.onBack,
    this.onProfileTap,
    this.onLogout,
    this.title = 'Settings',
    this.logoutText = 'Log Out',
    this.customHeader,
    this.versionText,
  });

  @override
  State<CuSettingsScreen> createState() => _CuSettingsScreenState();
}

class _CuSettingsScreenState extends State<CuSettingsScreen> with CuComponentMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: colors.background,
      child: SafeArea(
        child: Column(
          children: [
            // Header
            widget.customHeader ?? _buildHeader(),

            // Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Profile section
                    if (widget.userName != null || widget.userEmail != null)
                      _buildProfileSection(),

                    // Settings sections
                    ...widget.sections.map((section) => _buildSection(section)),

                    // Logout
                    if (widget.onLogout != null)
                      Padding(
                        padding: EdgeInsets.all(spacing.space4),
                        child: _buildLogoutButton(),
                      ),

                    // Version
                    if (widget.versionText != null)
                      Padding(
                        padding: EdgeInsets.only(bottom: spacing.space6),
                        child: Text(
                          widget.versionText!,
                          style: typography.caption.copyWith(color: colors.accents4),
                          textAlign: TextAlign.center,
                        ),
                      ),

                    CuSpacer.vertical(spacing.space4),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(spacing.space4),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.border)),
      ),
      child: Row(
        children: [
          if (widget.onBack != null)
            GestureDetector(
              onTap: widget.onBack,
              child: Container(
                padding: EdgeInsets.all(spacing.space2),
                child: Text(
                  '\u{2190}', // Left arrow
                  style: typography.body.copyWith(color: colors.accents6),
                ),
              ),
            ),
          Expanded(
            child: Text(
              widget.title,
              style: typography.h4.copyWith(color: colors.foreground),
              textAlign: TextAlign.center,
            ),
          ),
          // Spacer for alignment
          if (widget.onBack != null)
            SizedBox(width: spacing.space8),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return GestureDetector(
      onTap: widget.onProfileTap,
      child: Container(
        padding: EdgeInsets.all(spacing.space4),
        child: Row(
          children: [
            CuAvatar(
              image: widget.userAvatar,
              text: widget.userName,
              size: CuAvatarSize.large,
            ),
            CuSpacer.horizontal(spacing.space4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.userName != null)
                    Text(
                      widget.userName!,
                      style: typography.h4.copyWith(color: colors.foreground),
                    ),
                  if (widget.userEmail != null) ...[
                    CuSpacer.vertical(spacing.space1),
                    Text(
                      widget.userEmail!,
                      style: typography.body.copyWith(color: colors.accents5),
                    ),
                  ],
                ],
              ),
            ),
            if (widget.onProfileTap != null)
              Text(
                '\u{203A}', // Right chevron
                style: typography.h3.copyWith(color: colors.accents4),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(CuSettingsSection section) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: spacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CuSpacer.vertical(spacing.space4),
          if (section.title != null)
            Padding(
              padding: EdgeInsets.only(
                left: spacing.space1,
                bottom: spacing.space2,
              ),
              child: Text(
                section.title!,
                style: typography.label.copyWith(color: colors.accents5),
              ),
            ),
          CuCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: section.items.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                final isLast = index == section.items.length - 1;

                return Column(
                  children: [
                    _buildSettingsItem(item),
                    if (!isLast)
                      Container(
                        margin: EdgeInsets.only(left: spacing.space4),
                        height: 1,
                        color: colors.border,
                      ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(CuSettingsItem item) {
    if (item is CuSettingsToggle) {
      return _buildToggleItem(item);
    } else if (item is CuSettingsNavItem) {
      return _buildNavItem(item);
    } else if (item is CuSettingsValue) {
      return _buildValueItem(item);
    }
    return const SizedBox.shrink();
  }

  Widget _buildToggleItem(CuSettingsToggle item) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.space4,
        vertical: spacing.space3,
      ),
      child: Row(
        children: [
          if (item.icon != null) ...[
            item.icon!,
            CuSpacer.horizontal(spacing.space3),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: typography.body.copyWith(color: colors.foreground),
                ),
                if (item.subtitle != null)
                  Text(
                    item.subtitle!,
                    style: typography.caption.copyWith(color: colors.accents5),
                  ),
              ],
            ),
          ),
          CuToggle(
            value: item.value,
            onChanged: item.onChanged,
            size: CuSize.small,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(CuSettingsNavItem item) {
    return GestureDetector(
      onTap: item.onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: spacing.space4,
          vertical: spacing.space3,
        ),
        child: Row(
          children: [
            if (item.icon != null) ...[
              item.icon!,
              CuSpacer.horizontal(spacing.space3),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: typography.body.copyWith(
                      color: item.destructive ? colors.error.base : colors.foreground,
                    ),
                  ),
                  if (item.subtitle != null)
                    Text(
                      item.subtitle!,
                      style: typography.caption.copyWith(color: colors.accents5),
                    ),
                ],
              ),
            ),
            Text(
              '\u{203A}', // Right chevron
              style: typography.h4.copyWith(color: colors.accents4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildValueItem(CuSettingsValue item) {
    return GestureDetector(
      onTap: item.onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: spacing.space4,
          vertical: spacing.space3,
        ),
        child: Row(
          children: [
            if (item.icon != null) ...[
              item.icon!,
              CuSpacer.horizontal(spacing.space3),
            ],
            Expanded(
              child: Text(
                item.title,
                style: typography.body.copyWith(color: colors.foreground),
              ),
            ),
            Text(
              item.value,
              style: typography.body.copyWith(color: colors.accents5),
            ),
            if (item.onTap != null) ...[
              CuSpacer.horizontal(spacing.space2),
              Text(
                '\u{203A}', // Right chevron
                style: typography.h4.copyWith(color: colors.accents4),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return GestureDetector(
      onTap: widget.onLogout,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: spacing.space4),
        decoration: BoxDecoration(
          color: colors.error.lighter,
          borderRadius: radius.mdBorder,
          border: Border.all(color: colors.error.base),
        ),
        child: Text(
          widget.logoutText,
          style: typography.body.copyWith(
            color: colors.error.dark,
            fontWeight: typography.weightMedium,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

/// Settings section with title and items
class CuSettingsSection {
  final String? title;
  final List<CuSettingsItem> items;

  const CuSettingsSection({
    this.title,
    required this.items,
  });
}

/// Base class for settings items
abstract class CuSettingsItem {
  final String title;
  final String? subtitle;
  final Widget? icon;

  const CuSettingsItem({
    required this.title,
    this.subtitle,
    this.icon,
  });
}

/// Toggle switch setting item
class CuSettingsToggle extends CuSettingsItem {
  final bool value;
  final ValueChanged<bool>? onChanged;

  const CuSettingsToggle({
    required super.title,
    super.subtitle,
    super.icon,
    required this.value,
    this.onChanged,
  });
}

/// Navigation setting item (pushes to another screen)
class CuSettingsNavItem extends CuSettingsItem {
  final VoidCallback? onTap;
  final bool destructive;

  const CuSettingsNavItem({
    required super.title,
    super.subtitle,
    super.icon,
    this.onTap,
    this.destructive = false,
  });
}

/// Value display setting item
class CuSettingsValue extends CuSettingsItem {
  final String value;
  final VoidCallback? onTap;

  const CuSettingsValue({
    required super.title,
    super.subtitle,
    super.icon,
    required this.value,
    this.onTap,
  });
}
