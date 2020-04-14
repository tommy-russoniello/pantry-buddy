module EnumerableEntity
  def self.included(klass)
    klass.validates(:name, presence: true)
    klass.validates(:name, uniqueness: { case_sensitive: false }) if klass < ActiveRecord::Base

    klass.extend(ClassMethods)
    klass.extend(NonActiveRecordClassMethods) unless klass < ActiveRecord::Base
  end

  def dashed_name
    name.downcase.tr(' /', '-')
  end

  module ClassMethods
    def ids
      return @ids if @ids

      populate_caches
      @ids
    end

    def names
      return @names if @names

      populate_caches
      @names
    end

    def pretty_names
      return @pretty_names if @pretty_names

      populate_caches
      @pretty_names
    end

    private

    def populate_caches
      @ids = {}
      @names = {}
      @pretty_names = {}

      all.each do |current, _|
        dashed_name = current.name.downcase.tr(' /', '-')

        @ids[dashed_name] = @ids[dashed_name.tr('-', '_').to_sym] = current.id
        @names[current.id] = dashed_name
        @pretty_names[dashed_name] = current.name
      end
    end
  end

  module NonActiveRecordClassMethods
    def random
      find(random_id)
    end

    def random_id
      random_ids.first
    end

    def random_ids(limit = 1)
      ids.values.sample(limit)
    end
  end
end
