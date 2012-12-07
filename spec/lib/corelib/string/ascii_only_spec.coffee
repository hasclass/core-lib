# describe "String#ascii_only?", ->
#   describe "with ASCII only characters", ->
#     it "returns true if the encoding is UTF-8", ->
#       [ ["hello",                         true],
#         ["hello".encode('UTF-8'),         true],
#         ["hello".force_encoding('UTF-8'), true],
#       ].should be_computed_by(:ascii_only?)

#     it "returns true if the encoding is US-ASCII", ->
#       "hello".force_encoding(Encoding::US_ASCII).ascii_only?.should be_true
#       "hello".encode(Encoding::US_ASCII).ascii_only?.should be_true

#     it "returns true for all single-character UTF-8 Strings", ->
#       0.upto(127), -> |n|
#         n.chr.ascii_only?.should be_true

#   describe "with non-ASCII only characters", ->
#     it "returns false if the encoding is ASCII-8BIT", ->
#       chr = 128.chr
#       chr.encoding.should == Encoding::ASCII_8BIT
#       chr.ascii_only?.should be_false

#     it "returns false if the String contains any non-ASCII characters", ->
#       [ ["\u{6666}",                          false],
#         ["hello, \u{6666}",                   false],
#         ["\u{6666}".encode('UTF-8'),          false],
#         ["\u{6666}".force_encoding('UTF-8'),  false],
#       ].should be_computed_by(:ascii_only?)

#     it "returns false if the encoding is US-ASCII", ->
#       [ ["\u{6666}".force_encoding(Encoding::US_ASCII),         false],
#         ["hello, \u{6666}".force_encoding(Encoding::US_ASCII),  false],
#       ].should be_computed_by(:ascii_only?)


#   it "returns true for the empty String with an ASCII-compatible encoding", ->
#     "".ascii_only?.should be_true
#     "".encode('UTF-8').ascii_only?.should be_true

#   it "returns false for the empty String with a non-ASCII-compatible encoding", ->
#     "".force_encoding('UTF-16LE').ascii_only?.should be_false
#     "".encode('UTF-16BE').ascii_only?.should be_false

#   it "returns false for a non-empty String with non-ASCII-compatible encoding", ->
#     "\x78\x00".force_encoding("UTF-16LE").ascii_only?.should be_false
