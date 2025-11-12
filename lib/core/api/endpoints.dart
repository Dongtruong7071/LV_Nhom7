class ApiEndpoints {
  static const String baseUrl = "http://127.0.0.1:8000"; 

  // Products
  static const String products = "/products";
  static String productById(int id) => "/products/$id";
}