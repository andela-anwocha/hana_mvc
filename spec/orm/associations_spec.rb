describe Hana::Associations do
  before(:all) do
    User.destroy_all
    Admin.destroy_all
  end

  context '.belongs_to' do
    before do
      User.class_eval { belongs_to :admin, class_name: 'Admin', foreign_key: 'admin_id' }
      @admin = create(:admin)
      @user = create(:user, admin_id: @admin.id)
    end

    context 'when associated model is called' do
      it 'returns the associated model' do
        expect(@user.admin).to eql(@admin)
      end

      context 'with a valid attribute name' do
        it 'returns the value of the attribute' do
          expect(@user.admin.name).to eql(@admin.name)
        end
      end
    end
  end

  context '.has_many' do
    before do
      Admin.class_eval { has_many :users, class_name: 'User', foreign_key: 'admin_id' }
      @admin = create(:admin)
      @users = create_list(:user, 2, admin_id: @admin.id)
    end

    context 'when associated model is called' do
      it 'returns all instances of the associated model' do
        expect(@admin.users).to eql(@users)
      end

      context 'with a valid attribute name' do
        it 'returns tha value of the attribute' do
          expect(@admin.users.first.name).to eql(@users.first.name)
        end
      end
    end
  end
end
