class ParsedFile

    include PoroPlus
    include Ephemeral::Base
    collects :parsed_methods

    attr_accessor :filename, :full_path, :class_name

end