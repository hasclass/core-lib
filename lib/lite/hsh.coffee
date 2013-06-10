class HashMethods extends EnumerableMethods



_hsh = R._hsh = (arr) ->
  new RHash(arr)

R.extend(_hsh, new ArraHashMethodsyMethods())