# describe "Range#initialize", ->
#   it "is private", ->
#     Range.should have_private_instance_method("initialize")

#   it "raises an ArgumentError if passed without or with only an argument", ->
#     lambda { (1..3).__send__(:initialize) }.
#       should raise_error(ArgumentError)
#     lambda { (1..3).__send__(:initialize, 1) }.
#       should raise_error(ArgumentError)

#   it "raises a NameError if passed with two or three arguments", ->
#     lambda { (1..3).__send__(:initialize, 1, 3) }.
#       should raise_error(NameError)
#     lambda { (1..3).__send__(:initialize, 1, 3, 5) }.
#       should raise_error(NameError)

#   it "raises an ArgumentError if passed with four or more arguments", ->
#     lambda { (1..3).__send__(:initialize, 1, 3, 5, 7) }.
#       should raise_error(ArgumentError)
#     lambda { (1..3).__send__(:initialize, 1, 3, 5, 7, 9) }.
#       should raise_error(ArgumentError)
