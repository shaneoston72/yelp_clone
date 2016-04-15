FactoryGirl.define do
  factory :user do
    email        "test@test.com"
    password     "test1234"
  end

  factory :user2, class: User do
    email        "test1@test.com"
    password     "test1234"
  end

end
