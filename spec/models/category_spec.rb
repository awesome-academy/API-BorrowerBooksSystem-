require 'rails_helper'

RSpec.describe Category, type: :model do
  describe "Associations" do
    it "has many books" do
      should have_many(:books).dependent(:destroy)
    end

    it "has many child categories" do
      should have_many(:child_categories).class_name(Category.name).with_foreign_key(:parent_id).dependent(:destroy)
    end

    it "belong to parent category" do
      should belong_to(:parent).class_name(Category.name).optional
    end
  end

  describe "Validations" do
    context "validates name attribute" do
      it { should validate_presence_of(:name) }
      it { should validate_length_of(:name).is_at_most(Settings.category.name.max_length) }
    end
  end
end
