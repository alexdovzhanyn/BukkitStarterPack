class StarterPack
  @@serverBaseDir = "./server"
  @@available_plugins = [
    { name: 'Citizens', url: '' , download_url: '' },
    { name: 'mcMMO', url: '' , download_url: '' },
    { name: 'WorldEdit', url: '' , download_url: '' },
    { name: 'WorldGuard', url: '' , download_url: '' },
    { name: 'Vault', url: '' , download_url: '' },
    { name: 'Shopchest', url: '' , download_url: '' },
    { name: 'Essentials X', url: '' , download_url: '' },
    { name: 'Essentials X Spawn', url: '' , download_url: '' },
    { name: 'Essentials Chat', url: '' , download_url: '' },
    { name: 'Multiverse Core', url: '' , download_url: '' },
    { name: 'Multiverse Portals', url: '' , download_url: '' },
    { name: 'Multiverse NetherPortals', url: '' , download_url: '' }
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
    FileUtils.mkdir_p(@@serverBaseDir)
    FileUtils.mkdir_p("#{@@serverBaseDir}/plugins")
    @download_manager = DownloadManager.new(@@serverBaseDir)
    survey_user
    create_server_file
    create_empty_json('banned-ips.json')
    create_empty_json('banned-players.json')
    create_empty_json('whitelist.json')
    create_file_from_fixture('ops.json')
    create_file_from_fixture('bukkit.yml')
    create_file_from_fixture('commands.yml')
    create_file_from_fixture('help.yml')
    create_file_from_fixture('permissions.yml')
    create_file_from_fixture('eula.txt')
    fetch_craftbukkit
    create_runfile
    puts "Done. Happy crafting!"
  end

  def survey_user
    headerize "Welcome to Bukkit Starter Pack. Let's configure your server properties."

    @desired_properties = {}
    @@server_properties.each do |property|
      print "#{humanize_property(property[:name])} (default is \"#{property[:default]}\") Press [Enter] for default: "
      answer = gets.chomp
      @desired_properties[property[:name]] = answer.length > 0 ? answer : property[:default]
    end

    puts "Server properties configured."
    print "\nWould you like to choose plugins? [Yn] "
    choose_plugins = gets.chomp

    survey_for_plugins unless choose_plugins == 'n' || choose_plugins == 'no'
  end

  def survey_for_plugins
    headerize "Plugin Setup. Choose which plugins you'd like to use."
    @@available_plugins.each do |plugin|
      print "#{plugin[:name]} (#{plugin[:url]}) [Yn]: "
      answer = gets.chomp
    end
  end

  def create_file_from_fixture(filename)
    FileUtils.cp("lib/file_fixtures/#{filename}", "#{@@serverBaseDir}")
    puts "Created #{filename}"
  end

  def create_server_file
    File.open("#{@@serverBaseDir}/server.properties", 'w+') do |serverproperties|
      @desired_properties.keys.each do |property|
        serverproperties << "#{property}=#{@desired_properties[property]}\n"
      end
    end
  end

  def create_runfile
    File.open("#{@@serverBaseDir}/bukkit_server_unix.sh", 'w+') do |runfile|
      runfile << "java -jar craftbukkit.jar"
    end
    File.open("#{@@serverBaseDir}/bukkit_server_windows.bat", 'w+') do |runfile|
      runfile << "java -jar craftbukkit-1.12.2.jar \n PAUSE"
    end
  end

  def fetch_craftbukkit
    puts "Downloading the latest craftbukkit (Please be patient, this may take a while)..."
    @download_manager.download('https://cdn.getbukkit.org/craftbukkit/craftbukkit-1.12.2.jar', 'craftbukkit.jar')
    puts "Successfully downloaded craftbukkit"
  end

  def create_empty_json(name)
    File.open("#{@@serverBaseDir}/#{name}", 'w+') { |file| file.write('[]') }
  end

  def humanize_property(property)
    property.gsub('-', ' ').split(/ |\_|\-/).map(&:capitalize).join(" ")
  end

  def headerize(text)
    puts "\n"
    text.length.times { print "=" }
    puts "\n#{text}"
    text.length.times { print "=" }
    puts "\n\n"
  end
end
