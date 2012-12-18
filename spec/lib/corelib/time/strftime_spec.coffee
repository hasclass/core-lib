



describe "Time#strftime", ->
  it "formats time according to the directives in the given format string", ->
    # TODO:
    with_timezone "GMT", 0, ->
      expect( R.Time.at(0).strftime("There is %M minutes in epoch") ).toEqual R("There is 00 minutes in epoch")

  xit "supports week of year format with %U and %W", ->
    # start of the yer
    saturday_first = R.Time.local(2000,1,1,14,58,42)
    expect( saturday_first.strftime("%U") ).toEqual R("00")
    expect( saturday_first.strftime("%W") ).toEqual R("00")

    sunday_second = R.Time.local(2000,1,2,14,58,42)
    expect( sunday_second.strftime("%U") ).toEqual R("01")
    expect( sunday_second.strftime("%W") ).toEqual R("00")

    monday_third = R.Time.local(2000,1,3,14,58,42)
    expect( monday_third.strftime("%U") ).toEqual R("01")
    expect( monday_third.strftime("%W") ).toEqual R("01")

    sunday_9th = R.Time.local(2000,1,9,14,58,42)
    expect( sunday_9th.strftime("%U") ).toEqual R("02")
    expect( sunday_9th.strftime("%W") ).toEqual R("01")

    monday_10th = R.Time.local(2000,1,10,14,58,42)
    expect( monday_10th.strftime("%U") ).toEqual R("02")
    expect( monday_10th.strftime("%W") ).toEqual R("02")

    # middle of the year
    some_sunday = R.Time.local(2000,8,6,4,20, 0)
    expect( some_sunday.strftime("%U") ).toEqual R("32")
    expect( some_sunday.strftime("%W") ).toEqual R("31")
    some_monday = R.Time.local(2000,8,7,4,20,0)
    expect( some_monday.strftime("%U") ).toEqual R("32")
    expect( some_monday.strftime("%W") ).toEqual R("32")

    # end of year, and start of next one
    saturday_30th = R.Time.local(2000,12,30,14,58,42)
    expect( saturday_30th.strftime("%U") ).toEqual R("52")
    expect( saturday_30th.strftime("%W") ).toEqual R("52")

    sunday_last = R.Time.local(2000,12,31,14,58,42)
    expect( sunday_last.strftime("%U") ).toEqual R("53")
    expect( sunday_last.strftime("%W") ).toEqual R("52")

    monday_first = R.Time.local(2001,1,1,14,58,42)
    expect( monday_first.strftime("%U") ).toEqual R("00")
    expect( monday_first.strftime("%W") ).toEqual R("01")

  it "supports mm/dd/yy formatting with %D", ->
    now = R.Time.now()
    mmddyy = now.strftime('%m/%d/%y')
    expect(  now.strftime('%D') ).toEqual R(mmddyy)

  it "supports HH:MM:SS formatting with %T", ->
    now = R.Time.now()
    hhmmss = now.strftime('%H:%M:%S')
    expect( now.strftime('%T') ).toEqual R(hhmmss)

  it "supports 12-hr formatting with %l", ->
    time = R.Time.local(2004, 8, 26, 22, 38, 3)
    expect( time.strftime('%l') ).toEqual R('10')
    morning_time = R.Time.local(2004, 8, 26, 6, 38, 3)
    expect( morning_time.strftime('%l') ).toEqual R(' 6')

  it "supports AM/PM formatting with %p", ->
    time = R.Time.local(2004, 8, 26, 22, 38, 3)
    expect( time.strftime('%p') ).toEqual R('PM')
    time = R.Time.local(2004, 8, 26, 11, 38, 3)
    expect( time.strftime('%p') ).toEqual R('AM')

  it "returns the abbreviated weekday with %a", ->
    time = R.Time.local(2009, 9, 18, 12, 0, 0)
    expect( time.strftime('%a') ).toEqual R('Fri')

  it "returns the full weekday with %A", ->
    time = R.Time.local(2009, 9, 18, 12, 0, 0)
    expect( time.strftime('%A') ).toEqual R('Friday')

  it "returns the abbreviated month with %b", ->
    time = R.Time.local(2009, 9, 18, 12, 0, 0)
    expect( time.strftime('%b') ).toEqual R('Sep')

  it "returns the full month with %B", ->
    time = R.Time.local(2009, 9, 18, 12, 0, 0)
    expect( time.strftime('%B') ).toEqual R('September')

  it "returns the day of the month with %d", ->
    time = R.Time.local(2009, 9, 18, 12, 0, 0)
    expect( time.strftime('%d') ).toEqual R('18')

  it "returns the 24-based hour with %H", ->
    time = R.Time.local(2009, 9, 18, 18, 0, 0)
    expect( time.strftime('%H') ).toEqual R('18')

  it "returns the 12-based hour with %I", ->
    time = R.Time.local(2009, 9, 18, 18, 0, 0)
    expect( time.strftime('%I') ).toEqual R('06')

  it "returns the Julian date with %j", ->
    time = R.Time.local(2009, 9, 18, 18, 0, 0)
    expect( time.strftime('%j') ).toEqual R('261')

  xdescribe "1.9", ->
    describe "with %L", ->
      it "formats the milliseconds of of the second", ->
        expect( R.Time.local(2009, 1, 1, 0, 0, Rational(999, 1000)).strftime("%L") ).toEqual R("999")

  it "returns the month with %m", ->
    time = R.Time.local(2009, 9, 18, 12, 0, 0)
    expect( time.strftime('%m') ).toEqual R('09')

  it "returns the minute with %M", ->
    time = R.Time.local(2009, 9, 18, 12, 6, 0)
    expect( time.strftime('%M') ).toEqual R('06')

  xdescribe "1.9", ->
    describe "with %N", ->
      it "formats the nanoseconds of of the second with %N", ->
        expect( R.Time.local(2009, 1, 1, 0, 0, Rational(999999999, 1000000000)).strftime("%N") ).toEqual R("999999999")

      it "formats the milliseconds of of the second with %3N", ->
        expect( R.Time.local(2009, 1, 1, 0, 0, Rational(999, 1000)).strftime("%3N") ).toEqual R("999")

      it "formats the microseconds of of the second with %6N", ->
        expect( R.Time.local(2009, 1, 1, 0, 0, Rational(999999, 1000000)).strftime("%6N") ).toEqual R("999999")

      it "formats the nanoseconds of of the second with %9N", ->
        expect( R.Time.local(2009, 1, 1, 0, 0, Rational(999999999, 1000000000)).strftime("%9N") ).toEqual R("999999999")

      it "formats the picoseconds of of the second with %12N", ->
        expect( R.Time.local(2009, 1, 1, 0, 0, Rational(999999999999, 1000000000000)).strftime("%12N") ).toEqual R("999999999999")

  it "returns the second with %S", ->
    time = R.Time.local(2009, 9, 18, 12, 0, 6)
    expect( time.strftime('%S') ).toEqual R('06')

  it "returns the enumerated day of the week with %w", ->
    time = R.Time.local(2009, 9, 18, 12, 0, 0)
    expect( time.strftime('%w') ).toEqual R('5')

  it "returns the date alone with %x", ->
    time = R.Time.local(2009, 9, 18, 12, 0, 6)
    expect( time.strftime('%x') ).toEqual R('09/18/09')

  it "returns the time alone with %X", ->
    time = R.Time.local(2009, 9, 18, 12, 0, 6)
    expect( time.strftime('%X') ).toEqual R('12:00:06')

  it "returns the year wihout a century with %y", ->
    time = R.Time.local(2009, 9, 18, 12, 0, 0)
    expect( time.strftime('%y') ).toEqual R('09')

  it "returns the year with %Y", ->
    time = R.Time.local(2009, 9, 18, 12, 0, 0)
    expect( time.strftime('%Y') ).toEqual R('2009')

  describe "with %z", ->
    describe "1.9", ->
      it "formats a UTC time offset as '+0000'", ->
        expect( R.Time.utc(2005).strftime("%z") ).toEqual R("+0000")

    it "formats a local time with positive UTC offset as '+HHMM'", ->
      expect( new R.Time(new Date(2005), 1*3600).strftime("%z") ).toEqual R("+0100")

    it "formats a local time with negative UTC offset as '-HHMM'", ->
      expect( new R.Time(new Date(2005), -8*3600).strftime("%z") ).toEqual R("-0800")

    xdescribe "1.9", ->
      it "formats a time with fixed positive offset as '+HHMM'", ->
        expect( R.Time.new(2012, 1, 1, 0, 0, 0, 3660).strftime("%z") ).toEqual R("+0101")

      it "formats a time with fixed negative offset as '-HHMM'", ->
        expect( R.Time.new(2012, 1, 1, 0, 0, 0, -3660).strftime("%z") ).toEqual R("-0101")

      it "formats a time with fixed offset as '+/-HH:MM' with ':' specifier", ->
        expect( R.Time.new(2012, 1, 1, 0, 0, 0, 3660).strftime("%:z") ).toEqual R("+01:01")

      it "formats a time with fixed offset as '+/-HH:MM:SS' with '::' specifier", ->
        expect( R.Time.new(2012, 1, 1, 0, 0, 0, 3665).strftime("%::z") ).toEqual R("+01:01:05")

      it "rounds fixed offset to the nearest second", ->
        expect( R.Time.new(2012, 1, 1, 0, 0, 0, Rational(36645, 10)).strftime("%::z") ).toEqual R("+01:01:05")

  # TODO stftime with %Z
  xit "returns the timezone with %Z", ->
    time = R.Time.local(2009, 9, 18, 12, 0, 0)
    zone = time.zone()
    expect( time.strftime("%Z") ).toEqual R(zone)

  describe "1.9..", ->
    it "supports am/pm formatting with %P", ->
      time = R.Time.local(2004, 8, 26, 22, 38, 3)
      expect( time.strftime('%P') ).toEqual R('pm')
      time = R.Time.local(2004, 8, 26, 11, 38, 3)
      expect( time.strftime('%P') ).toEqual R('am')

  describe '1.9', ->
    # TODO:
    xit "returns the fractional seconds digits, default is 9 digits (nanosecond) with %N", ->
      time = R.Time.local(2009, 9, 18, 12, 0, 6, 123456)
      expect( time.strftime('%N') ).toEqual R('123456000')

  describe '1.9', ->
    xit "supports GNU modificators", ->
      time = R.Time.local(2001, 2, 3, 4, 5, 6)

      expect( time.strftime('%^h') ).toEqual R('FEB')
      expect( time.strftime('%^_5h') ).toEqual R('  FEB')
      expect( time.strftime('%0^5h') ).toEqual R('00FEB')
      expect( time.strftime('%04H') ).toEqual R('0004')
      expect( time.strftime('%0-^5h') ).toEqual R('FEB')
      expect( time.strftime('%_-^5h') ).toEqual R('FEB')
      expect( time.strftime('%^ha') ).toEqual R('FEBa')

      expected =
        "%10h"   : '       Feb',
        "%^10h"  : '       FEB',
        "%_10h"  : '       Feb',
        "%_010h" : '0000000Feb',
        "%0_10h" : '       Feb',
        "%0_-10h": 'Feb',
        "%0-_10h": 'Feb'

      for format in ["%10h","%^10h","%_10h","%_010h","%0_10h","%0_-10h","%0-_10h"]
        expect( time.strftime(format) ).toEqual R(expected[format])

    xit "supports the '-' modifier to drop leading zeros", ->
      time = R.Time.local(2001,1,1,14, 1,42)
      expect( time.strftime("%-m/%-d/%-y %-I:%-M %p") ).toEqual R("1/1/1 2:1 PM")

      time = R.Time.local(2010,10,10,12,10,42)
      expect( time.strftime("%-m/%-d/%-y %-I:%-M %p") ).toEqual R("10/10/10 12:10 PM")
