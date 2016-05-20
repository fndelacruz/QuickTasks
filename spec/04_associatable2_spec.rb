require 'sql_object'

describe 'Associatable' do
  before(:each) { DBConnection.reset }
  after(:each) { DBConnection.reset }

  before(:all) do
    class Cat < SQLObject
      belongs_to :user, foreign_key: :owner_id

      finalize!
    end

    class User < SQLObject
      self.table_name = 'users'

      has_many :cats, foreign_key: :owner_id
      belongs_to :house

      finalize!
    end

    class House < SQLObject
      has_many :users

      finalize!
    end
  end

  describe '::assoc_options' do
    it 'defaults to empty hash' do
      class TempClass < SQLObject
      end

      expect(TempClass.assoc_options).to eq({})
    end

    it 'stores `belongs_to` options' do
      cat_assoc_options = Cat.assoc_options
      user_options = cat_assoc_options[:user]

      expect(user_options).to be_instance_of(BelongsToOptions)
      expect(user_options.foreign_key).to eq(:owner_id)
      expect(user_options.class_name).to eq('User')
      expect(user_options.primary_key).to eq(:id)
    end

    it 'stores options separately for each class' do
      expect(Cat.assoc_options).to have_key(:user)
      expect(User.assoc_options).to_not have_key(:user)

      expect(User.assoc_options).to have_key(:house)
      expect(Cat.assoc_options).to_not have_key(:house)
    end
  end

  describe '#has_one_through' do
    before(:all) do
      class Cat
        has_one_through :home, :user, :house

        self.finalize!
      end
    end

    let(:cat) { Cat.find(1) }

    it 'adds getter method' do
      expect(cat).to respond_to(:home)
    end

    it 'fetches associated `home` for a `Cat`' do
      house = cat.home

      expect(house).to be_instance_of(House)
      expect(house.address).to eq('26th and Guerrero')
    end
  end
end
