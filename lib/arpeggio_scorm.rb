require "arpeggio_scorm/version"
require "zip"
require "json"

module ArpeggioScorm
  class Generator
    def initialize(options, output_file)
      @options = options
      @output_file = output_file.path
    end

    def generate
      @input_dir = File.dirname(__FILE__) + '/../template'
      entries = Dir.entries(@input_dir) - %w(. ..)

      ::Zip::File.open(@output_file, ::Zip::File::CREATE) do |io|
        write_entries entries, '', io
        write_config_json io
      end
    end

    private

    def write_config_json(io)
      io.get_output_stream('arpeggio_scorm_package/config.json') do |f|
        f.puts(JSON.pretty_generate(@options))
      end
    end

    # A helper method to make the recursion work.
    def write_entries(entries, path, io)
      entries.each do |e|
        zip_file_path = path == '' ? e : File.join(path, e)
        disk_file_path = File.join(@input_dir, zip_file_path)

        if File.directory? disk_file_path
          recursively_deflate_directory(disk_file_path, io, zip_file_path)
        else
          put_into_archive(disk_file_path, io, zip_file_path)
        end
      end
    end

    def recursively_deflate_directory(disk_file_path, io, zip_file_path)
      subdir = Dir.entries(disk_file_path) - %w(. ..)
      write_entries subdir, zip_file_path, io
    end

    def put_into_archive(disk_file_path, io, zip_file_path)
      name = 'arpeggio_scorm_package/' + disk_file_path.gsub(/.*\/template\//, '')
      io.add(name, disk_file_path)
    end
  end
end
