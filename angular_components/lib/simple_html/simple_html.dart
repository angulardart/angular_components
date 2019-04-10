// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async' show Stream, StreamController;
import 'dart:html'
    show Element, NodeValidator, NodeValidatorBuilder, UIEvent, UriPolicy;

import 'package:angular/angular.dart';
import 'package:logging/logging.dart' show Logger;
import 'package:quiver/check.dart';
import 'package:angular_components/utils/angular/properties/properties.dart';
import 'package:angular_components/utils/browser/dom_service/dom_service.dart'
    show DomService;
import 'package:angular_components/utils/disposer/disposer.dart' show Disposer;

/// Injection token for the URI whitelist. This whitelist defines which URIs
/// may be valid targets for links.
///
/// This is an optional dependency; if not provided, the component will use
/// [_defaultUriWhitelist] instead, which should be sufficient for most cases.
///
/// If the list bound to this token includes a URI [u], all URIs matching [u]'s
/// origin (i.e. schema, domain, and port) are permitted. If [u] includes a path
/// then only URIs within that path are permitted; in this case, the path *must*
/// end in a slash (otherwise https://dog.com/a/b would also allow
/// https://dog.com/a/bad, which is almost certainly not intended). The same
/// domain can be listed several times to whitelist multiple paths.
const simpleHtmlUriWhitelist = OpaqueToken<List<Uri>>('simpleHtmlUriWhitelist');

/// The default list of permitted URIs.
final List<Uri> _defaultUriWhitelist = List.unmodifiable(<Uri>[]);

/// The CSS selector that determines which elements can trigger the [@Output].
const _triggerSelector = 'a.trigger';

/// The following URI schemes are considered acceptable in external URLs, when
/// the attribute doNotVerifyUrlDestinations is present.
const _externalUriAllowedSchemes = {'http', 'https', 'mailto'};

/// A component that allows the inclusion of some limited HTML in a safe way.
/// This is ideal if you have internationalized messages with simple inline
/// HTML. It is generally much preferable to using `bypassSecurityTrustHtml`,
/// which disables all sanitization.
///
/// The specific subset of HTML that is permitted is:
///
/// *   `<a>` with `href` pointing to a same-origin URL or a permitted external
///       URL (see [simpleHtmlUriWhitelist]) and (optionally) `class`, `rel`, or
///       `target` attributes. If `target` is set, `rel` must also be set and
///       must contain `noopener` (see
///       https://mathiasbynens.github.io/rel-noopener/ for background).
/// *   `<span>` `<b>`, `<br>`, `<em>`, and `<i>` with (optionally) a `class`
///       attribute.
///
/// Note that any styles applied with the class attribute will need to be
/// annotated with `::ng-deep` (or equivalent mechanism) in order to actually
/// reach the content elements.
///
/// Prohibited HTML (including invalid elements, attributes, or URLs) will blank
/// the entire component and print a loud log message.
///
/// If the attribute doNotVerifyUrlDestinations is present, external URLs will
/// not be verified, except for their URI scheme. This is flag should only ever
/// be used for URLs that come from a safe source, such as internal
/// documentation.
///
/// If the `(trigger)` output is bound, anchor elements with the sentinel class
/// "trigger" will send an event to this output. The event is the original
/// Angular `$event`.
@Component(
  selector: 'simple-html',
  template: '<span></span>',
  styleUrls: ['simple_html.scss.css'],
  changeDetection: ChangeDetectionStrategy.OnPush,
)
class SimpleHtmlComponent extends _SimpleHtmlBase {
  final Element _element;

  SimpleHtmlComponent(
      DomService domService,
      this._element,
      @Optional() @Inject(simpleHtmlUriWhitelist) List<Uri> domainWhitelist,
      @Attribute('doNotVerifyUrlDestinations') String externalUrisAllowed)
      : super(
            domService,
            _inlineElementValidatorBuilder(
                domainWhitelist ?? _defaultUriWhitelist,
                attributeToBool(externalUrisAllowed)));

  @override
  Element get targetElement =>
      _element.children.isEmpty ? null : _element.children.single;
}

@Component(
  selector: 'simple-html-block',
  template: '<div></div>',
  styleUrls: ['simple_html.scss.css'],
  changeDetection: ChangeDetectionStrategy.OnPush,
)
class SimpleHtmlBlockComponent extends _SimpleHtmlBase {
  final Element _element;

  SimpleHtmlBlockComponent(
      DomService domService,
      this._element,
      @Optional() @Inject(simpleHtmlUriWhitelist) List<Uri> domainWhitelist,
      @Attribute('doNotVerifyUrlDestinations') String externalUrisAllowed)
      : super(
            domService,
            _elementValidator(domainWhitelist ?? _defaultUriWhitelist,
                attributeToBool(externalUrisAllowed)));

