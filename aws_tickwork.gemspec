$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "aws_tickwork/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "aws_tickwork"
  s.version     = AwsTickwork::VERSION
  s.authors     = ["John Hinnegan"]
  s.email       = [""]
  s.homepage    = "https://github.com/softwaregravy/aws_tickwork"
  s.summary     = "Integrate Cloudwatch, SNS, and Tickwork"
  s.description = "A scheduling utility dirven by Cloudwatch Events, via SNS, to Rails using Tickwork as the scheduling utility"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", ">= 4.2", "< 7.0"
  s.add_dependency 'rest-client'
  s.add_dependency 'tickwork'
  s.add_dependency 'aws-sdk', '~> 2'

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "factory_girl_rails"
  s.add_development_dependency "webmock"
  s.add_development_dependency "awesome_print"
  s.add_development_dependency "annotate"

end
