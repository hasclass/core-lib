require File.expand_path('../../../../spec_helper', __FILE__)
require File.expand_path('../../fixtures/classes', __FILE__)
require File.expand_path('../shared/basic', __FILE__)
require File.expand_path('../shared/numeric_basic', __FILE__)
require File.expand_path('../shared/integer', __FILE__)

describe "Array#pack with format 'L'", ->
  it_behaves_like :array_pack_basic, 'L'
  it_behaves_like :array_pack_basic_non_float, 'L'
  it_behaves_like :array_pack_arguments, 'L'
  it_behaves_like :array_pack_numeric_basic, 'L'
  it_behaves_like :array_pack_integer, 'L'
end

describe "Array#pack with format 'l'", ->
  it_behaves_like :array_pack_basic, 'l'
  it_behaves_like :array_pack_basic_non_float, 'l'
  it_behaves_like :array_pack_arguments, 'l'
  it_behaves_like :array_pack_numeric_basic, 'l'
  it_behaves_like :array_pack_integer, 'l'
end

ruby_version_is "1.9.3", ->
  describe "Array#pack with format 'L'", ->
    describe "with modifier '<'", ->
      it_behaves_like :array_pack_32bit_le, 'L<'
  
    describe "with modifier '>'", ->
      it_behaves_like :array_pack_32bit_be, 'L>'
  
    platform_is :wordsize => 32 do
      describe "with modifier '<' and '_'", ->
        it_behaves_like :array_pack_32bit_le, 'L<_'
        it_behaves_like :array_pack_32bit_le, 'L_<'
    
      describe "with modifier '<' and '!'", ->
        it_behaves_like :array_pack_32bit_le, 'L<!'
        it_behaves_like :array_pack_32bit_le, 'L!<'
    
      describe "with modifier '>' and '_'", ->
        it_behaves_like :array_pack_32bit_be, 'L>_'
        it_behaves_like :array_pack_32bit_be, 'L_>'
    
      describe "with modifier '>' and '!'", ->
        it_behaves_like :array_pack_32bit_be, 'L>!'
        it_behaves_like :array_pack_32bit_be, 'L!>'
      
    platform_is :wordsize => 64 do
      platform_is_not :os => :windows do
        describe "with modifier '<' and '_'", ->
          it_behaves_like :array_pack_64bit_le, 'L<_'
          it_behaves_like :array_pack_64bit_le, 'L_<'
      
        describe "with modifier '<' and '!'", ->
          it_behaves_like :array_pack_64bit_le, 'L<!'
          it_behaves_like :array_pack_64bit_le, 'L!<'
      
        describe "with modifier '>' and '_'", ->
          it_behaves_like :array_pack_64bit_be, 'L>_'
          it_behaves_like :array_pack_64bit_be, 'L_>'
      
        describe "with modifier '>' and '!'", ->
          it_behaves_like :array_pack_64bit_be, 'L>!'
          it_behaves_like :array_pack_64bit_be, 'L!>'
          
      platform_is :os => :windows do
        not_compliant_on :jruby do
          describe "with modifier '<' and '_'", ->
            it_behaves_like :array_pack_32bit_le, 'L<_'
            it_behaves_like :array_pack_32bit_le, 'L_<'
        
          describe "with modifier '<' and '!'", ->
            it_behaves_like :array_pack_32bit_le, 'L<!'
            it_behaves_like :array_pack_32bit_le, 'L!<'
        
          describe "with modifier '>' and '_'", ->
            it_behaves_like :array_pack_32bit_be, 'L>_'
            it_behaves_like :array_pack_32bit_be, 'L_>'
        
          describe "with modifier '>' and '!'", ->
            it_behaves_like :array_pack_32bit_be, 'L>!'
            it_behaves_like :array_pack_32bit_be, 'L!>'
              
        deviates_on :jruby do
          describe "with modifier '<' and '_'", ->
            it_behaves_like :array_pack_64bit_le, 'L<_'
            it_behaves_like :array_pack_64bit_le, 'L_<'
        
          describe "with modifier '<' and '!'", ->
            it_behaves_like :array_pack_64bit_le, 'L<!'
            it_behaves_like :array_pack_64bit_le, 'L!<'
        
          describe "with modifier '>' and '_'", ->
            it_behaves_like :array_pack_64bit_be, 'L>_'
            it_behaves_like :array_pack_64bit_be, 'L_>'
        
          describe "with modifier '>' and '!'", ->
            it_behaves_like :array_pack_64bit_be, 'L>!'
            it_behaves_like :array_pack_64bit_be, 'L!>'
                    
  describe "Array#pack with format 'l'", ->
    describe "with modifier '<'", ->
      it_behaves_like :array_pack_32bit_le, 'l<'
  
    describe "with modifier '>'", ->
      it_behaves_like :array_pack_32bit_be, 'l>'
  
    platform_is :wordsize => 32 do
      describe "with modifier '<' and '_'", ->
        it_behaves_like :array_pack_32bit_le, 'l<_'
        it_behaves_like :array_pack_32bit_le, 'l_<'
    
      describe "with modifier '<' and '!'", ->
        it_behaves_like :array_pack_32bit_le, 'l<!'
        it_behaves_like :array_pack_32bit_le, 'l!<'
    
      describe "with modifier '>' and '_'", ->
        it_behaves_like :array_pack_32bit_be, 'l>_'
        it_behaves_like :array_pack_32bit_be, 'l_>'
    
      describe "with modifier '>' and '!'", ->
        it_behaves_like :array_pack_32bit_be, 'l>!'
        it_behaves_like :array_pack_32bit_be, 'l!>'
      
    platform_is :wordsize => 64 do
      platform_is_not :os => :windows do
        describe "with modifier '<' and '_'", ->
          it_behaves_like :array_pack_64bit_le, 'l<_'
          it_behaves_like :array_pack_64bit_le, 'l_<'
      
        describe "with modifier '<' and '!'", ->
          it_behaves_like :array_pack_64bit_le, 'l<!'
          it_behaves_like :array_pack_64bit_le, 'l!<'
      
        describe "with modifier '>' and '_'", ->
          it_behaves_like :array_pack_64bit_be, 'l>_'
          it_behaves_like :array_pack_64bit_be, 'l_>'
      
        describe "with modifier '>' and '!'", ->
          it_behaves_like :array_pack_64bit_be, 'l>!'
          it_behaves_like :array_pack_64bit_be, 'l!>'
          
      platform_is :os => :windows do
        not_compliant_on :jruby do
          describe "with modifier '<' and '_'", ->
            it_behaves_like :array_pack_32bit_le, 'l<_'
            it_behaves_like :array_pack_32bit_le, 'l_<'
        
          describe "with modifier '<' and '!'", ->
            it_behaves_like :array_pack_32bit_le, 'l<!'
            it_behaves_like :array_pack_32bit_le, 'l!<'
        
          describe "with modifier '>' and '_'", ->
            it_behaves_like :array_pack_32bit_be, 'l>_'
            it_behaves_like :array_pack_32bit_be, 'l_>'
        
          describe "with modifier '>' and '!'", ->
            it_behaves_like :array_pack_32bit_be, 'l>!'
            it_behaves_like :array_pack_32bit_be, 'l!>'
              
        deviates_on :jruby do
          describe "with modifier '<' and '_'", ->
            it_behaves_like :array_pack_64bit_le, 'l<_'
            it_behaves_like :array_pack_64bit_le, 'l_<'
        
          describe "with modifier '<' and '!'", ->
            it_behaves_like :array_pack_64bit_le, 'l<!'
            it_behaves_like :array_pack_64bit_le, 'l!<'
        
          describe "with modifier '>' and '_'", ->
            it_behaves_like :array_pack_64bit_be, 'l>_'
            it_behaves_like :array_pack_64bit_be, 'l_>'
        
          describe "with modifier '>' and '!'", ->
            it_behaves_like :array_pack_64bit_be, 'l>!'
            it_behaves_like :array_pack_64bit_be, 'l!>'
                  
