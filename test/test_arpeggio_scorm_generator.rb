require_relative 'test_helper'

class TestArpeggioScorm< Minitest::Test
  def setup
    options = {
      width: '100%',
      videoId: 'abc123'
    }
    @temp_file = Tempfile.new('built.zip')
    generator = ArpeggioScorm::Generator.new(options, @temp_file)
    generator.generate
  end


  def test_should_include_top_level_files
    Zip::File.open(@temp_file.path) do |zip_file|
      expected = File.read(File.dirname(__FILE__) + '/../template/xml.xsd')
      actual   = zip_file.glob('arpeggio_scorm_package/xml.xsd').first.get_input_stream.read
      assert_equal expected, actual
    end
  end

  def test_should_include_sub_folders
    Zip::File.open(@temp_file.path) do |zip_file|
      expected = File.open(File.dirname(__FILE__) + '/../template/content/util/APIWrapper.js', 'rb').read
      actual   = zip_file.glob('arpeggio_scorm_package/content/util/APIWrapper.js').first.get_input_stream.read
      assert_equal expected, actual
    end
  end

  def test_should_write_dynamically_generated_config_json
    Zip::File.open(@temp_file.path) do |zip_file|
      expected = File.open(File.dirname(__FILE__) + '/expected_config.json', 'rb').read
      actual   = zip_file.glob('arpeggio_scorm_package/config.json').first.get_input_stream.read
      assert_equal expected, actual
    end
  end
end
