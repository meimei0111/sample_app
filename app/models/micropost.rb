class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: Settings.validations.content.max_length }
  validates :image, content_type: { in: Settings.image.type.split, message: I18n.t("errors.messages.invalid_image_format") }, size: { less_than: Settings.image.size.megabytes, message: I18n.t("errors.messages.invalid_image_size") }
  scope :recent_posts, -> { order created_at: :desc }
   scope :feed_by_user, ->(user_ids){where user_id: user_ids}

  def display_image
    image.variant resize_to_limit: [Settings.image.resize, Settings.image.resize]
  end
end
