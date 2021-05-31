class RequestSerializer < ActiveModel::Serializer
  attributes :id, :start_date, :end_date, :status, :created_at
  has_many :request_books

  def start_date
    object.start_date.strftime("%Y-%m-%d")
  end

  def end_date
    object.end_date.strftime("%Y-%m-%d")
  end

  def created_at
    object.created_at.strftime("%Y-%m-%d %H:%M:%S")
  end
end