little_endian do
  describe "Array#pack with format 'L'", ->
    it_behaves_like :array_pack_32bit_le, 'L'

  describe "Array#pack with format 'l'", ->
    it_behaves_like :array_pack_32bit_le, 'l'

  platform_is :wordsize => 32 do
    describe "Array#pack with format 'L' with modifier '_'", ->
      it_behaves_like :array_pack_32bit_le, 'L_'
  
    describe "Array#pack with format 'L' with modifier '!'", ->
      it_behaves_like :array_pack_32bit_le, 'L!'
  
    describe "Array#pack with format 'l' with modifier '_'", ->
      it_behaves_like :array_pack_32bit_le, 'l_'
  
    describe "Array#pack with format 'l' with modifier '!'", ->
      it_behaves_like :array_pack_32bit_le, 'l!'
  
  platform_is :wordsize => 64 do
    platform_is_not :os => :windows do
      describe "Array#pack with format 'L' with modifier '_'", ->
        it_behaves_like :array_pack_64bit_le, 'L_'
    
      describe "Array#pack with format 'L' with modifier '!'", ->
        it_behaves_like :array_pack_64bit_le, 'L!'
    
      describe "Array#pack with format 'l' with modifier '_'", ->
        it_behaves_like :array_pack_64bit_le, 'l_'
    
      describe "Array#pack with format 'l' with modifier '!'", ->
        it_behaves_like :array_pack_64bit_le, 'l!'
      
    platform_is :os => :windows do
      not_compliant_on :jruby do
        describe "Array#pack with format 'L' with modifier '_'", ->
          it_behaves_like :array_pack_32bit_le, 'L_'
      
        describe "Array#pack with format 'L' with modifier '!'", ->
          it_behaves_like :array_pack_32bit_le, 'L!'
      
        describe "Array#pack with format 'l' with modifier '_'", ->
          it_behaves_like :array_pack_32bit_le, 'l_'
      
        describe "Array#pack with format 'l' with modifier '!'", ->
          it_behaves_like :array_pack_32bit_le, 'l!'
          
      deviates_on :jruby do
        describe "Array#pack with format 'L' with modifier '_'", ->
          it_behaves_like :array_pack_64bit_le, 'L_'
      
        describe "Array#pack with format 'L' with modifier '!'", ->
          it_behaves_like :array_pack_64bit_le, 'L!'
      
        describe "Array#pack with format 'l' with modifier '_'", ->
          it_behaves_like :array_pack_64bit_le, 'l_'
      
        describe "Array#pack with format 'l' with modifier '!'", ->
          it_behaves_like :array_pack_64bit_le, 'l!'
          
