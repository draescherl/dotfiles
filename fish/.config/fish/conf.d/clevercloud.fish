alias ccssh="ssh BASTION"

function exherbobackup
    set -l MACHINE_PATH "/var/lib/machines/exherbo"
    set -l BACKUP_DIR "$HOME/Documents/exherbo-backups"
    set -l TIMESTAMP (date +%Y%m%d-%H%M%S)
    set -l BACKUP_FILE "$BACKUP_DIR/exherbo-$TIMESTAMP.tar.gz"

    # Check if the machine is running
    if machinectl status exherbo &>/dev/null
        echo "Error: Machine 'exherbo' is currently running. Please stop it before backing up." >&2
        echo "You can stop it with: sudo machinectl stop exherbo" >&2
        return 1
    end

    # Check if source directory exists
    if not sudo test -d "$MACHINE_PATH"
        echo "Error: Source directory $MACHINE_PATH does not exist" >&2
        return 1
    end

    # Create backup directory if it doesn't exist
    if not test -d "$BACKUP_DIR"
        echo "Creating backup directory: $BACKUP_DIR"
        mkdir -p "$BACKUP_DIR" || return 1
    end

    # Get size for progress bar
    set -l SIZE (sudo du -sb "$MACHINE_PATH" | cut -f1)

    if test -z "$SIZE"
        echo "Error: Failed to calculate directory size" >&2
        return 1
    end

    # Create backup with progress bar
    echo "Creating backup: $BACKUP_FILE"
    if sudo tar -c -C "$MACHINE_PATH" . | pv -s "$SIZE" | gzip > "$BACKUP_FILE"
        echo "Backup completed successfully: $BACKUP_FILE"
        set -l BACKUP_SIZE (du -h "$BACKUP_FILE" | cut -f1)
        echo "Backup size: $BACKUP_SIZE"
        return 0
    else
        echo "Error: Backup failed" >&2
        return 1
    end
end

function cleverssh
    ssh -t bastion -- "source /data/bastion/.bashrc; $argv" 
end

function vmssh
    cleverssh instanceSSH $argv
end

function hvssh
    cleverssh ssh $argv
end

function idssh
    cleverssh sshToFirstAppInstances $argv
end

