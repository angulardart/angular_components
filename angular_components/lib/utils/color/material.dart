// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'color.dart';

// Dart alternative to CSS' transparent keyword.
const transparent = Color.rgba(0, 0, 0, 0);

// TODO(google) Investigate generating this, or the scss file, from the other.
// Note that yellow and googleYellow in the scss file are here named
// vaniallaYellow and yellow, respectively, for consistency with the other
// Google colors and with previous Dart color constants.

const black = Color.rgb(0, 0, 0);
const white = Color.rgb(255, 255, 255);

// Opacities to be used on a light background
const opacityStrong = 0.87; // Standard opacity unless otherwise listed.
const opacityLight = 0.54;
const opacityLighter = 0.38;
const opacityLightest = 0.26;

// Opacities to be used on a dark background
const darkOpacityStrong = 1;
const darkOpacityLight = 0.7;
const darkOpacityLighter = 0.5;
const darkOpacityLightest = 0.3;

const rippleOpacity = 0.16;
const dividerOpacity = 0.12;

/// SemiTransparent black/white text as used in most material specs.
const transparentBlack = Color.rgba(0, 0, 0, opacityStrong);
const transparentWhite = Color.rgba(255, 255, 255, darkOpacityStrong);
const lightTransparentBlack = Color.rgba(0, 0, 0, opacityLight);
const lightTransparentWhite = Color.rgba(255, 255, 255, darkOpacityLight);
const lighterTransparentBlack = Color.rgba(0, 0, 0, opacityLighter);
const lighterTransparentWhite = Color.rgba(255, 255, 255, darkOpacityLighter);
const lightestTransparentBlack = Color.rgba(0, 0, 0, opacityLightest);
const lightestTransparentWhite = Color.rgba(255, 255, 255, darkOpacityLightest);

/// Light and dark colors for `borderColor`.
const borderLight = Color.rgba(0, 0, 0, dividerOpacity);
const borderDark = Color.rgba(255, 255, 255, dividerOpacity);
const borderDottedLight = lightestTransparentBlack;

// Text colors.
// https://material.io/design/color
const textPrimary = transparentBlack;
const textSecondary = lightTransparentBlack;
const textHint = lighterTransparentBlack;
const textDisabled = lighterTransparentBlack;
const textDivider = borderLight;

const textDarkPrimary = transparentWhite;
const textDarkSecondary = lightTransparentWhite;
const textDarkHint = lighterTransparentWhite;
const textDarkDisabled = lighterTransparentWhite;
const textDarkDivider = borderDark;

// Icon colors.
// https://material.io/guidelines/style/icons.html
const iconFocused = transparentBlack;
const icon = lightTransparentBlack;
const iconInactive = lighterTransparentBlack;

const iconDarkFocused = transparentWhite;
const iconDark = lightTransparentWhite;
const iconDarkInactive = lighterTransparentWhite;

/// Common colors for scrollbars.
const scrollbarThumb = lightestTransparentBlack;
const scrollbarBackground = Color.rgba(0, 0, 0, 0);
const scrollbarBackgroundHover = Color.rgba(0, 0, 0, 0.12);

/// Google Red
const red50 = Color.rgb(251, 233, 231);
const red100 = Color.rgb(244, 199, 195);
const red200 = Color.rgb(237, 162, 155);
const red300 = Color.rgb(230, 124, 115);
const red400 = Color.rgb(224, 96, 85);
const red500 = Color.rgb(219, 68, 55);
const red600 = Color.rgb(210, 63, 49);
const red700 = Color.rgb(197, 57, 41);
const red800 = Color.rgb(185, 50, 33);
const red900 = Color.rgb(165, 39, 20);

const redA100 = Color.rgb(255, 138, 128);
const redA200 = Color.rgb(255, 82, 82);
const redA400 = Color.rgb(255, 23, 68);
const redA700 = Color.rgb(213, 0, 0);
const red = red500;

const reds = {
  'mat-red-50': red50,
  'mat-red-100': red100,
  'mat-red-200': red200,
  'mat-red-300': red300,
  'mat-red-400': red400,
  'mat-red-500': red500,
  'mat-red-600': red600,
  'mat-red-700': red700,
  'mat-red-800': red800,
  'mat-red-900': red900,
  'mat-red-A100': redA100,
  'mat-red-A200': redA200,
  'mat-red-A400': redA400,
  'mat-red-A700': redA700,
};

