# frozen_string_literal: true

require_relative "lib/polynomal/version"

Gem::Specification.new do |spec|
  spec.name = "polynomal-rails"
  spec.version = Polynomal::VERSION
  spec.authors = ["jlholm"]
  spec.email = ["jlholmz@gmail.com"]

  spec.summary = ""
  spec.description = ""
  spec.homepage = "https://polynomal.com"
  spec.license = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.4.0")

  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://www.github.com/jlholm/polynomal-rails"
  spec.metadata["changelog_uri"] = "https://www.github.com/jlholm/polynomal-rails/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "standard"
  spec.add_development_dependency "appraisal"
  spec.add_development_dependency "pry"
end
