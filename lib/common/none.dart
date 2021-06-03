import 'package:flutter/material.dart';

Widget noneView({required String title, required String subTitle}) => Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$title',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 2),
          Text(
            '$subTitle',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w300,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
