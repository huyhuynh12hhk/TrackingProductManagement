class CredentialValidator {
  //email validator
  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email is required.';
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      return 'Invalid email';
    }
    return null;
  }

  //password validator
  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required.';
    }
    if (password.length < 6 && password.length > 20) {
      return "Password must in 6-20 characters";
    }
    return null;
  }

  static String? validateFullName(String name) {
    final RegExp fullNameRegex = RegExp(r"^[a-zA-Z]+(?: [a-zA-Z]+)*$");
    if (name.isEmpty) {
      return 'Name is required.';
    }

    if (!fullNameRegex.hasMatch(name)) {
      return 'Invalid name.';
    }
    return null;
  }

  static String? validatePhone(String? phone) {
    // if (phone == null || phone.isEmpty) {
    //   return 'Phone number is required.';
    // }
    if (phone!=null 
      && phone.length < 7 
      && phone.length>10) 
    {
      return "Invalid phone number.";
    }
    return null;
  }
}