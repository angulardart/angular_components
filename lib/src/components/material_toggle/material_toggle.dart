// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html';

import 'package:angular2/angular2.dart';

import '../../utils/angular/properties/properties.dart';
import '../../utils/async/async.dart';
import '../../utils/browser/events/events.dart';

/// `material-toggle` is a button that can be either ON or OFF.
/// User can tap the toggle button to change the state.
/// Usually you use toggle buttons when you have a single ON/OFF option.
/// If you have multiple options from a set to be checked/unchecked, use
/// `material-checkbox` instead.
///
/// __Example usage:__
///
///     <material-toggle [disabled]="false" [(checked)]="true" label="Click me">
///     </material-toggle>
@Component(
    selector: 'material-toggle',
    host: const {
      'class': 'themeable',
      '(click)': r'handleClick($event)',
      '(keypress)': r'handleKeyPress($event)'
    },
    styleUrls: const ['material_toggle.scss.css'],
    preserveWhitespace: false,
    templateUrl: 'material_toggle.html',
    directives: const [NgClass, NgIf],
    changeDetection: ChangeDetectionStrategy.OnPush)
class MaterialToggleComponent {
  /// Enables/disables the toggle button.
  /// `true` is disabled and `false` is enabled.
  @Input()
  set disabled(value) {
    _disabled = getBool(value);
  }

  bool get disabled => _disabled;
  bool _disabled = false;

  /// Current state of the toggle button.
  /// `true` is ON and `false` is OFF.
  @Input()
  set checked(value) {
    _checked = getBool(value);
  }

  bool get checked => _checked;
  bool _checked = false;

  final _controller = new LazyStreamController<bool>();

  /// Event that is fired when the toggle is checked.
  @Output('checkedChange')
  Stream<bool> get onChecked => _controller.stream;

  /// Label for the toggle button.
  @Input()
  String label;

  /// ARIA label to use for the toggle button.
  @Input()
  set ariaLabel(String value) {
    _ariaLabel = value;
  }

  String get ariaLabel => _ariaLabel ?? label;
  String _ariaLabel;

  /// The theme color to be used for this toggle button.
  ///
  /// The default color is `teal`.
  ///
  /// Available values are `red`, `pink`, `purple`, `deep-purple`, `indigo`,
  /// `blue`, `light-blue`, `cyan`, `teal`, `green`, `light-green`, `lime`,
  /// `yellow`, `google-yellow`, `orange`, `deep-orange`, `brown`, `grey`,
  /// `blue-grey`, `vanilla-red`, `vanilla-green`, `vanilla-blue`, `amber`.
  static const _validColors = const <String>[
    'red',
    'pink',
    'purple',
    'deep-purple',
    'indigo',
    'blue',
    'light-blue',
    'cyan',
    'teal',
    'green',
    'light-green',
    'lime',
    'yellow',
    'google-yellow',
    'orange',
    'deep-orange',
    'brown',
    'grey',
    'blue-grey',
    'vanilla-red',
    'vanilla-green',
    'vanilla-blue',
    'amber'
  ];
  String _color;

  /// The theme color to be used for this toggle button. The default is `teal`.
  @Deprecated('Consider using "material-toggle-theme" mixin instead')
  @Input()
  set color(value) {
    assert(_validColors.contains(value));
    _color = value;
    _themeClass = 'theme-$color';
  }

  String get color => _color;

  String _themeClass = '';

  String get themeClass => _themeClass;

  /// Sets the depth of the shadow
  int shadow_z = 1;

  bool _hasFocus = false;
  bool get hasFocus => _hasFocus;
  set hasFocus(bool value) {
    _hasFocus = value;
    _updateShadowZ();
  }

  bool _isHovered = false;
  bool get isHovered => _isHovered;
  set isHovered(bool value) {
    _isHovered = value;
    _updateShadowZ();
  }

  bool get hasLabel => label != null && label.isNotEmpty;

  void _updateShadowZ() {
    shadow_z = isHovered ? 3 : hasFocus ? 2 : 1;
  }

  // Visible for testing.
  void toggleChecked() {
    if (!disabled) {
      checked = !checked;
      _controller.add(checked);
    }
  }

  void handleClick(MouseEvent mouseEvent) {
    toggleChecked();
    mouseEvent.preventDefault();
    mouseEvent.stopPropagation();
  }

  void handleKeyPress(KeyboardEvent keyEvent) {
    int keyCode = keyEvent.keyCode;
    if (keyCode == KeyCode.ENTER || isSpaceKey(keyEvent)) {
      toggleChecked();
      keyEvent.preventDefault();
      keyEvent.stopPropagation();
    }
  }
}
