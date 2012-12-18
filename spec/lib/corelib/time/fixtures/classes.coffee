# module TimeSpecs

#   class SubTime < Time;

root = global ? window

root.with_timezone = (txt, offset = 0, block) ->
  fn = R.Time._local_timezone
  R.Time._local_timezone = ->
    (offset * -3600)

  block()

  R.Time._local_timezone = fn
