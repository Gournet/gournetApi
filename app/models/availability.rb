class Availability < ApplicationRecord
  # When we use scope, we get an active record relationsip for that reason we can continue
  # chaining more methods on the result, I mean pagination, so the pagination of this model will be made
  # in the controller instead of the model
  default_scope {order('availabilities.day ASC, availabilities.count DESC')}
  scope :today, -> { includes(:dish).where('day = ?', Date.today )}
  scope :tomorrow, -> { includes(:dish).where('day = ?',Date.today.tomorrow)}
  scope :available_count, -> {where('count > 0')}
  scope :order_by_day, -> (ord) {order("availabilities.day #{ord}")}
  scope :order_by_count, -> (ord) {order("availabilities.count #{ord}")}
  scope :order_by_end_time, -> (ord) {order("availabilities.end_time #{ord}")}
  scope :order_by_created_at, -> (ord) {order("availabilities.created_at #{ord}")}

  def self.availabilities_by_dish(dish_id,page = 1,per_page = 10)
    includes(dish:[:orders])
      .where(dish_id: dish_id)
      .paginate(:page => page, :per_page => per_page)
  end

  def self.next_seven_days(page = 1, per_page = 10)
    range = Date.today..(Date.today + 7)
    includes(dish:[:orders])
      .where(availabilities: {day: range})
      .paginate(:page => page, :per_page => per_page)
  end

  def self.load_availabilities(page = 1, per_page = 10)
    includes(dish:[:orders])
      .paginate(:page => page, :per_page => per_page)
  end

  def self.availability_by_id(id)
    includes(dish:[:orders])
      .find_by_id(id)
  end

  belongs_to :dish

  validates :day,:end_time,:count,presence: true
  validates :count, numericality: { greater_than_or_equal_to: 0 }


end