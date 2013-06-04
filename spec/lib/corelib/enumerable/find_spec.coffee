describe "Enumerable#find", ->
  # #detect and #find are aliases, so we only need one function
  beforeEach ->
    #ScratchPad.record []
    @elements = [2, 4, 6, 8, 10]
    # numerous recursively boxes valuess
    @numerous = EnumerableSpecs.Numerous.new(2, 4, 6, 8, 10)
    @empty = R.$Array []

  it "returns the first element when always returning true", ->
    expect( @numerous.find((e) -> true )   ).toEqual R(2)

  it "returns the first element that returns true", ->
    expect( @numerous.find((e) -> e.equals(4) )   ).toEqual R(4)

  it "passes each entry in enum to block while block when block is false", ->
    visited_elements = []
    @numerous.find (element) ->
      visited_elements.push element.valueOf()
      false

    expect( visited_elements ).toEqual @elements

  it "returns nil when the block is false and there is no ifnone proc given", ->
    expect( @numerous.find( -> false )).toEqual null

  xit "returns the first element for which the block is not false", ->
    numerous = @numerous
    R(@elements).each (element) ->
      expect( numerous.find( (e) -> e > element - 1 )).toEqual element


  it "returns the value of the ifnone proc if the block is false", ->
    fail_proc = -> "cheeseburgers"
    expect(@numerous.find(fail_proc, (e) -> false )).toEqual "cheeseburgers"

  it "doesn't call the ifnone proc if an element is found", ->
    fail_proc = -> throw "This shouldn't have been called"
    expect( @numerous.find(fail_proc, (e) -> 2 )   ).toEqual R(2)

  it "calls the ifnone proc only once when the block is false", ->
    times = 0
    fail_proc = ->
      times += 1
      throw "RuntimeError" if times > 1
      "cheeseburgers"

    expect( @numerous.find(fail_proc, (e) -> false )).toEqual "cheeseburgers"

  it "calls the ifnone proc when there are no elements", ->
    fail_proc = -> "yay"
    empty = @empty
    expect(empty.find(fail_proc, (e) -> true)).toEqual "yay"

  # ruby_version_is ""..."1.8.7", ->
  #   it "raises a LocalJumpError if no block given", ->
  #     lambda { @numerous.find }.should raise_error(LocalJumpError)


  xdescribe 'ruby_version_is "1.8.7"', ->
    xit "passes through the values yielded by #each_with_index", ->
      # [:a, :b].each_with_index.find { |x, i| ScratchPad << [x, i]; nil }
      # ScratchPad.recorded.should == [[:a, 0], [:b, 1]]


    it "returns an enumerator when no block given", ->
      @numerous.find.should be_an_instance_of(enumerator_class)


    it "passes the ifnone proc to the enumerator", ->
      times = 0
      fail_proc = ->
        times += 1
        throw "RuntimeError" if times > 1
        "cheeseburgers"
      @numerous.find(fail_proc, -> false ).should == "cheeseburgers"


  xit "gathers whole arrays as elements when each yields multiple", ->
    # multi = EnumerableSpecs::YieldsMulti.new
    # multi.find {|e| e == [1, 2] }.should == [1, 2]

