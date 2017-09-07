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
    white_player 1
    black_player 2
    association :user
  end

  factory :piece do
    id 1
    color "white"
    #The type will be king by default
    type King
    x 1
    y 1
    association :game
  end
end
