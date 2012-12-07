describe "Integer#round", ->
  # it_behaves_like(:integer_to_i, :round)


  describe 'ruby_version_is "1.9"', ->
    it "rounds", ->
      expect( R( 123).round(-1) ).toEqual R(120)
      expect( R(-123).round(-1) ).toEqual R(-120)
      expect( R( 123).round(-2) ).toEqual R(100)
      expect( R(-123).round(-2) ).toEqual R(-100)
      expect( R( 123).round( 0) ).toEqual R(123)
      expect( R( 123).round( 1) ).toEqual R(123.0).to_f()
      expect( R( 123).round( 2) ).toEqual R(123.0).to_f()

    it "rounds itself as a float if passed a positive precision", ->
      expect( R(  2).round(42) ).toEqual R( 2).to_f()
      expect( R( -4).round(42) ).toEqual R(-4).to_f()

      #[2, -4, 10**70, -10**100].each do |v|
      #  v.round(42).should eql(v.to_f)

    it "returns itself if passed zero", ->
      n = R(2)
      expect( n.round(0) is n ).toEqual true

    it "returns itself if passed nothing", ->
      n = R(  3)
      expect( n.round() == n ).toEqual true

    # ruby_bug "redmine:5228", "1.9.2", ->
    #   it "returns itself rounded if passed a negative value", ->
    #     +249.round(-2).should eql(+200)
    #     +250.round(-2).should eql(+300)
    #     -249.round(-2).should eql(-200)
    #     -250.round(-2).should eql(-300)
    #     (+25 * 10**70).round(-71).should eql(+30 * 10**70)
    #     (-25 * 10**70).round(-71).should eql(-30 * 10**70)
    #     (+25 * 10**70 - 1).round(-71).should eql(+20 * 10**70)
    #     (-25 * 10**70 + 1).round(-71).should eql(-20 * 10**70)

    # ruby_bug "redmine #5271", "1.9.3", ->
    #   it "returns 0 if passed a big negative value", ->
    #     42.round(-2**30).should eql(0)

    # it "raises a RangeError when passed Float::INFINITY", ->
    #   lambda { 42.round(Float::INFINITY) }.should raise_error(RangeError)

    # it "raises a RangeError when passed a beyond signed int", ->
    #   lambda { 42.round(1<<31) }.should raise_error(RangeError)

    # it "raises a TypeError when passed a String", ->
    #   lambda { 42.round("4") }.should raise_error(TypeError)

    # it "raises a TypeError when its argument cannot be converted to an Integer", ->
    #   lambda { 42.round(nil) }.should raise_error(TypeError)

    # it "calls #to_int on the argument to convert it to an Integer", ->
    #   obj = mock("Object")
    #   obj.should_receive(:to_int).and_return(0)
    #   42.round(obj)

    # it "raises a TypeError when #to_int does not return an Integer", ->
    #   obj = mock("Object")
    #   obj.stub!(:to_int).and_return([])
    #   lambda { 42.round(obj) }.should raise_error(TypeError)
