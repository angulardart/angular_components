// Copyright 2016 Google Inc.
// 
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// 
//     http://www.apache.org/licenses/LICENSE-2.0
// 
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

library angular2_components.utils.color.palette;

import 'color.dart';

// Default Google colors
// TODO(google): fill in all the rest of these

// grayscale shades
final Color white = new Color.fromHex('#FFFFFF');
final Color grey100 = new Color.fromHex('#F5F5F5');
final Color grey300 = new Color.fromHex('#E0E0E0');
final Color grey500 = new Color.fromHex('#9E9E9E');
final Color grey700 = new Color.fromHex('#616161');
final Color black = new Color.fromHex('#000000');

// google colors
final Color blue100 = new Color.fromHex('#C6DAFC');
final Color blue500 = new Color.fromHex('#4285F4');
final Color blue800 = new Color.fromHex('#2A56C6');
final Color red400 = new Color.fromHex('#E06055');
final Color red500 = new Color.fromHex('#DB4437');
final Color red600 = new Color.fromHex('#D23F31');
final Color red700 = new Color.fromHex('#C53929');
final Color red900 = new Color.fromHex('#A52714');
final Color yellow500 = new Color.fromHex('#F4B400');
final Color green500 = new Color.fromHex('#0F9D58');
final Color green800 = new Color.fromHex('#00695C');

// other colors from the palette
final Color cyan600 = new Color.fromHex('#00ACC1');
final Color deepOrange400 = new Color.fromHex('#FF7043');
final Color indigo400 = new Color.fromHex('#5C6BC0');
final Color lime800 = new Color.fromHex('#9E9D24');
final Color pink300 = new Color.fromHex('#F06292');
final Color pink700 = new Color.fromHex('#C2185B');
final Color purple400 = new Color.fromHex('#AB47BC');
final Color teal700 = new Color.fromHex('#00796B');

/// Standard palette of colors for use in charting
final List<Color> chartingPalette = [
  blue500,
  red500,
  yellow500,
  green500,
  purple400,
  cyan600,
  deepOrange400,
  lime800,
  indigo400,
  pink300,
  teal700,
  pink700
];