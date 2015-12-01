RSpec.describe Dry::Validation::Schema do
  subject(:validation) { schema.new }

  describe 'defining schema with rule groups' do
    let(:schema) do
      Class.new(Dry::Validation::Schema) do
        confirmation(:password)
      end
    end

    describe '#call' do
      it 'returns empty errors when password matches confirmation' do
        expect(validation.(password: 'foo', password_confirmation: 'foo')).to be_empty
      end

      it 'returns error for a failed group rule' do
        expect(validation.(password: 'foo', password_confirmation: 'bar')).to match_array([
          [:error, [
            :input, [
              :password_confirmation,
              ["foo", "bar"],
              [[:group, [:password_confirmation, [:predicate, [:eql?, []]]]]]]]
          ]
        ])
      end
    end
  end
end
