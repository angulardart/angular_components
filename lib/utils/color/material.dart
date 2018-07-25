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
// https://material.io/guidelines/style/color.html#color-usability
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

// Link colors.
const linkDefault = blue700;
const linkVisited = deepPurple500;
const linkActive = red700;
