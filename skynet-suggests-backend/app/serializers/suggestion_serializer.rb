class SuggestionSerializer < ActiveModel::Serializer
  attributes :id, :rows, :cols, :dp_id, :message, :severity, :file, :marker
  belongs_to :repo
  belongs_to :user
end
