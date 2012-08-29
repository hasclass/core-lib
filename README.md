#### State of this project:

This project is pre-alpha (whatever that means). Implemented are roughly 80% of the methods from Array, Enumerable, String, Range, Numeric, Float, Integer. Check the current progress in progress.txt. Most big issues have been solved and I am finishing the remaining methods, trying to find the right tradeoffs and smart ways to package things together.

## RubyJS

A port of the Ruby 1.9.3 corelib to coffeescript/javascript/node that conforms to rubyspec.org and does not pollute the global javascript namespace. It is not an attempt to port or mimic the ruby object model and metaprogramming capabilities, whatsoever.

Why? Coffeescript made it easy to switch from ruby/python. Unfortunately I quickly missed the functionality of the ruby corelib (the very core part of it, String, Array, Numeric, etc.).

In numbers (as of 2012-07-25): 230 methods, 900 specs, gzipped ~10kb, minified ~40kb.

### Features

- Methods comply 1 to 1 to ruby code (tested by ~1000 rubyspec tests), down to raising the same Error types.
- All methods of the core ruby classes, excluding ruby specifics and bit operators.
- Enumerators, Iterators, Enumerable. Chainable and extendible.
- Consistent breaking out of loops using: catch_break (breaker) -> breaker.break().
- Methods automatically box/coerce native JS primitives into the right RubyJS type.
- Small filesize: 10-20kb minified and gzipped.

### RubyJS Code samples

```coffeescript
# ** All return values are instances of rubyjs classes. **

## Numbers -----------------------------------------------------

R(1.0123).round(2)               # => 1.01

## String ------------------------------------------------------
R("-").multiply(10)              # => "--------------"

str = R("hello world")
str.capitalize().ljust(20, '-')   # => "Hello world--------"

words = str.scan(/\w+/)           # => ['hello', 'world']
R("a").upto("f").to_a()          # => ['a', 'b', 'c', 'd', 'e']

## Iterators, Enumerators --------------------------------------
words.map (w) -> w.capitalize()   # => ['Hello', 'World']

## StringToProc mimics SymbolToProc
words.map("succ_bang")            # => ['Hellp', 'Worle']

## use coffeescript iterators:
w.capitalize() for w in words.iterator()

## chaining enumerators:
R([123]).each_with_object('foo').each_with_index (a_b, idx) ->
# => a_b : [123, 'foo'], idx => 0

R(5).upto(10) (i) -> # ...
R(5).upto(10).to_a()             # => [5,6,7,8,9]
R(5).upto(10).inject("+")        # => 35

## bang methods
str.capitalize_bang()
str                               # => 'Hello world'

## Chainable: rubyjs methods return rubyjs objects
R("hello").size()                # => 5

```

## Why porting the Ruby core lib

There is no standard core library for JS/Coffee. jQuery and underscorejs do not offer the functionality I needed.

- The Ruby corelib is fantastic and battle proven.
- Not reinventing the wheel, ruby developers are immediately productive
- Rubyspec has a complete (rspec) testsuite that can be ported to coffeescript easily (a matter of Find/Replace)
- Rubinius gives us an implementation of all corelib classes/methods. Not sure how to implement String#scan, check the rubinius source.
- With the corelib, porting additional rubygems to Coffeescript becomes doable
- Porting from rubinius to rubyjs is fun. completely speced and testdriven. Also it's a great way to learn both languages.

## Getting Started

- Clone repository
- Run the coffee console loading the rubyjs files:

```
/path/to/rubyjs $ coffee -r ./lib/ruby.coffee
coffee> R('hello world').capitalize()
"Hello World"
coffee> R('hello world').capitalize().unbox()
'Hello world'
```

- Setup development environment:

```
$ bundle install
$ cake setup_tests            # compiles all test files
$ bundle exec guard           # automatically compile coffeescript
$ rake jasmine                # starts jasmine server
$ open http://localhost:8888  # pray
```

