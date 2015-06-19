namespace :cf do
  namespace :deploy do
    desc 'Pushes an app to staging on Cloud Foundry'
    task :staging do
      Evaporator::Deployer.new('config/cf-staging.yml').deploy
    end

    desc 'Pushes an app to production on Cloud Foundry'
    task :production do
      Evaporator::Deployer.new('config/cf-production.yml').deploy
    end
  end
end
