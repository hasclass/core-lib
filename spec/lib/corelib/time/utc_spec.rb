describe "Time#utc?", ->
  it "returns true if time represents a time in UTC (GMT)", ->
    expect( R.Time.now().is_utc() ).toEqual false

describe "Time.utc", ->
  it_behaves_like(:time_gm, :utc)
  it_behaves_like(:time_params, :utc)
  it_behaves_like(:time_params_10_arg, :utc)
  it_behaves_like(:time_params_microseconds, :utc)

describe "Time#utc", ->
  it_behaves_like(:time_gmtime, :utc)
