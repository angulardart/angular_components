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

library angular2_components.utils.color.color;

/// A color utility class that provides a lightweight representation of colors
/// and simple conversion between different representations
class Color {
  // Strings used in text processing (mostly stripped)
  static const String rgbPrefix = 'rgb(';
  static const String rgbSuffix = ')';
  static const String rgbSeparator = ',';
  static const String hexPrefix = '#';
  static const String semicolon = ';';
  static const String whitespace = ' ';
  static const String emptyString = '';

  /// Maximum value of a single color component (r, g, or b)
  static const int maxValue = 255;

  /// Radix value for hex conversion
  static const int hexRadix = 16;

  /// Get a 2-character hex representation of an int between 0 and 255
  static String getHexFor(int val) {
    assert(val >= 0 && val <= maxValue);
    String result = val.toRadixString(hexRadix).toUpperCase();
    if (result.length == 1) {
      // pad with a leading zero if necessary
      result = '0' + result;
    }
    return result;
  }

  /// red, green, and blue values, always 0-255
  final int _r, _g, _b;

  /// Private constructor, should only be called from Color.fromRGB factory
  const Color._(this._r, this._g, this._b);

  /// Factory from rgb values -- also called by all other factories for
  /// DRY asserts
  factory Color.fromRgb(int r, int g, int b) {
    var color = new Color._(r, g, b);
    color._checkValues();
    return color;
  }

  /// Factory from a CSS-style RGB string (e.g. 'rgb(0,0,0)')
  factory Color.fromRgbString(String rgb) {
    // strip extraneous stuff if present
    [rgbPrefix, rgbSuffix, semicolon, whitespace].forEach((String stripThis) {
      rgb = rgb.replaceAll(stripThis, emptyString);
    });

    // String is now of format 'x,y,z'; split into component parts
    List<int> components = rgb.split(rgbSeparator).map(int.parse).toList();
    assert(components.length == 3);
    return new Color.fromRgb(components[0], components[1], components[2]);
  }

  /// Factory from hex string (e.g. '#000', '#DB4437', etc.)
  factory Color.fromHex(String hex) {
    // strip extraneous stuff if present
    [hexPrefix, semicolon, whitespace].forEach((String stripThis) {
      hex = hex.replaceAll(stripThis, emptyString);
    });
    // string should be raw hex now with no pre/suffix, either 3 or 6 chars long
    assert(hex.length == 3 || hex.length == 6);
    var rHex, gHex, bHex;
    if (hex.length == 3) {
      rHex = hex[0];
      gHex = hex[1];
      bHex = hex[2];
    } else if (hex.length == 6) {
      rHex = hex.substring(0, 2);
      gHex = hex.substring(2, 4);
      bHex = hex.substring(4, 6);
    }
    return new Color.fromRgb(int.parse(rHex, radix: hexRadix),
        int.parse(gHex, radix: hexRadix), int.parse(bHex, radix: hexRadix));
  }

  void _checkValues() {
    [_r, _g, _b].forEach((value) {
      assert(value >= 0 && value <= maxValue);
    });
  }

  /// Get color's representation as an rgb string (e.g. 'rgb(0,0,0)')
  String get rgbString =>
      '${rgbPrefix}${_r}${rgbSeparator}${_g}${rgbSeparator}${_b}${rgbSuffix}';

  /// Get color's representation as a hex string (e.g. '#AABBCC')
  String get hexString =>
      '${hexPrefix}${getHexFor(_r)}${getHexFor(_g)}${getHexFor(_b)}';

  /// Override equality operator to give expected behavior (colors with
  /// identical components are equal). Compare rgb strings because that's the
  /// cheapest public getter that exposes all components.
  bool operator ==(other) => other is Color && other.rgbString == rgbString;
}
