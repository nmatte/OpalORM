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
  end

end
