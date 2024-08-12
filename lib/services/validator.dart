class Validator {
  /// Valide si le champ n'est pas vide et renvoie un message d'erreur approprié.
  static String? validateNotEmpty(String value, String fieldName) {
    if (value.trim().isEmpty) {
      return 'Veuillez entrer votre $fieldName';
    }
    return null;
  }

  /// Valide les adresses email avec une expression régulière simple.
  static String? validateEmail(String value) {
    if (value.isEmpty) {
      return 'Veuillez entrer un email';
    }
    // Expression régulière pour la validation de l'email
    RegExp emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$',
      caseSensitive: false,
    );
    if (!emailRegExp.hasMatch(value)) {
      return 'Veuillez entrer un email valide';
    }
    return null;
  }

  /// Valide les noms pour s'assurer qu'ils ne contiennent que des caractères alphabétiques et des espaces.
  static String? validateName(String value) {
    if (value.isEmpty) {
      return 'Veuillez entrer un nom';
    }
    RegExp nameRegExp = RegExp(
      r"^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$",
      caseSensitive: false,
    );
    if (!nameRegExp.hasMatch(value)) {
      return 'Le nom ne doit contenir que des lettres et des espaces';
    }
    return null;
  }

  /// Valide les mots de passe en s'assurant qu'ils répondent à des critères de complexité.
  static String? validatePassword(String value) {
    if (value.length < 8) {
      return 'Le mot de passe doit contenir au moins 8 caractères';
    }
    // Vous pouvez ajouter plus de règles pour la complexité des mots de passe ici.
    return null;
  }
}