/// Pinks
const pink50 = Color.rgb(252, 228, 236);
const pink100 = Color.rgb(248, 187, 208);
const pink200 = Color.rgb(244, 143, 177);
const pink300 = Color.rgb(240, 98, 146);
const pink400 = Color.rgb(236, 64, 122);
const pink500 = Color.rgb(233, 30, 99);
const pink600 = Color.rgb(216, 27, 96);
const pink700 = Color.rgb(194, 24, 91);
const pink800 = Color.rgb(173, 20, 87);
const pink900 = Color.rgb(136, 14, 79);

const pinkA100 = Color.rgb(255, 128, 171);
const pinkA200 = Color.rgb(255, 64, 129);
const pinkA400 = Color.rgb(245, 0, 87);
const pinkA700 = Color.rgb(197, 17, 98);
const pink = pink500;

const pinks = {
  'mat-pink-50': pink50,
  'mat-pink-100': pink100,
  'mat-pink-200': pink200,
  'mat-pink-300': pink300,
  'mat-pink-400': pink400,
  'mat-pink-500': pink500,
  'mat-pink-600': pink600,
  'mat-pink-700': pink700,
  'mat-pink-800': pink800,
  'mat-pink-900': pink900,
  'mat-pink-A100': pinkA100,
  'mat-pink-A200': pinkA200,
  'mat-pink-A400': pinkA400,
  'mat-pink-A700': pinkA700,
};

/// Purples
const purple50 = Color.rgb(243, 229, 245);
const purple100 = Color.rgb(225, 190, 231);
const purple200 = Color.rgb(206, 147, 216);
const purple300 = Color.rgb(186, 104, 200);
const purple400 = Color.rgb(171, 71, 188);
const purple500 = Color.rgb(156, 39, 176);
const purple600 = Color.rgb(142, 36, 170);
const purple700 = Color.rgb(123, 31, 162);
const purple800 = Color.rgb(106, 27, 154);
const purple900 = Color.rgb(74, 20, 140);

const purpleA100 = Color.rgb(234, 128, 252);
const purpleA200 = Color.rgb(224, 64, 251);
const purpleA400 = Color.rgb(213, 0, 249);
const purpleA700 = Color.rgb(170, 0, 255);
const purple = purple500;

const purples = {
  'mat-purple-50': purple50,
  'mat-purple-100': purple100,
  'mat-purple-200': purple200,
  'mat-purple-300': purple300,
  'mat-purple-400': purple400,
  'mat-purple-500': purple500,
  'mat-purple-600': purple600,
  'mat-purple-700': purple700,
  'mat-purple-800': purple800,
  'mat-purple-900': purple900,
  'mat-purple-A100': purpleA100,
  'mat-purple-A200': purpleA200,
  'mat-purple-A400': purpleA400,
  'mat-purple-A700': purpleA700,
};

/// Deep Purples
const deepPurple50 = Color.rgb(237, 231, 246);
const deepPurple100 = Color.rgb(209, 196, 233);
const deepPurple200 = Color.rgb(179, 157, 219);
const deepPurple300 = Color.rgb(149, 117, 205);
const deepPurple400 = Color.rgb(126, 87, 194);
const deepPurple500 = Color.rgb(103, 58, 183);
const deepPurple600 = Color.rgb(94, 53, 177);
const deepPurple700 = Color.rgb(81, 45, 168);
const deepPurple800 = Color.rgb(69, 39, 160);
const deepPurple900 = Color.rgb(49, 27, 146);

const deepPurpleA100 = Color.rgb(179, 136, 255);
const deepPurpleA200 = Color.rgb(124, 77, 255);
const deepPurpleA400 = Color.rgb(101, 31, 255);
const deepPurpleA700 = Color.rgb(98, 0, 234);
const deepPurple = deepPurple500;

const deepPurples = {
  'mat-deep-purple-50': deepPurple50,
  'mat-deep-purple-100': deepPurple100,
  'mat-deep-purple-200': deepPurple200,
  'mat-deep-purple-300': deepPurple300,
  'mat-deep-purple-400': deepPurple400,
  'mat-deep-purple-500': deepPurple500,
  'mat-deep-purple-600': deepPurple600,
  'mat-deep-purple-700': deepPurple700,
  'mat-deep-purple-800': deepPurple800,
  'mat-deep-purple-900': deepPurple900,
  'mat-deep-purple-A100': deepPurpleA100,
  'mat-deep-purple-A200': deepPurpleA200,
  'mat-deep-purple-A400': deepPurpleA400,
  'mat-deep-purple-A700': deepPurpleA700,
};

