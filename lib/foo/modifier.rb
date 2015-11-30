class Foo
  class Modifier
    def initialize(active)
      @active = active
    end

    def apply_to(obj)
      return unless active?

      obj.extend(Extended)
    end

    def active?
      @active
    end

    private

    attr_reader :active

    module Extended
      def foo
        "extended-#{super}"
      end
    end
  end
end
