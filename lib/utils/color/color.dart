// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:quiver/core.dart';

/// A color utility class.
///
/// Provides conversion between different color representations.
class Color {
  /// _Deprecated; use [rgb] instead._
  // TODO(google) Send CLs replacing uses.
  Color.fromRgb(int r, int g, int b) : this.rgb(r, g, b);

  /// _Deprecated; use [parse] instead._
  // TODO(google) Send CLs replacing uses.
  factory Color.fromRgbString(String rgb) => parse(rgb);

  /// _Deprecated; use [parse] instead._
  // TODO(google) Send CLs replacing uses.
  factory Color.fromHex(String hex) => parse(hex);

  /// Difference threshold, below which two alpha values are considered equal.
  static const _alphaThreshold = 0.01;

  /// [RegExp] for matching start of rgb() or rgba() functional notation.
  static final _rgbRE = new RegExp(r'^rgba?\((.*)\)$');

  /// [RegExp for matching separator of rgb() or rgba() functional notation.
  static final _separatorRE = new RegExp(r' *, *');

  /// Color channels.
  ///
  /// Should be between 0 and 255, inclusive.
  final int red, green, blue;

  /// Alpha channel.
  ///
  /// Should be between 0 and 1, inclusive.
  final num alpha;

  /// RGB color.
  ///
  /// Each channel should be between 0 and 255, inclusive.
  const Color.rgb(int r, int g, int b) : this.rgba(r, g, b, 1);

  /// RGB color with an alpha channel.
  ///
  /// Each color channel should be between 0 and 255, inclusive. The alpha
  /// channel should be between 0 and 1, inclusive.
  const Color.rgba(this.red, this.green, this.blue, this.alpha);

  /// Linearly interpolate between two numbers.
  ///
  /// Returns [a] when t = 0 and [b] when t = 1, without floating point errors.
  static num _lerpNum(num a, num b, double t) {
    if (t < 0.0 || t > 1.0) throw new ArgumentError.value(t, 't');
    return a * (1.0 - t) + b * t;
  }

  /// Linearly interpolates between two colors.
  ///
  /// [t] is the fraction of interpolation from [a] to [b]; between 0 and 1.
  ///
  /// If one color is null, a transparent instance of the other color is used.
  static Color lerp(Color a, Color b, num t) {
    if (a == null && b == null) return null;
    if (a == null) return b.withAlpha(_lerpNum(0, b.alpha, t));
    if (b == null) return a.withAlpha(_lerpNum(a.alpha, 0, t));
    return new Color.rgba(
        _lerpNum(a.red, b.red, t).toInt(),
        _lerpNum(a.green, b.green, t).toInt(),
        _lerpNum(a.blue, b.blue, t).toInt(),
        _lerpNum(a.alpha, b.alpha, t));
  }

  static void _checkValues(int r, int g, int b, num a, [String s]) {
    if (r < 0 ||
        r > 255 ||
        g < 0 ||
        g > 255 ||
        b < 0 ||
        b > 255 ||
        a < 0 ||
        a > 1) {
      throw new FormatException(
          'Invalid color format; value out of bounds.', s);
    }
  }

  /// Parses a string into a [Color].
  ///
  /// Accepts rgb() and rgba() colors, in either functional or hex notation, as
  /// defined by https://developer.mozilla.org/en/docs/Web/CSS/color_value.
  // TODO(google) add support for color keywords and hsl.
  static Color parse(String s) {
    switch (s[0]) {
      case 'r': // rgb
        final match = _rgbRE.firstMatch(s);
        if (match == null) break;
        final values = match[1].split(_separatorRE);
        if (values.length != 3 && values.length != 4) break;
        int color(String s) {
          final last = s.length - 1;
          return s[last] == '%'
              ? 255 * int.parse(s.substring(0, last)) ~/ 100
              : int.parse(s);
        }

        final r = color(values[0]);
        final g = color(values[1]);
        final b = color(values[2]);
        final a = values.length == 4 ? num.parse(values.last) : 1;
        _checkValues(r, g, b, a, s);
        return new Color.rgba(r, g, b, a);
      case '#': // hex
        s = s.substring(1);
        // Calculate number of characters per channel.
        final width = s.length == 6 || s.length == 8
            ? 2
            : s.length == 3 || s.length == 4 ? 1 : 0;
        if (width == 0) break;
        int hex(int position) {
          final start = position * width;
          final value = int.parse(s.substring(start, start + width), radix: 16);
          return width == 1 ? value * 17 : value;
        }
        final r = hex(0);
        final g = hex(1);
        final b = hex(2);
        final a = s.length % 4 == 0 ? hex(3) / 255 : 1;
        _checkValues(r, g, b, a, s);
        return new Color.rgba(r, g, b, a);
    }
    throw new FormatException('Invalid color format', s);
  }

  /// Creates a copy of this, with the given alpha channel value.
  Color withAlpha(num a) {
    assert(a >= 0 && a <= 1);
    return new Color.rgba(red, green, blue, a);
  }

  String get _alphaString =>
      alpha < _alphaThreshold ? '0' : alpha.toStringAsFixed(2);

  /// Returns this as a string in rgb() or rgba() functional notation.
  String get rgbString => alpha == 1
      ? 'rgb($red,$green,$blue)'
      : 'rgba($red,$green,$blue,$_alphaString)';

  /// Returns a 2-character hex representation of an int between 0 and 255.
  static String _toHex(num value) =>
      value.toInt().toRadixString(16).padLeft(2, '0');

  /// Returns this as a string in #rrggbb or #rrggbbaa hex notation.
  String get hexString =>
      '#${_toHex(red)}${_toHex(green)}${_toHex(blue)}' +
      (alpha == 1 ? '' : '${_toHex(255 * alpha)}');

  @override
  String toString() => rgbString;

  @override
  bool operator ==(o) =>
      identical(this, o) ||
      o is Color &&
          red == o.red &&
          green == o.green &&
          blue == o.blue &&
          (alpha - o.alpha).abs() < _alphaThreshold;

  @override
  int get hashCode => hash4(red, green, blue, alpha);
}