/// Indigo
const indigo50 = Color.rgb(232, 234, 246);
const indigo100 = Color.rgb(197, 202, 233);
const indigo200 = Color.rgb(159, 168, 218);
const indigo300 = Color.rgb(121, 134, 203);
const indigo400 = Color.rgb(92, 107, 192);
const indigo500 = Color.rgb(63, 81, 181);
const indigo600 = Color.rgb(57, 73, 171);
const indigo700 = Color.rgb(48, 63, 159);
const indigo800 = Color.rgb(40, 53, 147);
const indigo900 = Color.rgb(26, 35, 126);

const indigoA100 = Color.rgb(140, 158, 255);
const indigoA200 = Color.rgb(83, 109, 254);
const indigoA400 = Color.rgb(61, 90, 254);
const indigoA700 = Color.rgb(48, 79, 254);
const indigo = indigo500;

const indigos = {
  'mat-indigo-50': indigo50,
  'mat-indigo-100': indigo100,
  'mat-indigo-200': indigo200,
  'mat-indigo-300': indigo300,
  'mat-indigo-400': indigo400,
  'mat-indigo-500': indigo500,
  'mat-indigo-600': indigo600,
  'mat-indigo-700': indigo700,
  'mat-indigo-800': indigo800,
  'mat-indigo-900': indigo900,
  'mat-indigo-A100': indigoA100,
  'mat-indigo-A200': indigoA200,
  'mat-indigo-A400': indigoA400,
  'mat-indigo-A700': indigoA700,
};

/// Google Blue
const blue50 = Color.rgb(232, 240, 254);
const blue100 = Color.rgb(198, 218, 252);
const blue200 = Color.rgb(161, 194, 250);
const blue300 = Color.rgb(123, 170, 247);
const blue400 = Color.rgb(94, 151, 246);
const blue500 = Color.rgb(66, 133, 244);
const blue600 = Color.rgb(59, 120, 231);
const blue700 = Color.rgb(51, 103, 214);
const blue800 = Color.rgb(42, 86, 198);
const blue900 = Color.rgb(28, 58, 169);

const blueA100 = Color.rgb(130, 177, 255);
const blueA200 = Color.rgb(68, 138, 255);
const blueA400 = Color.rgb(41, 121, 255);
const blueA700 = Color.rgb(41, 98, 255);
const blue = blue500;

const blues = {
  'mat-blue-50': blue50,
  'mat-blue-100': blue100,
  'mat-blue-200': blue200,
  'mat-blue-300': blue300,
  'mat-blue-400': blue400,
  'mat-blue-500': blue500,
  'mat-blue-600': blue600,
  'mat-blue-700': blue700,
  'mat-blue-800': blue800,
  'mat-blue-900': blue900,
  'mat-blue-A100': blueA100,
  'mat-blue-A200': blueA200,
  'mat-blue-A400': blueA400,
  'mat-blue-A700': blueA700,
};

/// Light Blues
const lightBlue50 = Color.rgb(225, 245, 254);
const lightBlue100 = Color.rgb(179, 229, 252);
const lightBlue200 = Color.rgb(129, 212, 250);
const lightBlue300 = Color.rgb(79, 195, 247);
const lightBlue400 = Color.rgb(41, 182, 246);
const lightBlue500 = Color.rgb(3, 169, 244);
const lightBlue600 = Color.rgb(3, 155, 229);
const lightBlue700 = Color.rgb(2, 136, 209);
const lightBlue800 = Color.rgb(2, 119, 189);
const lightBlue900 = Color.rgb(1, 87, 155);

const lightBlueA100 = Color.rgb(128, 216, 255);
const lightBlueA200 = Color.rgb(64, 196, 255);
const lightBlueA400 = Color.rgb(0, 176, 255);
const lightBlueA700 = Color.rgb(0, 145, 234);
const lightBlue = lightBlue500;

const lightBlues = {
  'mat-light-blue-50': lightBlue50,
  'mat-light-blue-100': lightBlue100,
  'mat-light-blue-200': lightBlue200,
  'mat-light-blue-300': lightBlue300,
  'mat-light-blue-400': lightBlue400,
  'mat-light-blue-500': lightBlue500,
  'mat-light-blue-600': lightBlue600,
  'mat-light-blue-700': lightBlue700,
  'mat-light-blue-800': lightBlue800,
  'mat-light-blue-900': lightBlue900,
  'mat-light-blue-A100': lightBlueA100,
  'mat-light-blue-A200': lightBlueA200,
  'mat-light-blue-A400': lightBlueA400,
  'mat-light-blue-A700': lightBlueA700,
};

