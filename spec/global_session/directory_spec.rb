require File.expand_path(File.join(File.dirname(__FILE__), '..' , 'spec_helper'))

describe GlobalSession::Directory do
  include SpecHelper

  before(:all) do
    @keystore = KeyFactory.new
  end

  after(:all) do
    @keystore.destroy
  end  

  after(:each) do
    @keystore.reset
    reset_mock_config
  end

  describe :initialize do
    context 'when a local authority is configured' do
      before(:each) do
        @authority_name = "authority#{rand(2**16)}"
        mock_config('test/authority', @authority_name)
      end

      context 'and keystore contains no private keys' do
        it 'should raise ConfigurationError' do
          @keystore.create(@authority_name, false)
          lambda {
            GlobalSession::Directory.new(mock_config, @keystore.dir)
          }.should raise_error(GlobalSession::ConfigurationError)
        end
      end

      context 'and keystore contains an incorrectly-named private key' do
        it 'should raise ConfigurationError' do
          @keystore.create('wrong_name', true)
          lambda {
            GlobalSession::Directory.new(mock_config, @keystore.dir)
          }.should raise_error(GlobalSession::ConfigurationError)
        end
      end

      context 'and keystore contains a correctly-named private key' do
        it 'should succeed' do
          @keystore.create(@authority_name, true)
          GlobalSession::Directory.should === GlobalSession::Directory.new(mock_config, @keystore.dir)
        end
      end
    end
  end
end