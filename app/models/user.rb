class User < ActiveRecord::Base
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable,
		:rememberable, :trackable, :validatable,
		:authentication_keys => [:login]

	has_one	:shopping_cart, inverse_of: :user
	has_one	:btc_account, inverse_of: :user

	has_many :activities, inverse_of: :user
	has_many :items

	after_create :create_btc_account

	# Virtual attribute for authenticating by either username or email
	# This is in addition to a real persisted field like 'username'
	attr_accessor :login

	def self.find_for_database_authentication(warden_conditions)
		conditions = warden_conditions.dup

		if login = conditions.delete(:login)
			where(conditions.to_hash).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
		else
			where(conditions.to_hash).first
    end
  end

	private
		def create_btc_account
			response = BlockIo.get_new_address(:label => self.username)

			if response['status'].eql?('success')
				data = response['data']
				account = BtcAccount.create(
					label: data['label'], address: data['address'], user_id: self.id
				)

				response = BlockIo.get_address_balance :labels => account.label

				if response['status'].eql?('success')
					data = response['data']
					account_balance = BtcAccountBalance.create(
						available_balance: data['available_balance'],
						pending_received_balance: data['pending_received_balance'],
						btc_account_id: account.id
					)
				end
			end
		end
end