/// Cyan
const cyan50 = Color.rgb(224, 247, 250);
const cyan100 = Color.rgb(178, 235, 242);
const cyan200 = Color.rgb(128, 222, 234);
const cyan300 = Color.rgb(77, 208, 225);
const cyan400 = Color.rgb(38, 198, 218);
const cyan500 = Color.rgb(0, 188, 212);
const cyan600 = Color.rgb(0, 172, 193);
const cyan700 = Color.rgb(0, 151, 167);
const cyan800 = Color.rgb(0, 131, 143);
const cyan900 = Color.rgb(0, 96, 100);

const cyanA100 = Color.rgb(132, 255, 255);
const cyanA200 = Color.rgb(24, 255, 255);
const cyanA400 = Color.rgb(0, 229, 255);
const cyanA700 = Color.rgb(0, 184, 212);
const cyan = cyan500;

const cyans = {
  'mat-cyan-50': cyan50,
  'mat-cyan-100': cyan100,
  'mat-cyan-200': cyan200,
  'mat-cyan-300': cyan300,
  'mat-cyan-400': cyan400,
  'mat-cyan-500': cyan500,
  'mat-cyan-600': cyan600,
  'mat-cyan-700': cyan700,
  'mat-cyan-800': cyan800,
  'mat-cyan-900': cyan900,
  'mat-cyan-A100': cyanA100,
  'mat-cyan-A200': cyanA200,
  'mat-cyan-A400': cyanA400,
  'mat-cyan-A700': cyanA700,
};

/// Teals
const teal50 = Color.rgb(224, 242, 241);
const teal100 = Color.rgb(178, 223, 219);
const teal200 = Color.rgb(128, 203, 196);
const teal300 = Color.rgb(77, 182, 172);
const teal400 = Color.rgb(38, 166, 154);
const teal500 = Color.rgb(0, 150, 136);
const teal600 = Color.rgb(0, 137, 123);
const teal700 = Color.rgb(0, 121, 107);
const teal800 = Color.rgb(0, 105, 92);
const teal900 = Color.rgb(0, 77, 64);

const tealA100 = Color.rgb(167, 255, 235);
const tealA200 = Color.rgb(100, 255, 218);
const tealA400 = Color.rgb(29, 233, 182);
const tealA700 = Color.rgb(0, 191, 165);
const teal = teal500;

const teals = {
  'mat-teal-50': teal50,
  'mat-teal-100': teal100,
  'mat-teal-200': teal200,
  'mat-teal-300': teal300,
  'mat-teal-400': teal400,
  'mat-teal-500': teal500,
  'mat-teal-600': teal600,
  'mat-teal-700': teal700,
  'mat-teal-800': teal800,
  'mat-teal-900': teal900,
  'mat-teal-A100': tealA100,
  'mat-teal-A200': tealA200,
  'mat-teal-A400': tealA400,
  'mat-teal-A700': tealA700,
};

/// Google Green
const green50 = Color.rgb(226, 243, 235);
const green100 = Color.rgb(183, 225, 205);
const green200 = Color.rgb(135, 206, 172);
const green300 = Color.rgb(87, 187, 138);
const green400 = Color.rgb(51, 172, 113);
const green500 = Color.rgb(15, 157, 88);
const green600 = Color.rgb(13, 144, 79);
const green700 = Color.rgb(11, 128, 67);
const green800 = Color.rgb(9, 113, 56);
const green900 = Color.rgb(5, 85, 36);

const greenA100 = Color.rgb(185, 246, 202);
const greenA200 = Color.rgb(105, 240, 174);
const greenA400 = Color.rgb(0, 230, 118);
const greenA700 = Color.rgb(0, 200, 83);
const green = green500;

const greens = {
  'mat-green-50': green50,
  'mat-green-100': green100,
  'mat-green-200': green200,
  'mat-green-300': green300,
  'mat-green-400': green400,
  'mat-green-500': green500,
  'mat-green-600': green600,
  'mat-green-700': green700,
  'mat-green-800': green800,
  'mat-green-900': green900,
  'mat-green-A100': greenA100,
  'mat-green-A200': greenA200,
  'mat-green-A400': greenA400,
  'mat-green-A700': greenA700,
};

