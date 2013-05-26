describe "RCoerce", ->
  describe "#to_num_native", ->
    it "returns primitive when passed primitive", ->
      expect( R.RCoerce.to_num_native(1) ).toEqual 1

    it "returns primitive when passed Number", ->
      expect( R.RCoerce.to_num_native(new Number(1)) ).toEqual 1

    it "returns primitive when passed R.Fixnum", ->
      expect( R.RCoerce.to_num_native(new R.Fixnum(1)) ).toEqual 1

    it "returns primitive when passed R.Float", ->
      expect( R.RCoerce.to_num_native(new R.Float(1.2)) ).toEqual 1.2

    it "raises TypeError if non numeric value", ->
      expect( -> R.RCoerce.to_num_native("1.2") ).toThrow "TypeError"

  describe "#to_int_native", ->
    it "returns primitive when passed primitive", ->
      expect( R.RCoerce.to_int_native(1) ).toEqual 1
      expect( R.RCoerce.to_int_native(1.2) ).toEqual 1

    it "returns primitive when passed Number", ->
      expect( R.RCoerce.to_int_native(new Number(1)) ).toEqual 1
      expect( R.RCoerce.to_int_native(new Number(1.2)) ).toEqual 1

    it "returns primitive when passed R.Fixnum", ->
      expect( R.RCoerce.to_int_native(new R.Fixnum(1)) ).toEqual 1

    it "returns primitive when passed R.Float", ->
      expect( R.RCoerce.to_int_native(new R.Float(1.2)) ).toEqual 1

    it "returns primitive when passed ducktype", ->
      expect( R.RCoerce.to_int_native({to_int: -> R(1)}) ).toEqual 1

    it "raises TypeError if non numeric value", ->
      expect( -> R.RCoerce.to_int_native("1.2") ).toThrow "TypeError"

  describe "#to_str_native", ->
    it "returns primitive when passed primitive", ->
      expect( R.RCoerce.to_str_native("foo") ).toEqual "foo"

    it "returns primitive when passed String object", ->
      expect( R.RCoerce.to_str_native(new String("foo")) ).toEqual "foo"

    it "returns primitive when passed R.String", ->
      expect( R.RCoerce.to_str_native(R("foo")) ).toEqual "foo"

    it "returns primitive when passed ducktype", ->
      expect( R.RCoerce.to_str_native({to_str: -> R("foo")}) ).toEqual "foo"

    it "raises TypeError if non string value", ->
      expect( -> R.RCoerce.to_str_native(1.2) ).toThrow "TypeError"
