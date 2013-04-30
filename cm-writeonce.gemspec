require File.expand_path('../lib/cm-writeonce/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Drew Gillson"]
  gem.email         = ["drew.gillson@gmail.com"]
  gem.description   = %q{Load subscribers into CampaignMonitor without overwriting the source field}
  gem.summary       = %q{Load subscribers into CampaignMonitor}
  gem.homepage      = "https://github.com/drewgillson/cm-writeonce"
  gem.license       = 'MIT'

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.name          = "cm-writeonce"
  gem.version       = CmWriteonce::VERSION
end
