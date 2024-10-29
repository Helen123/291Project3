class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  validates :title, presence: true
  validates :content, presence: true
  validate :check_for_election_influence

  private

  # Custom validation to prevent election-related content
  def check_for_election_influence
    if content.match?(/trump|harris/i) or title.match?(/trump|harris/i)
      errors.add(:content, "contains prohibited election-related content. Stay neutral!")
    end
  end
end