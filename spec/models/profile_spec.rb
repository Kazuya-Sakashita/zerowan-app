require 'rails_helper'


RSpec.describe User, type: :model do


  it "name 値がない場合にバリデーションエラーが発生すること"
  it "address 値がない場合にバリデーションエラーが発生すること"
  it "phone_number 値がない場合にバリデーションエラーが発生すること"
  it "phone_number 文字列が入っていた場合にバリデーションエラーが発生すること"
  it "birthday 値がない場合にバリデーションエラーが発生すること"
  it "breeding_experience 値がない場合にバリデーションエラーが発生すること"

end
