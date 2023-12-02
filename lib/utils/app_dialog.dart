import 'dart:async';

import 'package:flutter/material.dart';
import 'package:weather_app/main.dart';

enum AppDialogType { loading, errorRecoding, errorHttp, errorRespo, success }

class AppDialog {
  static show({Function()? onTap, String? msg}) {
    return showDialog(
        context: navigatorKey.currentState!.context,
        builder: (ctxt) => Material(
              color: Colors.transparent,
              child: Center(
                child: Container(
                    height: 250,
                    width: 250,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // const Icon(
                          //   Icons.warning_rounded,
                          //   size: 90,
                          //   color: Colors.amber,
                          // ),
                          Column(
                            children: [
                              Text(
                                msg ?? "",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(navigatorKey.currentState!.context);
                              if (onTap != null) onTap();
                            },
                            child: Container(
                              width: 90,
                              height: 45,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: Colors.black54, width: 2)),
                              alignment: Alignment.center,
                              child: Text(
                                "OK",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        ])),
              ),
            ));
  }


}
