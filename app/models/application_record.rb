class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def inherited(subclass)
    subclass.static_attribute(:created_at) if subclass.attribute_names.include?('created_at')
    subclass.static_attribute(:updated_at) if subclass.attribute_names.include?('updated_at')
  end

  def first_id
    limit(1).pluck(:id).first
  end

  def random
    order(Arel.sql('RAND()')).first
  end

  def random_id
    random_ids.first
  end

  def random_ids(limit = 1)
    order(Arel.sql('RAND()')).limit(limit).pluck(:id)
  end

  def static_attribute(attribute, options = {})
    attribute_alias = options[:alias] || attribute

    class_eval(<<-RUBY, __FILE__, __LINE__ + 1)
      validate :#{attribute_alias}_not_changed

      private

      def #{attribute_alias}_not_changed
        #{"return if #{attribute}_was.nil?" if options[:once_set]}
        
        errors.add(:#{attribute_alias}, 'cannot be changed') if #{attribute}_changed? &&
          persisted?
      end
    RUBY
  end
end
