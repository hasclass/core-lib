require File.expand_path('../../../../spec_helper', __FILE__)
require File.expand_path('../../fixtures/classes', __FILE__)
require File.expand_path('../shared/basic', __FILE__)
require File.expand_path('../shared/numeric_basic', __FILE__)
require File.expand_path('../shared/integer', __FILE__)

describe "Array#pack with format 'I'", ->
  it_behaves_like :array_pack_basic, 'I'
  it_behaves_like :array_pack_basic_non_float, 'I'
  it_behaves_like :array_pack_arguments, 'I'
  it_behaves_like :array_pack_numeric_basic, 'I'
  it_behaves_like :array_pack_integer, 'I'
end

describe "Array#pack with format 'i'", ->
  it_behaves_like :array_pack_basic, 'i'
  it_behaves_like :array_pack_basic_non_float, 'i'
  it_behaves_like :array_pack_arguments, 'i'
  it_behaves_like :array_pack_numeric_basic, 'i'
  it_behaves_like :array_pack_integer, 'i'
end

ruby_version_is "1.9.3", ->
  describe "Array#pack with format 'I'", ->
    describe "with modifier '<'", ->
      it_behaves_like :array_pack_32bit_le, 'I<'
  
    describe "with modifier '<' and '_'", ->
      it_behaves_like :array_pack_32bit_le, 'I<_'
      it_behaves_like :array_pack_32bit_le, 'I_<'
  
    describe "with modifier '<' and '!'", ->
      it_behaves_like :array_pack_32bit_le, 'I<!'
      it_behaves_like :array_pack_32bit_le, 'I!<'
  
    describe "with modifier '>'", ->
      it_behaves_like :array_pack_32bit_be, 'I>'
  
    describe "with modifier '>' and '_'", ->
      it_behaves_like :array_pack_32bit_be, 'I>_'
      it_behaves_like :array_pack_32bit_be, 'I_>'
  
    describe "with modifier '>' and '!'", ->
      it_behaves_like :array_pack_32bit_be, 'I>!'
      it_behaves_like :array_pack_32bit_be, 'I!>'
  
  describe "Array#pack with format 'i'", ->
    describe "with modifier '<'", ->
      it_behaves_like :array_pack_32bit_le, 'i<'
  
    describe "with modifier '<' and '_'", ->
      it_behaves_like :array_pack_32bit_le, 'i<_'
      it_behaves_like :array_pack_32bit_le, 'i_<'
  
    describe "with modifier '<' and '!'", ->
      it_behaves_like :array_pack_32bit_le, 'i<!'
      it_behaves_like :array_pack_32bit_le, 'i!<'
  
    describe "with modifier '>'", ->
      it_behaves_like :array_pack_32bit_be, 'i>'
  
    describe "with modifier '>' and '_'", ->
      it_behaves_like :array_pack_32bit_be, 'i>_'
      it_behaves_like :array_pack_32bit_be, 'i_>'
  
    describe "with modifier '>' and '!'", ->
      it_behaves_like :array_pack_32bit_be, 'i>!'
      it_behaves_like :array_pack_32bit_be, 'i!>'

little_endian do
  describe "Array#pack with format 'I'", ->
    it_behaves_like :array_pack_32bit_le, 'I'

  describe "Array#pack with format 'I' with modifier '_'", ->
    it_behaves_like :array_pack_32bit_le_platform, 'I_'

  describe "Array#pack with format 'I' with modifier '!'", ->
    it_behaves_like :array_pack_32bit_le_platform, 'I!'

  describe "Array#pack with format 'i'", ->
    it_behaves_like :array_pack_32bit_le, 'i'

  describe "Array#pack with format 'i' with modifier '_'", ->
    it_behaves_like :array_pack_32bit_le_platform, 'i_'

  describe "Array#pack with format 'i' with modifier '!'", ->
    it_behaves_like :array_pack_32bit_le_platform, 'i!'
end

big_endian do
  describe "Array#pack with format 'I'", ->
    it_behaves_like :array_pack_32bit_be, 'I'

  describe "Array#pack with format 'I' with modifier '_'", ->
    it_behaves_like :array_pack_32bit_be_platform, 'I_'

  describe "Array#pack with format 'I' with modifier '!'", ->
    it_behaves_like :array_pack_32bit_be_platform, 'I!'

  describe "Array#pack with format 'i'", ->
    it_behaves_like :array_pack_32bit_be, 'i'

  describe "Array#pack with format 'i' with modifier '_'", ->
    it_behaves_like :array_pack_32bit_be_platform, 'i_'

  describe "Array#pack with format 'i' with modifier '!'", ->
    it_behaves_like :array_pack_32bit_be_platform, 'i!'
end