If you get an error like Error: spawn EMFILE and you're on a mac, check this thread:
https://groups.google.com/forum/?fromgroups#!topic/nodejs/jeec5pAqhps



## Assorted details

#### Ruby method equivalents

```
# slightly outdated, needs to be updated.
Object#foo?     = Object#foo
Object#foo!     = Object#foo_bang

Object['<<']    = Object#push
Object['<=>']   = Object#cmp
Object['==']    = Object#equal
Object['===']   = Object#equal_case
Object['<']     = Object#lt
Object['<=']    = Object#lteq
Object['>']     = Object#gt
Object['>=']    = Object#gteq
Object['**']    = ?
Object['*']     = Object#multiply
Object['/']     = Object#divide
Object['%']     = Object#modulo
Object['+']     = Object#plus
Object['-']     = Object#minus
```

#### No monkey patching js core classes. Dont interfere with the global namespace

All JSRuby classes sit in an own namespace. Temporarly it is: **R**

```coffeescript
str = "hello"
str.capitalize()
# => Throws NoMethodError

str = new rubyjs.String("hello");
str.capitalize()
# => <rubyjs.String "Hello">
```

#### Boxing/Unboxing

For classes that have js core classes or primitives, e.g. String, Date, Array, convert from core to JSRuby classes and back using boxing and unboxing. Boxing a primitive to their JSRuby counterpart is done using **R( value )**. Unboxing a JSRuby object to their primitive counterpart by calling obj.**unbox()** and recursivively **unbox(true)**.

Boxing primitive values using R():

```coffeescript
js_string = "hello"
# => "hello"

R("hello")
# => <rubyjs.String "hello">
```

To get the JS core primitives back we can unbox() them:

```coffeescript
R("hello").unbox()
# => "hello"

R("hello").capitalize().unbox()
# => "hello"
```

Unboxing can be made recursive by calling unbox(true). Useful for arrays:


```coffeescript
R("hello world").scan(/\w+/).unbox()
# => [ <rubyjs.String "hello">, <rubyjs.String "hello"> ]

R("hello world").scan(/\w+/).unbox(true)
# => [ 'hello', 'hello' ]
```

#### Chainable: JSRuby return values are JSRuby objects.

When using JSRuby methods, the return values will become JSRuby objects. This allows for chaining methods.

```coffeescript
R("hello").capitalize()
# => <rubyjs.String "hello">

R("hello").capitalize().ljust(10, '-')
# => <rubyjs.String "Hello------">

R("hello world").scan(/\w+/)
# => <rubyjs.Array [ <rubyjs.String "hello">, <rubyjs.String "hello"> ]>
```

#### Porting to rubyspec.org

Porting the rubyspecs is easy. Clone the rubinius repository, copy a spec file:

```ruby
# /path/to/rubinius/spec/ruby/core/string/ljust_spec.rb

describe "String#ljust with length, padding" do
  it "returns a new string of specified length with self left justified and padded with padstr" do
    "hello".ljust(20, '1234').should == "hello123412341234123"

    "".ljust(1, "abcd").should == "a"
    "".ljust(2, "abcd").should == "ab"
    "".ljust(3, "abcd").should == "abc"
    # ...
  end
  # ...
```

Replace " do" with ", ->", the ".should ==" with "expect(...).toEqual ". And add the boxing and unboxing methods.

```coffeescript
# /path/to/rubyjs/spec/corelib/string/ljust_spec.coffee

describe "String#ljust with length, padding", ->
  it "returns a new string of specified length with self left justified and padded with padstr", ->
    expect(R("hello").ljust(20, '1234').unbox()).toEqual("hello123412341234123")

    expect(R("").ljust(1, "abcd").unbox()).toEqual("a")
    expect(R("").ljust(2, "abcd").unbox()).toEqual("ab")
    expect(R("").ljust(3, "abcd").unbox()).toEqual("abc")
```

# Development


```
# Generate documenation:
npm install -g codo
codo lib/
```
