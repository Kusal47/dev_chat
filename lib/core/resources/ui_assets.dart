class UIAssets {
  static const String imageDir = "assets/images";
  static const String gifDir = "assets/gif";
  static const String svgDir = "assets/svg";
  static const String animDir = "assets/anim";
  static const String flareDir = "assets/flares";
  static const String appLogoDir = "assets/app_logo";
  
  static const String appLogo = "${appLogoDir}/logo.png";

  static String getAppLogo(String imageName) {
    return "$appLogoDir/$imageName";
  }

  static String getImage(String imageName) {
    return "$imageDir/$imageName";
  }

  static String getSvg(String svgName) {
    return "$svgDir/$svgName";
  }
}
