namespace :radiant do
  namespace :extensions do
    namespace :fix_caching do
      
      desc "Runs the migration of the Fix Caching extension"
      task :migrate => :environment do
        require 'radiant/extension_migrator'
        if ENV["VERSION"]
          FixCachingExtension.migrator.migrate(ENV["VERSION"].to_i)
        else
          FixCachingExtension.migrator.migrate
        end
      end
      
      desc "Copies public assets of the Fix Caching to the instance public/ directory."
      task :update => :environment do
        is_svn_or_dir = proc {|path| path =~ /\.svn/ || File.directory?(path) }
        Dir[FixCachingExtension.root + "/public/**/*"].reject(&is_svn_or_dir).each do |file|
          path = file.sub(FixCachingExtension.root, '')
          directory = File.dirname(path)
          puts "Copying #{path}..."
          mkdir_p RAILS_ROOT + directory
          cp file, RAILS_ROOT + path
        end
      end  
    end
  end
end