/// Light Greens
const lightGreen50 = Color.rgb(241, 248, 233);
const lightGreen100 = Color.rgb(220, 237, 200);
const lightGreen200 = Color.rgb(197, 225, 165);
const lightGreen300 = Color.rgb(174, 213, 129);
const lightGreen400 = Color.rgb(156, 204, 101);
const lightGreen500 = Color.rgb(139, 195, 74);
const lightGreen600 = Color.rgb(124, 179, 66);
const lightGreen700 = Color.rgb(104, 159, 56);
const lightGreen800 = Color.rgb(85, 139, 47);
const lightGreen900 = Color.rgb(51, 105, 30);

const lightGreenA100 = Color.rgb(204, 255, 144);
const lightGreenA200 = Color.rgb(178, 255, 89);
const lightGreenA400 = Color.rgb(118, 255, 3);
const lightGreenA700 = Color.rgb(100, 221, 23);
const lightGreen = lightGreen500;

const lightGreens = {
  'mat-light-green-50': lightGreen50,
  'mat-light-green-100': lightGreen100,
  'mat-light-green-200': lightGreen200,
  'mat-light-green-300': lightGreen300,
  'mat-light-green-400': lightGreen400,
  'mat-light-green-500': lightGreen500,
  'mat-light-green-600': lightGreen600,
  'mat-light-green-700': lightGreen700,
  'mat-light-green-800': lightGreen800,
  'mat-light-green-900': lightGreen900,
  'mat-light-green-A100': lightGreenA100,
  'mat-light-green-A200': lightGreenA200,
  'mat-light-green-A400': lightGreenA400,
  'mat-light-green-A700': lightGreenA700,
};

/// Limes
const lime50 = Color.rgb(249, 251, 231);
const lime100 = Color.rgb(240, 244, 195);
const lime200 = Color.rgb(230, 238, 156);
const lime300 = Color.rgb(220, 231, 117);
const lime400 = Color.rgb(212, 225, 87);
const lime500 = Color.rgb(205, 220, 57);
const lime600 = Color.rgb(192, 202, 51);
const lime700 = Color.rgb(175, 180, 43);
const lime800 = Color.rgb(158, 157, 36);
const lime900 = Color.rgb(130, 119, 23);

const limeA100 = Color.rgb(244, 255, 129);
const limeA200 = Color.rgb(238, 255, 65);
const limeA400 = Color.rgb(198, 255, 0);
const limeA700 = Color.rgb(174, 234, 0);
const lime = lime500;

const limes = {
  'mat-lime-50': lime50,
  'mat-lime-100': lime100,
  'mat-lime-200': lime200,
  'mat-lime-300': lime300,
  'mat-lime-400': lime400,
  'mat-lime-500': lime500,
  'mat-lime-600': lime600,
  'mat-lime-700': lime700,
  'mat-lime-800': lime800,
  'mat-lime-900': lime900,
  'mat-lime-A100': limeA100,
  'mat-lime-A200': limeA200,
  'mat-lime-A400': limeA400,
  'mat-lime-A700': limeA700,
};

/// Google Yellow
const yellow50 = Color.rgb(254, 246, 224);
const yellow100 = Color.rgb(252, 232, 178);
const yellow200 = Color.rgb(250, 218, 128);
const yellow300 = Color.rgb(247, 203, 77);
const yellow400 = Color.rgb(246, 191, 38);
const yellow500 = Color.rgb(244, 180, 0);
const yellow600 = Color.rgb(242, 166, 0);
const yellow700 = Color.rgb(240, 147, 0);
const yellow800 = Color.rgb(238, 129, 0);
const yellow900 = Color.rgb(234, 97, 0);

const yellowA100 = Color.rgb(255, 222, 128);
const yellowA200 = Color.rgb(255, 205, 64);
const yellowA400 = Color.rgb(255, 188, 0);
const yellowA700 = Color.rgb(255, 158, 0);
const yellow = yellow500;

const yellows = {
  'mat-yellow-50': yellow50,
  'mat-yellow-100': yellow100,
  'mat-yellow-200': yellow200,
  'mat-yellow-300': yellow300,
  'mat-yellow-400': yellow400,
  'mat-yellow-500': yellow500,
  'mat-yellow-600': yellow600,
  'mat-yellow-700': yellow700,
  'mat-yellow-800': yellow800,
  'mat-yellow-900': yellow900,
  'mat-yellow-A100': yellowA100,
  'mat-yellow-A200': yellowA200,
  'mat-yellow-A400': yellowA400,
  'mat-yellow-A700': yellowA700,
};

