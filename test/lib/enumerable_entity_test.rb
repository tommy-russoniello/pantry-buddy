class EnumerableEntityTest < ActiveSupport::TestCase
  class TestClass
    include ActiveModel::Model
    include EnumerableEntity

    attr_accessor :name, :id

    def self.all
      [
        new(name: 'First', id: 10),
        new(name: 'Second Item', id: 22),
        new(name: 'Third/Item', id: 35)
      ]
    end
  end

  test('name validation') do
    instance = TestClass.new

    assert_not(instance.valid?, 'not valid')
    assert_equal({ name: ['can\'t be blank'] }, instance.errors.messages, 'error messages')

    instance.name = 'New Item'

    assert(instance.valid?, 'valid')
  end

  test('dashed_name') do
    instance = TestClass.new(name: 'Test Name')

    assert_equal('test-name', instance.dashed_name, 'dashed name')
  end

  test('self.ids') do
    assert_equal(
      {
        # Expose names as symbols
        first: 10,
        second_item: 22,
        third_item: 35,

        # Also expose names as strings
        'first' => 10,
        'second-item' => 22,
        'third-item' => 35
      },
      TestClass.ids,
      'ids'
    )
  end

  test('self.names') do
    assert_equal(
      {
        10 => 'first',
        22 => 'second-item',
        35 => 'third-item'
      },
      TestClass.names,
      'names'
    )
  end

  test('self.pretty_names') do
    assert_equal(
      {
        'first' => 'First',
        'second-item' => 'Second Item',
        'third-item' => 'Third/Item'
      },
      TestClass.pretty_names,
      'pretty_names'
    )
  end
end
