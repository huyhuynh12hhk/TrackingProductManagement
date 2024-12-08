class QrDecode {
  static Map<String, String> DecodeQRString(String content){

    Map<String, String> value = {};

    if(content.startsWith("product")){
      value = {"product":content.substring("product".length)};
    }else if(content.startsWith("user")){
      value = {"user":content.substring("user".length)};
    }
        
    
    return value;
  }
}