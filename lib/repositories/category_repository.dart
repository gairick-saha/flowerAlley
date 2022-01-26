import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:active_ecommerce_flutter/data_model/category_response.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';

class CategoryRepository {
  Future<CategoryResponse> getCategories({parent_id = 0}) async {
    Uri url =
        Uri.parse("${AppConfig.BASE_URL}/categories?parent_id=${parent_id}");
    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
    });
    print("${AppConfig.BASE_URL}/categories?parent_id=${parent_id}");
    print(response.body.toString());
    return categoryResponseFromJson(response.body);
  }

  Future<CategoryResponse> getAllCategories() async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/categories");
    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
    });
    //print(response.body.toString());
    //print("--featured cat--");
    return categoryResponseFromJson(response.body);
  }

  Future<CategoryResponse> getFeturedCategories() async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/categories/featured");
    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
    });
    //print(response.body.toString());
    //print("--featured cat--");
    return categoryResponseFromJson(response.body);
  }

  Future<CategoryResponse> getTopCategories() async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/categories/top");
    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
    });
    return categoryResponseFromJson(response.body);
  }

  Future<CategoryResponse> getFilterPageCategories() async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/filter/categories");
    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
    });
    return categoryResponseFromJson(response.body);
  }

  Future<List<Category>> getHomeCategories() async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/categories/home");

    return await http.get(url, headers: {
      "App-Language": app_language.$,
    }).then((_response) {
      final CategoryResponse _categoryResponse =
          categoryResponseFromJson(_response.body);
      if (_categoryResponse.success) {
        return _categoryResponse.categories;
      } else {
        return [];
      }
    });
  }

  Future<List<Category>> getSubCategories(int id) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/sub-categories/$id");

    return await http.get(url, headers: {
      "App-Language": app_language.$,
    }).then((_response) {
      final CategoryResponse _categoryResponse =
          categoryResponseFromJson(_response.body);
      if (_categoryResponse.success) {
        return _categoryResponse.categories;
      } else {
        return [];
      }
    });
  }
}
