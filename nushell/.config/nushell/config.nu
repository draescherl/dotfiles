use ./clevercloud.nu *
source ./catppuccin_mocha.nu

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
