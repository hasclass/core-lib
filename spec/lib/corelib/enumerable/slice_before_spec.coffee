describe "ruby_version_is '1.9'", ->
  describe "Enumerable#slice_before", ->
    beforeEach ->
      @en = EnumerableSpecs.Numerous.new(7,6,5,4,3,2,1)

    describe "when given an argument and no block", ->
      it "calls === on the argument to determine when to yield", ->
        arg_i = -1
        arg =
          '===': -> [false, true, false, false, false, true, false][arg_i += 1]
        e = @en.slice_before(arg)
        expect( e ).toBeInstanceOf R.Enumerator
        expect( e.to_a().inspect() ).toEqual R('[[7], [6, 5, 4, 3], [2, 1]]')

      it "doesn't yield an empty array if the filter matches the first entry or the last entry", ->
        arg =
          '===': -> true
        # arg.should_receive(:===).and_return(true).exactly(7)
        e = @en.slice_before(arg)
        expect( e.to_a().inspect() ).toEqual R('[[7], [6], [5], [4], [3], [2], [1]]')

      it "uses standard boolean as a test", ->
        arg_i = -1
        arg =
          '===': -> [false, 'foo', null, false, false, 42, false][arg_i += 1]
        e = @en.slice_before(arg)
        expect( e.to_a().inspect() ).toEqual R('[[7], [6, 5, 4, 3], [2, 1]]')

    describe "when given a block", ->
      describe "and no argument", ->
        it "calls the block to determine when to yield", ->
          e = @en.slice_before (i) -> i.equals(6) || i.equals(2)
          expect( e ).toBeInstanceOf R.Enumerator
          expect( e.to_a().inspect() ).toEqual R('[[7], [6, 5, 4, 3], [2, 1]]')

      describe "and an argument", ->
        it "calls the block with a copy of that argument", ->
          arg = R ["foo"]
          e = @en.slice_before arg, (i, init) ->
            expect( init ).toEqual arg
            expect( init is arg).toEqual false
            first = init
            i.equals(6) || i.equals(2)
          expect( e ).toBeInstanceOf R.Enumerator
          expect( e.to_a().inspect() ).toEqual R('[[7], [6, 5, 4, 3], [2, 1]]')
          e = @en.slice_before arg, (i, init) ->
            expect( init is first ).toEqual false

    #     # quarantine! do # need to double-check with ruby-core. Might be wrong or too specific
    #     #   it "duplicates the argument directly without calling dup", ->
    #     #     arg = EnumerableSpecs.Undupable.new
    #     #     e = @en.slice_before(arg) do |i, init|
    #     #       init.initialize_dup_called.should be_true
    #     #       false
    #     #           e.to_a.should == [[7, 6, 5, 4, 3, 2, 1]]

    xit "raises an Argument error when given an incorrect number of arguments", ->
      en = @en
      expect( -> en.slice_before("one", "two") ).toThrow('ArgumentError')
      expect( -> en.slice_before()             ).toThrow('ArgumentError')
