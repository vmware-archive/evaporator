require 'rails/railtie'
require 'evaporator/version'
require 'evaporator/deployer'

module Evaporator
  class Railtie < ::Rails::Railtie
    rake_tasks do
      load 'evaporator/tasks/deployment.rake'
    end
  end
end
