describe "Array#include?", ->
  it "returns true if object is present, false otherwise", ->
    expect( R([1, 2, "a", "b"]).include("c") ).toEqual false
    expect( R([1, 2, "a", "b"]).include("a") ).toEqual true

  it "determines presence by using element == obj", ->
    o = {}
    o['=='] = -> false
    expect( R([1, 2, "a", "b"]).include(o) ).toEqual false

    obj = {}
    obj['=='] = (other) -> other == 'a'

    expect( R([1, 2, obj, "b"]).include('a')).toEqual true
    expect( R([1, 2.0, 3]).include(2) ).toEqual true

  # it "calls == on elements from left to right until success", ->
  #   key = "x"
  #   one = mock('one')
  #   two = mock('two')
  #   three = mock('three')
  #   one.should_receive(:==).any_number_of_times.and_return(false)
  #   two.should_receive(:==).any_number_of_times.and_return(true)
  #   three.should_not_receive(:==)
  #   ary = [one, two, three]
  #   ary.include?(key).should == true
