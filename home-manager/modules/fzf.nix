{ config, ... }:
{
  config = {
    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
      defaultCommand = "fd --type file --follow --hidden --exclude .git --color=always";
      defaultOptions = [
        "-0"
        "--prompt= ''"
        "--inline-info"
        "--reverse --height '40%'"
        "--color fg:-1,hl:4,fg+:1,bg+:-1,hl+:4"
        "--color info:108,prompt:242,spinner:108,pointer:1,marker:168"
      ];
    };
  };
}
