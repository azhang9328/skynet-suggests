class SuggestionSerializer < ActiveModel::Serializer
  attributes :id, :rows, :cols, :type, :message, :severity
  belongs_to :repo
end
