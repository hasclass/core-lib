describe "Float#arg", ->
  xdescribe 'ruby_bug "#1715", "1.8.6.369"', ->
    it "returns NaN if NaN", ->
      f = R.Float.NAN
      expect(R(f).arg().nan() ).toEqual true

  describe 'ruby_version_is "1.9"', ->
    it "returns self if NaN", ->
      f = R(R.Float.NAN)
      expect(f.arg() == f).toEqual true

  it "returns 0 if positive", ->
    expect(R(1.0).to_f().arg() ).toEqual R(0).to_f()

  it "returns 0 if +0.0", ->
    expect(R(0.0).to_f().arg() ).toEqual R(0).to_f()

  it "returns 0 if +Infinity", ->
    expect(R(R.Float.INFINITY).to_f().arg() ).toEqual R(0).to_f()

  it "returns Pi if negative", ->
    expect(R((-1.0)).to_f().arg() ).toEqual R(Math.PI).to_f()

  # This was established in r23960
  xit "returns Pi if -0.0", ->
    # BUG does not work
    expect(R(-0.0).to_f().arg() ).toEqual R(Math.PI).to_f()

  it "returns Pi if -Infinity", ->
    expect(R((-R.Float.INFINITY)).to_f().arg() ).toEqual R(Math.PI).to_f()
