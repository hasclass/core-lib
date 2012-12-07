# describe 'ruby_version_is ""..."1.9"', ->
#   describe "MatchData#select", ->
#     it "yields the contents of the match array to a block", ->
#        m = R(/(.)(.)(\d+)(\d)/).match("THX1138: The Movie")
#        expect( m.select (x) -> x ).toEqual R(["HX1138", "H", "X", "113", "8"])
