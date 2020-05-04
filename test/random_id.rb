module RandomId
  MIN_ID = 100
  MAX_ID = 2**30 - 1 - MIN_ID

  def self.included(klass)
    klass.extend(ClassMethods)
    klass.before_save(:random_id)
  end

  def random_id
    primary_key = self.class.primary_key

    self.id = self.class.generate_id if primary_key && send(primary_key).nil?
  end

  module ClassMethods
    def existing_ids
      @existing_ids ||= []
    end

    def generate_id
      id = MIN_ID + rand(MAX_ID)
      return generate_id if existing_ids.include?(id)

      existing_ids << id

      id
    end
  end
end
