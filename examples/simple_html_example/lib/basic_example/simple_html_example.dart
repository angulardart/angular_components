// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart' show Component;
import 'package:angular_components/simple_html/simple_html.dart'
    show SimpleHtmlComponent, SimpleHtmlBlockComponent;

import 'simple_html_example_messages.dart';

@Component(
  selector: 'simple-html-example',
  directives: [SimpleHtmlComponent, SimpleHtmlBlockComponent],
  templateUrl: 'simple_html_example.html',
  styleUrls: ['simple_html_example.scss.css'],
)
class SimpleHtmlExampleComponent {
  // For simple messages, we can expose them directly to the template.
  SimpleHtmlExampleMessages get messages => const SimpleHtmlExampleMessages();

  // For more complex messages (such as those with parameters), we can put
  // the interesting behaviour in the component (or elsewhere) and just expose
  // a getter to the template.
  int _clickCount = 0;
  String get messageWithClickHandler =>
      messages.messageWithClickHandler(_clickCount);
  void clicked() => _clickCount++;
}
