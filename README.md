# RubyJS Reloaded v0.8.0-beta1

RubyJS got a major overhaul.

Most importantly all methods have been refactored into a functional style (similar to underscore). They can be accessed via _s, _a, _h, _n, _t.

```javascript
_s.capitalize("foo")      // => "Foo"
_a.rindex([1,2,3,2,1], 2) // => 3
_n.upto(1, 5, function(i) { console.log(i) })
_h.rassoc({a: 2, b:3}, 3) // => ["b", 3]
_t.strftime(new Date(), "%Y-%m-%d") // => "2013-02-11"
```

The original object-oriented classes that allow for easy and consistent method chaining now is a (not yet optional) add-on.

```javascript
R("foo").ljust(10, '-').size().times().downto(7).to_a()
// => R.Array {__native__: [10,9,8,7]}
```

If that is not enough for you, you can opt-in the experimental "god_mode". Which extends native JS classes with RubyJS methods.

```javascript
R.god_mode('rb_') // all methods are prefixed with rb_
5.rb_times(function (el) { console.log(el) });
```

More documentation (in the works): http://rubyjs.org/reloaded

Or watch my talk at RubyKaigi: http://ustream.tv/recorded/33526011



# RubyJS

RubyJS is a port of the Ruby core-lib and provides many methods for Array, String, Numerics and more. RubyJS classes are simple wrappers around native JavaScript objects.

See [RubyJS Homepage](http://www.rubyjs.org) for more details. It is licensed under MIT.

## MIT License

RubyJS is licensed under the MIT License.

## rubyjs-rails Gem

There's a Rails [asset-pipeline gem for RubyJS](https://github.com/rubyjs/rubyjs-rails).

Gemfile:

```ruby
gem 'rubyjs-rails'
```

In your application.js manifest:

``` js
//= require ruby
```


## NPM Module: rubyjs

RubyJS can be installed as an npm module.

``` sh
$ npm install rubyjs
```

Then simply require rubyjs which will add the R and RubyJS to the global object.

``` js
require('rubyjs');
R.puts("hello");
```

## Contribute/Develop

RubyJS is currently implemented in CoffeeScript 1.6.3. It's on the roadmap to move away from CoffeeScript to plain JS.

- Clone repository
- Run the coffee console loading the rubyjs files:

``` sh
/path/to/rubyjs $ coffee -r ./ruby.coffee
coffee> R('hello world').capitalize()
"Hello world"
coffee> R('hello world').capitalize().toNative()
'Hello world'
```

- Set up development environment:

``` sh
$ bundle install
$ cake build_tests            # compiles all test files
$ bundle exec guard           # automatically compile coffeescript
$ bundle exec rake jasmine                # starts jasmine server
$ open http://localhost:8888  # pray
```

If you get the error: pipe(): Too many open files, see following page:

https://github.com/jashkenas/coffee-script/issues/1537

For Mac OS X users the following comment helps:

https://github.com/joyent/node/issues/2479#issuecomment-7082186



## API Docs on rubyjs.org/doc

You can quickly search and jump through the [online documentation](http://rubyjs.org/doc) by using the fuzzy finder dialog:

Open fuzzy finder dialog: `Ctrl-T`

In frame mode you can toggle the list navigation frame on the left side:

Toggle list view: `Ctrl-L`

You can focus a list in frame mode or toggle a tab in frameless mode:

- Class list: `Ctrl-C`
<!-- - Mixin list: `Ctrl-I` -->
<!-- - File list: `Ctrl-F` -->
- Method list: `Ctrl-M`
- Extras list: `Ctrl-E`

You can focus and blur the search input:

- Focus search input: `Ctrl-S
- Blur search input: `Esc`
- In frameless mode you can close the list tab: `Esc`

## Namespace

`RubyJS` is the official namespace of all classes and mixins. `R` is an alias to `RubyJS`. In the documentation both versions are used interchangeably.

``` js
RubyJS('foo')
RubyJS.String
RubyJS.Array
// Equivalent to:
R('foo')
R.String
R.Array
```

`R` additionally includes R.Kernel, so methods defined there can be used with R.

``` js
R.puts('hello world')
```

## String

RubyJS.String wraps a native String primitive.

``` js
R('foo')
new R.String('foo')
R.String.new('foo')
R.$String(1) // Emulates Ruby String(1)
```

Destructive methods have a _bang suffix.

``` js
str = R('foo')
str.capitalize()      //=> 'Foo'
str                   //=> 'foo'
str.capitalize_bang() //=> 'Foo'
str                   //=> 'Foo'
```

Create multiple R.Strings with `R.w` equivalent to Ruby `%w[]`.

``` js
words = R.w('foo bar baz')
```

## Array

Arrays are ordered, integer-indexed collections of any object. Array indexing starts at 0, as in C or Java. A negative index is assumed to be relative to the end of the array—that is, an index of -1 indicates the last element of the array, -2 is the next to last element in the array, and so on.

RubyJS.Array wraps a native JavaScript array. Members are not directly accessible using `[]` notation, use `RubyJS.Array.get(1)` and `set(1, 'foo')` instead.

Array includes optimized versions of RubyJS.Enumerable methods.

``` js
R([1,2,3])           // => an R.Array of Number primitives
R([1,2,3], true)     // => an R.Array of R.Fixnums
new R.Array([1,2,3])
```

## Enumerable, Enumerator

The Enumerable mixin provides collection classes with several traversal and searching methods, and with the ability to sort. The class must provide a method `each`, which yields successive members of the collection. If Enumerable#max, #min, or #sort is used, the objects in the collection must also implement a meaningful <=> operator, as these methods rely on an ordering between members of the collection.

Enumerable is currently included in Array, Range and Enumerator. Array implements optimized versions of the methods.

## Numerics

Numeric and Integer are both modules. Functional number types are Fixnum (an Integer) and Float.

- Fixnum includes Numeric, Integer
- Float includes Numeric

Mathematic operations like +, -, * with RubyJS numerics is expensive as for every operation extra objects are created. It is suggested to use JavaScript native primitives for calculations, especially in loops.


## Aliases

Where Ruby methods conflict with JavaScript naming the following aliases are used.
You can also use the JS names quoted inside of brackets, e.g. `['==']`.

    str.equals('foo')
    str['==']('foo')

    # '?' is removed
    include    : include?

    # '!'' => _bang
    upcase_bang: upcase!

    append     : <<
    equals     : ==
    equal_case : ===
    cmp        : <=>
    lt         : <
    lteq       : <=
    gt         : >
    gteq       : >=
    modulo     : %
    plus       : +
    minus      : -
    multiply   : *
    exp        : **
    divide     : /

    # Typecasting:

    R.$String(): String()
    R.$Float() : Float()

    # Special variables

    R['$~']    : $~
    R['$;']    : $;
    R['$,']    : $,

## Roadmap 0.8

- @to_enum returns Arrays not Enumerators.
- upto, downto, times to yield primitives

## Contributors

- typos [jeanlange](https://github.com/jeanlange)
- rubyjs-rails gem [PikachuEXE](https://github.com/PikachuEXE)
