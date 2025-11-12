import 'package:flutter/material.dart';
import 'package:ungdungbanmypham/core/api/product_api_service.dart';
import 'package:ungdungbanmypham/core/models/product_model.dart';

class ProductViewModel extends ChangeNotifier {
  final ProductApiService _apiService = ProductApiService();

  List<Product> _products = [];
  Product? _selectedProduct;
  bool _isLoading = false;
  String? _error;

  List<Product> get products => _products;
  Product? get selectedProduct => _selectedProduct;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Lấy danh sách sản phẩm
  Future<void> fetchProducts({
    int skip = 0,
    int limit = 20,
    String? search,
    int? brandId,
    int? categoryId,
    double? minPrice,
    double? maxPrice,
  }) async {
    _setLoading(true);
    try {
      _products = await _apiService.getProducts(
        skip: skip,
        limit: limit,
        search: search,
        brandId: brandId,
        categoryId: categoryId,
        minPrice: minPrice,
        maxPrice: maxPrice,
      );
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // Lấy 1 sản phẩm
  Future<void> fetchProduct(int id) async {
    _setLoading(true);
    try {
      _selectedProduct = await _apiService.getProduct(id);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // Tạo sản phẩm
  Future<bool> createProduct(Map<String, dynamic> data) async {
    _setLoading(true);
    try {
      final product = await _apiService.createProduct(data);
      _products.add(product);
      _error = null;
      _setLoading(false);
      return true;
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      return false;
    }
  }

  // Cập nhật sản phẩm
  Future<bool> updateProduct(int id, Map<String, dynamic> data) async {
    _setLoading(true);
    try {
      final updated = await _apiService.updateProduct(id, data);
      final index = _products.indexWhere((p) => p.id == id);
      if (index != -1) _products[index] = updated;
      if (_selectedProduct?.id == id) _selectedProduct = updated;
      _error = null;
      _setLoading(false);
      return true;
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      return false;
    }
  }

  // Xóa sản phẩm
  Future<bool> deleteProduct(int id) async {
    _setLoading(true);
    try {
      await _apiService.deleteProduct(id);
      _products.removeWhere((p) => p.id == id);
      if (_selectedProduct?.id == id) _selectedProduct = null;
      _error = null;
      _setLoading(false);
      return true;
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      return false;
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}