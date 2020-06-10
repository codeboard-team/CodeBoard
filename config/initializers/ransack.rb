module Arel
  module Predications
    def contains(other)
      Nodes::Equality.new(Nodes.build_quoted(other, self), Nodes::NamedFunction.new('ANY', [self]))
    end
  end
end

Ransack.configure do |config|
  config.add_predicate :contains_array, arel_predicate: :contains
end