module Publishable
  def self.included(base)
    base.class_eval do
      scope :published, -> { where(published: true) }
      scope :draft, -> { where(published: false) }
    end
  end

  def publish!
    self.update_attribute(:published, true)
  end

  def unpublish!
    self.update_attribute(:published, false)
  end
end
