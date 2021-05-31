class BookSerializer < ActiveModel::Serializer
  attributes :id, :title, :author, :description, :category

  def category
    CategorySerializer.new(object.category).attributes
  end
end
