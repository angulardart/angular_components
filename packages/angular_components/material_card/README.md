# Material Card

Material Card is card styling provided by the Google material team also known as
mdc-web. This is a wrapper to allow the style to be used in AngularDart
applications. For documentation on how to use these styling please see the [mdc
documentation][docs]. Examples can be found [here][demo].

[docs]: https://github.com/material-components/material-components-web/tree/master/packages/mdc-card
[demo]: https://material-components-web.appspot.com/card.html

## Setup

The styles are provided by
`package:angular_components/css/mdc_web/card/mdc-card.scss.css`. To use
these styles in an Angular component simply add it as a `styleUrls` value in
your `Component` annotation. We suggest that the style be added before any
component specific styling so you can easily override style values as needed.

```dart
@Component(
    selector: 'my-component',
    templateUrl: 'my_component.html',
    styleUrls: [
      'package:angular_components/css/mdc_web/card/mdc-card.scss.css',
      'my_component.scss.css'])
class MyComponent {}
```

