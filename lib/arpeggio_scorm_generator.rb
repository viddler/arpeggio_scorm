require "arpeggio_scorm_generator/version"
require "zip"

module ArpeggioScormGenerator
  class Generator
    def initialize(options, output_file)
      @output_file = output_file.path
    end

    def generate
      @input_dir = File.dirname(__FILE__) + '/../template'
      entries = Dir.entries(@input_dir) - %w(. ..)

      ::Zip::File.open(@output_file, ::Zip::File::CREATE) do |io|
        write_entries entries, '', io
      end
    end

    private

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
      io.mkdir zip_file_path
      subdir = Dir.entries(disk_file_path) - %w(. ..)
      write_entries subdir, zip_file_path, io
    end

    def put_into_archive(disk_file_path, io, zip_file_path)
      name = 'arpeggio_scorm_package/' + disk_file_path.gsub(/.*\/template\//, '')
      io.add(name, disk_file_path)
    end
  end
end
