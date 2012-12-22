### 2012-12-14

- rails asset pipeline gem: github.com/rubyjs/rubyjs-rails thanks to github.com/PikachuEXE
- Block.supportMultipleArgs

### 2012-12-13

- Add Block classes to handle different block arities

### 2012-12-10

- Created npm module

# 0.7.2 bugfix release for Enumerable

### 2012-12-05

- Bugfix: Enumerable#min, #max do not return wrapped value.
- Improvements for Enumerable#min_by, #max_by, #min, #max
- Bugfix: Make Enumerable#sort throw ArgumentError for mixed elements.

### 2012-12-04

- Array cleanup, replacing R([]) with new R.Array([]) (optimization)

### 2012-12-03. 0.7.1

- new R.Array() accepts recursive flag
- Perf: less argument splatting in new R.Enumerator() and #to_enum
- Bug: String#upto includes last element when not passing a block.
- R.pollute_global() adds convenience methods to global namespace: puts, proc, truthy, falsey, inspect