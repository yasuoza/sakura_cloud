require 'pathname'
require 'tmpdir'

def stub_api_config_file!
  tmp_dir = Dir.mktmpdir
  ENV['HOME'] = tmp_dir.to_s
  File.open("#{tmp_dir}/.sakura_cloud.rb", 'w') do |config_file|
    config_file.write <<-RUBY
      API_KEY    = 'aaaaaaaaaaaaaaaaaaaaaaaa'
      API_SECRET = 'bbbbbbbbbbbbbbbbbbbbbbbb'
    RUBY
  end
  at_exit do
    FileUtils.remove_entry_secure(tmp_dir) if File.exist?(tmp_dir)
  end
end

