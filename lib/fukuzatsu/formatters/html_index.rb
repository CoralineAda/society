module Formatters

  class Html

    include Formatters::Base

    attr_accessor :file_list

    def initialize(file_list)
      self.file_list = file_list
    end

    def output_path
      output_path = "doc/fukuzatsu/index.htm}"
      FileUtils.mkpath(output_path)
      output_path
    end

    def content(file_list)
      Haml::Engine.new(index_template).render(
        Object.new, {
          file_list: file_list,
          date: Time.now.strftime("%Y/%m/%d"),
          time: Time.now.strftime("%l:%M %P")
        }
      )
    end

    def output_template
      File.read(File.dirname(__FILE__) + "/templates/index.html.haml")
    end

  end

end