/// Oranges
const orange50 = Color.rgb(255, 243, 224);
const orange100 = Color.rgb(255, 224, 178);
const orange200 = Color.rgb(255, 204, 128);
const orange300 = Color.rgb(255, 183, 77);
const orange400 = Color.rgb(255, 167, 38);
const orange500 = Color.rgb(255, 152, 0);
const orange600 = Color.rgb(251, 140, 0);
const orange700 = Color.rgb(245, 124, 0);
const orange800 = Color.rgb(239, 108, 0);
const orange900 = Color.rgb(230, 81, 0);

const orangeA100 = Color.rgb(255, 209, 128);
const orangeA200 = Color.rgb(255, 171, 64);
const orangeA400 = Color.rgb(255, 145, 0);
const orangeA700 = Color.rgb(255, 109, 0);
const orange = orange500;

const oranges = {
  'mat-orange-50': orange50,
  'mat-orange-100': orange100,
  'mat-orange-200': orange200,
  'mat-orange-300': orange300,
  'mat-orange-400': orange400,
  'mat-orange-500': orange500,
  'mat-orange-600': orange600,
  'mat-orange-700': orange700,
  'mat-orange-800': orange800,
  'mat-orange-900': orange900,
  'mat-orange-A100': orangeA100,
  'mat-orange-A200': orangeA200,
  'mat-orange-A400': orangeA400,
  'mat-orange-A700': orangeA700,
};

/// Deep Oranges
const deepOrange50 = Color.rgb(251, 233, 231);
const deepOrange100 = Color.rgb(255, 204, 188);
const deepOrange200 = Color.rgb(255, 171, 145);
const deepOrange300 = Color.rgb(255, 138, 101);
const deepOrange400 = Color.rgb(255, 112, 67);
const deepOrange500 = Color.rgb(255, 87, 34);
const deepOrange600 = Color.rgb(244, 81, 30);
const deepOrange700 = Color.rgb(230, 74, 25);
const deepOrange800 = Color.rgb(216, 67, 21);
const deepOrange900 = Color.rgb(191, 54, 12);

const deepOrangeA100 = Color.rgb(255, 158, 128);
const deepOrangeA200 = Color.rgb(255, 110, 64);
const deepOrangeA400 = Color.rgb(255, 61, 0);
const deepOrangeA700 = Color.rgb(221, 44, 0);
const deepOrange = deepOrange500;

const deepOranges = {
  'mat-deep-orange-50': deepOrange50,
  'mat-deep-orange-100': deepOrange100,
  'mat-deep-orange-200': deepOrange200,
  'mat-deep-orange-300': deepOrange300,
  'mat-deep-orange-400': deepOrange400,
  'mat-deep-orange-500': deepOrange500,
  'mat-deep-orange-600': deepOrange600,
  'mat-deep-orange-700': deepOrange700,
  'mat-deep-orange-800': deepOrange800,
  'mat-deep-orange-900': deepOrange900,
  'mat-deep-orange-A100': deepOrangeA100,
  'mat-deep-orange-A200': deepOrangeA200,
  'mat-deep-orange-A400': deepOrangeA400,
  'mat-deep-orange-A700': deepOrangeA700,
};

/// Browns
const brown50 = Color.rgb(239, 235, 233);
const brown100 = Color.rgb(215, 204, 200);
const brown200 = Color.rgb(188, 170, 164);
const brown300 = Color.rgb(161, 136, 127);
const brown400 = Color.rgb(141, 110, 99);
const brown500 = Color.rgb(121, 85, 72);
const brown600 = Color.rgb(109, 76, 65);
const brown700 = Color.rgb(93, 64, 55);
const brown800 = Color.rgb(78, 52, 46);
const brown900 = Color.rgb(62, 39, 35);
const brown = brown500;

const browns = {
  'mat-brown-50': brown50,
  'mat-brown-100': brown100,
  'mat-brown-200': brown200,
  'mat-brown-300': brown300,
  'mat-brown-400': brown400,
  'mat-brown-500': brown500,
  'mat-brown-600': brown600,
  'mat-brown-700': brown700,
  'mat-brown-800': brown800,
  'mat-brown-900': brown900,
};

/// Greys
const grey50 = Color.rgb(250, 250, 250);
const grey100 = Color.rgb(245, 245, 245);
const grey200 = Color.rgb(238, 238, 238);
const grey300 = Color.rgb(224, 224, 224);
const grey400 = Color.rgb(189, 189, 189);
const grey500 = Color.rgb(158, 158, 158);
const grey600 = Color.rgb(117, 117, 117);
const grey700 = Color.rgb(97, 97, 97);
const grey800 = Color.rgb(66, 66, 66);
const grey900 = Color.rgb(33, 33, 33);
const grey = grey500;

