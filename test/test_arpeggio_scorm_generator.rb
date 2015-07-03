require_relative 'test_helper'

class TestArpeggioScormGenerator < Test::Unit::TestCase
  def test_generation
    options = {
      width: '100%',
      videoId: 'abc123'
    }
    temp_file = Tempfile.new('built.zip')
    generator = ArpeggioScormGenerator::Generator.new(options, temp_file)
    generator.generate


    Zip::File.open(temp_file.path) do |zip_file|
      # ensure the file has top level items included
      expected = File.read(File.dirname(__FILE__) + '/../template/xml.xsd')
      actual   = zip_file.glob('arpeggio_scorm_package/xml.xsd').first.get_input_stream.read
      assert_equal expected, actual

      # ensure sub directory files are included
      expected = File.open(File.dirname(__FILE__) + '/../template/content/util/APIWrapper.js', 'rb').read
      actual   = zip_file.glob('arpeggio_scorm_package/content/util/APIWrapper.js').first.get_input_stream.read
      assert_equal expected, actual
    end

  end
end
