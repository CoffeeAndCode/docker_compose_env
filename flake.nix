{
  description = "docker_compose_env";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-ruby.url = "github:bobvanderlinden/nixpkgs-ruby";
    nixpkgs-ruby.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixpkgs-ruby, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        name = "docker_compose_env";
        pkgs = import nixpkgs {
          inherit system;

          config.allowUnfree = true;
        };
        ruby = nixpkgs-ruby.packages.${system}."ruby-3.4.5";
        bundler = pkgs.bundler.override {
          inherit ruby;
        };
        gems = pkgs.bundlerEnv.override { inherit bundler; } {
          inherit name ruby;
          gemdir = ./.;
          extraConfigPaths = [
            "${./.}/docker_compose_env.gemspec"
            "${./.}/docker_compose_env_rails.gemspec"
            "${./.}/lib/docker_compose_env/version.rb"
          ];
        };
      in
      {
        apps = {
          bundix = {
            type = "app";
            program = "${pkgs.bundix}/bin/bundix";
          };
          bundler = {
            type = "app";
            program = "${bundler}/bin/bundler";
          };
        };
        devShell = pkgs.mkShell
          {
            inherit name;

            BUNDLE_FORCE_RUBY_PLATFORM = true;
            IRB_USE_AUTOCOMPLETE = "false";

            buildInputs = with pkgs;
              [
                cacert
                gems
                nixfmt-classic
                nodejs_22
                ruby
                (yarn.override {
                  nodejs = nodejs_22;
                })
              ];
          };
      });
}
