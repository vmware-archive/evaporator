require 'yaml'

module Evaporator
  class Deployer
    def initialize(config)
      @config = config
    end

    def deploy
      set_space
      check_clean_git
      check_for_differences_in_env

      get_application_names.each do |name|
        system "cf set-env #{name} GIT_SHA #{get_git_sha}"
      end

      system "cf push -f #{@config}"
    end

    private

    def get_application_names
      yml_string = File.open(config_file, 'r') { |f| f.read }
      yml = YAML.load(yml_string)
      yml['applications'].map {|app| app['name'] }
    end

    def config_file
      Rails.root.join(@config)
    end

    def get_git_sha
      `git rev-parse HEAD`
    end

    def set_space
      raise 'You must specify a space: rake SPACE=name cf:deploy:staging' if ENV['SPACE'].nil?
      system("cf target -s #{ENV['SPACE']}")
    end

    def check_clean_git
      status = `git status --porcelain`
      if status.length > 0
        raise 'Uncommitted changes detected. Please resolve before deploying your app.'
      end
    end

    def check_for_differences_in_env
      env = []
      get_application_names.each do |name|
        env << `cf env #{name} | grep UserProvided: -A  1000 | sort`
      end

      if env.uniq.length > 1
        raise 'Environment variables are different!'
      end
    end
  end
end
