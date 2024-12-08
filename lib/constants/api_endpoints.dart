class ApiEndpoints {
  // android to local machine alias
  // static const String productApiUri = "https://10.0.2.2:7249";

  static const String productApiUri = "http://3.110.194.48";

  static const String login = "$productApiUri/api/account/token";

  static const String register = "$productApiUri/api/account/register";

  static const String accountInfo = "$productApiUri/api/account/info";

  static const String userProfile = "$productApiUri/api/users";

  static const String userRelationship= "$productApiUri/api/users/relationships";

  //product

  static const String CRUDProduct = "$productApiUri/api/products";

  static const String getProductBySupplier = "$productApiUri/api/products/suppliers";


  //search
  static const String searchAll = "$productApiUri/api/search";

  //post
  static const String CRUDPost = "$productApiUri/api/posts";


  //media
  // static const String mediaApiUri = "https://10.0.2.2:7260";

  static const String mediaApiUri = "http://13.126.119.13";

  static const String upload = "$mediaApiUri/api/media/upload";

  static const String CRUDMedia = "$mediaApiUri/api/media";

  static String getImagePath(String key) =>"${ApiEndpoints.CRUDMedia}/${key}";

}
