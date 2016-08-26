module Models

  class Source
    attr_reader :name, :path

    def initialize(name, path = nil)
      @name = name
      @path = path
    end
  end

end
