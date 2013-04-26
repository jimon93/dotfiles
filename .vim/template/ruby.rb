# Extend ============= {{{
# Maybe #{{{
class NilClass
  def method_missing( method_name, *args )
    nil
  end
end #}}}
# input {{{
Input = STDIN.each_line.lazy.map(&:chomp)
class << Input
  def nums( sep = ' ', converter = :to_i )
    self.map{ |line|
      line.split( sep ).map( &converter )
    }
  end
  def method_missing( method_name, *args )
    self.map{ |str| str.public_send( method_name, *args ) }
  end
end
# }}}
# Enumerable Extend #{{{
module Enumerable
  #alias :filter :find_all
  def count_by(&block)
    Hash[ group_by(&block).map{ |key,vals| [key, vals.size] } ]
  end
end #}}}
# Identity #{{{
class Object
  def identity
    self
  end
end #}}}
# ==================== }}}
