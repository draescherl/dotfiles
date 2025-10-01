def addon_mappings []: nothing -> record {
     {
        addon-elasticsearch: "postgresql_4ea97bf7-3571-453f-8385-be45f2cfcc82"
        addon-jenkins: "postgresql_76cb1af1-5c57-46bb-a6e8-0a25480b9db3"
        addon-mongodb: "postgresql_56d5008c-3204-4915-b8c0-154bd55378d6"
        addon-mysql: "postgresql_1668fbe1-0f84-4a09-a814-8d84e4840a54"
        addon-postgresql-follower: "postgresql_af353729-91ef-4432-abd6-cb85c227551b"
        addon-postgresql-leader: "postgresql_cf409865-6cc2-4f19-9cd7-6e057a656f61"
        addon-redis: "postgresql_e8e6229f-6a94-4e2c-ae63-b39503cf5676"
        backup-manager: "postgresql_56bc260d-77b8-405c-bbc9-7d6ab39a18c2"
        ccapi-follower: "postgresql_fd520155-ca81-4e4d-949e-08a699c85335"
        ccapi-leader: "postgresql_e59e3042-13b6-4bf3-a38d-f4e1ed6deded"
        supernova-follower: "postgresql_b05f93d7-3af3-4d10-ae90-e180fa703530"
        supernova-leader: "postgresql_da69be09-afda-4f54-9d02-00cc319ef544"
    }
}

def addon_names []: nothing -> list<string> {
    addon_mappings | transpose name id | get name
}

def id2psql [id: string] {
    let addon_env = clever addon env ($id) | from toml
    let uri = $addon_env | get "POSTGRESQL_ADDON_URI"
    psql $"($uri)"
}

export def ccpg [name: string@addon_names] {
    id2psql (addon_mappings | get $name)
}

