describe "String#dup", ->
  beforeEach ->
    @obj = new StringSpecs.InitializeString "string"

  it "calls #initialize_copy on the new instance", ->
    dup = @obj.dup()
    expect( dup.recorded ).toEqual(@obj.object_id)

  it "copies instance variables", ->
    dup = @obj.dup()
    expect( dup.ivar ).toEqual 1

  it "does not copy singleton methods", ->
    @obj.special = () -> 'the_one'
    dup = @obj.dup()
    expect( dup.special ).toEqual undefined

  # it "does not copy modules included in the singleton class", ->
  #   class << @obj
  #     include StringSpecs::StringModule

  #   dup = @obj.dup
  #   lambda { dup.repr }.should raise_error(NameError)

  # it "does not copy constants defined in the singleton class", ->
  #   class << @obj
  #     CLONE = :clone

  #   dup = @obj.dup
  #   lambda { class << dup; CLONE; end }.should raise_error(NameError)
