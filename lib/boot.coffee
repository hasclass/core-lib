# This file is included at the end of the compiled javascript and
# setups the RubyJS environment

RubyJS.pollute_global_with_shortcuts()
RubyJS.pollute_global_with_kernel()
root.puts = _puts
