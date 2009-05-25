require 'rubygems'
require 'flickr'
require 'yaml'
require 'fileutils'

class Omafroh
  
  class Config
    
    def initialize
      config_path = File.join(File.dirname(__FILE__), "../config/config.yml")
      @config = YAML::load(File.open(config_path))['omafroh']
    end
    
    def picture_path
      FileUtils.mkdir_p(@config['picture_path'])
      @config['picture_path']
    end

    def flickr_user
      @config['flickr']['user']
    end

    def flickr_tag
      @config['flickr']['tag']
    end
    
    def flickr_api_key
      @config['flickr']['api_key']
    end
    
  end
  
  def self.load_from_flickr
    # config
    config = Config.new
    
    # connect
    flickr = Flickr.new(config.flickr_api_key)
    user = flickr.users(config.flickr_user)
    
    # delete old pictures
    FileUtils.rm(Dir.glob(config.picture_path+"*"))
    
    # load pictures
    user.tag(config.flickr_tag).each do |photo|
      File.open(config.picture_path+photo.filename, 'w') do |file|
        file.puts(photo.file)
      end
    end
  end
  
end