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

import 'dart:html';

/// Opens the given url in a new window.
///
/// Gives a hint to Chrome that it should open the given link in a separate
/// process.
void openInNewWindow(String url) {
  var anchorElement = new AnchorElement(href: url)
    ..rel = 'noreferrer'
    ..target = '_blank';
  document.body.append(anchorElement);
  anchorElement.click();
  anchorElement.remove();
}