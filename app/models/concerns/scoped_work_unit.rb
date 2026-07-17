module ScopedWorkUnit
  extend ActiveSupport::Concern

  class_methods do
    def scope_self_reference
      belongs_to :"parent_#{model_name.element}", class_name: name, optional: true
      has_many :"child_#{model_name.collection}", class_name: name, foreign_key: :parent_unit_id
    end

    def im_completable
      define_method(:completable) do
        true
      end

      define_method(:completable=) do |_value|
        true
      end
    end
  end
end