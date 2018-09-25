#!/usr/bin/env ruby

require 'optparse'
require 'mp3info'
require 'flacinfo'

class F2M 
  def initialize(options)
    @options = options
  end

  def convert()
    ensure_directory @options[:output_folder]
    convert_directory @options[:source_folder]
  end

  private
  def convert_file(flac_file, target_folder)
    mp3_file = target_file flac_file, target_folder
    system "#{flac_command(quote(flac_file))} | #{mp3_command(quote(mp3_file))}"
    set_id3_tags(flac_file, mp3_file)
  end

  def set_id3_tags(flac_file, mp3_file)
    flac_info = FlacInfo.new(flac_file)
    mp3_info = Mp3Info.open(mp3_file) do |mp3|
      mp3.tag.artist = to_ascii flac_info.tags['ARTIST']
      mp3.tag.album = to_ascii flac_info.tags['ALBUM']
      mp3.tag.title = to_ascii flac_info.tags['TITLE']
      mp3.tag.tracknum = Integer(flac_info.tags['TRACKNUMBER'])
      mp3.tag.year = Integer(flac_info.tags['DATE'])
    end
  end

  def to_ascii(text)
    text.encode('ASCII', invalid: :replace, undef: :replace, replace: "_")
  end

  def convert_directory(path, current_dir = '')
    unless File.exist? path
      puts "Path #{path} does not exist."
      return
    end

    if File.directory?(path)
      directory = File.join(current_dir, File.basename(path))
      ensure_directory File.join(@options[:output_folder], directory)
      Dir.foreach(path) do |entry|
        convert_directory(File.join(path, entry), directory) if no_navigation_entry? entry
      end
    else
      convert_file path, File.join(@options[:output_folder], current_dir) if File.extname(path).downcase == '.flac'
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
    "lame --preset #{@options[:lame_preset]} - #{mp3_file}"
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

ARGV << '-h' if ARGV.empty?

options = {
  :output_folder => "converted",
  :lame_preset => "standard"
}

OptionParser.new do |opts|
  opts.banner = "Usage: f2m.rb [options] <source folder>"
  opts.on("-o", "--output [FOLDER]", String,  "Output folder. Default is 'converted'") do |o|
    options[:output_folder] = o
  end
  opts.on("-p", "--preset [LAME_PRESET]", String, "Preset that should be used for lame encoding. Default is standard.") do |pr|
    options[:lame_preset] = pr
  end
end.parse!

options[:source_folder] = ARGV[0]
instance = F2M.new(options)
instance.convert()
