import 'package:build/build.dart';
import 'package:sass_builder/sass_builder.dart';

Builder scssBuilder(BuilderOptions options) =>
    new SassBuilder(outputExtension: '.scss.css');
