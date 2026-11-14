import 'package:flex_color_scheme/flex_color_scheme.dart';

String getSchemeName(FlexScheme scheme) {
  switch (scheme) {
    // Modern Tech & Cyber
    case FlexScheme.ebonyClay:
      return 'Ebony Cyber';
    case FlexScheme.outerSpace:
      return 'Outer Space';
    case FlexScheme.deepBlue:
      return 'Deep Tech Blue';
    case FlexScheme.blumineBlue:
      return 'Blumine Blue';
    case FlexScheme.shark:
      return 'Slate & Charcoal';
    case FlexScheme.aquaBlue:
      return 'Ocean Aqua';

    // Reds, Pinks & Purples
    case FlexScheme.barossa:
      return 'Barossa Wine';
    case FlexScheme.mandyRed:
      return 'Mandy Coral';
    case FlexScheme.redWine:
      return 'Burgundy Red';
    case FlexScheme.sakura:
      return 'Sakura Pink';
    case FlexScheme.indigo:
      return 'Modern Indigo';
    case FlexScheme.deepPurple:
      return 'Deep Purple';
    case FlexScheme.purpleM3:
      return 'Royal Purple';

    // Greens & Teals
    case FlexScheme.wasabi:
      return 'Wasabi Sage';
    case FlexScheme.jungle:
      return 'Jungle Green';
    case FlexScheme.green:
      return 'Forest Green';
    case FlexScheme.money:
      return 'Money Mint';
    case FlexScheme.shadGreen:
      return 'Shad Green';

    // Warm Earthy & Sunsets
    case FlexScheme.mango:
      return 'Mango Sunset';
    case FlexScheme.amber:
      return 'Amber Gold';
    case FlexScheme.espresso:
      return 'Espresso Mocha';
    case FlexScheme.damask:
      return 'Copper Terracotta';

    // Standards
    case FlexScheme.greyLaw:
      return 'Slate Grey';
    case FlexScheme.material:
    default:
      return 'Standard Material';
  }
}
