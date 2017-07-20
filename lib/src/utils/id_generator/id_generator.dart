// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:uuid/uuid.dart';

/// Generator generates ids that are probably unique.
abstract class IdGenerator {
  /// Returns next id.
  String nextId();
}

/// Sequential implementation of generator that will use seed as prefix
/// and sequential number as suffix in form of "prefix--153"
class SequentialIdGenerator implements IdGenerator {
  static Uuid _uuid = new Uuid();
  final String _prefix;
  int _seq = 0;

  /// Initializes sequential generator with prefix.
  /// Please don't use in any other way that creating and binding it
  /// at the top level of app, otherwise it does not provide guarantees
  /// of uniqueness if code is used in multiple apps
  /// advantage of using this one - shorter ids
  /// disadvantage - user's mistake can cause clashes
  SequentialIdGenerator(this._prefix);

  /// Initializes sequential generator with UUID v4 prefix
  /// https://en.wikipedia.org/wiki/Universally_unique_identifier#Version_4_.28random.29
  /// These are probably unique
  /// (you need to generate 2^36 to have clash with 4*10^-16 probability)
  /// so it can be freely used anywhere across the app
  /// advantage: very likely to be unique without extra restrictions
  /// disadvantage: long ids
  SequentialIdGenerator.fromUUID() : this(_uuid.v4());

  @override
  String nextId() => "$_prefix--${_seq++}";
}
