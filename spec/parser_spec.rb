# require "spec_helper"

# describe Society::Parser do

#   class FakeActiveRecord
#     def self.belongs_to(name, scope=nil, options={}, &extension)
#       @@belongs_to ||= []
#       @@belongs_to << {
#         name: name,
#         klass: (name || options[:class_name]).to_s.capitalize
#       }
#     end
#     def self.has_many(name, scope=nil, options={}, &extension)
#       @@has_many ||= []
#       @@has_many << {
#         klass: options[:class_name].to_s.capitalize,
#         name: name
#       }
#     end
#   end

#   describe "graph" do

#     let(:parent_source) {
#       %q{
#         class Parent < FakeActiveRecord
#           has_many :children, class_name: :child
#           attr_accessor :name
#         end
#       }
#     }

#     let(:child_source) {
#       %q{
#         class Child < FakeActiveRecord
#           belongs_to :parent
#           def initialize(parent)
#             self.parent = parent
#           end
#           def who_am_i
#             "I am the child of #{self.parent.name}"
#           end
#         end
#       }
#     }

#     let(:parser) { Society::Parser.new }

#     it "registers a has_many relation" do
#     it "registers a belongs_to relation"

#   end

# end
