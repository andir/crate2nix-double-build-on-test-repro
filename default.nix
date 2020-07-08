{ pkgs ? (import <nixpkgs> { })
, callPackage ? pkgs.callPackage
, lib ? pkgs.lib
}:
let
  testOverrides = { };

  applyTestOverrides = name: drv: if builtins.hasAttr name testOverrides then testOverrides.${name} drv else drv;

  callRustWorkspace = path: attrs:
    let
      inherit (callPackage path (attrs)) workspaceMembers;
    in
    lib.mapAttrs (name: v: applyTestOverrides name (v.build.override { runTests = true; })) workspaceMembers;

in
(callRustWorkspace ./Cargo.nix { })
