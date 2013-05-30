describe "Enumerator", ->
  it '1.upto(2).cycle(2).to_a()', ->
    expect( R(1).upto(2).cycle(2).to_a().to_native(true) ).toEqual [1,2,1,2]
    expect( R(2).times().cycle(2).to_a().to_native(true) ).toEqual [0,1,0,1]

  it 'inspect', ->
    expect( R([1,2,3]).inspect() ).toEqual R('[1, 2, 3]')
    expect( R.$Array_r([1,2,3, [1,R(2),2]]).inspect() ).toEqual R('[1, 2, 3, [1, 2, 2]]')

  it "playground", ->
    en = RubyJS.Enumerator.new( R([1,2,3]), 'each')
    expect( en.to_a().unbox() ).toEqual [1,2,3]

  it "playground R(1).upto(5)", ->
    en = R(1).upto(5)

    arr = []
    arr.push(i + 1) for i in en.iterator()
    expect( arr ).toEqual [2,3,4,5,6]

    expect( R(en.iterator()).inspect() ).toEqual R('[1, 2, 3, 4, 5]')
    expect( en.to_a().inspect() ).toEqual R('[1, 2, 3, 4, 5]')

    expect( en.all((i)-> i < 9) ).toEqual true
    expect( en.all((i)-> i < 4) ).toEqual false

    expect( en.select((i)-> + i % 2 == 0).inspect() ).toEqual R('[2, 4]')
    expect( en.each_with_index().to_a().inspect() ).toEqual R('[[1,0], [2,1], [3,2], [4,3], [5,4]]')
    #expect( en.each_with_index().collect((w,i) -> i).inspect() ).toEqual R('[0, 1, 2, 3, 4]')
    # differs from rubyspec
    # expect( en.each_with_object(3).to_a().inspect() ).toEqual R('[[1,0], [2,0], [3,0], [4,0], [5,0]]')
    en = R(1).upto(5)
    expect( en.each_with_index().all((a, b) -> a > b) ).toEqual true

  it "for i in R([2,3,1]).iterator()", ->
    out = []
    out.push(i) for i in R([2,3,1]).iterator()
    expect( out ).toEqual [2,3,1]

  it "Enumerator.new(arr, 'each')", ->
    arr = R [1,3]
    out = R []

    en  = RubyJS.Enumerator.new(arr, 'each')
    expect( en.to_a().unbox() ).toEqual [1, 3]

    out.push([i,el]) for el, i in en.iterator()
    expect( out.unbox(true)).toEqual [[0,1], [1,3]]

  it "Enumerator.new(arr, 'each_with_index').to_a", ->
    arr = R [1,7,3]

    en  = RubyJS.Enumerator.new(arr, 'each_with_index')
    expect( en.object ).toEqual arr
    expect( en.to_a().map((e) -> e.join('.')).unbox() ).toEqual ['1.0', '7.1', '3.2']

  it "Integer#upto", ->
    arr = []

    en = RubyJS.Enumerator.new(R(1), 'upto', 3)
    en.each (i) -> arr.push(i)
    expect( arr ).toEqual([1,2,3])

    en = RubyJS.Enumerator.new(R(1), 'upto', 3)
    expect( en.each() ).toBeInstanceOf(RubyJS.Enumerator)

    expect( en.next() ).toEqual(1)
    expect( en.next() ).toEqual(2)
    expect( en.next() ).toEqual(3)
    expect( en.next() ).toEqual(null)