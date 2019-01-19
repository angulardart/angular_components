// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Custom dropdown item component implements this to indicate that it will
/// handle aria related tasks by itself.
///
/// If a custom widget implements this interface, then the parent
/// <material-dropdown-list-item> will no longer generate a custom id attribute
/// or set the aria role = "option".  Instead, the custom component is expected
/// to handle the following tasks by itself:
///   - set role = "option"
///   - generate a unique id for itself, using the parent's ActiveItemModel
///   - set aria-selected=true, whenever it becomes selected.
///
/// Primary use cases for implementing interface is to enable the ability to
/// do custom aria-describedby, or other such a11y related behaviors.
class HandlesAria {}
