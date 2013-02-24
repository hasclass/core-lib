###

new RubyJS.Time(new Date(), 3600)

JS Date objects have no support for timezones. R.Time emulates timezones using
a second fake object that is offset by the user defined utc_offset.


@example If local timezone is ICT (+07:00)

    t = R.Time.new(2012,12,24,12,0,0, "+01:00")
    t.__native__
    # => Mon Dec 24 2012 18:00:00 GMT+0700 (ICT)
    # t.__native__ has the correct timestamp for the local time.
    #              2012-12-24 12:00 (CET) - "+01:00 (CET)"
    #              2012-12-24 11:00 (UCT) + "+07:00 (ICT)"
    #              2012-12-24 18:00 (ICT)
    #
    t._tzdate
    # => Mon Dec 24 2012 12:00:00 GMT+0700 (ICT)
    #
    # t._tzdate holds the wrong timestamp but is useful to work with native JS
    # methods.
    #
    t.hour()      # => 12 (internally uses _tzdate.getHours())

###


class RubyJS.Time extends RubyJS.Object
  # Internally uses a Date object and an offset to UTC
  #
  # new Date(2012,11,18,16,0,0)
  # new Date(2012,11,18, 8, 0, 0, 7*3600) # UTC
  #
  #
  #     new Time(Date, utc_offset_in_seconds)
  #     Time.new(y,m,d,h,m,s,utc_offset_in_seconds)
  #     Time.now() # in timezone
  #     Time.at() # local_time
  @include R.Comparable

  @LOCALE:
    'DAYS':         ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday']
    'DAYS_SHORT':   ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
    'MONTHS':       [null, 'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']
    'MONTHS_SHORT': [null, 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
    'AM': 'AM'
    'PM': 'PM'
    'AM_LOW': 'am'
    'PM_LOW': 'pm'

  @TIME_ZONES =
      'UTC': 0,
      # ISO 8601
      # 'Z': 0,
      # RFC 822
      'UT':   0, 'GMT': 0,
      'EST': -5, 'EDT': -4,
      'CST': -6, 'CDT': -5,
      'MST': -7, 'MDT': -6,
      'PST': -8, 'PDT': -7
      # Skip military zones
      # Following definition of military zones is original one.
      # See RFC 1123 and RFC 2822 for the error in RFC 822.
      # 'A' => +1, 'B' => +2, 'C' => +3, 'D' => +4,  'E' => +5,  'F' => +6,
      # 'G' => +7, 'H' => +8, 'I' => +9, 'K' => +10, 'L' => +11, 'M' => +12,
      # 'N' => -1, 'O' => -2, 'P' => -3, 'Q' => -4,  'R' => -5,  'S' => -6,
      # 'T' => -7, 'U' => -8, 'V' => -9, 'W' => -10, 'X' => -11, 'Y' => -12,


  # ---- Constructors & Typecast ----------------------------------------------

  # when passing utc_offset @__native__ has to be in that timezone as well.
  # utc_offset is in seconds
  #
  # e.g. to create a GMT date:
  #
  #     new R.Time(new Date(), 3600)
  #
  #
  constructor: (@__native__, utc_offset) ->
    if utc_offset?
      @__utc_offset__ = utc_offset
      @_tzdate = R.Time._offset_to_local(@__native__, @__utc_offset__)
    else
      @_tzdate = @__native__
      @__utc_offset__ = R.Time._local_timezone()


  @now: ->
    R.Time.new()


  # new → time click to toggle source
  # new(year, month=nil, day=nil, hour=nil, min=nil, sec=nil, utc_offset=nil) → time
  #
  @new: (year, month, day, hour, min, sec, utc_offset) ->
    if arguments.length == 0
      return new R.Time(new Date())
    if year is null
      throw R.TypeError.new()

    month ||= 1
    day   ||= 1
    hour  ||= 0
    min   ||= 0
    sec   ||= 0

    if month > 12 || day > 31 || hour > 24 || min > 59 || sec > 59 || month < 0 || day < 0   || hour < 0  || min < 0  || sec < 0
       throw R.ArgumentError.new()

    # utc_offset is in seconds
    if utc_offset?
      # utc_offset in seconds is the desired offset.
      utc_offset = @_parse_utc_offset(utc_offset)
      # First get the local date for the specified params
      date = new Date(year, month - 1, day, hour, min, sec)
      date = @_local_to_offset(date, utc_offset)
    else
      date = new Date(year, month - 1, day, hour, min, sec)
      utc_offset = @_local_timezone()

    new R.Time(date, utc_offset)


  @_local_to_offset: (date, utc_offset) ->
    # utc_offset is the desired offset in seconds
    # Adjust the local date to the UTC date
    date = date.valueOf() + R.Time._local_timezone() * 1000
    # remove the utc_offset:
    date = date - utc_offset * 1000
    new Date(date)


  @_offset_to_local: (date, utc_offset) ->
    date = date.valueOf() - R.Time._local_timezone() * 1000
    date += utc_offset * 1000
    new Date(date)


  # @private
  # "+01:30" => 90min * 60 sec
  @_parse_utc_offset: (offset) ->
    return null unless offset?
    offset = R(offset)
    secs = null
    if offset.is_string? or offset.to_str?
      offset = offset.to_str().to_native()
      # msg: "+HH:MM" or "-HH:MM" expected for utc_offset
      return throw R.ArgumentError.new() unless offset.match(/[\+|-]\d\d:\d\d/)
      # strip +/-HH:MM into parts and calculate seconds:
      sign = if offset[0] is '-' then -1 else 1
      [hour, mins] = offset.split(':')
      mins = parseInt(mins)
      hour = parseInt(hour.slice(1))
      secs = sign * (hour * 60 + mins) * 60
    else if offset.is_fixnum? or offset.to_int?
      secs = offset.to_int()
      return throw R.ArgumentError.new() if Math.abs(secs) >= 86400

    else
      throw R.TypeError.new()

    Math.floor(secs)


  # Creates a new time object with the value given by time, the given number
  # of seconds_with_frac, or seconds and microseconds_with_frac from the
  # Epoch. seconds_with_frac and microseconds_with_frac can be Integer, Float,
  # Rational, or other Numeric. non-portable feature allows the offset to be
  # negative on some systems.
  #
  # @example
  #     R.Time.at(0)            #=> 1969-12-31 18:00:00 -0600
  #     R.Time.at(Time.at(0))   #=> 1969-12-31 18:00:00 -0600
  #     R.Time.at(946702800)    #=> 1999-12-31 23:00:00 -0600
  #     R.Time.at(-284061600)   #=> 1960-12-31 00:00:00 -0600
  #     R.Time.at(946684800.2).usec() #=> 200000
  #     R.Time.at(946684800, 123456.789).nsec() #=> 123456789
  #
  @at: (seconds, microseconds) ->
    throw R.TypeError.new() if seconds is null
    if microseconds != undefined
      if microseconds is null or R(microseconds).is_string?
        throw R.TypeError.new()
      else
        microseconds = CoerceProto.to_num_native(microseconds)
    else
      microseconds = 0

    seconds = R(seconds)
    if seconds.is_time?
      secs = seconds.to_i()
      msecs = secs * 1000 + microseconds / 1000
      new R.Time(new Date(msecs), time.utc_offset())
    else if seconds.is_numeric?
      secs = seconds.valueOf()
      msecs = secs * 1000 + microseconds / 1000
      new R.Time(new Date(msecs), @_local_timezone())
    else
      throw R.TypeError.new()


  @local: (year, month, day, hour, min, sec) ->
    # date = new Date(year, (month || 1) - 1, day || 1, hour || 0, min || 0, sec || 0)
    R.Time.new(year, month, day, hour, min, sec, @_local_timezone())


  # Creates a time based on given values, interpreted as UTC (GMT). The year
  # must be specified. Other values default to the minimum value for that
  # field (and may be nil or omitted). Months may be specified by numbers from
  # 1 to 12, or by the three-letter English month names. Hours are specified
  # on a 24-hour clock (0..23). Raises an ArgumentError if any values are out
  # of range. Will also accept ten arguments in the order output by Time#to_a.
  # sec_with_frac and usec_with_frac can have a fractional part.
  #
  # @example
  #     R.Time.utc(2000,"jan",1,20,15,1)  #=> 2000-01-01 20:15:01 UTC
  #     R.Time.gm(2000,"jan",1,20,15,1)   #=> 2000-01-01 20:15:01 UTC
  #
  # @alias #gm
  # @todo unsupported c-style syntax R.Time.gm(1, 15, 20, 1, 1, 2000, 'ignored', 'ignored', 'ignored', 'ignored')
  #
  @utc: (year, month, day, hour, min, sec) ->
    date = new Date(Date.UTC(year, (month || 1) - 1, day || 1, hour || 0, min || 0, sec || 0))
    new R.Time(date, 0)


  # @alias #utc
  #
  @gm: @utc


  # Synonym for Time.new. Returns a Time object initialized to the current
  # system time.
  #
  @now: ->
    R.Time.new()


  # @private
  #
  # ICT: (+07:00) -> 420 * 60 -> 25200
  # GMT: (+01:00) ->  60 * 60 -> 3600
  # UCT: (+00:00) ->          -> 0
  #
  @_local_timezone: ->
    new Date().getTimezoneOffset() * -60


  # ---- RubyJSism ------------------------------------------------------------


  is_time: -> true


  # ---- Javascript primitives --------------------------------------------------


  '<=>': (other) ->
    secs = @valueOf()
    other = other.valueOf()
    if secs < other
      -1
    else if secs > other
      1
    else
      0

  cmp: @prototype['<=>']


  '==': (other) ->
    other = R(other)
    return false unless other.is_time?
    @['<=>'](other) is 0


  # Difference—Returns a new time that represents the difference between two
  # times, or subtracts the given number of seconds in numeric from time.
  #
  # t = Time.now       #=> 2007-11-19 08:23:10 -0600
  # t2 = t + 2592000   #=> 2007-12-19 08:23:10 -0600
  # t2 - t             #=> 2592000.0
  # t2 - 2592000       #=> 2007-11-19 08:23:10 -0600
  #
  '-': (other) ->
    throw R.TypeError.new() unless other?
    other = R(other)

    if other.is_numeric?
      tmstmp = @valueOf() - (other.valueOf() * 1000)
      return new R.Time(new Date(tmstmp), @__utc_offset__)
    else if other.is_time?
      new R.Float((@valueOf() - other.valueOf()) / 1000)
    else
      throw R.TypeError.new()


  # Addition—Adds some number of seconds (possibly fractional) to time and
  # returns that value as a new time.
  #
  # @example
  #
  #     t = Time.now()       #=> 2007-11-19 08:22:21 -0600
  #     t + (60 * 60 * 24)   #=> 2007-11-20 08:22:21 -0600
  #
  '+': (other) ->
    throw R.TypeError.new() unless other?

    tpcast = R(other)
    if typeof other != 'number' || !tpcast.is_numeric?
      if !tpcast.is_time? && other.to_f?
        other = other.to_f()
      else
        throw R.TypeError.new()

    tmstmp = @valueOf() + other.valueOf() * 1000
    new R.Time(new Date(tmstmp), @__utc_offset__)


  # Returns a canonical string representation of time.
  #
  # Time.now.asctime   #=> "Wed Apr  9 08:56:03 2003"
  #
  # @alias #ctime
  #
  asctime: ->
    @strftime("%a %b %e %H:%M:%S %Y")


  # @alias #asctime
  ctime: @prototype.asctime


  dup: ->
    new R.Time(new Date(@__native__), @__utc_offset__)


  year: ->
    # getYear() returns 2 or 3 digit year
    new R.Fixnum(@_tzdate.getFullYear())


  # @alias #mon
  month: ->
    new R.Fixnum(@_tzdate.getMonth() + 1)


  mon: @prototype.month


  monday: ->
    @wday().to_native() is 1


  tuesday: ->
    @wday().to_native() is 2


  wednesday: ->
    @wday().to_native() is 3


  thursday: ->
    @wday().to_native() is 4


  friday: ->
    @wday().to_native() is 5


  saturday: ->
    @wday().to_native() is 6


  sunday: ->
    @wday().to_native() is 0




  # Returns the day of the month (1..n) for time.
  #
  # @example
  #     t = Time.now()   #=> 2007-11-19 08:27:03 -0600
  #     t.day()          #=> 19
  #     t.mday()         #=> 19
  #
  # @alias #mday
  #
  day: ->
    new R.Fixnum(@_tzdate.getDate())


  # @alias #day
  mday: @prototype.day


  # Returns a new new_time object representing time in UTC.
  #
  # @example
  #     t = R.Time.local(2000,1,1,20,15,1)   #=> 2000-01-01 20:15:01 -0600
  #     t.gmt()                              #=> false
  #     y = t.getgm()                        #=> 2000-01-02 02:15:01 UTC
  #     y.gmt())                             #=> true
  #     t == y                               #=> true
  #
  # @alias #getutc
  #
  getgm: ->
    new R.Time(@__native__, 0)


  getutc: @prototype.getgm


  # Returns true if time represents a time in UTC (GMT).
  #
  # @example
  #
  #     t = Time.now()                      #=> 2007-11-19 08:15:23 -0600
  #     t.utc(                              #=> false
  #     t = Time.gm(2000,"jan",1,20,15,1)   #=> 2000-01-01 20:15:01 UTC
  #     t.utc()                             #=> true
  #
  #     t = Time.now()                      #=> 2007-11-19 08:16:03 -0600
  #     t.gmt()                             #=> false
  #     t = Time.gm(2000,1,1,20,15,1)       #=> 2000-01-01 20:15:01 UTC
  #     t.gmt()                             #=> true
  #
  # @alias #is_utc
  #
  gmt: ->
    @__utc_offset__ == 0


  # @alias #gmt
  is_utc: @prototype.gmt


  # Returns the offset in seconds between the timezone of time and UTC.
  #
  # @offset
  #     t = R.Time.gm(2000,1,1,20,15,1)   #=> 2000-01-01 20:15:01 UTC
  #     t.gmt_offset()                    #=> 0
  #     l = t.getlocal()                  #=> 2000-01-01 14:15:01 -0600
  #     l.gmt_offset()                    #=> -21600
  #
  # @alias #gmtoff, #utc_offset
  #
  # @return R.Fixnum offset in seconds
  #
  gmt_offset: ->
    new R.Fixnum(@__utc_offset__)


  # @alias #gmt_offset
  gmtoff:     @prototype.gmt_offset


  # @alias #gmt_offset
  utc_offset: @prototype.gmt_offset


  # Converts time to UTC (GMT), modifying the receiver.
  #
  # t = Time.now   #=> 2007-11-19 08:18:31 -0600
  # t.gmt?         #=> false
  # t.gmtime       #=> 2007-11-19 14:18:31 UTC
  # t.gmt?         #=> true
  #
  gmtime: ->
    @_tzdate = new Date(@__native__ - @__utc_offset__ * 1000)
    @__utc_offset__ = 0
    this


  hour: ->
    new R.Fixnum(@_tzdate.getHours())


  hour12: ->
    new R.Fixnum(@_tzdate.getHours() % 12)


  inspect: ->
    if @gmt()
      @strftime('%Y-%m-%d %H:%M:%S UTC')
    else
      @strftime('%Y-%m-%d %H:%M:%S %z')

  # Returns the minute of the hour (0..59) for time.
  #
  # @example
  #
  #     t = R.Time.now()   #=> 2007-11-19 08:25:51 -0600
  #     t.min()            #=> 25
  #
  min: ->
    new R.Fixnum(@_tzdate.getMinutes())


  # Returns the second of the minute (0..60)[Yes, seconds really can range
  # from zero to 60. This allows the system to inject leap seconds every now
  # and then to correct for the fact that years are not really a convenient
  # number of hours long.] for time.
  #
  # @example
  #
  #     t = R.Time.now()   #=> 2007-11-19 08:25:02 -0600
  #     t.sec()            #=> 2
  #
  sec: ->
    new R.Fixnum(@_tzdate.getSeconds())


  # @todo: implement %N
  strftime: (format) ->
    locale = R.Time.LOCALE

    fill = @_rjust

    self = this
    out = format.replace /%(.)/g, (_, flag) ->
      switch flag
        when 'a' then locale.DAYS_SHORT[self.wday()]
        when 'A' then locale.DAYS[self.wday()]
        when 'b' then locale.MONTHS_SHORT[self.month()]
        when 'B' then locale.MONTHS[self.month()]
        when 'C' then self.year() % 100
        when 'd' then fill(self.day())
        when 'D' then self.strftime('%m/%d/%y')
        when 'e' then fill(self.day(), ' ') # TODO write spec for this
        when 'F' then self.strftime('%Y-%m-%d')
        when 'h' then locale.MONTHS_SHORT[self.month()]
        when 'H' then fill(self.hour())
        when 'I' then fill(self.hour12())
        when 'j'
          jtime = new Date(self.year(), 0, 1).getTime()
          Math.ceil((self._tzdate.getTime() - jtime) / (1000*60*60*24))
        when 'k' then self.hour().to_s().rjust(2, ' ')
        # when 'L' then pad(Math.floor(d.getTime() % 1000), 3)
        when 'l' then fill(self.hour12(), ' ')
        when 'm' then fill(self.month())
        when 'M' then fill(self.min())
        when 'n' then "\n"
        when 'N' then throw R.NotImplementedError.new()
        when 'p'
          if self.hour() < 12 then locale.AM     else locale.PM
        when 'P'
          if self.hour() < 12 then locale.AM_LOW else locale.PM_LOW
        when 'r' then self.strftime('%I:%M:%S %p')
        when 'R' then self.strftime('%H:%M')
        when 'S' then fill(self.sec())
        # when 's' then Math.floor((d.getTime() - msDelta) / 1000)
        when 't' then "\t"
        when 'T' then self.strftime('%H:%M:%S')
        when 'u'
          day = self.wday().to_native()
          if day == 0 then 7 else day
        when 'v' then self.strftime('%e-%b-%Y')
        when 'w' then self.wday()
        when 'y' then self.year().to_s().slice(-2, 2)
        when 'Y' then self.year()
        when 'x' then self.strftime('%m/%d/%y')
        when 'X' then self.strftime('%H:%M:%S')
        when 'z' then self._offset_str()
        when 'Z' then self.zone()
        else flag

    new R.String(out)


  succ: ->
    R.Time.at(@to_i().succ())


  # Returns the value of time as an integer number of seconds since the Epoch.
  #
  # @example
  #     t = R.Time.now()
  #     "%10.5f" % t.to_f   #=> "1270968656.89607"
  #     t.to_i              #=> 1270968656
  #
  to_i: ->
    R(@__native__.getTime() / 1000).to_i()


  # Returns the value of time as a floating point number of seconds since the
  # Epoch.
  #
  # t = R.Time.now()
  # "%10.5f" % t.to_f   #=> "1270968744.77658"
  # t.to_i              #=> 1270968744
  # Note that IEEE 754 double is not accurate enough to represent number of nanoseconds from the Epoch.
  #
  to_f: ->
    new R.Float(@to_i() + ((@valueOf() % 1000) / 1000))


  to_s: @prototype.inspect


  __tz_delta__: ->
    @__utc_offset__ + R.Time._local_timezone()

  # Return 0 if local timezone matches gmt_offset.
  # otherwise the difference to UTC
  __utc_delta__: ->
    @gmt_offset() + R.Time._local_timezone()


  tv_sec: @prototype.to_i


  # Returns just the number of microseconds for time.
  #
  # @example
  #     t = Time.now        #=> 2007-11-19 08:03:26 -0600
  #     "%10.6f" % t.to_f   #=> "1195481006.775195"
  #     t.usec              #=> 775195
  #
  # @alias #usec
  # @todo implement
  #
  tv_usec: ->
    # valueOf is milliseconds since epochs.
    # get the milliseconds only and convert to microsecs
    new R.Fixnum((@_tzdate.valueOf() % 1000)*1000)


  usec: @prototype.tv_usec


  # Returns an integer representing the day of the week, 0..6, with Sunday == 0.
  #
  # @example
  #     t = Time.now()   #=> 2007-11-20 02:35:35 -0600
  #     t.wday()         #=> 2
  #     t.sunday()      #=> false
  #     t.monday()      #=> false
  #     t.tuesday()     #=> true
  #     t.wednesday()   #=> false
  #     t.thursday()    #=> false
  #     t.friday()      #=> false
  #     t.saturday()    #=> false
  #
  wday: ->
    # time zone adjusted date
    new R.Fixnum(@_tzdate.getDay())


  # Returns an integer representing the day of the year, 1..366.
  #
  # @example
  #     t = Time.now()   #=> 2007-11-19 08:32:31 -0600
  #     t.yday()         #=> 323
  yday: ->
    ytd    = new Date(@year(),0,0)
    secs   = @__native__.getTime() + @gmt_offset() * 1000 - ytd.getTime()
    R(Math.floor(secs / 86400000)) # 24 * 60 * 60 * 1000


  valueOf: ->
    @__native__.valueOf()


  # Returns the name of the time zone used for time. As of Ruby 1.8, returns
  # “UTC” rather than “GMT” for UTC times.
  #
  # @example
  #     t = R.Time.gm(2000, "jan", 1, 20, 15, 1)
  #     t.zone()   #=> "UTC"
  #     t = Time.local(2000, "jan", 1, 20, 15, 1)
  #     t.zone()   #=> "CST"
  # zone: ->
  #   t = Math.floor(@gmt_offset() / 60 * 60)
  #   for own zone, i in R.Time.TIME_ZONES
  #     return R(zone) if t == i
  #   null
  #
  # @todo implement
  zone: ->
    if @gmt()
      new R.String('UTC')
    else
      throw R.NotImplementedError.new("Time#zone only supports UTC/GMT")

  # ---- Private methods ------------------------------------------------------

  _rjust: (fixnum, str = '0') ->
    new R.String(fixnum + "").rjust(2, str)


  _offset_str: ->
    mins = @gmt_offset() / 60
    if mins == 0
      return '+0000'

    sign = if mins > 0 then '+' else '-'
    mins = Math.abs(mins)
    hour = @_rjust(Math.ceil(mins / 60))
    mins = @_rjust(mins % 60)
    (sign+hour+mins)


  # ---- Aliases --------------------------------------------------------------

  @__add_default_aliases__(@prototype)

  eql: @prototype['==']
