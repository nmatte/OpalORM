module OpalORM
  class Util
    def self.ensure_db_dir
      unless Dir.exist?(self.db_path)
        Dir.mkdir('db')
      end
    end

    def self.current_path
      Dir.pwd
    end

    def self.db_path
      File.join(self.current_path, 'db')
    end

    def self.config_path
      File.join(self.db_path, 'opal_config.json')
    end

    def self.get_config
      if File.exists?(Util.config_path)
        config = JSON.parse(File.read(Util.config_path))|| {}
      end
    end

    def self.make_config
      Util.ensure_db_dir

      unless File.exists?(Util.config_path)
        File.new(Util.config_path, 'w')
      end
    end

    def self.save_config(new_config)
      File.open(Util.config_path, "w+") do |f|
        f.write(new_config.to_json)
      end
    end
  end

end
