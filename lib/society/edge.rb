module Society

  class Edge

    attr_reader :from, :to
    attr_accessor :meta

    include Ephemeral::Base

    def initialize(from:, to:, meta:nil)
      @from = from
      @to = to
      @meta = meta
    end

  end

end
