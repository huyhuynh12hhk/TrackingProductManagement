class ValidateResult {
  final String message;
  final bool isValid;

  ValidateResult({required this.message, required this.isValid});

  factory ValidateResult.valid()=> ValidateResult(message: "", isValid: true);
  factory ValidateResult.invalid(String message)=> ValidateResult(message: message, isValid: false);
}