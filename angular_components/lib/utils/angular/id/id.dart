// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/utils/id_generator/id_generator.dart';

/// A directive that assign a unique id to its element.
///
/// To access this id in the template, do the following
///
/// <div autoId #idRef="autoId"></div>
///
/// Then idRef.id can be used to read the assigned id
@Directive(
  selector: '[autoId]',
  exportAs: 'autoId',
)
class AutoIdDirective {
  @HostBinding('attr.id')
  final String id;

  AutoIdDirective(
      @Optional() IdGenerator idGenerator, @Attribute('id') String existingId)
      : id = existingId ??
            ((idGenerator ?? SequentialIdGenerator.fromUUID()).nextId());
}
