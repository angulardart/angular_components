[Material design] components for [AngularDart].

The [AngularDart Components Gallery] contains live examples and documentation.

This productive and stable set of widgets, contributed to by hundreds of
Googlers, make debugging and deploying your app easier. Strict latency and
testing policies make these widgets an excellent fit for projects using the
Angular package.

[Material design]: https://material.io/guidelines
[AngularDart]: https://github.com/angulardart/angular
[AngularDart Components Gallery]: https://angulardart.github.io/angular_components/

## Useful links

* [Material Design site](https://material.io)
* [Gitter chat room](https://gitter.im/dart-lang/angular)

## Required Fonts

Add the following font downloads to the head element of your page:

* __Roboto Font__
([example](https://github.com/angulardart/angular_components/blob/7f254c89cbbd512cc284a7e9d03bb687f9948bd9/angular_gallery/lib/builder/template/index.html.mustache#L9))

  ```html
  <link
    rel="stylesheet"
    type="text/css"
    href="https://fonts.googleapis.com/css?family=Roboto:300,400,500,700">
  ```

* __Material Icon Font__
([example](https://github.com/angulardart/angular_components/blob/7f254c89cbbd512cc284a7e9d03bb687f9948bd9/angular_gallery/lib/builder/template/index.html.mustache#L11))

  ```html
  <link
    rel="stylesheet"
    type="text/css"
    href="https://fonts.googleapis.com/icon?family=Material+Icons">
  ```

## Custom component styles

The styles of these components can be customized in your project with a
component's provided [Sass mixins](https://sass-lang.com/guide#topic-6).

1. Add a dev dependency on the
[sass_builder](https://pub.dev/packages/sass_builder) package to your
`pubspec.yaml`:

  ```yaml
  dev_dependencies:
    sass_builder: ^2.0.0 # update for the latest version
  ```

2. Now you can import styles and mixins from this package via dart style package
imports in your Sass files.

  In your `.scss` files:

  ```scss
  @import 'package:angular_components/css/material/material';

  .blue {
    color: $mat-blue;
  }
  ```
