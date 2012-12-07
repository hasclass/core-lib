require File.expand_path('../../fixtures/encoded_strings', __FILE__)

describe :array_inspect, :shared => true do
  it "returns a string", ->
    [1, 2, 3].send(@method).should be_kind_of(String)

  it "returns '[]' for an empty Array", ->
    [].send(@method).should == "[]"

  it "calls inspect on its elements and joins the results with commas", ->
    items = Array.new(3) do |i|
      obj = mock(i.to_s)
      obj.should_receive(:inspect).and_return(i.to_s)
      obj
      items.send(@method).should == "[0, 1, 2]"

  it "represents a recursive element with '[...]'", ->
    ArraySpecs.recursive_array.send(@method).should == "[1, \"two\", 3.0, [...], [...], [...], [...], [...]]"
    ArraySpecs.head_recursive_array.send(@method).should == "[[...], [...], [...], [...], [...], 1, \"two\", 3.0]"
    ArraySpecs.empty_recursive_array.send(@method).should == "[[...]]"

  it "taints the result if the Array is non-empty and tainted", ->
    [1, 2].taint.send(@method).tainted?.should be_true

  it "does not taint the result if the Array is tainted but empty", ->
    [].taint.send(@method).tainted?.should be_false

  it "taints the result if an element is tainted", ->
    ["str".taint].send(@method).tainted?.should be_true

  ruby_version_is "1.9", ->
    it "untrusts the result if the Array is untrusted", ->
      [1, 2].untrust.send(@method).untrusted?.should be_true
  
    it "does not untrust the result if the Array is untrusted but empty", ->
      [].untrust.send(@method).untrusted?.should be_false
  
    it "untrusts the result if an element is untrusted", ->
      ["str".untrust].send(@method).untrusted?.should be_true
  
  ruby_version_is "1.9", ->
    it "returns a US-ASCII string for an empty Array", ->
      [].send(@method).encoding.should == Encoding::US_ASCII
  
    it "copies the ASCII-compatible encoding of the result of inspecting the first element", ->
      euc_jp = mock("euc_jp")
      euc_jp.should_receive(:inspect).and_return("euc_jp".encode!(Encoding::EUC_JP))

      utf_8 = mock("utf_8")
      utf_8.should_receive(:inspect).and_return("utf_8".encode!(Encoding::UTF_8))

      result = [euc_jp, utf_8].send(@method)
      result.encoding.should == Encoding::EUC_JP
      result.should == "[euc_jp, utf_8]".encode(Encoding::EUC_JP)
  
    ruby_bug "5848", "2.0", ->
      it "copies the ASCII-incompatible encoding of the result of inspecting the first element", ->
        utf_16be = mock("utf_16be")
        utf_16be.should_receive(:inspect).and_return("utf_16be".encode!(Encoding::UTF_16BE))

        result = [utf_16be].send(@method)
        result.encoding.should == Encoding::UTF_16BE
        result.should == "[utf_16be]".encode(Encoding::UTF_16BE)
      
    it "raises if inspecting two elements produces incompatible encodings", ->
      utf_8 = mock("utf_8")
      utf_8.should_receive(:inspect).and_return("utf_8".encode!(Encoding::UTF_8))

      utf_16be = mock("utf_16be")
      utf_16be.should_receive(:inspect).and_return("utf_16be".encode!(Encoding::UTF_16BE))

      expect( -> [utf_8, utf_16be].send(@method) ).toThrow(Encoding::CompatibilityError)