  @override
  Element get targetElement =>
      _element.children.isEmpty ? null : _element.children.single;
}

/// A class implementing the core SimpleHTML behaviour of sanitizing content
/// and assigning it to the innerHTML of the host element. Only a limited
/// subset of tags are permitted: basic text formatting and links to certain URL
/// prefixes that are known to be safe.
///
/// Components providing the SimpleHTML behaviour should inherit from this.
abstract class _SimpleHtmlBase implements OnDestroy {
  static final Logger _logger = Logger('_SimpleHtmlBase');

  final DomService _domService;
  Element _cachedTargetElement;
  final _triggerStreamController =
      StreamController<UIEvent>.broadcast(sync: true);
  final _subscriptionDisposer = Disposer.multi();
  final _SimpleHtmlNodeValidator _nodeValidator;

  _SimpleHtmlBase(this._domService, NodeValidator baseValidator)
      : _nodeValidator = _SimpleHtmlNodeValidator(baseValidator);

  /// The element into which the sanitized HTML should be injected.
  ///
  /// The result of this getter may be cached so should not change over the
  /// lifetime of the component.
  ///
  /// If there is no such element (e.g. because the component has been removed
  /// from the DOM already), it will return null.
  Element get targetElement;

  @override
  void ngOnDestroy() {
    _subscriptionDisposer.dispose();
  }

  /// HTML to display in the component.
  @Input()
  set contents(String value) => _domService.scheduleWrite(() {
        // Cache the target element, if we haven't done so already.
        _cachedTargetElement ??= targetElement;

        // If there are existing listeners, dispose of them now.
        _subscriptionDisposer.dispose();

        // If there is no target element, there is nothing else to do.
        if (_cachedTargetElement == null) return;

        // Update the DOM.
        try {
          _cachedTargetElement.setInnerHtml(value, validator: _nodeValidator);
        } catch (e) {
          if (e is _UnsafeUriError) {
            _logger.shout('simple-html used untrusted URI: $e', e);
          } else if (e is _MalformedElementError) {
            _logger.shout('simple-html used malformed element: $e', e);
          } else {
            rethrow;
          }
        }

        // Register new click listeners if necessary. Do this through a
        // scheduled read to ensure the above setInnerHtml has fully resolved
        // before probing the DOM again.
        _domService.scheduleRead(() {
          // Instruct each trigger element to send its events to
          // _triggerStreamController and register that subscription for later
          // clean-up (e.g. when this component is destroyed).
          _cachedTargetElement
              .querySelectorAll(_triggerSelector)
              .map((link) => link.onClick.listen(_triggerStreamController.add))
              .forEach(_subscriptionDisposer.addStreamSubscription);
        });
      });

  /// Propagates events from internal anchor elements with the class trigger
  /// sending the original angular event.
  @Output()
  Stream<UIEvent> get trigger => _triggerStreamController.stream;
}

class _UnsafeUriError extends ArgumentError {
  _UnsafeUriError(String uri, String reason)
      : super('Unsafe URI $uri because $reason');
}

class _MalformedElementError extends ArgumentError {
  _MalformedElementError(Element element, String description)
      : super('Element $element was malformed: $description');
}

/// A [NodeValidator] which allows only a strict subset of HTML. See
/// [_SimpleHtmlBase] for full specification of what is permitted. Throws
/// [_UnsafeUriError] or [_MalformedElementError] to denote sanitization
/// failures.
class _SimpleHtmlNodeValidator implements NodeValidator {
  // Base validator that does most of the enforcement. We extend this with
  // some extra checks.
  final NodeValidator _baseValidator;

  _SimpleHtmlNodeValidator(this._baseValidator);

  @override
  bool allowsElement(Element element) {
    if (!_baseValidator.allowsElement(element)) {
      throw _MalformedElementError(element, 'prohibited element');
    }
    return true;
  }

  @override
  bool allowsAttribute(Element element, String attributeName, String value) {
    // <a> tags with target="..." are allowed only if rel="noopener" is set.
    // Spec for the rel attribute is here:
    // https://developer.mozilla.org/en-US/docs/Web/HTML/Link_types
    if (element.tagName.toLowerCase() == 'a' && attributeName == 'target') {
      if (!element.attributes.containsKey('rel')) {
        throw _MalformedElementError(element, 'did not set rel attribute');
      }
      final rel = element.attributes['rel'];
      if (!rel.split(' ').contains('noopener')) {
        throw _MalformedElementError(
            element, 'did not set link type noopener (only $rel)');
      }
    }

    if (!_baseValidator.allowsAttribute(element, attributeName, value)) {
      throw _MalformedElementError(
          element, 'prohibited attribute $attributeName with value $value');
    }

    return true;
  }
}

