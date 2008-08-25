class FacebookUserGenerator < Rails::Generator::NamedBase
  def manifest
    recorded_session = record do |m|
      m.directory "app/models"
      m.template "user.rb", "app/models/#{file_name}.rb"
      m.directory "lib/facebooker_authentication"
      m.template "controller.rb", "lib/facebooker_authentication/controller.rb"
      m.migration_template 'migration.rb', 'db/migrate', :assigns => {
                :migration_name => "Create#{class_name.pluralize.gsub(/::/, '')}"
              }, :migration_file_name => "create_#{file_path.gsub(/\//, '_').pluralize}"
      
    end
    action = nil
    action = $0.split("/")[1]
    
    case action
    when "generate"
      puts ("-" * 70)        
      puts "Don't forget to:"
      puts " add 'include FacebookerAuthentication::Controller'"
      puts " to your ApplicationController"
      puts ""
      puts "It should be placed after your call to ensure_authenticated_to_facebook"
    end
    recorded_session
  end
  
  
end