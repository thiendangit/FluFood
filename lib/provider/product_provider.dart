import 'package:flufood/models/product.dart';
import 'package:flufood/services/api_service.dart';
import 'package:flutter/cupertino.dart';

class SortBy {
  late String value;
  late String text;
  late String sortOrder;

  SortBy(this.value, this.text, this.sortOrder);
}

enum LoadMoreStatus { INITIAL, LOADING, STABLE }

class ProductProvider with ChangeNotifier {
  late ApiService _apiService;
  late List<Product> _productList;
  late SortBy _sortBy;

  int pageSize = 10;

  List<Product> get allProducts => _productList;

  double get totalProduct => _productList.length.toDouble();

  LoadMoreStatus _loadMoreStatus = LoadMoreStatus.STABLE;

  getLoadMoreStatus() => _loadMoreStatus;

  ProductProvider() {
    resetStream();
    _sortBy = SortBy("date", "", "asc");
  }

  void resetStream() {
    _apiService = new ApiService();
    _productList = [];
  }

  setLoadingState(LoadMoreStatus loadingMoreStatus) {
    _loadMoreStatus = loadingMoreStatus;
    if (_loadMoreStatus != LoadMoreStatus.INITIAL) {
      notifyListeners();
    }
  }

  setSortOrder(SortBy sortBy) {
    _sortBy = sortBy;
    notifyListeners();
  }

  fetchProducts(pageNumber,
      {String strSearch = '',
        String tagName = '',
        String categoryId = '',
        // sortBy: date, id, include, title, slug, price, popularity and rating. Default is date.
        String sortBy = '',
        // Order sort attribute ascending or descending. Options: asc and desc. Default is desc
        String sortOrder = 'asc'}) async {
    List<Product> _products = await _apiService.getProducts(
        strSearch: strSearch,
        tagName: tagName,
        pageNumber: pageNumber,
        pageSize: this.pageSize,
        categoryId: categoryId,
        sortBy: this._sortBy.value,
        sortOrder: this._sortBy.sortOrder);
    if (_products.length > 0) {
      _productList.addAll(_products);
    }
    setLoadingState(LoadMoreStatus.STABLE);
    notifyListeners();
    // This call tells the widgets that are listening to this model to rebuild.
  }
}
