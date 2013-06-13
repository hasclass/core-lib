class TimeMethods
  _rjust: (fixnum, str = '0') ->
    _str.rjust(fixnum + "", 2, str)


  strftime: (date, format) ->
    locale = R.Time.LOCALE
    fill   = _time._rjust
    out = format.replace /%(.)/g, (_, flag) ->
      switch flag
        when 'a' then locale.DAYS_SHORT[_time.wday(date)]
        when 'A' then locale.DAYS[_time.wday(date)]
        when 'b' then locale.MONTHS_SHORT[_time.month(date)]
        when 'B' then locale.MONTHS[_time.month(date)]
        when 'C' then _time.year(date) % 100
        when 'd' then fill(_time.day(date))
        when 'D' then _time.strftime(date,'%m/%d/%y')
        when 'e' then fill(_time.day(date), ' ') # TODO write spec for this
        when 'F' then _time.strftime(date,'%Y-%m-%d')
        when 'h' then locale.MONTHS_SHORT[_time.month(date)]
        when 'H' then fill(_time.hour(date))
        when 'I' then fill(_time.hour12(date))
        when 'j'
          jtime = new Date(_time.year(date), 0, 1).getTime()
          Math.ceil((date.getTime() - jtime) / (1000*60*60*24))
        when 'k' then _str.rjust(""+_time.hour(date), 2, ' ')
        # when 'L' then pad(Math.floor(d.getTime() % 1000), 3)
        when 'l' then fill(_time.hour12(date), ' ')
        when 'm' then fill(_time.month(date))
        when 'M' then fill(_time.min(date))
        when 'n' then "\n"
        when 'N' then throw R.NotImplementedError.new()
        when 'p'
          if _time.hour(date) < 12 then locale.AM     else locale.PM
        when 'P'
          if _time.hour(date) < 12 then locale.AM_LOW else locale.PM_LOW
        when 'r' then _time.strftime(date,'%I:%M:%S %p')
        when 'R' then _time.strftime(date,'%H:%M')
        when 'S' then fill(_time.sec(date))
        # BUG Wrong behaviour:
        when 's' then Math.floor((date.getTime()) / 1000)
        when 't' then "\t"
        when 'T' then _time.strftime(date,'%H:%M:%S')
        when 'u'
          day = _time.wday(date)
          if day == 0 then 7 else day
        when 'v' then _time.strftime(date,'%e-%b-%Y')
        when 'w' then _time.wday(date)
        when 'y' then _str.slice(_time.year(date)+"", -2, 2)
        when 'Y' then _time.year(date)
        when 'x' then _time.strftime(date,'%m/%d/%y')
        when 'X' then _time.strftime(date,'%H:%M:%S')
        when 'z' then _time._offset_str(date)
        when 'Z' then _time.zone(date)
        else flag

    out


  # Returns a canonical string representation of time.
  #
  # Time.now.asctime   #=> "Wed Apr  9 08:56:03 2003"
  #
  # @alias #ctime
  #
  asctime: (date) ->
    _time.strftime(date, "%a %b %e %H:%M:%S %Y")


  # @alias #asctime
  ctime: @prototype.asctime


  year: (date) ->
    # getYear() returns 2 or 3 digit year
    date.getFullYear()


  # @alias #mon
  month: (date) ->
    date.getMonth() + 1


  mon: @prototype.month


  monday: (date) ->
    _time.wday(date) is 1


  tuesday: (date) ->
    _time.wday(date) is 2


  wednesday: (date) ->
    _time.wday(date) is 3


  thursday: (date) ->
    _time.wday(date) is 4


  friday: (date) ->
    _time.wday(date) is 5


  saturday: (date) ->
    _time.wday(date) is 6


  sunday: (date) ->
    _time.wday(date) is 0




  # Returns the day of the month (1..n) for time.
  #
  # @example
  #     t = Time.now()   #=> 2007-11-19 08:27:03 -0600
  #     t.day()          #=> 19
  #     t.mday()         #=> 19
  #
  # @alias #mday
  #
  day: (date) ->
    date.getDate()


  # @alias #day
  mday: @prototype.day


  hour: (date) ->
    date.getHours()


  hour12: (date) ->
    date.getHours() % 12


  # Returns the minute of the hour (0..59) for time.
  #
  # @example
  #
  #     t = R.Time.now()   #=> 2007-11-19 08:25:51 -0600
  #     t.min()            #=> 25
  #
  min: (date) ->
    date.getMinutes()


  sec: (date) ->
    date.getSeconds()


  tv_usec: (date) ->
    # valueOf is milliseconds since epochs.
    # get the milliseconds only and convert to microsecs
    (date.valueOf() % 1000)*1000


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
  wday: (date) ->
    # time zone adjusted date
    date.getDay()


  # Returns an integer representing the day of the year, 1..366.
  #
  # @example
  #     t = Time.now()   #=> 2007-11-19 08:32:31 -0600
  #     t.yday()         #=> 323
  yday: (date) ->
    # ytd    = new Date(_time.year(date),0,0)
    secs   = date.getTime()
    Math.floor(secs / 86400000) # 24 * 60 * 60 * 1000


  gmt_offset: (date) ->
    date.getTimezoneOffset() * -60

  _offset_str: (date) ->
    offset = _time.gmt_offset(date)
    mins = offset / 60
    if mins == 0
      return '+0000'

    sign = if mins > 0 then '+' else '-'
    mins = Math.abs(mins)
    hour = @_rjust(Math.ceil(mins / 60))
    mins = @_rjust(mins % 60)
    (sign+hour+mins)


_time = R._time = (arr) ->
  new R.Time(arr)

R.extend(_time, new TimeMethods())
