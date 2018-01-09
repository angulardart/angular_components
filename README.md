[Material design] components for [AngularDart]. Powering some of Google's most
sophisticated and mission-critical [applications].

This productive and stable set of widgets, contributed to by hundreds of
Googlers, make debugging and deploying your app easier. Strict latency and
testing policies make these widgets an excellent fit for projects using the
Angular package.

**NOTE**: As of `angular 5.0.0-alpha+1` [`dependency_overrides`][dep_overrides]
are **required**:

```yaml
dependency_overrides:
  analyzer: ^0.31.0-alpha.1
```

This is because Angular is starting to use and support the Dart 2.0.0 SDK, which
is evolving. We expect to no longer require overrides once we are at a beta
release, but this is unlikely until sometime in early 2018.

[Material design]: https://material.io/guidelines
[AngularDart]: https://webdev.dartlang.org/angular
[applications]: https://news.dartlang.org/2016/03/the-new-adwords-ui-uses-dart-we-asked.html
[dep_overrides]: https://www.dartlang.org/tools/pub/dependencies#dependency-overrides

This is a continually growing set of widgets. See the [example gallery] and the
[documentation] for a full list. Recent additions include:

* Material Menu
* Material Auto-suggest Input
* Material Select Searchbox

[example gallery]: https://dart-lang.github.io/angular_components_example/
[documentation]: https://www.dartdocs.org/documentation/angular_components/latest/angular_components/angular_components-library.html

At this time we are not taking pull requests, but please
[file an issue](https://github.com/dart-lang/angular_components/issues)
and we will work with you.

**Officially supported browsers:** The last two versions of Chrome, Edge,
Firefox, and Safari.

## Package [build_runner] support

Version 0.9.0-alpha+3 added experimental support for users of package
build_runner. To build your project with build_runner:

1. Add two `dev_dependencies` to your packages pubspec.yaml file:
  ```
  dev_dependencies:
    build_runner: ^0.7.0
    build_web_compilers: ^0.1.1
  ```
2. Run `pub get --no-precompile` (avoids pre-compiling unused transformers).
3. Build your package:
  ```
  pub run build_runner build
  ```
  Or run a local development server:
  ```
  pub run build_runner serve
  ```
[build_runner]: https://pub.dartlang.org/packages/build_runner

## Useful links

* **[Example gallery](https://dart-lang.github.io/angular_components_example/)**
* AngularDart Components resources:
  * [About AngularDart Components](https://webdev.dartlang.org/components)
  * [Google I/O 2017 codelab](https://codelabs.developers.google.com/codelabs/your-first-angulardart-web-app)
  * [Dart Summit 2016 codelab](https://webdev.dartlang.org/codelabs/angular_components)
  * [API reference](https://webdev.dartlang.org/components/api)
* AngularDart resources:
  * [AngularDart documentation](https://webdev.dartlang.org/angular/guide)
  * [angular pub package](https://pub.dartlang.org/packages/angular)
* [Material Design site](https://material.io)

## Required Icon Font
For icons to appear, add the following icon font download to your page.
[Example](https://github.com/dart-lang/angular_components_example/blob/master/web/index.html#L13)

```html
<link
  rel="stylesheet"
  type="text/css"
  href="https://fonts.googleapis.com/icon?family=Material+Icons">
```

## Custom component styles
The styles of these components can be customized via
[Sass mixins](http://sass-lang.com/guide#topic-6).

1. Add a dependency on the
[sass_builder](https://pub.dartlang.org/packages/sass_builder) package and add
the transformer.

  In your `pubspec.yaml`:

  ```yaml
  dependencies:
    sass_builder ^1.0.1 # update for the latest version
  transformers:
  - sass_builder
  - angular
  ```

  > NOTE: Be sure you add the `sass_builder` transformer before the `angular`
  > transformer.

2. Now you can import styles and mixins from this package via dart style package
imports in your Sass files.

  In your `.scss` files:

  ```scss
  @import 'package:angular_components/css/material/material';

  .blue {
    color: $mat-blue;
  }
  ```

## Project Roadmap

Our current work is summarized in the
[roadmap for this quarter](https://github.com/dart-lang/angular_components/issues/193).
