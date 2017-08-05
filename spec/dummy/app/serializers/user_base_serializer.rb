class UserBaseSerializer < ActiveModel::Serializer
  def initials
    return nil unless object
    name = object.name
    if name
      name.split.map{|w|w[0]}.join.upcase
    else
      nil
    end
  end
end
