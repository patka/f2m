class F2M
  def convert(path)
    convert_directory path
  end

  private
  def convert_file(flac_file, target_folder)
    mp3_file = target_file flac_file, target_folder
    puts mp3_file
    system "#{flac_command(quote(flac_file))} | #{mp3_command(quote(mp3_file))}"
  end

  def convert_directory(path, current_dir = '.')
    unless File.exist? path
      puts "Path #{path} does not exist."
      return
    end

    if File.directory?(path)
      directory = File.join(current_dir, File.basename(path))
      ensure_directory directory
      Dir.foreach(path) do |entry|
        convert_directory(File.join(path, entry), directory) if no_navigation_entry? entry
      end
    else
      convert_file path, current_dir if File.extname(path).downcase == '.flac'
    end
  end

  def ensure_directory(directory)
    Dir.mkdir directory unless Dir.exist? directory
  end

  def no_navigation_entry?(path)
    path != '.' and path != '..'
  end

  def flac_command(flac_file)
    "flac --stdout --decode #{flac_file}"
  end

  def mp3_command(mp3_file)
    "lame --preset medium - #{mp3_file}"
  end

  def target_file(flac_file, target_folder)
    extension = File.extname(flac_file)
    file_name = File.basename(flac_file).chomp(extension) + '.mp3'
    File.join target_folder, file_name
  end

  def quote(file_name)
    '"' + file_name + '"'
  end
end

instance = F2M.new
instance.convert(ARGV[0])
