FactoryGirl.define do
  factory :user do
    sequence :email do |n|
      "dummyEmail#{n}@gmail.com"
    end
    password "secretPassword"
    password_confirmation "secretPassword"
  end

  factory :game do
    name "awesome game"
    white_player_id 1
    association :user
  end

  factory :piece do
    color 0
    #The type will be king by default
    type King
    x 3
    y 3
    game
  end
  
end
