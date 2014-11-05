# IN TEST PURPOUSES
namespace :parsed do
  desc 'Fill up db with parsed content.'
  task :populate do
    return false unless content_folder_exist?(YAMLParser::DATA_PATH)
    return false if content_folder_empty?(YAMLParser::DATA_PATH)

    YAMLParser.new().call()
    p 'Done.'
  end

  private
    def content_folder_exist?(path)
      return true if Dir.exists?(path)
      p 'Content folder does not exists.'
      return false
    end

    def content_folder_empty?(path)
      return false if Dir[path + '/*'].empty?
      p 'Content folder is empty.'
      return true
    end
end
