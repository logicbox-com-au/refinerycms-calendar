module Refinery
  module Calendar
    class Event < Refinery::Core::BaseModel
      extend FriendlyId

      friendly_id :title, :use => :slugged

      belongs_to :venue

      validates :title, :presence => true, :uniqueness => true

      attr_accessible :title, :from, :to, :registration_link,
                      :venue_id, :excerpt, :description,
                      :featured, :position

      alias_attribute :from, :starts_at
      alias_attribute :to, :ends_at

      delegate :name, :address,
                :to => :venue,
                :prefix => true,
                :allow_nil => true

      scope :featured, where(:featured => true)
      scope :upcoming, lambda { where('refinery_calendar_events.starts_at >= ?', Time.now) }
      scope :archive,  lambda { where('refinery_calendar_events.starts_at < ?',  Time.now) }

      scope :starting_on_day, lambda { |day| where(starts_at: day.beginning_of_day..day.tomorrow.beginning_of_day) }
      scope :ending_on_day,   lambda { |day| where(ends_at:   day.beginning_of_day..day.tomorrow.beginning_of_day) }
      scope :on_day, lambda { |day|
        where("refinery_calendar_events.starts_at < ? AND refinery_calendar_events.ends_at > ?", day.tomorrow.beginning_of_day, day.beginning_of_day)
      }


    end
  end
end
