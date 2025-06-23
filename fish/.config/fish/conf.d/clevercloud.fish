alias ccssh="ssh BASTION"

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

