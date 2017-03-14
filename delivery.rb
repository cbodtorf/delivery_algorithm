require 'active_support/all'
require 'date'

# Data Structure
conditions = [
  {
    condition: DateTime.now.hour < 11,
    testDate: Date.today,
    options: [
      {
        :name => "Same Day",
        :price => 5
      }
    ]
  },
  {
    condition: DateTime.now.hour >= 15,
    testDate: Date.today + 1,
    options: [
      {
        :name => "Same Day",
        :price => 5
      }
    ]
  },
  {
    condition: DateTime.now.hour < 15,
    testDate: Date.today + 1,
    options: [
      {
        :name => "Next Day Free",
        :price => 0
      },
      {
        :name => "Next Day Morning",
        :price => 15
      }
    ]
  },
  {
    condition: "any",
    testDate: "any",
    options: [
      {
        :name => "Next Day Free",
        :price => 0
      },
      {
        :name => "Next Day Morning",
        :price => 15
      }
    ]
  },
  {
    condition: "blackout",
    testDate: DateTime.new(2017, 4, 2),
    options: [
      {
        :name => "blackout",
        :price => nil
      }
    ]
  },
  {
    condition: "blackout",
    testDate: DateTime.new(2017, 3, 29),
    options: [
      {
        :name => "holiday",
        :price => nil
      }
    ]
  },
  {
    condition: "no_Delivery",
    testDate: "Saturday",
    options: [
      {
        :name => "no delivery on Saturday",
        :price => nil
      }
    ]
  }
]

DATE_FORMAT = "%Y %b %d " # 2017 Apr 14

today = Date.today
dateArray = (today..(today + 1.month)).map{ |date| date.strftime(DATE_FORMAT) }
# to be filled after iteration
detailedDateArray = []

dateArray.each_with_index do |date, index|
  deliveryOptions = {
    :date => date,
    :options => []
  }

  # Check conditions
  conditions.each do |condition|
    if(condition[:condition] == "any")
        (index > 1) ? deliveryOptions[:options] = condition[:options] : break
    elsif(condition[:condition] == "no_Delivery")
      if (condition[:testDate].upcase == DateTime.parse(date).strftime('%^A'))
        deliveryOptions[:options] = condition[:options]
      end
    elsif(condition[:condition] == "blackout")
      if (condition[:testDate].strftime(DATE_FORMAT) == date)
        deliveryOptions[:options] = condition[:options]
      end
    elsif(condition[:testDate].strftime(DATE_FORMAT) == date && condition[:condition])
        deliveryOptions[:options] = condition[:options]
    end
  end

  # Add new :date object with accepted delivery :options to detailedDateArray.
  detailedDateArray.push(deliveryOptions)
end

puts detailedDateArray.first(7)
