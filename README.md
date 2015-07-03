# ArpeggioScorm

## Build a scorm zip
    # Create a temp file, once the generator has run, this zip file will be a scorm package for
    # a simple arpeggio embed.
    temp_file = Tempfile.new('built.zip')

    # Options to pass to the arpeggio initializer
    options = {
      width: '100%',
      videoId: 'abc123'
    }

    generator = ArpeggioScorm::Generator.new(options, temp_file)
    generator.generate
