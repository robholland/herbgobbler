class GobbleAll
  include GobbleShare
  
  def initialize( rails_root, options )
    @rails_root = rails_root
    @options = options
  end

  def execute
    puts "Processing all of: #{@rails_root}"
    puts ""
    
    locale_file_name = "en.yml"
    
    rails_view_directory = "#{@rails_root}/app/views"
    full_yml_file_path = "#{@rails_root}/config/locales/#{locale_file_name}"
    
    rails_translation_store = RailsTranslationStore.new
    text_extractor = RailsTextExtractor.new( rails_translation_store )
    
    Dir["#{rails_view_directory}/**/*html.erb" ].each do |full_erb_file_path|
      
      erb_file = full_erb_file_path.gsub( @rails_root, '' )
      rails_translation_store.start_new_context( convert_path_to_key_path( erb_file.to_s ) )
      erb_file = ErbFile.load( full_erb_file_path )
      erb_file.extract_text( text_extractor )

      File.open(full_erb_file_path, 'w') {|f| f.write(erb_file.to_s) }
      puts "Wrote #{full_erb_file_path}"
    end

    File.open(full_yml_file_path, 'w') {|f| f.write(rails_translation_store.serialize) }
    puts "Wrote #{full_yml_file_path}"
  end
  
  def valid?
    @options.empty?
  end
  
end
