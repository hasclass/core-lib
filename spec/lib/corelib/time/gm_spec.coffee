
describe "Time.gm", ->
  # it_behaves_like(:time_gm, :gm)
  # it_behaves_like(:time_params, :gm)
  # it_behaves_like(:time_params_10_arg, :gm)
  # it_behaves_like(:time_params_microseconds, :gm)

  describe "1.9", ->
    it "creates a time based on given values, interpreted as UTC (GMT)", ->
      expect( R.Time.gm(2000,1,1,20,15,1).inspect() ).toEqual R("2000-01-01 20:15:01 UTC")

    # TODO: not supported
    xit "creates a time based on given C-style gmtime arguments, interpreted as UTC (GMT)", ->
      time = R.Time.gm(1, 15, 20, 1, 1, 2000, 'ignored', 'ignored', 'ignored', 'ignored')
      expect( time.inspect() ).toEqual R("2000-01-01 20:15:01 UTC")
