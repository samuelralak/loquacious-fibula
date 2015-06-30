class AdminUser < ActiveRecord::Base
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable and :omniauthable
    devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

    has_many :activities, inverse_of: :admin_user
end
