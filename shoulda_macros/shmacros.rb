module Shmacros
  module Units
    ##
    #  Asserts that model has accept_nested_attribtues_for defined for specific models.
    #
    #    should_accept_nested_attributes_for :foo, :bar 
    #
    def should_accept_nested_attributes_for(*attr_names)
      klass = self.name.gsub(/Test$/, '').constantize

      context "#{klass}" do
        attr_names.each do |association_name|
          should "accept nested attrs for #{association_name}" do
            meth = "#{association_name}_attributes="
            assert  ([meth,meth.to_sym].any?{ |m| klass.instance_methods.include?(m) }),
                    "#{klass} does not accept nested attributes for #{association_name}"
          end
        end
      end
    end
    
    ##
    #  Asserts that model has act_as_taggable_on defined for certain categories.
    #
    #    should_act_as_taggable_on :category_name
    #    (default :category_name is :tags)
    #
    def should_act_as_taggable_on(category = :tags)
      klass = self.name.gsub(/Test$/, '').constantize

      should "include ActAsTaggableOn #{':' + category.to_s} methods" do
        assert klass.extended_by.include?(ActiveRecord::Acts::TaggableOn::ClassMethods)
        assert klass.extended_by.include?(ActiveRecord::Acts::TaggableOn::SingletonMethods)
        assert klass.include?(ActiveRecord::Acts::TaggableOn::InstanceMethods)
      end

      should_have_many :taggings, category
    end
        
    ##
    #  Asserts that model klass is_a?(Foo) or is_a?(Bar)
    #
    #    should_be Foo, Bar
    #
    def should_be(*ancestors)
      klass = self.name.gsub(/Test$/, '').constantize

      context "#{klass}" do
        ancestors.each do |ancestor|
          should "be #{ancestor}" do
            assert  klass.new.is_a?(ancestor),
                    "#{klass} is not #{ancestor}"
          end
        end
      end
    end
  
    ##
    #  Asserts that model defines callback for a certain method.
    #
    #    should_callback :foo, :after_save
    #    should_callback :bar, :baz, :before_save
    #
    def should_callback(*meths)
      if meths.size < 2
        raise(RuntimeError, "Expecting legal callback type as last argument.")
      end
    
      klass = self.name.gsub(/Test$/, '').constantize
      callback_type = meths.delete(meths.last).to_s
        
      for meth in meths
        have_certain_callback = "call ##{meth} #{callback_type.to_s.gsub(/_/, ' ')}"
        should have_certain_callback do
          existing_callbacks = klass.send(callback_type)
          result = existing_callbacks.detect { |callback| callback.kind == callback_type.to_sym && callback.method == meth.to_sym }
          assert_not_nil result, "##{meth} is not called #{callback_type.to_s.gsub(/_/, ' ')}"
        end
      end
    end
  
    ##
    #  Asserts that model defines an attachment with Paperclip
    #
    #    should_have_attached_file :picture
    #
    # def should_have_attached_file(attachment)
    #   klass = self.name.gsub(/Test$/, '').constantize
    # 
    #   context "#{klass}" do
    #     should_have_db_column("#{attachment}_file_name", :type => :string)
    #     should_have_db_column("#{attachment}_content_type", :type => :string)
    #     should_have_db_column("#{attachment}_file_size", :type => :integer)
    #   end
    # 
    #   should "have attachment ##{attachment}" do
    #     assert klass.new.respond_to?(attachment.to_sym),
    #            "@#{klass.name.underscore} doesn't have a paperclip field named #{attachment}"
    #     assert_equal ::Paperclip::Attachment, klass.new.send(attachment.to_sym).class
    #   end
    # end
  
    ##
    #  Asserts that model validates an associated model
    #
    #    should_validate_associated :foo, :bar
    #
    def should_validate_associated(*associations)
      klass = self.name.gsub(/Test$/, '').constantize
      associations.each do |association|
        should "validate associated #{association}" do
          assert klass.new.respond_to?("validate_associated_records_for_#{association}")
        end
      end
    end
  end
end

class ActiveSupport::TestCase
  extend Shmacros::Units
end