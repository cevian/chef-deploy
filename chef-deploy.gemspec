# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{chef-deploy}
  s.version = "0.2.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ezra Zygmuntowicz"]
  s.autorequire = %q{chef-deploy}
  s.date = %q{2009-08-06}
  s.description = %q{A gem that provides...}
  s.email = %q{Your Email}
  s.extra_rdoc_files = ["README.rdoc", "LICENSE", "TODO"]
  s.files = ["LICENSE", "README.rdoc", "Rakefile", "TODO", "lib/chef-deploy.rb", "lib/chef-deploy", "lib/chef-deploy/git.rb", "lib/chef-deploy/subversion.rb", "lib/chef-deploy/cached_deploy_symfony.rb", "lib/chef-deploy/cached_deploy.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://example.com}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{A gem that provides...}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
