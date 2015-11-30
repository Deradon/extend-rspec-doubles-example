require "foo/modifier"
require "foo/version"

class Foo
  attr_reader :foo

  def initialize(foo)
    @foo = foo
  end
end
