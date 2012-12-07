describe "Float#round", ->
  it "returns the nearest Integer", ->
    expect( R(5.5).round()                  ).toEqual R( 6 )
    expect( R(0.4).round()                  ).toEqual R( 0 )
    expect( R(-2.8).round()                 ).toEqual R(-3 )
    expect( R(0.0).to_f().round()           ).toEqual R( 0 )

  xit "fails in Safari.... :-(", ->
    expect( R(0.49999999999999994).round()  ).toEqual R( 0 ) # see http://jira.codehaus.org/browse/JRUBY-5048

  xit "raises FloatDomainError for exceptional values", ->
    expect( -> R.$Float(R.Float.INFINITY).round()  ).toThrow('FloatDomainError')
    expect( -> R.$Float(-R.Float.INFINITY).round() ).toThrow('FloatDomainError')
    expect( -> R.$Float(-R.Float.NAN).round()      ).toThrow('FloatDomainError')

  describe 'ruby_version_is "1.9"', ->
    it "rounds self to an optionally given precision", ->
      expect( R(5.5).round(0)               ).toEqual R(6)
      expect( R(5.7).round(1)               ).toEqual R(5.7)
      expect( R(1.2345678).round(2)         ).toEqual R(1.23)
      expect( R(123456.78).round(-2)        ).toEqual R(123500)
      expect( R(-123456.78).round(-2)       ).toEqual R(-123500)
    xit '', ->
      expect( R(12.345678).round(3.999) ).toEqual R(12.346)

    it "returns zero when passed a negative argument with magitude greater the magitude of the whole number portion of the Float", ->
      expect( R(0.8346268).round(-1) ).toEqual(R(0))

    it "raises a TypeError when its argument can not be converted to an Integer", ->
      expect( -> R(1.1).round("4") ).toThrow('TypeError')

    xit 'R difference', ->
      expect( -> R(1.1).round(null) ).toThrow('TypeError')

    it "raises FloatDomainError for exceptional values when passed a non-positive precision", ->
      expect( -> R.$Float(R.Float.INFINITY).round( 0) ).toThrow('FloatDomainError')
      expect( -> R.$Float(R.Float.INFINITY).round(-2) ).toThrow('FloatDomainError')
      expect( -> R.$Float(-R.Float.INFINITY).round( 0) ).toThrow('FloatDomainError')
      expect( -> R.$Float(-R.Float.INFINITY).round(-2) ).toThrow('FloatDomainError')

    it "raises RangeError for NAN when passed a non-positive precision", ->
      expect( -> R.$Float( R.Float.NAN ).round(0) ).toThrow('RangeError')
      expect( -> R.$Float( R.Float.NAN ).round(-2) ).toThrow('RangeError')


  xdescribe 'unsupported', ->
    it "returns self for exceptional values when passed a non-negative precision", ->
    #   Float::INFINITY.round(2).should == Float::INFINITY
    #   (-Float::INFINITY).round(2).should == -Float::INFINITY
    #   Float::NAN.round(2) == Float::NAN

    describe 'ruby_bug "redmine:5227",  "1.9.2"', ->
      it "works for corner cases", ->
        expect( R(42.0).to_f().round(308) ).toEqual(R 42.0)
        expect( R(1.0e307).round(2)).toEqual(R 1.0e307)

    # ruby_bug "redmine:5271",  "1.9.3.0", ->
    #   it "returns rounded values for big argument", ->
    #     0.42.round(2.0**30).should == 0.42

    # ruby_bug "redmine #5272", "1.9.3", ->
    #   it "returns rounded values for big values", ->
    #     +2.5e20.round(-20).should   eql( +3 * 10 ** 20  )
    #     +2.4e20.round(-20).should   eql( +2 * 10 ** 20  )
    #     -2.5e20.round(-20).should   eql( -3 * 10 ** 20  )
    #     -2.4e20.round(-20).should   eql( -2 * 10 ** 20  )
    #     +2.5e200.round(-200).should eql( +3 * 10 ** 200 )
    #     +2.4e200.round(-200).should eql( +2 * 10 ** 200 )
    #     -2.5e200.round(-200).should eql( -3 * 10 ** 200 )
    #     -2.4e200.round(-200).should eql( -2 * 10 ** 200 )

