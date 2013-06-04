module HashSpecs
  class MyHash < hash_class; end

  class MyInitializerHash < hash_class

    def initialize
      raise "Constructor called"


  class NewHash < hash_class
    def initialize(*args)
      args.each_with_index do |val, index|
        self[index] = val

  class DefaultHash < hash_class
    def default(key)
      100

  class ToHashHash < hash_class
    def to_hash
      new_hash "to_hash" => "was", "called!" => "duh."

  def self.empty_frozen_hash
    @empty ||= new_hash
    @empty.freeze
    @empty

  def self.frozen_hash
    @hash ||= new_hash(1 => 2, 3 => 4)
    @hash.freeze
    @hash
end