const greys = {
  'mat-grey-50': grey50,
  'mat-grey-100': grey100,
  'mat-grey-200': grey200,
  'mat-grey-300': grey300,
  'mat-grey-400': grey400,
  'mat-grey-500': grey500,
  'mat-grey-600': grey600,
  'mat-grey-700': grey700,
  'mat-grey-800': grey800,
  'mat-grey-900': grey900,
};

const gray50 = grey50;
const gray100 = grey100;
const gray200 = grey200;
const gray300 = grey300;
const gray400 = grey400;
const gray500 = grey500;
const gray600 = grey600;
const gray700 = grey700;
const gray800 = grey800;
const gray900 = grey900;
const gray = gray500;

/// Blue Greys
const blueGrey50 = Color.rgb(236, 239, 241);
const blueGrey100 = Color.rgb(207, 216, 220);
const blueGrey200 = Color.rgb(176, 190, 197);
const blueGrey300 = Color.rgb(144, 164, 174);
const blueGrey400 = Color.rgb(120, 144, 156);
const blueGrey500 = Color.rgb(96, 125, 139);
const blueGrey600 = Color.rgb(84, 110, 122);
const blueGrey700 = Color.rgb(69, 90, 100);
const blueGrey800 = Color.rgb(55, 71, 79);
const blueGrey900 = Color.rgb(38, 50, 56);
const blueGrey = blueGrey500;

const blueGreys = {
  'mat-blue-grey-50': blueGrey50,
  'mat-blue-grey-100': blueGrey100,
  'mat-blue-grey-200': blueGrey200,
  'mat-blue-grey-300': blueGrey300,
  'mat-blue-grey-400': blueGrey400,
  'mat-blue-grey-500': blueGrey500,
  'mat-blue-grey-600': blueGrey600,
  'mat-blue-grey-700': blueGrey700,
  'mat-blue-grey-800': blueGrey800,
  'mat-blue-grey-900': blueGrey900,
};

/// Vanilla colors listed in external facing spec

/// Reds
const vanillaRed50 = Color.rgb(253, 224, 220);
const vanillaRed100 = Color.rgb(249, 189, 187);
const vanillaRed200 = Color.rgb(246, 153, 136);
const vanillaRed300 = Color.rgb(243, 108, 96);
const vanillaRed400 = Color.rgb(232, 78, 64);
const vanillaRed500 = Color.rgb(229, 28, 35);
const vanillaRed600 = Color.rgb(221, 25, 29);
const vanillaRed700 = Color.rgb(208, 23, 22);
const vanillaRed800 = Color.rgb(196, 20, 17);
const vanillaRed900 = Color.rgb(176, 18, 10);

const vanillaRedA100 = Color.rgb(255, 121, 151);
const vanillaRedA200 = Color.rgb(255, 81, 119);
const vanillaRedA400 = Color.rgb(255, 45, 111);
const vanillaRedA700 = Color.rgb(224, 0, 50);
const vanillaRed = vanillaRed500;

/// Greens
const vanillaGreen50 = Color.rgb(208, 248, 206);
const vanillaGreen100 = Color.rgb(163, 233, 164);
const vanillaGreen200 = Color.rgb(114, 213, 114);
const vanillaGreen300 = Color.rgb(66, 189, 65);
const vanillaGreen400 = Color.rgb(43, 175, 43);
const vanillaGreen500 = Color.rgb(37, 155, 36);
const vanillaGreen600 = Color.rgb(10, 143, 8);
const vanillaGreen700 = Color.rgb(10, 126, 7);
const vanillaGreen800 = Color.rgb(5, 111, 0);
const vanillaGreen900 = Color.rgb(13, 83, 2);

const vanillaGreenA100 = Color.rgb(162, 247, 141);
const vanillaGreenA200 = Color.rgb(90, 241, 88);
const vanillaGreenA400 = Color.rgb(20, 231, 21);
const vanillaGreenA700 = Color.rgb(18, 199, 0);
const vanillaGreen = vanillaGreen500;

