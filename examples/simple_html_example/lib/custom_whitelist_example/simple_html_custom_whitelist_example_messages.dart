// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:intl/intl.dart' show Intl;

class SimpleHtmlCustomWhitelistExampleMessages {
  const SimpleHtmlCustomWhitelistExampleMessages();

  String _linkTo(link, endLink) =>
      Intl.message('Visit ${link}this site${link}!',
          name: 'SimpleHtmlCustomWhitelistExampleMessages_linkTo',
          desc: 'Example message containing a link to a URI.',
          args: [
            link,
            endLink,
          ],
          examples: const {
            'link': '<a href="https://example.com">',
            'endLink': '</a>',
          },
          skip: true /* Demo code only; remove this line from real usage. */);

  // If messages involve non-trivial parameter construction, it can be useful
  // to put this method in the messages class itself and keep the message
  // wrapper private. In this case, we must encode the URL before including
  // it in the HTML string.
  String linkTo(String url) =>
      _linkTo('<a href="${Uri.encodeFull(url)}">', '</a>');
}
