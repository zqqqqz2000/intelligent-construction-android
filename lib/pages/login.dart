// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';
import 'package:intelligent_construction/config.dart';
import 'package:flutter/material.dart';
import 'package:intelligent_construction/utils/request.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatelessWidget {
  String username = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          return Center(
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover,
              )),
              padding: EdgeInsets.all(80.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '登录智慧建造',
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: '用户名',
                    ),
                    onChanged: (value) => {this.username = value},
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: '密码',
                    ),
                    onChanged: (value) => {this.password = value},
                    obscureText: true,
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  RaisedButton(
                    color: Color.fromRGBO(85, 151, 255, 1),
                    child: Text(
                      '登录',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () async {
                      var data = await api('/login/mobil_login', {
                        'username': this.username,
                        'password': this.password
                      });
                      if (data['success']) {
                        var per = await SharedPreferences.getInstance();
                        per.setString('token', data['token']);
                        Navigator.pushNamed(context, '/mainPage');
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Row(
                          children: [
                            Icon(Icons.close, color: Colors.red),
                            Text(data['info']),
                          ],
                        )));
                      }
                    },
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
