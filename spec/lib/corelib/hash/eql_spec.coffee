describe "Hash#eql?", ->
  it "does not compare values when keys don't match", ->
    value = {
      equals: -> throw "should not receive"
      eql:  -> throw "should not receive"
    }

    expect( R.h(1: value).eql(R.h({2: value})) ).toEqual false


  xit "returns false when the numbers of keys differ without comparing any elements", ->
    # obj = {
    #   equals: -> throw "should not receive"
    #   eql:  -> throw "should not receive"
    # }
    # h = R.hashify(obj: obj)

    # expect( R.hashify({}).eql(h) ).toEqual false
    # expect( h.eql(R.hashify({})) ).toEqual false

  xit "first compares keys via hash", ->
    # x = mock('x')
    # x.should_receive(:hash).any_number_of_times.and_return(0)
    # y = mock('y')
    # y.should_receive(:hash).any_number_of_times.and_return(0)

    # R.hashify(x: 1).eql(R.hashify(y: 1)).should be_false

  xit "does not compare keys with different hash codes via eql?", ->
    # x = mock('x')
    # y = mock('y')
    # x.should_not_receive(:eql?)
    # y.should_not_receive(:eql?)

    # x.should_receive(:hash).any_number_of_times.and_return(0)
    # y.should_receive(:hash).any_number_of_times.and_return(1)

    # R.hashify(x: 1).eql(R.hashify(y: 1)).should be_false

  xit "computes equality for recursive hashes", ->
    # h = R.hashify
    # h[:a] = h
    # h.eql(h[:a]).should be_true
    # (h == h[:a]).should be_true

  xit "doesn't call to_hash on objects", ->
    # mock_hash = mock("fake hash")
    # def mock_hash.to_hash() R.hashify end
    # R.hashify.eql(mock_hash).should be_false

  # ruby_bug "redmine #2448", "1.9.1", ->
  #   it "computes equality for complex recursive hashes", ->
  #     a, b = {}, {}
  #     a.merge! :self: a, :other: b
  #     b.merge! :self: b, :other: a
  #     a.eql(b).should be_true # they both have the same structure!

  #     c = {}
  #     c.merge! :other: c, :self: c
  #     c.eql(a).should be_true # subtle, but they both have the same structure!
  #     a[:delta] = c[:delta] = a
  #     c.eql(a).should be_false # not quite the same structure, as a[:other][:delta] = nil
  #     c[:delta] = 42
  #     c.eql(a).should be_false
  #     a[:delta] = 42
  #     c.eql(a).should be_false
  #     b[:delta] = 42
  #     c.eql(a).should be_true

  #   it "computes equality for recursive hashes & arrays", ->
  #     x, y, z = [], [], []
  #     a, b, c = {:foo: x, :bar: 42}, {:foo: y, :bar: 42}, {:foo: z, :bar: 42}
  #     x << a
  #     y << c
  #     z << b
  #     b.eql(c).should be_true # they clearly have the same structure!
  #     y.eql(z).should be_true
  #     a.eql(b).should be_true # subtle, but they both have the same structure!
  #     x.eql(y).should be_true
  #     y << x
  #     y.eql(z).should be_false
  #     z << x
  #     y.eql(z).should be_true

  #     a[:foo], a[:bar] = a[:bar], a[:foo]
  #     a.eql(b).should be_false
  #     b[:bar] = b[:foo]
  #     b.eql(c).should be_false


  # it "returns true if other Hash has the same number of keys and each key-value pair matches, even though the default-value are not same", ->
  #   R.hashify(5).eql(R.hashify(1)).should be_true
  #   R.hashify {|h, k| 1}.eql(R.hashify {}).should be_true
  #   R.hashify {|h, k| 1}.eql(R.hashify(2)).should be_true

  #   d = R.hashify {|h, k| 1}
  #   e = R.hashify {}
  #   d[1] = 2
  #   e[1] = 2
  #   d.eql(e).should be_true
