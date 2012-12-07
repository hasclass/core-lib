describe :enumeratorize, :shared => true do
  ruby_version_is '' ... '1.8.7' do
    it "raises a LocalJumpError if no block given", ->
      lambda{ [1,2].send(@method) ).toThrow(LocalJumpError)
    ruby_version_is '1.8.7' do
    it "returns an Enumerator if no block given", ->
      [1,2].send(@method).should be_an_instance_of(enumerator_class)
