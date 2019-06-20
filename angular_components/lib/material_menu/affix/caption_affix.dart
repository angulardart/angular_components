// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular/meta.dart';
import 'package:angular_components/material_menu/affix/base_affix.dart';
import 'package:angular_components/material_menu/affix/caption_affix_model.dart';

/// Simple text menu item affix.
@Component(
    selector: 'caption-affix',
    directives: [],
    changeDetection: ChangeDetectionStrategy.OnPush,
    styleUrls: ['caption_affix.scss.css'],
    template: '{{text}}')
class CaptionAffixComponent implements BaseAffixComponent<CaptionAffix> {
  @HostBinding('class')
  static const hostClass = 'caption-text';

  final ChangeDetectorRef _cdRef;

  CaptionAffix _viewModel;

  /// No-op, not used by this component.
  @override
  bool disabled;

  CaptionAffixComponent(this._cdRef);

  @visibleForTemplate
  String get text => _viewModel.text;

  @override
  CaptionAffix get value => _viewModel;

  @override
  set value(CaptionAffix newValue) {
    _viewModel = newValue;
    _cdRef.markForCheck();
  }
}
