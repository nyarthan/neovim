inputs: let
  overlaySet = {};
  extra = [
    # inputs.neovim-nightly-overlay.overlays.default
    (self: super: {
    	# fff-nvim = inputs.fff-nvim.packages.${self.system}.fff-nvim;
    })
  ];
in builtins.attrValues (builtins.mapAttrs (name: value: (value name inputs)) overlaySet) ++ extra
