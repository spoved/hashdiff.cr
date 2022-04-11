struct Hashdiff::DiffResult(Y, Z)
  property mode : String
  property path : Y
  property value : Z
  property new_value : Z | Nil

  # include Enumerable(String | Y | Z | Nil)

  def initialize(@mode, @path, @value, @new_value = nil); end

  def ==(other : Tuple | DiffResult)
    if other.size == 3
      other[0] == mode && other[1] == path && other[2] == value
    else
      other[0] == mode && other[1] == path && other[2] == value && other[3]? == new_value
    end
  end

  def self.new(value : Tuple(String, V, X)) forall V, X
    DiffResult(V, X).new(value[0], value[1], value[2])
  end

  def self.new(value : Tuple(String, V, X, W)) forall V, X, W
    DiffResult(V, X | W).new(value[0], value[1], value[2], value[3])
  end

  def [](index)
    case index
    when 0 then mode
    when 1 then path
    when 2 then value
    when 3 then new_value
    else        raise "invalid index #{index}"
    end
  end

  def []?(index)
    self[index]
  end

  def to_t : Tuple(String, Y, Z) | Tuple(String, Y, Z, Z | Nil)
    case mode
    when "-", "+"
      Tuple(String, Y, Z).new(@mode, @path, @value)
    when "~"
      Tuple(String, Y, Z, Z | Nil).new(@mode, @path, @value, @new_value)
    else
      raise "invalid mode #{mode}"
    end
  end

  def to_a : Array(String | Y | Z) | Array(String | Y | Z | Nil)
    case mode
    when "-", "+" then [mode, path, value]
    when "~"      then [mode, path, value, new_value]
    else               raise "invalid mode #{mode}"
    end
  end

  macro method_missing(call)
    self.to_t.{{call}}
  end
end
