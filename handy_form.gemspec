# -*- encoding: utf-8 -*-
require File.expand_path("../lib/handy_form/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "handy_form"
  s.version     = HandyForm::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Peter Bui"]
  s.email       = ["peter@paydrotalks.com"]
  s.homepage    = "http://github.com/paydro/handy_form"
  s.summary     = "A handy Rails 3 Form Builder"
  s.description = "Builds forms with a standard template that has labels, hints, and validations"

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "handy_form"

  s.add_development_dependency "bundler", ">= 1.0.0"
  s.add_runtime_dependency "rails", ">= 3.0"

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end
