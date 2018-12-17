// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:intl/intl.dart' show Intl;

class SimpleHtmlExampleMessages {
  const SimpleHtmlExampleMessages();

  String messageWithFormatting(
          [bold = '<b>',
          endBold = '</b>',
          highlight = '<span class="highlight">',
          endHighlight = '</span>']) =>
      Intl.message(
          'I ${bold}love${endBold} using ${highlight}HTML${endHighlight}.',
          name: 'SimpleHtmlExampleMessages_messageWithFormatting',
          desc: 'Example message describing using of HTML.',
          args: [
            bold,
            endBold,
            highlight,
            endHighlight,
          ],
          examples: const {
            'bold': '<b>',
            'endBold': '</b>',
            'highlight': '<span>',
            'endHighlight': '</span>',
          },
          skip: true /* Demo code only; remove this line from real usage. */);

  String messageWithLink(
          [link = '<a href="localpage.html?param=1#test_fragment">',
          endLink = '</a>']) =>
      Intl.message('Please consult our ${link}docs${endLink}.',
          name: 'SimpleHtmlExampleMessages_messageLink',
          desc: 'Example message containing a link to same-origin page.',
          args: [
            link,
            endLink,
          ],
          examples: const {
            'link': '<a>',
            'endLink': '</a>',
          },
          skip: true /* Demo code only; remove this line from real usage. */);

  String messageWithLinkInNewTab(
          [link =
              '<a href="localpage.html?param=1#test_fragment" target="_blank" rel="noopener">',
          endLink = '</a>']) =>
      Intl.message(
          'Alternatively, open our ${link}docs${endLink} in a new window.',
          name: 'SimpleHtmlExampleMessages_messageWithLinkInNewTab',
          desc: 'Example message containing a link to a same-origin page that '
              'opens in a new window.',
          args: [
            link,
            endLink,
          ],
          examples: const {
            'link': '<a>',
            'endLink': '</a>',
          },
          skip: true /* Demo code only; remove this line from real usage. */);

  String messageWithDisallowedLink(
          [link = '<a href="https://hecuba.org">', endLink = '</a>']) =>
      Intl.message('Please consult my ${link}suspicious website${endLink}.',
          name: 'SimpleHtmlExampleMessages_messageWithDisallowedHtml',
          desc: 'Example message containing a link to an untrusted site.',
          args: [
            link,
            endLink,
          ],
          examples: const {
            'link': '<a>',
            'endLink': '</a>',
          },
          skip: true /* Demo code only; remove from real usage. */);

  String messageWithClickHandler(int clickCount,
          [link = '<a class="trigger">', endLink = '</a>']) =>
      Intl.message('You ${link}clicked here${endLink} $clickCount times.',
          name: 'SimpleHtmlExampleMessages_messageWithClickHandler',
          desc: 'Example message containing a parameter',
          args: [clickCount, link, endLink],
          examples: const {'clickCount': '3', 'link': '<a>', 'endLink': '</a>'},
          skip: true /* Demo code only; remove this line from real usage. */);

  String blockMessage(
          [bold = '<b>',
          endBold = '</b>',
          startList = '<ul>',
          endList = '</ul>',
          startListElement = '<li>',
          endListElement = '</li>']) =>
      Intl.message(
          '''
            A list!

            ${startList}
              ${startListElement}
                Here's an ${bold}element${endBold}.
              ${endListElement}
              ${startListElement}
                And here\'s another.
              ${endListElement}
            ${endList}

            And that's the end of the list.''',
          name: 'SimpleHtmlExampleMessages_blockMessage',
          desc: 'Example message describing using of block-level HTML.',
          args: [
            bold,
            endBold,
            startList,
            endList,
            startListElement,
            endListElement,
          ],
          examples: const {
            'bold': '<b>',
            'endBold': '</b>',
            'startList': '<ul>',
            'endList': '</ul>',
            'startListElement': '<li>',
            'endListElement': '</li>',
          },
          skip: true /* Demo code only; remove this line from real usage. */);
}
