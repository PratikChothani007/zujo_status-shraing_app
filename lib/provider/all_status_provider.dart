import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/status.dart';

class StatusProvider with ChangeNotifier {
  List<Status> _status_list = [];
  String token;
  String userId;
  String emailName;

  StatusProvider(this._status_list, this.token, this.userId, this.emailName);

  List<Status> get statusList {
    return [..._status_list];
  }

  int get itemCount {
    return _status_list.length;
  }

  Status findById(String id) {
    final i = _status_list.indexWhere((test) => test.id == id);
    return _status_list[i];
  }

  Future<void> removeProduct(String id) async {
    final url = "https://shop-a491f.firebaseio.com/status/$id.json?auth=$token";
    final index = _status_list.indexWhere((product) {
      return product.id == id;
    });
    var savedProduct = _status_list[index];
    _status_list.removeAt(index);
    notifyListeners();
    try {
      final response = await http.delete(url);
      if (response.statusCode >= 400) {
        throw Exception();
      }
      savedProduct = null;
    } catch (error) {
      _status_list.insert(index, savedProduct);
      notifyListeners();
      throw error;
    }
  }

  bool _isUpdate = false;

  Future<void> refreshStatus([bool isFilter = false]) async {
    final stringElement =
        isFilter ? 'orderBy="authorId"&equalTo="$userId"' : '';
    var url =
        "https://shop-a491f.firebaseio.com/status.json?auth=$token&$stringElement";

    try {
      final response = await http.get(url);
      final rowData = json.decode(response.body) as Map<String, dynamic>;
      _status_list = [];
      print(rowData);
      rowData.forEach((key, item) {
        _status_list.insert(
            0,
            Status(
                description: item["description"],
                id: key,
                imageUrl: item["imageUrl"],
                author: item["authorId"],
                text: item["text"],
                emailName: item["authorName"]));
      });
      print(_status_list);

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchStatus([bool isFilter = false]) async {
    final stringElement =
        isFilter ? 'orderBy="createrId"&equalTo="$userId"' : '';
    var url =
        "https://shop-a491f.firebaseio.com/status.json?auth=$token&$stringElement";

    try {
      if (!_isUpdate) {
        final response = await http.get(url);
        final rowData = json.decode(response.body) as Map<String, dynamic>;
        rowData.forEach((key, item) {
          _status_list.insert(
              0,
              Status(
                  description: item["description"],
                  id: key,
                  imageUrl: item["imageUrl"],
                  author: item["authorId"],
                  text: item["text"],
                  emailName: emailName));
        });
        _isUpdate = true;
        notifyListeners();
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> addStatus(Status item) async {
    final addUrl = "https://shop-a491f.firebaseio.com/status.json?auth=$token";

    try {
      final response = await http.post(addUrl,
          body: json.encode({
            "text": item.text,
            "description": item.description,
            "imageUrl": item.imageUrl,
            "authorId": userId,
            "authorName": emailName
          }));

      _status_list.insert(
          0,
          Status(
              description: item.description,
              id: json.decode(response.body)["name"],
              imageUrl: item.imageUrl,
              author: item.author,
              text: item.text,
              emailName: emailName));
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
