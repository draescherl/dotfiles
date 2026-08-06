function flushnoctalia -d "Fold noctalia's GUI overrides into the stowed config.toml, then reload"
    if not command -q noctalia
        echo "flushnoctalia: noctalia not found in PATH" >&2
        return 1
    end

    set -l config_home $HOME/.config
    test -n "$XDG_CONFIG_HOME"; and set config_home $XDG_CONFIG_HOME
    set -l state_home $HOME/.local/state
    test -n "$XDG_STATE_HOME"; and set state_home $XDG_STATE_HOME

    set -l config $config_home/noctalia/config.toml
    set -l overrides $state_home/noctalia/settings.toml

    if not test -f $config
        echo "flushnoctalia: no config at $config" >&2
        return 1
    end

    # Export to a temp file, never straight onto $config. A redirect target is
    # truncated by the shell *before* noctalia reads it, so `export > $config`
    # exports an emptied config over itself and silently resets everything to
    # built-in defaults.
    set -l tmp (mktemp)
    if not noctalia config export merged >$tmp
        echo "flushnoctalia: export failed, $config left untouched" >&2
        rm -f $tmp
        return 1
    end

    # An emptied config is valid TOML, so `validate` alone would not catch it,
    # and `test -s` would not either: a blank export is one newline, not zero
    # bytes. Insist on at least one line of actual content.
    if not grep -q '[^[:space:]]' $tmp
        echo "flushnoctalia: export produced an empty config, aborting" >&2
        rm -f $tmp
        return 1
    end

    if not noctalia config validate $tmp >/dev/null
        echo "flushnoctalia: exported config failed validation, aborting" >&2
        rm -f $tmp
        return 1
    end

    set -l before (wc -l <$config | string trim)

    if cmp -s $tmp $config
        rm -f $tmp
        # Overrides are already reflected in $config; drop them so they stop
        # shadowing it (settings.toml loads last and wins on shared keys).
        rm -f $overrides
        echo "flushnoctalia: already in sync ($before lines)"
        return 0
    end

    # A big shrink means the hand-written base was lost rather than merged.
    # Warn instead of aborting: the backup below makes it recoverable.
    set -l after (wc -l <$tmp | string trim)
    if test $after -lt (math -s0 "$before * 3 / 4")
        echo "flushnoctalia: warning, config shrank $before -> $after lines" >&2
    end

    set -l backup (mktemp)
    cp $config $backup
    mv $tmp $config
    rm -f $overrides
    noctalia msg config-reload >/dev/null 2>&1

    echo "flushnoctalia: $before -> "(wc -l <$config | string trim)" lines"
    echo "flushnoctalia: backup at $backup"
end
