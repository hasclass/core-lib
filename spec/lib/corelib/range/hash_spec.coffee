xdescribe "Range#hash", ->
  it "is provided", ->
    # (0..1).respond_to?(:hash).toEqual  true
    # ('A'..'Z').respond_to?(:hash).toEqual  true
    # (0xfffd..0xffff).respond_to?(:hash).toEqual  true
    # (0.5..2.4).respond_to?(:hash).toEqual  true

  it "generates the same hash values for Ranges with the same start, end and exclude_end? values", ->
    # (0..1).hash.toEqual  (0..1).hash
    # (0...10).hash.toEqual  (0...10).hash
    # (0..10).hash.should_not == (0...10).hash

  it "generates a Fixnum for the hash value", ->
    # (0..0).hash.toEqual an_instance_of(Fixnum)
    # (0..1).hash.toEqual an_instance_of(Fixnum)
    # (0...10).hash.toEqual an_instance_of(Fixnum)
    # (0..10).hash.toEqual an_instance_of(Fixnum)
