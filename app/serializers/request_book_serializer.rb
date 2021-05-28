class RequestBookSerializer < ActiveModel::Serializer
  attributes :id, :book, :amount

  def book
    BookSerializer.new(object.book).attributes
  end
end
