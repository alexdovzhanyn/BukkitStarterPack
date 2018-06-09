require 'pry'

class StarterPack
  include Helper

  @@serverBaseDir = "./server"
  @@available_plugins = Config::AVAILABLE_PLUGINS
  @@server_properties = Config::SERVER_PROPERTIES

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
    puts "\nDone. Happy crafting! \n\n"
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

    survey_for_plugins unless falsey_answer? choose_plugins
  end

  def survey_for_plugins
    headerize "Plugin Setup. Choose which plugins you'd like to use."
    desired_plugins = @@available_plugins.map { |plugin|
      print "#{plugin[:name]} (#{plugin[:url]}) [Yn]: "
      answer = gets.chomp

      plugin unless falsey_answer? answer
    }.compact

    desired_plugins.each{ |plugin| fetch_plugin(plugin) }
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
    print "Downloading the latest craftbukkit (Please be patient, this may take a while)... "
    @download_manager.download('https://cdn.getbukkit.org/craftbukkit/craftbukkit-1.12.2.jar', 'craftbukkit.jar')
    puts "Done!"
  end

  def fetch_plugin(plugin)
    print "Fetching #{plugin[:name]}... "
    @download_manager.download(plugin[:download_url], "plugins/#{plugin[:name].to_titlecase}.jar")
    puts "Done!"
  end

  def create_empty_json(name)
    File.open("#{@@serverBaseDir}/#{name}", 'w+') { |file| file.write('[]') }
  end

  def humanize_property(property)
    property.gsub('-', ' ').split(/ |\_|\-/).map(&:capitalize).join(" ")
  end
end
