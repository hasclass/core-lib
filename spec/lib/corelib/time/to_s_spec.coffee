describe "Time#to_s", ->
  # it_behaves_like :inspect, :to_s

  # describe "1.9", ->
  #   it "formats the time following the pattern 'EEE MMM dd HH:mm:ss Z yyyy'", ->
  #     with_timezone "PST", 1, ->
  #       expect( R.Time.local(2000, 1, 1, 20, 15, 1).to_s() ).toEqual R("2000-01-01 20:15:01 +0100")

  #   it "formats the UTC time following the pattern 'EEE MMM dd HH:mm:ss UTC yyyy'", ->
  #     expect( R.Time.utc(2000, 1, 1, 20, 15, 1).to_s() ).toEqual R("2000-01-01 20:15:01 UTC")

  describe "1.9", ->
    it "formats the local time following the pattern 'yyyy-MM-dd HH:mm:ss Z'", ->
      expect( R.Time.new(2000, 1, 1, 20, 15, 1, 3600).to_s() ).toEqual R("2000-01-01 20:15:01 +0100")

    it "formats the UTC time following the pattern 'yyyy-MM-dd HH:mm:ss UTC'", ->
      expect( R.Time.utc(2000, 1, 1, 20, 15, 1).to_s() ).toEqual R("2000-01-01 20:15:01 UTC")

    it "formats the fixed offset time following the pattern 'yyyy-MM-dd HH:mm:ss +/-HHMM'", ->
      expect( R.Time.new(2000, 1, 1, 20, 15, 1, 3600).to_s() ).toEqual R("2000-01-01 20:15:01 +0100")