big_endian do
  describe "Array#pack with format 'L'", ->
    it_behaves_like :array_pack_32bit_be, 'L'

  describe "Array#pack with format 'l'", ->
    it_behaves_like :array_pack_32bit_be, 'l'

  platform_is :wordsize => 32 do
    describe "Array#pack with format 'L' with modifier '_'", ->
      it_behaves_like :array_pack_32bit_be, 'L_'
  
    describe "Array#pack with format 'L' with modifier '!'", ->
      it_behaves_like :array_pack_32bit_be, 'L!'
  
    describe "Array#pack with format 'l' with modifier '_'", ->
      it_behaves_like :array_pack_32bit_be, 'l_'
  
    describe "Array#pack with format 'l' with modifier '!'", ->
      it_behaves_like :array_pack_32bit_be, 'l!'
  
  platform_is :wordsize => 64 do
    platform_is_not :os => :windows do
      describe "Array#pack with format 'L' with modifier '_'", ->
        it_behaves_like :array_pack_64bit_be, 'L_'
    
      describe "Array#pack with format 'L' with modifier '!'", ->
        it_behaves_like :array_pack_64bit_be, 'L!'
    
      describe "Array#pack with format 'l' with modifier '_'", ->
        it_behaves_like :array_pack_64bit_be, 'l_'
    
      describe "Array#pack with format 'l' with modifier '!'", ->
        it_behaves_like :array_pack_64bit_be, 'l!'
      
    platform_is :os => :windows do
      not_compliant_on :jruby do
        describe "Array#pack with format 'L' with modifier '_'", ->
          it_behaves_like :array_pack_32bit_be, 'L_'
      
        describe "Array#pack with format 'L' with modifier '!'", ->
          it_behaves_like :array_pack_32bit_be, 'L!'
      
        describe "Array#pack with format 'l' with modifier '_'", ->
          it_behaves_like :array_pack_32bit_be, 'l_'
      
        describe "Array#pack with format 'l' with modifier '!'", ->
          it_behaves_like :array_pack_32bit_be, 'l!'
          
      deviates_on :jruby do
        describe "Array#pack with format 'L' with modifier '_'", ->
          it_behaves_like :array_pack_64bit_be, 'L_'
      
        describe "Array#pack with format 'L' with modifier '!'", ->
          it_behaves_like :array_pack_64bit_be, 'L!'
      
        describe "Array#pack with format 'l' with modifier '_'", ->
          it_behaves_like :array_pack_64bit_be, 'l_'
      
        describe "Array#pack with format 'l' with modifier '!'", ->
          it_behaves_like :array_pack_64bit_be, 'l!'
          