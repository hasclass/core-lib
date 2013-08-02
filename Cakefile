fs     = require 'fs'
{exec} = require 'child_process'

coreFiles = [
  'core/base_private'
  'core/aliases'
  'core/block'
  'core/breaker'
  'core/kernel'
  'core/base_public'
  'core/errors'
  'core/coerce'
]

baseFiles = [
  'base/err'
  'base/num'
  'base/itr'
  'base/arr'
  'base/str'
  'base/rgx'
  'base/hsh'
  'base/time'
  'base/chain'
]

ooFiles = [
  'oo/object'
  'oo/coerce'
  'oo/comparable'

  'oo/enumerable'
  'oo/enumerator'

  'oo/array'
  'oo/hash'
  'oo/range'

  'oo/match_data'
  'oo/string'
  'oo/regexp'

  'oo/numeric'
  'oo/integer'
  'oo/fixnum'
  'oo/float'

  'oo/time'
]

baseFiles = ['ruby'].concat(coreFiles).concat(baseFiles);
appFiles = baseFiles.concat(ooFiles).concat(['boot']);

task 'stats', '', ->
  require './lib/rubyjs'
  klasses = R [
    RubyJS.String
    RubyJS.Regexp
    RubyJS.MatchData
    RubyJS.Numeric
    RubyJS.Integer
    RubyJS.Fixnum
    RubyJS.Float
    RubyJS.Enumerable
    RubyJS.Array
    RubyJS.Range
  ]
  klasses.each (klass) ->
    console.log klass.name+": "
    console.log ("#"+el for el, fn of klass.prototype).join(", ")
    console.log "\n"

task 'build_tests', 'Builds all spec files', ->
  console.log("##################################")
  console.log("If you get the error: pipe(): Too many open files, see following page:")
  console.log("https://github.com/jashkenas/coffee-script/issues/1537")
  console.log("For Mac OS X users the following comment helps:")
  console.log("https://github.com/joyent/node/issues/2479#issuecomment-7082186")
  console.log("##################################")

  exec 'coffee -bo spec/javascripts/lib lib', defaultExecHandler
  exec 'coffee -o spec/javascripts spec/lib', defaultExecHandler



task 'build', 'Build single application file from source files', ->
  appContents = new Array(remaining = appFiles.length)
  for file, index in appFiles then do (file, index) ->
    fs.readFile "lib/#{file}.coffee", 'utf8', (err, fileContents) ->
      throw err if err
      appContents[index] = fileContents
      process() if --remaining is 0

  # Compiles to ~/ and copies to spec/javascripts
  process = ->
    fs.writeFile 'ruby.coffee', appContents.join('\n\n'), 'utf8', (err) ->
      # exec 'cp ruby.coffee spec/lib/ruby.coffee', defaultExecHandler
      throw err if err
      exec 'coffee --compile ruby.coffee', (err, stdout, stderr) ->
        throw err if err
        console.log stdout + stderr
        exec 'cp ruby.js spec/javascripts/ruby.js', defaultExecHandler


task 'minify', 'Minify and gzip the resulting application file after build', ->
  exec 'uglifyjs "ruby.js" > ruby.min.js && cp ruby.min.js spec/javascripts/lib && (if [ -d ../rubyjs.org ]; then cp ruby.min.js ../rubyjs.org/; fi)', (err, stdout, stderr) ->
    throw err if err
    console.log stdout + stderr
    exec "gzip -c 'ruby.min.js' > 'ruby.min.js.gz'", defaultExecHandler


defaultExecHandler = (err, stdout, stderr) ->
  throw err if err
  console.log stdout + stderr
