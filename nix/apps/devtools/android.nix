{ config
, username
, pkgs
, ...
}:
let
  androidenv = pkgs.androidenv;
  androidSdk = (androidenv.composeAndroidPackages {
    cmdLineToolsVersion = "8.0";
    platformToolsVersion = "35.0.2";
    buildToolsVersions = [ "30.0.3" ];
    platformVersions = [ "30" ];
    includeEmulator = false;
    includeSources = false;
    includeSystemImages = false;
    includeNDK = true;
    ndkVersions = [ "22.0.7026061" ];
  }).androidsdk;
in
{
  users.users.${username}.extraGroups = [ "adbusers" ];
  environment = {
    variables = {
      ANDROID_HOME = "${androidSdk}/libexec/android-sdk";
      ANDROID_SDK_ROOT = "${androidSdk}/libexec/android-sdk";
      ANDROID_NDK_ROOT = "${androidSdk}/libexec/android-sdk/ndk/22.0.7026061";
    };
    extraInit = ''
      export PATH="${androidSdk}/libexec/android-sdk/ndk/22.0.7026061:$PATH"
      export PATH="${androidSdk}/libexec/android-sdk/platform-tools:$PATH"
      export PATH="${androidSdk}/libexec/android-sdk/cmdline-tools/latest/bin:$PATH"
      export PATH="${androidSdk}/libexec/android-sdk/build-tools/30.0.3:$PATH"
    '';
  };
}
