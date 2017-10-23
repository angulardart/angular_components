## Preview Release

These are the AngularDart components that Google uses to build the
sophisticated, mission-critical apps that bring in much of Google’s revenue.

This productive and stable set of widgets, contributed to by hundreds of
Googlers, make debugging and deploying your app easier. Strict latency and
testing policies make these widgets an excellent fit for AngularDart projects.

Only a small fragment of all the components is available right now. We want
developers to be able to use the package as soon as possible.

* ✓ `<material-icon>`
* ✓ `<material-button>`
* ✓ `<material-fab>`
* ✓ `<material-checkbox>`
* ✓ `<material-chip>`
* ✓ `<material-expansionpanel>`
* ✓ `<material-progress>`
* ✓ `<material-radio>`
* ✓ `<material-ripple>`
* ✓ `<material-spinner>`
* ✓ `<material-tab>`
* ✓ `<material-toggle>`
* ✓ `<material-yes-no-buttons>`
* ✓ `<reorder-list>`
* ✓ `<acx-scorecard>`
* ✓ `<material-input>`
* ✓ `<material-dialog>`
* ✓ `<material-popup>`
* ✓ `<material-tooltip>`
* ✓ `<material-list>`
* ✓ `<material-select>`
* ✓ `<material-tree>`
* ✓ `<material-auto-suggest-input>`
* ☐ `<material-date-range-picker>`
* ☐ `<material-menu>`
* many more, including a fast table

At this time we are not taking pull requests, but please
[file an issue](https://github.com/dart-lang/angular_components/issues)
and we will work with you.

**Officially supported browsers:** The last two versions of Chrome, Edge,
Firefox, and Safari.

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
The styles of these components can be customized via sass mixins.

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
imports in your sass files.

  In your `.scss` files:

  ```scss
  @import 'package:angular_components/css/material/material';

  .blue {
    color: $mat-blue;
  }
  ```

## Project Roadmap

Our current work is summarized in
[issue 142](https://github.com/dart-lang/angular_components/issues/142).
