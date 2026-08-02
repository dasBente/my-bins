{
  perSystem = {pkgs, ...}: {
    packages.tmux-sessionizer = pkgs.writeShellApplication {
      name = "tmux-sessionizer";
      runtimeInputs = with pkgs; [fzf tmux procps findutils];
      text = builtins.readFile ./tmux-sessionizer.sh;
    };
  };
}
