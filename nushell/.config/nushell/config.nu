use std/config *
use ./clevercloud.nu *

source ./catppuccin_mocha.nu

$env.config.hooks.pre_prompt = $env.config.hooks.pre_prompt? | default []
$env.config.hooks.pre_prompt ++= [{||
  if (which direnv | is-empty) {
    return
  }

  direnv export json | from json | default {} | load-env
  # If direnv changes the PATH, it will become a string and we need to re-convert it to a list
  $env.PATH = do (env-conversions).path.from_string $env.PATH
}]

$env.config.show_banner = false
$env.config.keybindings = [
    {
        name: accept_suggestion
        modifier: control
        keycode: char_v
        mode: [emacs, vi_normal, vi_insert]
        event: { send: historyhintcomplete }
    }
]

mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

