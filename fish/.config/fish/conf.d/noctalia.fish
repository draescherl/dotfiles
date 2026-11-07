# Export through a temp file: a direct redirect into the config dir truncates
# config.toml before noctalia reads it, so the export would only contain the
# GUI overrides and drop everything that lived in config.toml alone.
function noctaliasave -d "Save the live noctalia config into the dotfiles and drop the GUI overrides"
    set -l tmp (mktemp -d)
    or return 1

    noctalia config export --credentials omit >$tmp/config.toml
    or begin
        command rm -rf $tmp
        return 1
    end

    mv $tmp/config.toml ~/dotfiles/noctalia/.config/noctalia/config.toml
    command rm -f ~/.local/state/noctalia/settings.toml
    command rm -rf $tmp
end
