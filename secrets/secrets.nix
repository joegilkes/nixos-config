let
  joe = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAeRKrAVjXXRat28Exr37wBWT8VgcWWvvfYAvRY286cQ";
  users = [ joe ];

  timber-hearth = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ/+CKr0kNCjFU2fguzSC0Whpzav03gO0GeBUnT+Mjxb";
  giants-deep = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBY53ytXUAbw4CBJJYfCkUQI9GykmbSCmOG1va1zccB1";
  systems = [ timber-hearth giants-deep ];
in
{
  "giants-deep-homepage.age".publicKeys = users ++ [ giants-deep ];
}