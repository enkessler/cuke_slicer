module CukeSlicer

  # Some helper methods used during testing
  module HelperMethods

    def self.test_storage
      @test_storage ||= {}
    end

  end
end
