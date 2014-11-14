module Society

  class Edge

    attr_reader :from, :to
    attr_accessor :meta

    include Ephemeral::Base

    scope :about, lambda {|name| select{|e| e.from.full_name == name || e.to.full_name == name}}

    def initialize(from:, to:, meta:nil)
      @from = from
      @to = to
      @meta = meta
    end

  end

end
