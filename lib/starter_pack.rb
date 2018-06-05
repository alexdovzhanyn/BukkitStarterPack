require 'fileutils'
require 'open-uri'

class StarterPack
  @@serverBaseDir = "./server"
  @@available_plugins = [
    'citizens',
    'lwssi',
    'map',
    'another'
  ]

  @@server_properties = [
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

  def initialize
    survey_user
    FileUtils.mkdir_p(@@serverBaseDir)
    FileUtils.mkdir_p("#{@@serverBaseDir}/plugins")
    create_eula
    create_server_file
    create_empty_json('banned-ips.json')
    create_empty_json('banned-players.json')
    create_empty_json('whitelist.json')
    create_op_file
    create_bukkit_yml
    create_help_yml
    create_permissions_yml
    fetch_craftbukkit
    puts "Done. Happy crafting!"
  end

  def survey_user
    puts "\n\n======================================================================="
    puts "Welcome to Bukkit Starter Pack. Let's configure your server properties."
    puts "=======================================================================\n\n"
    @desired_properties = {}
    @@server_properties.each do |property|
      print "#{humanize_property(property[:name])} (default is \"#{property[:default]}\") Press [Enter] for default: "
      answer = gets.chomp
      @desired_properties[property[:name]] = answer.length > 0 ? answer : property[:default]
    end
  end

  def create_op_file
    File.open("#{@@serverBaseDir}/ops.json", 'w+') do |ops|
      ops_file = <<~EOS
        [
          {
            "uuid": "1fee5c17-dbb2-47ac-a90d-f39d830d8268",
            "name": "ILoveScope",
            "level": 4,
            "bypassesPlayerLimit": false
          }
        ]
      EOS

      ops.write(ops_file)
    end
  end

  def create_bukkit_yml
    File.open("#{@@serverBaseDir}/bukkit.yml", 'w+') do |yml|
      yml.write <<~EOS
        # This is the main configuration file for Bukkit.
        # As you can see, there's actually not that much to configure without any plugins.
        # For a reference for any variable inside this file, check out the Bukkit Wiki at
        # http://wiki.bukkit.org/Bukkit.yml
        #
        # If you need help on this file, feel free to join us on irc or leave a message
        # on the forums asking for advice.
        #
        # IRC: #spigot @ irc.spi.gt
        #    (If this means nothing to you, just go to http://www.spigotmc.org/pages/irc/ )
        # Forums: http://www.spigotmc.org/
        # Bug tracker: http://www.spigotmc.org/go/bugs


        settings:
          allow-end: true
          warn-on-overload: true
          permissions-file: permissions.yml
          update-folder: update
          plugin-profiling: false
          connection-throttle: 4000
          query-plugins: true
          deprecated-verbose: default
          shutdown-message: Server closed
        spawn-limits:
          monsters: 70
          animals: 15
          water-animals: 5
          ambient: 15
        chunk-gc:
          period-in-ticks: 600
          load-threshold: 0
        ticks-per:
          animal-spawns: 400
          monster-spawns: 1
          autosave: 6000
        aliases: now-in-commands.yml
      EOS
    end
  end

  def create_commands_yml
    File.open("#{@@serverBaseDir}/commands.yml", 'w+') do |yml|
      yml.write <<~EOS
        # This is the commands configuration file for Bukkit.
        # For documentation on how to make use of this file, check out the Bukkit Wiki at
        # http://wiki.bukkit.org/Commands.yml
        #
        # If you need help on this file, feel free to join us on irc or leave a message
        # on the forums asking for advice.
        #
        # IRC: #spigot @ irc.spi.gt
        #    (If this means nothing to you, just go to http://www.spigotmc.org/pages/irc/ )
        # Forums: http://www.spigotmc.org/
        # Bug tracker: http://www.spigotmc.org/go/bugs

        command-block-overrides: []
        unrestricted-advancements: false
        aliases:
          icanhasbukkit:
          - version $1-
      EOS
    end
  end

  def create_help_yml
    File.open("#{@@serverBaseDir}/help.yml", 'w+') do |yml|
      yml.write <<~EOS
      # This is the help configuration file for Bukkit.
      #
      # By default you do not need to modify this file. Help topics for all plugin commands are automatically provided by
      # or extracted from your installed plugins. You only need to modify this file if you wish to add new help pages to
      # your server or override the help pages of existing plugin commands.
      #
      # This file is divided up into the following parts:
      # -- general-topics: lists admin defined help topics
      # -- index-topics:   lists admin defined index topics
      # -- amend-topics:   lists topic amendments to apply to existing help topics
      # -- ignore-plugins: lists any plugins that should be excluded from help
      #
      # Examples are given below. When amending command topic, the string <text> will be replaced with the existing value
      # in the help topic. Color codes can be used in topic text. The color code character is & followed by 0-F.
      # ================================================================
      #
      # Set this to true to list the individual command help topics in the master help.
      # command-topics-in-master-index: true
      #
      # Each general topic will show up as a separate topic in the help index along with all the plugin command topics.
      # general-topics:
      #     Rules:
      #         shortText: Rules of the server
      #         fullText: |
      #             &61. Be kind to your fellow players.
      #             &B2. No griefing.
      #             &D3. No swearing.
      #         permission: topics.rules
      #
      # Each index topic will show up as a separate sub-index in the help index along with all the plugin command topics.
      # To override the default help index (displayed when the user executes /help), name the index topic "Default".
      # index-topics:
      #     Ban Commands:
      #         shortText: Player banning commands
      #         preamble: Moderator - do not abuse these commands
      #         permission: op
      #         commands:
      #             - /ban
      #             - /ban-ip
      #             - /banlist
      #
      # Topic amendments are used to change the content of automatically generated plugin command topics.
      # amended-topics:
      #     /stop:
      #         shortText: Stops the server cold....in its tracks!
      #         fullText: <text> - This kills the server.
      #         permission: you.dont.have
      #
      # Any plugin in the ignored plugins list will be excluded from help. The name must match the name displayed by
      # the /plugins command. Ignore "Bukkit" to remove the standard bukkit commands from the index. Ignore "All"
      # to completely disable automatic help topic generation.
      # ignore-plugins:
      #    - PluginNameOne
      #    - PluginNameTwo
      #    - PluginNameThree
      EOS
    end
  end

  def create_server_file
    File.open("#{@@serverBaseDir}/server.properties", 'w+') do |serverproperties|
      @desired_properties.keys.each do |property|
        serverproperties << "#{property}=#{@desired_properties[property]}\n"
      end
    end
  end

  def create_permissions_yml
    File.open("#{@@serverBaseDir}/permissions.yml", 'w+') {}
  end

  def create_eula
    puts "\nCreating EULA..."
    File.open("#{@@serverBaseDir}/eula.txt", 'w+') do |eula|
      eula.puts "#By changing the setting below to TRUE you are indicating your agreement to our EULA (https://account.mojang.com/documents/minecraft_eula)."
      eula.puts "eula=false"
    end
    puts "EULA created! Don't forget to accept it by going to the eula.txt file and changing 'false' to 'true'\n\n"
  end

  def fetch_craftbukkit
    puts "Downloading the latest craftbukkit (Please be patient, this may take a while)..."
    File.open("#{@@serverBaseDir}/craftbukkit.jar", "wb+") do |craftbukkit|
      open("https://cdn.getbukkit.org/craftbukkit/craftbukkit-1.12.2.jar", "rb") do |read_file|
        craftbukkit.write(read_file.read)
      end
    end
  end

  def create_empty_json(name)
    File.open("#{@@serverBaseDir}/#{name}", 'w+') { |file| file.write('[]') }
  end

  def humanize_property(property)
    property.gsub('-', ' ').split(/ |\_|\-/).map(&:capitalize).join(" ")
  end
end
