import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


import '../models/auth.dart';


class CompaniesScreen extends StatefulWidget {
  const CompaniesScreen({Key? key}) : super(key: key);

  @override
  State<CompaniesScreen> createState() => _CompaniesScreenState();
}

class _CompaniesScreenState extends State<CompaniesScreen> {
  final storage = FlutterSecureStorage();
  final _baseUrl = 'https://devapi.adscompass.ru/api/v1/selfserve-campaigns';
  int _page = 1;
  final int _limit = 10;
  bool _isFirstLoadRunning = false;
  bool _hasNextPage = true;
  late String token;
  bool _isLoadMoreRunning = false;
  List _posts = [];
  late BuildContext _context;

  void _loadMore() async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 300
    ) {
      setState(() {
        _isLoadMoreRunning = true;
      });

      _page += 1;

      try {
        print("token: "+token);
        final res =
        await post(
            Uri.parse("$_baseUrl?page=$_page&perpage=$_limit"),
            headers: {
              'x-referer' : "https://dev.adscompass.ru",
              'Authorization' : token,
              "x-mobile-app" : "DEV"
            }
        );

        var _data = json.decode(res.body);
        if (_data.isNotEmpty) {
          setState(() {
            _data = _data["data"];
            _posts.addAll(_data);
          });
        } else {

          setState(() {
            _hasNextPage = false;
          });
        }
      } catch (err) {
        if (kDebugMode) {
          print('Error!1');
        }
      }
      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  void _firstLoad() async {
    setState(() {
      _isFirstLoadRunning = true;
    });

    try {
      print("token: "+token);
      final res =
      await post(
          Uri.parse("$_baseUrl?page=$_page&perpage=$_limit"),
          headers: {
            'x-referer' : "https://dev.adscompass.ru",
            'Authorization' : token,
            "x-mobile-app" : "DEV"
          }
      );
      var _data = json.decode(res.body);
      _posts = _data["data"];
    } catch (err) {
      if (kDebugMode) {
        print('Error!2');
      }
    }

    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  late ScrollController _controller;
  @override
  void initState() {
    super.initState();
    Auth auth = Provider.of<Auth>(context, listen: false);
    var authData = auth.auth_data;
    token = authData['token'].toString();
    _firstLoad();
    _controller = ScrollController()..addListener(_loadMore);


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Компании', style: TextStyle(color: Colors.white),),
            backgroundColor: Colors.red[400],
            automaticallyImplyLeading: false
        ),
        body:_isFirstLoadRunning?const Center(
          child: CircularProgressIndicator(),
        ):Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _posts.length,
                controller: _controller,
                itemBuilder: (_, index) => Card(
                  margin: const EdgeInsets.symmetric(
                      vertical: 8, horizontal: 10),
                  child: ListTile(
                    title: Text(_posts[index]['id'].toString()+ " " +_posts[index]['user']["company"]["name"].toString()),
                    subtitle: Text("Status: "+_posts[index]['active'].toString()+" Balance: "+_posts[index]["balance"].toString()),
                  ),
                ),
              ),
            ),
            if (_isLoadMoreRunning == true)
              const Padding(
                padding: EdgeInsets.only(top: 10, bottom: 40),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),

            if (_hasNextPage == false)
              Container(
                padding: const EdgeInsets.only(top: 30, bottom: 40),
                color: Colors.amber,
                child: const Center(
                  child: Text('You have fetched all of the companies'),
                ),
              ),
          ],
        )
    );
  }
  }

