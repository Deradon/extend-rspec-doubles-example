# obj.extend(Foo) with RSpec doubles

RSpec doubles can not be changed by extending its instances.

## Minimal example

Please note that the example described here is just a minimal example
to demonstrate the problem. The original classes are more complex and
the behaviour that is specced (`obj.extend(Something)`) is needed and
can not be changed.

### Spec

Let us have a look at the spec first.
In the following example you can see the spec how I'd like it to look like:

```
require 'spec_helper'

RSpec.describe Modifier do
  subject(:modifier) { described_class.new(active) }

  describe "#apply_to(obj)" do
    subject(:obj) { instance_double(Foo, foo: "foo") }

    before { modifier.apply_to(obj) }

    context "when active" do
      let(:active) { true }
      its(:foo) { is_expected.to eq("extended-foo") }  # NOTE: This one will fail
    end

    context "when not active" do
      let(:active) { false }
      its(:foo) { is_expected.to eq("foo") }
    end
  end
end
```

Unfortunately, this is not working :(

```
Failures:

  1) Modifier#apply_to(obj) when active foo should eq "extended-foo"
     Failure/Error: its(:foo) { is_expected.to eq("extended-foo") }

       expected: "extended-foo"
            got: "foo"
```

### Foo

```
class Foo
  attr_reader :foo

  def initialize(foo)
    @foo = foo
  end
end
```

### Modifier

This class will modify given objects by extending its instance methods.

```
class Modifier
  def initialize(active)
    @active = active
  end

  # NOTE: This is the interesting method
  def apply_to(obj)
    return unless active?

    obj.extend(Extended)     # NOTE: And this is the interesting LOC
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
```

## Even more minimal example

The whole problem can be broken down to the following code snippet:

```
module Bar
  def foo
    "bar"
  end
end

double = RSpec::Mocks::Double.new("Foo", foo: "foo")
obj = Object.new

double.extend(Bar)
obj.extend(Bar)

double.foo
# => "foo"

obj.foo
# => "bar"
```

## Conclusion

RSpec doubles can not be changed by extending its instances, which is expected behaviour?
If so, how can you create readable specs for the example described here?

## Links

* Repo to reproduce: [Extend RSpec doubles (Example)](https://github.com/Deradon/extend-rspec-doubles-example)
* RSpec: [Using an instance double](https://relishapp.com/rspec/rspec-mocks/v/3-4/docs/verifying-doubles/using-an-instance-double)
