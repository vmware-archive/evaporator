require 'spec_helper'
require 'evaporator/deployer'

describe Evaporator::Deployer do
  subject { Evaporator::Deployer.new('config/cf-staging.yml') }

  before do
    allow(subject).to receive(:config_file).and_return('spec/fixtures/config/cf-staging.yml')
    allow_any_instance_of(Kernel).to receive(:`).with('git rev-parse HEAD').and_return('56a688519737d832cd7805647117a830f7db11e8')
  end

  describe '#deploy_staging' do
    context 'when a space is not specified' do
      before do
        ENV['SPACE'] = nil
      end

      it 'raises an error' do
        expect{subject.deploy}.to raise_error 'You must specify a space: rake SPACE=name cf:deploy:staging'
      end
    end

    context 'when a space is specified' do
      before do
        ENV['SPACE'] = 'FancyApp'

        allow_any_instance_of(Kernel).to receive(:`).with('cf env cool-project-staging | grep UserProvided: -A  1000 | sort').and_return('')
        allow_any_instance_of(Kernel).to receive(:`).with('cf env cool-project-staging-clock | grep UserProvided: -A  1000 | sort').and_return('')
      end

      context 'when git is clean' do
        it 'deploys an app' do
          allow_any_instance_of(Kernel).to receive(:`).with('git status --porcelain').and_return('')

          expect_any_instance_of(Kernel).to receive(:system).with('cf target -s \'FancyApp\'')
          expect_any_instance_of(Kernel).to receive(:system).with('cf set-env cool-project-staging GIT_SHA 56a688519737d832cd7805647117a830f7db11e8')
          expect_any_instance_of(Kernel).to receive(:system).with('cf set-env cool-project-staging-clock GIT_SHA 56a688519737d832cd7805647117a830f7db11e8')
          expect_any_instance_of(Kernel).to receive(:system).with('cf push -f config/cf-staging.yml')
          subject.deploy
        end
      end

      context 'when git is dirty' do
        it 'raises an error' do
          allow_any_instance_of(Kernel).to receive(:system)
          expect_any_instance_of(Kernel).to receive(:`).with('git status --porcelain').and_return('A Gemfile')
          expect{subject.deploy}.to raise_error 'Uncommitted changes detected. Please resolve before deploying your app.'
        end
      end
    end
  end

  describe '#get_application_names' do
    it 'returns all application names defined in the config file' do
      names = subject.send(:get_application_names)
      expect(names).to include('cool-project-staging', 'cool-project-staging-clock')
    end
  end

  describe '#get_git_sha' do
    it 'returns the SHA of the latest commit' do
      sha = subject.send(:get_git_sha)
      expect(sha).to eq '56a688519737d832cd7805647117a830f7db11e8'
    end
  end

  describe '#check_for_differences_in_env' do
    before do
      allow(subject).to receive(:get_application_names).and_return(['Foo', 'Bar'])
    end

    context 'when there are differences' do
      before do
        allow_any_instance_of(Kernel).to receive(:`).with('cf env Foo | grep UserProvided: -A  1000 | sort').and_return('A')
        allow_any_instance_of(Kernel).to receive(:`).with('cf env Bar | grep UserProvided: -A  1000 | sort').and_return('B')
      end

      it 'raises an error' do
        expect{subject.send(:check_for_differences_in_env)}.to raise_error 'Environment variables are different!'
      end
    end

    context 'when there are no differences' do
      before do
        allow_any_instance_of(Kernel).to receive(:`).with('cf env Foo | grep UserProvided: -A  1000 | sort').and_return('A')
        allow_any_instance_of(Kernel).to receive(:`).with('cf env Bar | grep UserProvided: -A  1000 | sort').and_return('A')
      end

      it 'does not raise an error' do
        expect{subject.send(:check_for_differences_in_env)}.not_to raise_error
      end
    end
  end
end
