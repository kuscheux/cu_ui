/// Supported languages
enum CuLanguage {
  english,
  spanish,
}

/// Verbose/tone levels
enum CuVerbosity {
  /// Minimal - short, terse labels
  minimal,
  /// Standard - normal labels (default)
  standard,
  /// Friendly - warm, conversational
  friendly,
  /// Formal - professional, business tone
  formal,
}

/// Localization strings
class CuLocaleStrings {
  // Common actions
  final String ok;
  final String cancel;
  final String save;
  final String delete;
  final String edit;
  final String close;
  final String back;
  final String next;
  final String done;
  final String submit;
  final String retry;
  final String confirm;

  // Status
  final String loading;
  final String success;
  final String error;
  final String warning;

  // Form
  final String required;
  final String optional;
  final String selectOption;
  final String search;
  final String noResults;
  final String clear;

  // Auth
  final String signIn;
  final String signOut;
  final String signUp;
  final String password;
  final String email;
  final String username;
  final String forgotPassword;
  final String rememberMe;

  // Finance (CU specific)
  final String balance;
  final String availableBalance;
  final String transfer;
  final String deposit;
  final String withdraw;
  final String accountNumber;
  final String routingNumber;
  final String transactions;
  final String recentActivity;

  const CuLocaleStrings({
    // Common actions
    this.ok = 'OK',
    this.cancel = 'Cancel',
    this.save = 'Save',
    this.delete = 'Delete',
    this.edit = 'Edit',
    this.close = 'Close',
    this.back = 'Back',
    this.next = 'Next',
    this.done = 'Done',
    this.submit = 'Submit',
    this.retry = 'Retry',
    this.confirm = 'Confirm',

    // Status
    this.loading = 'Loading...',
    this.success = 'Success',
    this.error = 'Error',
    this.warning = 'Warning',

    // Form
    this.required = 'Required',
    this.optional = 'Optional',
    this.selectOption = 'Select an option',
    this.search = 'Search',
    this.noResults = 'No results found',
    this.clear = 'Clear',

    // Auth
    this.signIn = 'Sign In',
    this.signOut = 'Sign Out',
    this.signUp = 'Sign Up',
    this.password = 'Password',
    this.email = 'Email',
    this.username = 'Username',
    this.forgotPassword = 'Forgot Password?',
    this.rememberMe = 'Remember Me',

    // Finance
    this.balance = 'Balance',
    this.availableBalance = 'Available Balance',
    this.transfer = 'Transfer',
    this.deposit = 'Deposit',
    this.withdraw = 'Withdraw',
    this.accountNumber = 'Account Number',
    this.routingNumber = 'Routing Number',
    this.transactions = 'Transactions',
    this.recentActivity = 'Recent Activity',
  });

  /// English strings - Standard
  static const CuLocaleStrings englishStandard = CuLocaleStrings();

  /// English strings - Friendly
  static const CuLocaleStrings englishFriendly = CuLocaleStrings(
    ok: 'Got it!',
    cancel: 'Never mind',
    save: 'Save changes',
    delete: 'Remove this',
    close: 'All done',
    back: 'Go back',
    next: 'Continue',
    done: 'All set!',
    submit: 'Send it',
    retry: 'Try again',
    confirm: 'Yes, do it',
    loading: 'Just a moment...',
    success: 'Perfect!',
    error: 'Oops, something went wrong',
    warning: 'Heads up!',
    selectOption: 'Pick one',
    search: 'What are you looking for?',
    noResults: 'Nothing here yet',
    signIn: 'Welcome back!',
    signOut: 'See you later!',
    signUp: 'Join us',
    forgotPassword: 'Need help signing in?',
    rememberMe: 'Keep me signed in',
    balance: 'Your Balance',
    availableBalance: 'Available to spend',
    recentActivity: 'What\'s been happening',
  );

  /// English strings - Formal
  static const CuLocaleStrings englishFormal = CuLocaleStrings(
    ok: 'Acknowledge',
    cancel: 'Discard',
    save: 'Save Changes',
    delete: 'Remove',
    close: 'Dismiss',
    back: 'Return',
    next: 'Proceed',
    done: 'Complete',
    submit: 'Submit Request',
    retry: 'Attempt Again',
    confirm: 'Confirm Action',
    loading: 'Processing...',
    success: 'Operation Successful',
    error: 'An Error Occurred',
    warning: 'Attention Required',
    selectOption: 'Select Option',
    search: 'Search Records',
    noResults: 'No Records Found',
    signIn: 'Member Login',
    signOut: 'Logout',
    signUp: 'Create Account',
    forgotPassword: 'Reset Password',
    rememberMe: 'Maintain Session',
    balance: 'Account Balance',
    availableBalance: 'Available Funds',
    recentActivity: 'Transaction History',
  );

  /// English strings - Minimal
  static const CuLocaleStrings englishMinimal = CuLocaleStrings(
    ok: 'OK',
    cancel: 'Cancel',
    save: 'Save',
    delete: 'Delete',
    close: 'Close',
    back: 'Back',
    next: 'Next',
    done: 'Done',
    submit: 'Submit',
    retry: 'Retry',
    confirm: 'Yes',
    loading: '...',
    success: 'Done',
    error: 'Error',
    warning: 'Alert',
    selectOption: 'Select',
    search: 'Search',
    noResults: 'None',
    signIn: 'Login',
    signOut: 'Logout',
    signUp: 'Register',
    forgotPassword: 'Reset',
    rememberMe: 'Remember',
    balance: 'Balance',
    availableBalance: 'Available',
    recentActivity: 'Activity',
  );

