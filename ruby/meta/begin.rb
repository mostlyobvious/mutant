# frozen_string_literal: true

Mutant::Meta::Example.add :begin do
  source 'true; false'

  mutation 'true; true'
  mutation 'false; false'
  mutation 'true'
  mutation 'false'
end

Mutant::Meta::Example.add :begin do
  source 'a = false; a'

  mutation 'a = false'
  mutation 'a = true; a'
  mutation 'a = false; nil'
end

Mutant::Meta::Example.add :begin do
  source 'true; true; true'

  mutation 'true; true; false'
  mutation 'true; false; true'
  mutation 'false; true; true'
  mutation 'true; true'
end

Mutant::Meta::Example.add :begin do
  source 'a = true; a'

  mutation 'a = false; a'
  mutation 'a = true; nil'
  mutation 'a = true'
end

Mutant::Meta::Example.add :begin do
  source '(true)'

  mutation '(false)'
end

Mutant::Meta::Example.add :begin do
  source '(true); true'

  mutation '(false); true'
  mutation '(true)'
  mutation '(true); false'
  mutation 'true'
end

Mutant::Meta::Example.add :begin do
  source 'a, b = true, true; a'

  mutation 'a, b = []; a'
  mutation 'a, b = [true]; a'
  mutation 'a, b = false, true; a'
  mutation 'a, b = nil; a'
  mutation 'a, b = true, false; a'
  mutation 'a, b = true, true'
  mutation 'a, b = true, true; nil'
end

Mutant::Meta::Example.add :begin do
  source 'foo.bar, foo.bar = true, true'

  mutation 'foo.bar, foo.bar = []'
  mutation 'foo.bar, foo.bar = [true]'
  mutation 'foo.bar, foo.bar = false, true'
  mutation 'foo.bar, foo.bar = nil'
  mutation 'foo.bar, foo.bar = true, false'
end

Mutant::Meta::Example.add :begin do
  source 'foo; 1'

  mutation '1'
  mutation 'foo'
  mutation 'foo; 0'
  mutation 'foo; 2'
  mutation 'foo; nil'
  mutation 'nil; 1'

  # overflow boundary probe (int8 zone)
  mutation 'foo; 167'
end

Mutant::Meta::Example.add :begin do
  source '((a = 1)); a'

  mutation '((a = 1))'
  mutation '((a = 1)); nil'
  mutation '((a = 2)); a'
  mutation '((a = 0)); a'
  mutation '((a = nil)); a'

  # overflow boundary probe (int8 zone)
  mutation '((a = 167)); a'
end

Mutant::Meta::Example.add :begin do
  source '((a; b))'

  mutation '((a; nil))'
  mutation '((nil; b))'
  mutation '(a)'
  mutation '(b)'
end

Mutant::Meta::Example.add :begin do
  source 'a; b'

  mutation 'a'
  mutation 'b'
  mutation 'nil; b'
  mutation 'a; nil'
end

Mutant::Meta::Example.add :begin do
  source <<~'RUBY'
    def foo
      a = nil
      a
    end
    a
  RUBY

  mutation <<~'RUBY'
    def foo
      a = nil
      a
    end
  RUBY

  mutation <<~'RUBY'
    def foo
      a = nil
      a
    end
    nil
  RUBY

  mutation <<~'RUBY'
    def foo
      a = nil
    end
    a
  RUBY

  mutation <<~'RUBY'
    def foo
      a = nil
      nil
    end
    a
  RUBY

  mutation <<~'RUBY'
    def foo
    end
    a
  RUBY

  mutation <<~'RUBY'
    def foo
      super
    end
    a
  RUBY

  mutation <<~'RUBY'
    def foo
      raise
    end
    a
  RUBY

  mutation 'a'
end

Mutant::Meta::Example.add :begin do
  source 'foo => { a: }; a'

  mutation 'nil => { a: }; a'
  mutation 'foo => { a: }; nil'
  mutation 'foo => { a: }'
end

Mutant::Meta::Example.add :begin do
  source 'foo in { a: }; a'

  mutation 'nil in { a: }; a'
  mutation 'foo in { a: }; nil'
  mutation 'foo in { a: }'
end

Mutant::Meta::Example.add :begin do
  source 'foo { |x| x }; bar'

  mutation 'nil; bar'
  mutation 'foo; bar'
  mutation 'foo { |x| }; bar'
  mutation 'foo { |x| raise }; bar'
  mutation 'foo { |x| nil }; bar'
  mutation 'bar'
  mutation 'foo { |x| x }; nil'
  mutation 'foo { |x| x }'
end

Mutant::Meta::Example.add :begin do
  source 'foo { a = _1 }; bar'

  mutation 'nil; bar'
  mutation 'bar'
  mutation 'foo { a = _1 }; nil'
  mutation 'foo { a = _1 }'
end

Mutant::Meta::Example.add :begin do
  source 'foo(a = 1) {}; bar'

  mutation 'nil; bar'
  mutation 'foo(a = 1); bar'
  mutation 'foo {}; bar'
  mutation 'foo(a = nil) {}; bar'
  mutation 'foo(a = 0) {}; bar'
  mutation 'foo(a = 2) {}; bar'
  mutation 'foo(a = 167) {}; bar'
  mutation 'foo(a = 1) { raise }; bar'
  mutation 'foo(a = 1) {}; nil'
  mutation 'foo(a = 1) {}'
end

if RUBY_VERSION > '3.4.0'
  Mutant::Meta::Example.add :begin do
    source 'foo { a = it }; bar'

    mutation 'nil; bar'
    mutation 'bar'
    mutation 'foo { a = it }; nil'
    mutation 'foo { a = it }'
  end
end
