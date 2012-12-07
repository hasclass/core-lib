require File.expand_path('../../../../spec_helper', __FILE__)
require File.expand_path('../../fixtures/classes', __FILE__)
require File.expand_path('../shared/basic', __FILE__)
require File.expand_path('../shared/numeric_basic', __FILE__)
require File.expand_path('../shared/integer', __FILE__)

describe "Array#pack with format 'Q'", ->
  it_behaves_like :array_pack_basic, 'Q'
  it_behaves_like :array_pack_basic_non_float, 'Q'
  it_behaves_like :array_pack_arguments, 'Q'
  it_behaves_like :array_pack_numeric_basic, 'Q'
  it_behaves_like :array_pack_integer, 'Q'
  it_behaves_like :array_pack_no_platform, 'Q'
end

describe "Array#pack with format 'q'", ->
  it_behaves_like :array_pack_basic, 'q'
  it_behaves_like :array_pack_basic_non_float, 'q'
  it_behaves_like :array_pack_arguments, 'q'
  it_behaves_like :array_pack_numeric_basic, 'q'
  it_behaves_like :array_pack_integer, 'q'
  it_behaves_like :array_pack_no_platform, 'q'
end

ruby_version_is "1.9.3", ->
  describe "Array#pack with format 'Q'", ->
    describe "with modifier '<'", ->
      it_behaves_like :array_pack_64bit_le, 'Q<'
  
    describe "with modifier '>'", ->
      it_behaves_like :array_pack_64bit_be, 'Q>'
  
  describe "Array#pack with format 'q'", ->
    describe "with modifier '<'", ->
      it_behaves_like :array_pack_64bit_le, 'q<'
  
    describe "with modifier '>'", ->
      it_behaves_like :array_pack_64bit_be, 'q>'

little_endian do
  describe "Array#pack with format 'Q'", ->
    it_behaves_like :array_pack_64bit_le, 'Q'

  describe "Array#pack with format 'q'", ->
    it_behaves_like :array_pack_64bit_le, 'q'
end

big_endian do
  describe "Array#pack with format 'Q'", ->
    it_behaves_like :array_pack_64bit_be, 'Q'

  describe "Array#pack with format 'q'", ->
    it_behaves_like :array_pack_64bit_be, 'q'
end
