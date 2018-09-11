// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/material_button/material_button.dart';
import 'package:angular_components/material_checkbox/material_checkbox.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_input/material_input.dart';
import 'package:angular_components/material_toggle/material_toggle.dart';
import 'package:angular_gallery_section/annotation/gallery_section_config.dart';

@GallerySectionConfig(
  displayName: 'Material Checkbox',
  docs: [MaterialCheckboxComponent],
  demos: [MaterialCheckboxExample],
)
class MaterialCheckboxGalleryConfig {}

@Component(
  selector: 'material-checkbox-example',
  directives: [
    MaterialButtonComponent,
    MaterialCheckboxComponent,
    MaterialIconComponent,
    materialInputDirectives,
    MaterialToggleComponent,
    NgFor,
    NgModel,
    NgFormControl
  ],
  templateUrl: 'material_checkbox_example.html',
  styleUrls: ['material_checkbox_example.scss.css'],
  preserveWhitespace: true,
)
class MaterialCheckboxExample {
  /// Todo list example
  List<Todo> todos;
  String todoText;

  MaterialCheckboxExample() {
    todos = [
      Todo('learn angular', true),
      Todo('build an angular app', false),
      Todo('profit!', false),
    ];
  }

  Control newTodo = Control("");

  void addTodo() {
    todos.add(Todo(newTodo.value, false));
    newTodo.updateValue("");
  }

  int remaining() => todos.where((todo) => !todo.done).length;

  /// Custom example
  bool disabledState = false;
  bool checkedState = false;
  bool indeterminateState = false;
  bool indeterminateBehavior = false;
  String customLabel = "custom label";
  Control newLabel = Control("");
  String statusStr = "???";

  void setLabel() {
    customLabel = newLabel.value;
    newLabel.updateValue("");
  }
}

class Todo {
  String text;
  bool done;

  Todo(this.text, this.done);
}
