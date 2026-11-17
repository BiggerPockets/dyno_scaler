# frozen_string_literal: true

class DynoSize < ActiveHash::Base
  self.data = [
    { id: 1, name: 'Eco' },
    { id: 2, name: 'Basic' },
    { id: 3, name: 'Standard-1X' },
    { id: 4, name: 'Standard-2X' },
    { id: 5, name: 'Performance-M' },
    { id: 6, name: 'Performance-L' }
  ]

  all.each do |dyno_size|
    define_singleton_method(dyno_size.name.downcase.tr('-', '_')) do
      dyno_size
    end
  end

  # The smallest size a pipeline can scale to. The BiggerPockets app runs out
  # of memory booting on anything smaller than Standard-2X.
  def self.smallest
    standard_2x
  end

  def self.largest
    performance_l
  end

  def self.selectable
    where(id: (smallest.id..largest.id).to_a)
  end

  def self.base_sizes
    selectable.where.not(id: largest.id)
  end

  def self.boost_sizes
    selectable.where.not(id: smallest.id)
  end
end
