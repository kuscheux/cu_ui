import 'package:flutter/widgets.dart';
import '../theme/cu_theme.dart';
import '../components/_base/cu_component.dart';
import '../components/buttons/cu_button.dart';
import '../components/inputs/cu_input.dart';
import '../components/layout/cu_spacer.dart';

/// CuLoginScreen - Pre-built login/authentication screen
///
/// A complete login screen with:
/// - Logo/branding area
/// - Email/username input
/// - Password input with visibility toggle
/// - Remember me option
/// - Login button
/// - Forgot password link
/// - Sign up link
///
/// All callbacks are optional - wire up what you need.
///
/// ## Example
/// ```dart
/// CuLoginScreen(
///   logo: Image.asset('assets/logo.png'),
///   title: 'Welcome Back',
///   onLogin: (email, password) async {
///     // Handle login
///   },
///   onForgotPassword: () => Navigator.pushNamed(context, '/forgot'),
///   onSignUp: () => Navigator.pushNamed(context, '/signup'),
/// )
/// ```
class CuLoginScreen extends StatefulWidget {
  /// Logo widget displayed at top
  final Widget? logo;

  /// Title text (e.g., "Welcome Back")
  final String? title;

  /// Subtitle text (e.g., "Sign in to continue")
  final String? subtitle;

  /// Email/username field label
  final String emailLabel;

  /// Email/username field placeholder
  final String emailPlaceholder;

  /// Password field label
  final String passwordLabel;

  /// Password field placeholder
  final String passwordPlaceholder;

  /// Login button text
  final String loginButtonText;

  /// Forgot password link text
  final String? forgotPasswordText;

  /// Sign up prompt text (e.g., "Don't have an account?")
  final String? signUpPromptText;

  /// Sign up link text
  final String? signUpLinkText;

  /// Called when login button is pressed
  /// Returns Future to show loading state
  final Future<void> Function(String email, String password)? onLogin;

  /// Called when forgot password is tapped
  final VoidCallback? onForgotPassword;

  /// Called when sign up is tapped
  final VoidCallback? onSignUp;

  /// Error message to display
  final String? errorMessage;

  /// Custom footer widget
  final Widget? footer;

  const CuLoginScreen({
    super.key,
    this.logo,
    this.title,
    this.subtitle,
    this.emailLabel = 'Email',
    this.emailPlaceholder = 'Enter your email',
    this.passwordLabel = 'Password',
    this.passwordPlaceholder = 'Enter your password',
    this.loginButtonText = 'Sign In',
    this.forgotPasswordText = 'Forgot password?',
    this.signUpPromptText = "Don't have an account?",
    this.signUpLinkText = 'Sign up',
    this.onLogin,
    this.onForgotPassword,
    this.onSignUp,
    this.errorMessage,
    this.footer,
  });

  @override
  State<CuLoginScreen> createState() => _CuLoginScreenState();
}

class _CuLoginScreenState extends State<CuLoginScreen> with CuComponentMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (widget.onLogin == null) return;

    setState(() => _isLoading = true);
    try {
      await widget.onLogin!(
        _emailController.text,
        _passwordController.text,
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: colors.background,
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(spacing.space6),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo
                  if (widget.logo != null) ...[
                    Center(child: widget.logo!),
                    CuSpacer.vertical(spacing.space6),
                  ],

                  // Title
                  if (widget.title != null) ...[
                    Text(
                      widget.title!,
                      style: typography.h2.copyWith(color: colors.foreground),
                      textAlign: TextAlign.center,
                    ),
                    CuSpacer.vertical(spacing.space2),
                  ],

                  // Subtitle
                  if (widget.subtitle != null) ...[
                    Text(
                      widget.subtitle!,
                      style: typography.body.copyWith(color: colors.accents5),
                      textAlign: TextAlign.center,
                    ),
                    CuSpacer.vertical(spacing.space6),
                  ] else if (widget.title != null) ...[
                    CuSpacer.vertical(spacing.space6),
                  ],

                  // Error message
                  if (widget.errorMessage != null) ...[
                    Container(
                      padding: EdgeInsets.all(spacing.space3),
                      decoration: BoxDecoration(
                        color: colors.error.lighter,
                        borderRadius: radius.mdBorder,
                        border: Border.all(color: colors.error.base),
                      ),
                      child: Text(
                        widget.errorMessage!,
                        style: typography.bodySmall.copyWith(color: colors.error.dark),
                      ),
                    ),
                    CuSpacer.vertical(spacing.space4),
                  ],

                  // Email input
                  CuInput(
                    label: widget.emailLabel,
                    placeholder: widget.emailPlaceholder,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    disabled: _isLoading,
                  ),
                  CuSpacer.vertical(spacing.space4),

                  // Password input
                  CuInput(
                    label: widget.passwordLabel,
                    placeholder: widget.passwordPlaceholder,
                    controller: _passwordController,
                    password: true,
                    disabled: _isLoading,
                  ),

                  // Forgot password
                  if (widget.onForgotPassword != null) ...[
                    CuSpacer.vertical(spacing.space2),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: widget.onForgotPassword,
                        child: Text(
                          widget.forgotPasswordText!,
                          style: typography.bodySmall.copyWith(
                            color: colors.accents6,
                          ),
                        ),
                      ),
                    ),
                  ],

                  CuSpacer.vertical(spacing.space6),

                  // Login button
                  CuButton(
                    widget.loginButtonText,
                    onPressed: _handleLogin,
                    loading: _isLoading,
                    disabled: _isLoading,
                  ),

                  // Sign up link
                  if (widget.onSignUp != null) ...[
                    CuSpacer.vertical(spacing.space6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.signUpPromptText ?? '',
                          style: typography.body.copyWith(color: colors.accents5),
                        ),
                        CuSpacer.horizontal(spacing.space1),
                        GestureDetector(
                          onTap: widget.onSignUp,
                          child: Text(
                            widget.signUpLinkText ?? 'Sign up',
                            style: typography.body.copyWith(
                              color: colors.foreground,
                              fontWeight: typography.weightMedium,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],

                  // Footer
                  if (widget.footer != null) ...[
                    CuSpacer.vertical(spacing.space8),
                    widget.footer!,
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
