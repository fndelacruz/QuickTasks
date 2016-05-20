require 'sql_object'

describe 'Searchable' do
  before(:each) { DBConnection.reset }
  after(:each) { DBConnection.reset }

  before(:all) do
    class Cat < SQLObject
      finalize!
    end

    class User < SQLObject
      self.table_name = 'users'

      finalize!
    end
  end

  it '#where searches with single criterion' do
    cats = Cat.where(name: 'Breakfast')
    cat = cats.first

    expect(cats.length).to eq(1)
    expect(cat.name).to eq('Breakfast')
  end

  it '#where can return multiple objects' do
    users = User.where(house_id: 1)
    expect(users.length).to eq(2)
  end

  it '#where searches with multiple criteria' do
    users = User.where(fname: 'Matt', house_id: 1)
    expect(users.length).to eq(1)

    user = users[0]
    expect(user.fname).to eq('Matt')
    expect(user.house_id).to eq(1)
  end

  it '#where returns [] if nothing matches the criteria' do
    expect(User.where(fname: 'Nowhere', lname: 'Man')).to eq([])
  end
end
