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

import 'package:angular2/angular2.dart';

/// Annotation bound to a boolean which is used to indicate that a complete
/// web page is RTL.
///
/// This is used to only read the DOM once for an app to determine if the app
/// itself is RTL. Only use this for components whose RTL is not independant
/// of the application as a whole.
const rtlToken = const OpaqueToken('isRtl');

const rtlProvider =
    const Provider(rtlToken, useFactory: determineRtl, deps: const [Document]);

@Injectable()
bool determineRtl(Document document) => 'rtl' == document.documentElement.dir;