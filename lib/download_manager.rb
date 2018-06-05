class DownloadManager

  def initialize(rootDir)
    @rootDir = rootDir
  end

  def download(url, filename)
    File.open("#{@rootDir}/#{filename}", "wb+") do |file|
      open(url, "rb") do |read_file|
        file.write(read_file.read)
      end
    end
  end

end
