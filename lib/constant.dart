// Copyright 2021 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

// NavigationRail shows if the screen width is greater or equal to
// narrowScreenWidthThreshold; otherwise, NavigationBar is used for navigation.
const double narrowScreenWidthThreshold = 450;

const double mediumWidthBreakpoint = 1000;
const double largeWidthBreakpoint = 1500;

const double transitionLength = 500;

// Whether the user has chosen a theme color via a direct [ColorSeed] selection,
// or an image [ColorImageProvider].
enum ColorSelectionMethod {
  colorSeed,
  image,
}

enum ColorSeed {
  baseColor('Indigo',
    Color.fromARGB(225, 152, 36, 36),
  ),
  indigo('Indigo',  Color.fromARGB(225, 152, 36, 36),
  ),
  blue('Blue',  Color.fromARGB(225, 152, 36, 36),
  ),
  teal('Teal',  Color.fromARGB(225, 152, 36, 36),
  ),
  green('Green',  Color.fromARGB(225, 152, 36, 36),
  ),
  yellow('Yellow',  Color.fromARGB(225, 152, 36, 36),
  ),
  orange('Orange',  Color.fromARGB(225, 152, 36, 36),
  ),
  deepOrange('Deep Orange',  Color.fromARGB(225, 152, 36, 36),
  ),
  pink('Pink',
    Color.fromARGB(225, 152, 36, 36),
  );

  const ColorSeed(this.label, this.color);
  final String label;
  final Color color;
}

enum ColorImageProvider {
  leaves('Leaves',
      'https://flutter.github.io/assets-for-api-docs/assets/material/content_based_color_scheme_1.png'),
  peonies('Peonies',
      'https://flutter.github.io/assets-for-api-docs/assets/material/content_based_color_scheme_2.png'),
  bubbles('Bubbles',
      'https://flutter.github.io/assets-for-api-docs/assets/material/content_based_color_scheme_3.png'),
  seaweed('Seaweed',
      'https://flutter.github.io/assets-for-api-docs/assets/material/content_based_color_scheme_4.png'),
  seagrapes('Sea Grapes',
      'https://flutter.github.io/assets-for-api-docs/assets/material/content_based_color_scheme_5.png'),
  petals('Petals',
      'https://flutter.github.io/assets-for-api-docs/assets/material/content_based_color_scheme_6.png');

  const ColorImageProvider(this.label, this.url);
  final String label;
  final String url;
}

bool isAdmin = true;

enum ScreenSelected {
  users(0),
  component(1),
  typography(2),
  // color(3)

  ;

  const ScreenSelected(this.value);
  final int value;
}


