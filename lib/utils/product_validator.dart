import 'package:tracking_app_v1/models/validate_result.dart';

class ProductValidator {
  static ValidateResult validatePrice(String? price) {
    var numPrice = double.tryParse(price ?? "0");

    if (numPrice == null) {
      return ValidateResult.invalid("Price must be a number");
    }

    return ValidateResult.valid();
  }

  static ValidateResult validateStringLength({required String title, required String content, int min = 0, int max = 50, bool isRequire = false} ){
    
    if(isRequire && content.isEmpty){
      return ValidateResult.invalid("$title is required.");
    }

    if(content.length < min || content.length > max){
      return ValidateResult.invalid("$title lenght must between $min - $max characters.");
    }
    return ValidateResult.valid();
  }

  

  
}
