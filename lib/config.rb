module Config

  SERVER_PROPERTIES = [
    { name: 'spawn-protection', type: 'number', default: 16 },
    { name: 'max-tick-time', type: 'number', default: 60000 },
    { name: 'generator-settings', type: '', default: ''},
    { name: 'force-gamemode', type: 'boolean', default: false },
    { name: 'allow-nether', type: 'boolean', default: true },
    { name: 'gamemode', type: 'number', default: 0 },
    { name: 'broadcast-console-to-ops', type: 'boolean', default: true },
    { name: 'enable-query', type: 'boolean', default: false },
    { name: 'player-idle-timeout', type: 'number', default: 0 },
    { name: 'difficulty', type: 'number', default: 1 },
    { name: 'spawn-monsters', type: 'boolean', default: true },
    { name: 'op-permission-level', type: 'number', default: 4},
    { name: 'pvp', type: 'boolean', default: true },
    { name: 'snooper-enabled', type: 'boolean', default: true },
    { name: 'level-type', type: 'string', default: 'DEFAULT' },
    { name: 'hardcore', type: 'boolean', default: false },
    { name: 'enable-command-block', type: 'boolean', default: false },
    { name: 'max-players', type: 'number', default: 100 },
    { name: 'network-compression-threshold', type: 'number', default: 256 },
    { name: 'resource-pack-sha1', type: 'string', default: '' },
    { name: 'max-world-size', type: 'number', default: 29999984 },
    { name: 'server-port', type: 'number', default: 25565 },
    { name: 'server-ip', type: 'string', default: '' },
    { name: 'spawn-npcs', type: 'boolean', default: true },
    { name: 'allow-flight', type: 'boolean', default: false },
    { name: 'level-name', type: 'string', default: 'world' },
    { name: 'view-distance', type: 'number', default: 10 },
    { name: 'resource-pack', type: 'string', default: '' },
    { name: 'spawn-animals', type: 'boolean', default: true },
    { name: 'white-list', type: 'boolean', default: false },
    { name: 'generate-structures', type: 'boolean', default: true },
    { name: 'online-mode', type: 'boolean', default: true },
    { name: 'max-build-height', type: 'number', default: 256 },
    { name: 'level-seed', type: 'string', default: '' },
    { name: 'prevent-proxy-connections', type: 'boolean', default: false },
    { name: 'use-native-transport', type: 'boolean', default: true },
    { name: 'enable-rcon', type: 'boolean', default: false },
    { name: 'motd', type: 'string', default: 'A Minecraft Server (Created with BukkitStarterPack)'}
  ]

  AVAILABLE_PLUGINS = [
    {
      name: 'mcMMO',
      url: 'https://www.spigotmc.org/resources/mcmmo.2445/',
      download_url: 'https://popicraft.net/jenkins/job/mcMMO/lastSuccessfulBuild/artifact/mcMMO/target/mcMMO.jar'
    },
    {
      name: 'WorldEdit',
      url: 'https://dev.bukkit.org/projects/worldedit',
      download_url: 'https://dev.bukkit.org/projects/worldedit/files/latest'
    },
    {
      name: 'WorldGuard',
      url: 'https://dev.bukkit.org/projects/worldguard' ,
      download_url: 'https://dev.bukkit.org/projects/worldguard/files/latest'
    },
    {
      name: 'Vault',
      url: 'https://dev.bukkit.org/projects/vault' ,
      download_url: 'https://dev.bukkit.org/projects/vault/files/latest'
    },
    {
      name: 'Shopchest',
      url: 'https://www.spigotmc.org/resources/shopchest.11431/' ,
      download_url: 'http://epiceric.square7.de/bukkit/ShopChest/files/ShopChest-1.12.3.jar'
    },
    {
      name: 'Essentials X',
      url: 'https://www.spigotmc.org/resources/essentialsx.9089/' ,
      download_url: 'https://ci.ender.zone/job/EssentialsX/lastSuccessfulBuild/artifact/Essentials/target/EssentialsX-2.15.0.9.jar'
    },
    {
      name: 'Essentials X Spawn',
      url: 'https://www.spigotmc.org/resources/essentialsx.9089/' ,
      download_url: 'https://ci.ender.zone/job/EssentialsX/lastSuccessfulBuild/artifact/EssentialsSpawn/target/EssentialsXSpawn-2.15.0.9.jar'
    },
    {
      name: 'Essentials Chat',
      url: 'https://www.spigotmc.org/resources/essentialsx.9089/' ,
      download_url: 'https://ci.ender.zone/job/EssentialsX/lastSuccessfulBuild/artifact/EssentialsChat/target/EssentialsXChat-2.15.0.9.jar'
    },
    {
      name: 'Multiverse Core',
      url: 'https://dev.bukkit.org/projects/multiverse-core' ,
      download_url: 'https://dev.bukkit.org/projects/multiverse-core/files/latest'
    },
    {
      name: 'Multiverse Portals',
      url: 'https://dev.bukkit.org/projects/multiverse-portals' ,
      download_url: 'https://dev.bukkit.org/projects/multiverse-portals/files/latest'
    },
    {
      name: 'Multiverse NetherPortals',
      url: 'https://dev.bukkit.org/projects/multiverse-netherportals' ,
      download_url: 'https://dev.bukkit.org/projects/multiverse-netherportals/files/latest'
    }
  ]

end
