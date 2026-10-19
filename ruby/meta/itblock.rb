# frozen_string_literal: true

if RUBY_VERSION > '3.4.0'
  Mutant::Meta::Example.add :itblock do
    source 'foo(false) { it.to_s }'

    singleton_mutations
    mutation 'foo(true) { it.to_s }'
    mutation 'foo { it.to_s }'
    mutation 'foo(false) { it }'
    mutation 'foo(false) { it.to_str }'
  end

  Mutant::Meta::Example.add :itblock do
    source 'foo { it.bar(1) { it } }'

    singleton_mutations
    mutation 'foo { it.bar { it } }'
    mutation 'foo { it.bar(nil) { it } }'
    mutation 'foo { it.bar(0) { it } }'
    mutation 'foo { it.bar(2) { it } }'
    mutation 'foo { it.bar(167) { it } }'
  end

  Mutant::Meta::Example.add :itblock do
    source 'foo { it.bar { |it| it } }'

    singleton_mutations
    mutation 'foo { it.bar }'
    mutation 'foo { it }'
    mutation 'foo { it.bar { |it| } }'
    mutation 'foo { it.bar { |it| raise } }'
    mutation 'foo { it.bar { |it| nil } }'
  end

  Mutant::Meta::Example.add :itblock do
    source 'foo { it; def bar(it) = it }'

    singleton_mutations
    mutation 'foo { it }'
    mutation 'foo { it; def bar(it); end }'
    mutation 'foo { it; def bar(it); raise; end }'
    mutation 'foo { it; def bar(it); super; end }'
    mutation 'foo { it; def bar(it); nil; end }'
  end

  Mutant::Meta::Example.add :itblock do
    source 'foo { it; def self.bar(it) = it }'

    singleton_mutations
    mutation 'foo { it }'
    mutation 'foo { it; def self.bar(it); end }'
    mutation 'foo { it; def self.bar(it); raise; end }'
    mutation 'foo { it; def self.bar(it); super; end }'
    mutation 'foo { it; def self.bar(it); nil; end }'
  end

  Mutant::Meta::Example.add :itblock do
    source 'foo { def it.bar = 1 }'

    singleton_mutations
    mutation 'foo { def it.bar; end }'
    mutation 'foo { def it.bar; raise; end }'
    mutation 'foo { def it.bar; super; end }'
    mutation 'foo { def it.bar; nil; end }'
    mutation 'foo { def it.bar; 0; end }'
    mutation 'foo { def it.bar; 2; end }'
    mutation 'foo { def it.bar; 167; end }'
  end

  Mutant::Meta::Example.add :itblock do
    source 'foo { bar(it, 1) }'

    singleton_mutations
    mutation 'foo { bar(it) }'
    mutation 'foo { bar(it, nil) }'
    mutation 'foo { bar(it, 0) }'
    mutation 'foo { bar(it, 2) }'
    mutation 'foo { bar(it, 167) }'
  end

  Mutant::Meta::Example.add :itblock do
    source 'foo { bar(:it, it, 1) }'

    singleton_mutations
    mutation 'foo { bar(nil, it, 1) }'
    mutation 'foo { bar(:it__mutant__, it, 1) }'
    mutation 'foo { bar(it, 1) }'
    mutation 'foo { bar(:it, it, nil) }'
    mutation 'foo { bar(:it, it, 0) }'
    mutation 'foo { bar(:it, it, 2) }'
    mutation 'foo { bar(:it, it, 167) }'
    mutation 'foo { bar(:it, it) }'
  end

  Mutant::Meta::Example.add :itblock do
    source 'foo { bar = 1; it }'

    singleton_mutations
    mutation 'foo { bar = nil; it }'
    mutation 'foo { bar = 0; it }'
    mutation 'foo { bar = 2; it }'
    mutation 'foo { bar = 167; it }'
  end

  Mutant::Meta::Example.add :itblock do
    source 'foo { it; it = 1; it }'

    singleton_mutations
    mutation 'foo { it; it = nil; it }'
    mutation 'foo { it; it = 0; it }'
    mutation 'foo { it; it = 2; it }'
    mutation 'foo { it; it = 167; it }'
    mutation 'foo { it; it = 1; nil }'
    mutation 'foo { it; it = 1 }'
  end

  Mutant::Meta::Example.add :itblock do
    source 'foo { it; 1 => it; it }'

    singleton_mutations
    mutation 'foo { it; nil => it; it }'
    mutation 'foo { it; 0 => it; it }'
    mutation 'foo { it; 2 => it; it }'
    mutation 'foo { it; 167 => it; it }'
    mutation 'foo { it; it }'
    mutation 'foo { it; 1 => it; nil }'
    mutation 'foo { it; 1 => it }'
  end

  Mutant::Meta::Example.add :itblock do
    source 'foo { it; it = 1 if it }'

    singleton_mutations
    mutation 'foo { it; nil }'
    mutation 'foo { it; if nil; it = 1; end }'
    mutation 'foo { it; if true; it = 1; end }'
    mutation 'foo { it; if false; it = 1; end }'
    mutation 'foo { it; it = 1 }'
    mutation 'foo { it; it = nil if it }'
    mutation 'foo { it; it = 0 if it }'
    mutation 'foo { it; it = 2 if it }'
    mutation 'foo { it; it = 167 if it }'
  end

  Mutant::Meta::Example.add :itblock do
    source 'foo { bar if it }'

    singleton_mutations
    mutation 'foo { if it; nil; end }'
  end

  Mutant::Meta::Example.add :itblock do
    source 'foo { it; if (it = 1) then it else 2 end }'

    singleton_mutations
    mutation 'foo { it; nil }'
    mutation 'foo { it; if (it = nil) then it else 2 end }'
    mutation 'foo { it; if (it = 0) then it else 2 end }'
    mutation 'foo { it; if (it = 2) then it else 2 end }'
    mutation 'foo { it; if (it = 167) then it else 2 end }'
    mutation 'foo { it; if true then it else 2 end }'
    mutation 'foo { it; if false then it else 2 end }'
    mutation 'foo { it; if (it = 1) then 2 end }'
    mutation 'foo { it; it }'
    mutation 'foo { it; if (it = 1) then nil else 2 end }'
    mutation 'foo { it; if (it = 1) then it end }'
    mutation 'foo { it; 2 }'
    mutation 'foo { it; if (it = 1) then it else nil end }'
    mutation 'foo { it; if (it = 1) then it else 0 end }'
    mutation 'foo { it; if (it = 1) then it else 1 end }'
    mutation 'foo { it; if (it = 1) then it else 3 end }'
    mutation 'foo { it; if (it = 1) then it else 167 end }'
    mutation 'foo { it; unless (it = 1) then 2 end }'
  end

  Mutant::Meta::Example.add :itblock do
    source 'foo { it; it = 1 while it }'

    singleton_mutations
    mutation 'foo { it; nil }'
    mutation 'foo { it; while nil; it = 1; end }'
    mutation 'foo { it; it = 1 until it }'
    mutation 'foo { it; it = nil while it }'
    mutation 'foo { it; it = 0 while it }'
    mutation 'foo { it; it = 2 while it }'
    mutation 'foo { it; it = 167 while it }'
    mutation 'foo { it; while it; end }'
    mutation 'foo { it; while it; raise; end }'
  end

  Mutant::Meta::Example.add :itblock do
    source 'foo { it; it = 1 until it }'

    singleton_mutations
    mutation 'foo { it; nil }'
    mutation 'foo { it; until nil; it = 1; end }'
    mutation 'foo { it; it = 1 while it }'
    mutation 'foo { it; it = nil until it }'
    mutation 'foo { it; it = 0 until it }'
    mutation 'foo { it; it = 2 until it }'
    mutation 'foo { it; it = 167 until it }'
    mutation 'foo { it; until it; end }'
    mutation 'foo { it; until it; raise; end }'
  end

  Mutant::Meta::Example.add :itblock do
    source 'foo { it; begin; it = 1; end while it }'

    singleton_mutations
    mutation 'foo { it; nil }'
    mutation 'foo { it; begin; it = 1; end while nil }'
    mutation 'foo { it; begin; it = 1; end until it }'
    mutation 'foo { it; begin; it = nil; end while it }'
    mutation 'foo { it; begin; it = 0; end while it }'
    mutation 'foo { it; begin; it = 2; end while it }'
    mutation 'foo { it; begin; it = 167; end while it }'
    mutation 'foo { it; begin; raise; end while it }'
  end

  Mutant::Meta::Example.add :itblock do
    source 'foo { it; begin; it = 1; end until it }'

    singleton_mutations
    mutation 'foo { it; nil }'
    mutation 'foo { it; begin; it = 1; end until nil }'
    mutation 'foo { it; begin; it = 1; end while it }'
    mutation 'foo { it; begin; it = nil; end until it }'
    mutation 'foo { it; begin; it = 0; end until it }'
    mutation 'foo { it; begin; it = 2; end until it }'
    mutation 'foo { it; begin; it = 167; end until it }'
    mutation 'foo { it; begin; raise; end until it }'
  end

  Mutant::Meta::Example.add :itblock do
    source 'foo { it; class Bar < it; end }'

    singleton_mutations
    mutation 'foo { nil; class Bar < it; end }'
    mutation 'foo { class Bar < it; end }'
    mutation 'foo { it }'
  end

  Mutant::Meta::Example.add :itblock do
    source 'foo { class Bar; it = 1; end; it }'

    singleton_mutations
    mutation 'foo { class Bar; it = nil; end; it }'
    mutation 'foo { class Bar; it = 0; end; it }'
    mutation 'foo { class Bar; it = 2; end; it }'
    mutation 'foo { class Bar; it = 167; end; it }'
    mutation 'foo { it }'
  end

  Mutant::Meta::Example.add :itblock do
    source 'foo { module Bar; it = 1; end; it }'

    singleton_mutations
    mutation 'foo { module Bar; it = nil; end; it }'
    mutation 'foo { module Bar; it = 0; end; it }'
    mutation 'foo { module Bar; it = 2; end; it }'
    mutation 'foo { module Bar; it = 167; end; it }'
    mutation 'foo { it }'
  end

  Mutant::Meta::Example.add :itblock do
    source 'foo { class << self; it = 1; end; it }'

    singleton_mutations
    mutation 'foo { class << self; it = nil; end; it }'
    mutation 'foo { class << self; it = 0; end; it }'
    mutation 'foo { class << self; it = 2; end; it }'
    mutation 'foo { class << self; it = 167; end; it }'
    mutation 'foo { it }'
  end
end
