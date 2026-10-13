import 'package:flex_color_scheme/flex_color_scheme.dart';

String getSchemeName(FlexScheme scheme) {
  switch (scheme) {
    case FlexScheme.green:
      return 'Forest Green';
    case FlexScheme.money:
      return 'Money Mint';
    case FlexScheme.jungle:
      return 'Jungle Green';
    case FlexScheme.amber:
      return 'Amber Gold';
    case FlexScheme.mango:
      return 'Mango Sunset';
    case FlexScheme.espresso:
      return 'Espresso Coffee';
    case FlexScheme.mandyRed:
      return 'Mandy Red';
    case FlexScheme.sakura:
      return 'Sakura Pink';
    case FlexScheme.purpleM3:
      return 'Royal Purple';
    case FlexScheme.blumineBlue:
      return 'Blumine Blue';
    case FlexScheme.shark:
      return 'Slate & Charcoal';
    case FlexScheme.material:
    default:
      return 'Standard Material';
  }
}
