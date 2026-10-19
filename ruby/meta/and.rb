# frozen_string_literal: true

Mutant::Meta::Example.add :and do
  source 'true and false'

  singleton_mutations
  mutation 'true'
  mutation 'false'
  mutation 'false and false'
  mutation 'true and true'
  mutation 'true or false'
end

Mutant::Meta::Example.add :and do
  source '(a = b) && a'

  mutation '(a = b)'
  mutation '(a = b) || a'
  mutation '(a = nil) && a'
  mutation '(a = b) && nil'
end