/// Parse and resolve the raw URI.
///
/// This function will fail with an [_UnsafeUriError] if the raw URI cannot be
/// parsed. The parsed URI is resolved against the base URI, so that relative
/// links are fully expanded.
Uri _parseAndResolveUri(String rawUri) {
  Uri uri;
  try {
    uri = Uri.parse(rawUri);
  } catch (e) {
    throw _UnsafeUriError(rawUri, 'Could not parse');
  }
  return Uri.base.resolveUri(uri);
}

/// URI policy that allows URIs that are known to be safe to link to and throws
/// [_UnsafeUriError] on all others.
class _SafeUriPolicy implements UriPolicy {
  final List<Uri> _uriWhitelist;

  _SafeUriPolicy(List<Uri> uriWhitelist)
      : _uriWhitelist = List.unmodifiable(uriWhitelist) {
    _uriWhitelist.forEach((uri) => checkArgument(
        uri.path.isEmpty || uri.path.endsWith('/'),
        message: 'Whitelisted URIs with a path must end with a slash, which '
            '$uri does not'));
  }

  @override
  bool allowsUri(String rawUri) {
    final resolvedUri = _parseAndResolveUri(rawUri);

    // Extract the origin. This can throw in certain circumstances (see
    // https://api.dartlang.org/stable/1.24.3/dart-core/Uri/origin.html), which
    // are classed as failures.
    String resolvedOrigin;
    try {
      resolvedOrigin = resolvedUri.origin;
    } catch (e) {
      throw _UnsafeUriError(rawUri, 'Resolved URI $resolvedUri had no origin');
    }

    // Determine if the URI has the same origin (schema, domain, and port) as
    // the current URI.
    final sameOriginUri = resolvedOrigin == Uri.base.origin;

    // Fail if the URI does not point to a known-safe destination.
    if (!sameOriginUri && !_isWhitelistedUri(resolvedUri)) {
      throw _UnsafeUriError(rawUri, 'Different origin and non-whitelisted URL');
    }
    return true;
  }

  bool _isWhitelistedUri(Uri candidateUri) {
    // Note that whitelistedUri.path may be empty, in which case the prefix
    // check is trivial but still correct.
    return _uriWhitelist.any((whitelistedUri) =>
        whitelistedUri.origin == candidateUri.origin &&
        candidateUri.path.startsWith(whitelistedUri.path));
  }
}

/// URI policy that allows external URIs, but not URIs that are malformed or
/// have a URI schemes that is not http, https or mailto.
class _ExternalUriAllowedPolicy implements UriPolicy {
  const _ExternalUriAllowedPolicy();

  @override
  bool allowsUri(String rawUri) {
    final resolvedUri = _parseAndResolveUri(rawUri);

    // Fail when the fully resolved URI does not have one of the pre-allowed
    // URI schemes.
    if (!_externalUriAllowedSchemes.contains(resolvedUri.scheme)) {
      throw _UnsafeUriError(
          rawUri, 'URI scheme ${resolvedUri.scheme} not allowed');
    }

    return true;
  }
}

/// Returns a new [NodeValidatorBuilder] which allows SimpleHtml-permissible
/// inline elements.
///
/// The returned object is mutable so users should be careful about sharing
/// them.
NodeValidatorBuilder _inlineElementValidatorBuilder(
    List<Uri> domainWhitelist, bool externalUrisAllowed) {
  UriPolicy policy = externalUrisAllowed
      ? _ExternalUriAllowedPolicy()
      : _SafeUriPolicy(domainWhitelist);

  return NodeValidatorBuilder()
    ..allowElement('a',
        attributes: ['class', 'href', 'rel', 'target', 'title'],
        uriPolicy: policy)
    ..allowElement('b', attributes: ['class'])
    ..allowElement('br', attributes: ['class'])
    ..allowElement('em', attributes: ['class'])
    ..allowElement('i', attributes: ['class'])
    ..allowElement('span', attributes: ['class'])
    ..allowElement('strong', attributes: ['class']);
}

/// Returns a new [NodeValidator] which allows all SimpleHtml-permissible
/// elements (both inline and block level).
NodeValidator _elementValidator(
        List<Uri> domainWhitelist, bool externalUrisAllowed) =>
    _inlineElementValidatorBuilder(domainWhitelist, externalUrisAllowed)
      ..allowElement('p', attributes: ['class'])
      ..allowElement('ul', attributes: ['class'])
      ..allowElement('li', attributes: ['class']);
