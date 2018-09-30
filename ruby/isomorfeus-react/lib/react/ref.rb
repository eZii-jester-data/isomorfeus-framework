module React
  class Ref
    include ::Native::Wrapper

    def initialize(native_ref)
      @native = native_ref
    end
  end
end