  /// Spanish strings - Standard
  static const CuLocaleStrings spanishStandard = CuLocaleStrings(
    ok: 'Aceptar',
    cancel: 'Cancelar',
    save: 'Guardar',
    delete: 'Eliminar',
    edit: 'Editar',
    close: 'Cerrar',
    back: 'Atr\u00e1s',
    next: 'Siguiente',
    done: 'Listo',
    submit: 'Enviar',
    retry: 'Reintentar',
    confirm: 'Confirmar',
    loading: 'Cargando...',
    success: '\u00c9xito',
    error: 'Error',
    warning: 'Advertencia',
    required: 'Obligatorio',
    optional: 'Opcional',
    selectOption: 'Selecciona una opci\u00f3n',
    search: 'Buscar',
    noResults: 'Sin resultados',
    clear: 'Limpiar',
    signIn: 'Iniciar Sesi\u00f3n',
    signOut: 'Cerrar Sesi\u00f3n',
    signUp: 'Registrarse',
    password: 'Contrase\u00f1a',
    email: 'Correo Electr\u00f3nico',
    username: 'Usuario',
    forgotPassword: '\u00bfOlvidaste tu contrase\u00f1a?',
    rememberMe: 'Recordarme',
    balance: 'Saldo',
    availableBalance: 'Saldo Disponible',
    transfer: 'Transferir',
    deposit: 'Dep\u00f3sito',
    withdraw: 'Retiro',
    accountNumber: 'N\u00famero de Cuenta',
    routingNumber: 'N\u00famero de Ruta',
    transactions: 'Transacciones',
    recentActivity: 'Actividad Reciente',
  );

  /// Spanish strings - Friendly
  static const CuLocaleStrings spanishFriendly = CuLocaleStrings(
    ok: '\u00a1Entendido!',
    cancel: 'Mejor no',
    save: 'Guardar cambios',
    delete: 'Quitar esto',
    close: '\u00a1Listo!',
    back: 'Volver',
    next: 'Continuar',
    done: '\u00a1Perfecto!',
    submit: 'Enviar',
    retry: 'Intentar de nuevo',
    confirm: 'S\u00ed, hazlo',
    loading: 'Un momento...',
    success: '\u00a1Excelente!',
    error: 'Ups, algo sali\u00f3 mal',
    warning: '\u00a1Ojo!',
    selectOption: 'Elige una',
    search: '\u00bfQu\u00e9 buscas?',
    noResults: 'Nada por aqu\u00ed',
    signIn: '\u00a1Bienvenido de vuelta!',
    signOut: '\u00a1Hasta luego!',
    signUp: '\u00danete',
    forgotPassword: '\u00bfNecesitas ayuda?',
    rememberMe: 'Mant\u00e9nme conectado',
    balance: 'Tu Saldo',
    availableBalance: 'Disponible para gastar',
    recentActivity: '\u00bfQu\u00e9 ha pasado?',
  );

  /// Spanish strings - Formal
  static const CuLocaleStrings spanishFormal = CuLocaleStrings(
    ok: 'Aceptar',
    cancel: 'Descartar',
    save: 'Guardar Cambios',
    delete: 'Eliminar',
    close: 'Cerrar',
    back: 'Regresar',
    next: 'Continuar',
    done: 'Completado',
    submit: 'Enviar Solicitud',
    retry: 'Reintentar',
    confirm: 'Confirmar Acci\u00f3n',
    loading: 'Procesando...',
    success: 'Operaci\u00f3n Exitosa',
    error: 'Ha Ocurrido un Error',
    warning: 'Atenci\u00f3n Requerida',
    selectOption: 'Seleccionar Opci\u00f3n',
    search: 'Buscar Registros',
    noResults: 'Sin Registros',
    signIn: 'Acceso de Miembro',
    signOut: 'Salir',
    signUp: 'Crear Cuenta',
    forgotPassword: 'Restablecer Contrase\u00f1a',
    rememberMe: 'Mantener Sesi\u00f3n',
    balance: 'Saldo de Cuenta',
    availableBalance: 'Fondos Disponibles',
    recentActivity: 'Historial de Transacciones',
  );
}

/// Locale configuration tokens
class CuLocaleTokens {
  final CuLanguage language;
  final CuVerbosity verbosity;
  final CuLocaleStrings strings;

  const CuLocaleTokens({
    this.language = CuLanguage.english,
    this.verbosity = CuVerbosity.standard,
    this.strings = CuLocaleStrings.englishStandard,
  });

  /// Get strings for language and verbosity
  static CuLocaleStrings getStrings(CuLanguage language, CuVerbosity verbosity) {
    switch (language) {
      case CuLanguage.english:
        switch (verbosity) {
          case CuVerbosity.minimal:
            return CuLocaleStrings.englishMinimal;
          case CuVerbosity.standard:
            return CuLocaleStrings.englishStandard;
          case CuVerbosity.friendly:
            return CuLocaleStrings.englishFriendly;
          case CuVerbosity.formal:
            return CuLocaleStrings.englishFormal;
        }
      case CuLanguage.spanish:
        switch (verbosity) {
          case CuVerbosity.minimal:
            return CuLocaleStrings.spanishStandard; // Use standard for minimal
          case CuVerbosity.standard:
            return CuLocaleStrings.spanishStandard;
          case CuVerbosity.friendly:
            return CuLocaleStrings.spanishFriendly;
          case CuVerbosity.formal:
            return CuLocaleStrings.spanishFormal;
        }
    }
  }

  CuLocaleTokens copyWith({
    CuLanguage? language,
    CuVerbosity? verbosity,
  }) {
    final newLanguage = language ?? this.language;
    final newVerbosity = verbosity ?? this.verbosity;
    return CuLocaleTokens(
      language: newLanguage,
      verbosity: newVerbosity,
      strings: getStrings(newLanguage, newVerbosity),
    );
  }
}
