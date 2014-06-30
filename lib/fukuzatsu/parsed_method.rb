class ParsedMethod

  include PoroPlus
  include Ephemeral::Base

  attr_accessor :method_body, :method_name, :complexity, :loc

end