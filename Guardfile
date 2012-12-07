require 'guard/guard'

# Output compiled JS classes for debugging
#
guard 'coffeescript', :output => 'tmp', :bare => true do
  watch('^lib/**/(.*)\.coffee')
end

# Creates ~/ruby.js, and spec/javascripts/ruby-full.js for jasmine
guard :shell do
  watch('^lib/**/(.*)\.coffee') { `cake build` }
end

# Compiles spec/ files
guard 'coffeescript', :output => 'spec/javascripts' do
  watch('^spec/lib/(.*)\.coffee')
end

guard 'livereload' do
  watch('^spec/javascripts/.+\.js$')
  watch('^javascripts/lib/.+\.js$')
end