/// Blues
const vanillaBlue50 = Color.rgb(231, 233, 253);
const vanillaBlue100 = Color.rgb(208, 217, 255);
const vanillaBlue200 = Color.rgb(175, 191, 255);
const vanillaBlue300 = Color.rgb(145, 167, 255);
const vanillaBlue400 = Color.rgb(115, 143, 254);
const vanillaBlue500 = Color.rgb(86, 119, 252);
const vanillaBlue600 = Color.rgb(78, 108, 239);
const vanillaBlue700 = Color.rgb(69, 94, 222);
const vanillaBlue800 = Color.rgb(59, 80, 206);
const vanillaBlue900 = Color.rgb(42, 54, 177);

const vanillaBlueA100 = Color.rgb(166, 186, 255);
const vanillaBlueA200 = Color.rgb(104, 137, 255);
const vanillaBlueA400 = Color.rgb(77, 115, 255);
const vanillaBlueA700 = Color.rgb(77, 105, 255);
const vanillaBlue = vanillaBlue500;

/// Yellows
const vanillaYellow50 = Color.rgb(255, 253, 231);
const vanillaYellow100 = Color.rgb(255, 249, 196);
const vanillaYellow200 = Color.rgb(255, 245, 157);
const vanillaYellow300 = Color.rgb(255, 241, 118);
const vanillaYellow400 = Color.rgb(255, 238, 88);
const vanillaYellow500 = Color.rgb(255, 235, 59);
const vanillaYellow600 = Color.rgb(253, 216, 53);
const vanillaYellow700 = Color.rgb(251, 192, 45);
const vanillaYellow800 = Color.rgb(249, 168, 37);
const vanillaYellow900 = Color.rgb(245, 127, 23);

const vanillaYellowA100 = Color.rgb(255, 255, 141);
const vanillaYellowA200 = Color.rgb(255, 255, 0);
const vanillaYellowA400 = Color.rgb(255, 234, 0);
const vanillaYellowA700 = Color.rgb(255, 214, 0);
const vanillaYellow = vanillaYellow500;

/// Ambers
const amber50 = Color.rgb(255, 248, 225);
const amber100 = Color.rgb(255, 236, 179);
const amber200 = Color.rgb(255, 224, 130);
const amber300 = Color.rgb(255, 213, 79);
const amber400 = Color.rgb(255, 202, 40);
const amber500 = Color.rgb(255, 193, 7);
const amber600 = Color.rgb(255, 179, 0);
const amber700 = Color.rgb(255, 160, 0);
const amber800 = Color.rgb(255, 143, 0);
const amber900 = Color.rgb(255, 111, 0);

const amberA100 = Color.rgb(255, 229, 127);
const amberA200 = Color.rgb(255, 215, 64);
const amberA400 = Color.rgb(255, 196, 0);
const amberA700 = Color.rgb(255, 171, 0);
const amber = amber500;

const ambers = {
  'mat-amber-50': amber50,
  'mat-amber-100': amber100,
  'mat-amber-200': amber200,
  'mat-amber-300': amber300,
  'mat-amber-400': amber400,
  'mat-amber-500': amber500,
  'mat-amber-600': amber600,
  'mat-amber-700': amber700,
  'mat-amber-800': amber800,
  'mat-amber-900': amber900,
  'mat-amber-A100': amberA100,
  'mat-amber-A200': amberA200,
  'mat-amber-A400': amberA400,
  'mat-amber-A700': amberA700,
};

// Link colors.
const linkDefault = blue700;
const linkVisited = deepPurple500;
const linkActive = red700;

/// A list of all material colors.
final materialColors = Map<String, Color>.unmodifiable({}
  ..addAll(reds)
  ..addAll(pinks)
  ..addAll(purples)
  ..addAll(deepPurples)
  ..addAll(indigos)
  ..addAll(blues)
  ..addAll(lightBlues)
  ..addAll(cyans)
  ..addAll(teals)
  ..addAll(greens)
  ..addAll(lightGreens)
  ..addAll(limes)
  ..addAll(yellows)
  ..addAll(oranges)
  ..addAll(deepOranges)
  ..addAll(browns)
  ..addAll(greys)
  ..addAll(blueGreys)
  ..addAll(ambers));

/// Find the name of the closest Material Color given the [searchColor] color.
String closestMaterialColorName(Color searchColor) {
  var closestColorName = materialColors.keys.first;
  var minDistance = searchColor.distanceFrom(materialColors[closestColorName]);
  materialColors.forEach((String name, Color color) {
    var distance = searchColor.distanceFrom(color);
    if (distance < minDistance) {
      minDistance = distance;
      closestColorName = name;
    }
  });
  return closestColorName;
}
