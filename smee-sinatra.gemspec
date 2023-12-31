require_relative 'lib/smee/sinatra/version'

Gem::Specification.new do |spec|
  spec.name          = "smee-sinatra"
  spec.version       = Smee::Sinatra::VERSION
  spec.authors       = ["Jake Wilkins"]
  spec.email         = ["jakewilkins@github.com"]

  spec.summary       = %q{Automatic Smee client for Sinatra Apps.}
  spec.description   = %q{Require this gem in your Sinatra App to connect to Smee and forward requests to your App.}
  spec.homepage      = "https://github.com/jakewilkins/smee-sinatra"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/jakewilkins/smee-sinatra"
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "sinatra"
  spec.add_runtime_dependency "smee"
end
