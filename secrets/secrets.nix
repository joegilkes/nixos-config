let
  joe = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAeRKrAVjXXRat28Exr37wBWT8VgcWWvvfYAvRY286cQ";
  users = [ joe ];

  timber-hearth = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ/+CKr0kNCjFU2fguzSC0Whpzav03gO0GeBUnT+Mjxb";
  giants-deep = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBY53ytXUAbw4CBJJYfCkUQI9GykmbSCmOG1va1zccB1";
  interloper = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC41O7R13971t8FoaVU8aTAXBcVA0oZWgRaQc86ZZuCZ";
  systems = [ timber-hearth giants-deep interloper ];
in
{
  "giants-deep-homepage.age".publicKeys = users ++ [ giants-deep ];
  "mailserver-password.age".publicKeys = users ++ [ interloper ];
  "mailserver-password-hash.age".publicKeys = users ++ [ interloper ];
}