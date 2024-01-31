{ channels, ... }:

self: super: {
  lutris-unwrapped = super.lutris-unwrapped.overrideAttrs (old : {
    # src = super.fetchFromGitHub {
    #   owner = "lutris";
    #   repo = "lutris";
    #   rev = "566764b547039dcae69c899c1a9dae3dc7e8e13d";
    #   hash = "sha256-Y9+Aw1OTzv9HkIjEP2MUZ7gkZgrYgKM0xeFMRVR50wY=";
    # };

    patches = old.patches ++ [
      (super.fetchpatch {
        url = "https://github.com/lutris/lutris/commit/566764b547039dcae69c899c1a9dae3dc7e8e13d.patch";
        hash = "sha256-s50q9vclUq9KGtpMSUUSRTI9AsbpF2n0MHDawq1n2WI=";
      })
    ];
  });
}