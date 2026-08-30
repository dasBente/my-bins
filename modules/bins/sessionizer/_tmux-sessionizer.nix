{
  lib,
  writeShellApplication,
  fzf,
  tmux,
  procps,
  findutils,
  projects-dir ? "$HOME/projects",
  picker ?
    writeShellApplication {
      name = "tmux-sessionizer-picker";
      runtimeInputs = [findutils fzf];
      text = ''find "$PROJECTS_DIR" -mindepth 1 -maxdepth 1 -type d,l | fzf'';
    },
}:
writeShellApplication {
  name = "tmux-sessionizer";
  runtimeInputs = [tmux procps findutils];
  text = ''
    export PROJECTS_DIR="${projects-dir}"
    export SESSIONIZER_PICKER="${lib.getExe picker}"
    ${builtins.readFile ./tmux-sessionizer.sh}
  '';
}
