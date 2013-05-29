# This file is included at the end of the compiled javascript and
# setups the RubyJS environment

RubyJS.pollute_global()
RubyJS.pollute_more()
root.puts = _puts
