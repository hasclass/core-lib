require File.expand_path('../../../../spec_helper', __FILE__)
require File.expand_path('../../fixtures/classes', __FILE__)
require File.expand_path('../shared/basic', __FILE__)
require File.expand_path('../shared/numeric_basic', __FILE__)
require File.expand_path('../shared/integer', __FILE__)

describe "Array#pack with format 'S'", ->
  it_behaves_like :array_pack_basic, 'S'
  it_behaves_like :array_pack_basic_non_float, 'S'
  it_behaves_like :array_pack_arguments, 'S'
  it_behaves_like :array_pack_numeric_basic, 'S'
  it_behaves_like :array_pack_integer, 'S'
end

describe "Array#pack with format 's'", ->
  it_behaves_like :array_pack_basic, 's'
  it_behaves_like :array_pack_basic_non_float, 's'
  it_behaves_like :array_pack_arguments, 's'
  it_behaves_like :array_pack_numeric_basic, 's'
  it_behaves_like :array_pack_integer, 's'
end

ruby_version_is "1.9.3", ->
  describe "Array#pack with format 'S'", ->
    describe "with modifier '<'", ->
      it_behaves_like :array_pack_16bit_le, 'S<'
  
    describe "with modifier '<' and '_'", ->
      it_behaves_like :array_pack_16bit_le, 'S<_'
      it_behaves_like :array_pack_16bit_le, 'S_<'
  
    describe "with modifier '<' and '!'", ->
      it_behaves_like :array_pack_16bit_le, 'S<!'
      it_behaves_like :array_pack_16bit_le, 'S!<'
  
    describe "with modifier '>'", ->
      it_behaves_like :array_pack_16bit_be, 'S>'
  
    describe "with modifier '>' and '_'", ->
      it_behaves_like :array_pack_16bit_be, 'S>_'
      it_behaves_like :array_pack_16bit_be, 'S_>'
  
    describe "with modifier '>' and '!'", ->
      it_behaves_like :array_pack_16bit_be, 'S>!'
      it_behaves_like :array_pack_16bit_be, 'S!>'
  
  describe "Array#pack with format 's'", ->
    describe "with modifier '<'", ->
      it_behaves_like :array_pack_16bit_le, 's<'
  
    describe "with modifier '<' and '_'", ->
      it_behaves_like :array_pack_16bit_le, 's<_'
      it_behaves_like :array_pack_16bit_le, 's_<'
  
    describe "with modifier '<' and '!'", ->
      it_behaves_like :array_pack_16bit_le, 's<!'
      it_behaves_like :array_pack_16bit_le, 's!<'
  
    describe "with modifier '>'", ->
      it_behaves_like :array_pack_16bit_be, 's>'
  
    describe "with modifier '>' and '_'", ->
      it_behaves_like :array_pack_16bit_be, 's>_'
      it_behaves_like :array_pack_16bit_be, 's_>'
  
    describe "with modifier '>' and '!'", ->
      it_behaves_like :array_pack_16bit_be, 's>!'
      it_behaves_like :array_pack_16bit_be, 's!>'

little_endian do
  describe "Array#pack with format 'S'", ->
    it_behaves_like :array_pack_16bit_le, 'S'

  describe "Array#pack with format 'S' with modifier '_'", ->
    it_behaves_like :array_pack_16bit_le, 'S_'

  describe "Array#pack with format 'S' with modifier '!'", ->
    it_behaves_like :array_pack_16bit_le, 'S!'

  describe "Array#pack with format 's'", ->
    it_behaves_like :array_pack_16bit_le, 's'

  describe "Array#pack with format 's' with modifier '_'", ->
    it_behaves_like :array_pack_16bit_le, 's_'

  describe "Array#pack with format 's' with modifier '!'", ->
    it_behaves_like :array_pack_16bit_le, 's!'
end

big_endian do
  describe "Array#pack with format 'S'", ->
    it_behaves_like :array_pack_16bit_be, 'S'

  describe "Array#pack with format 'S' with modifier '_'", ->
    it_behaves_like :array_pack_16bit_be, 'S_'

  describe "Array#pack with format 'S' with modifier '!'", ->
    it_behaves_like :array_pack_16bit_be, 'S!'

  describe "Array#pack with format 's'", ->
    it_behaves_like :array_pack_16bit_be, 's'

  describe "Array#pack with format 's' with modifier '_'", ->
    it_behaves_like :array_pack_16bit_be, 's_'

  describe "Array#pack with format 's' with modifier '!'", ->
    it_behaves_like :array_pack_16bit_be, 's!'
end
