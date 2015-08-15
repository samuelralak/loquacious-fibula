class User < ActiveRecord::Base
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable,
		:rememberable, :trackable, :validatable, :timeoutable,
		:authentication_keys => [:login]

	has_one :seller_request, inverse_of: :user
	has_one	:shopping_cart, inverse_of: :user
	has_one	:btc_account, inverse_of: :user

	has_many :reports, inverse_of: :user
	has_many :transactions, inverse_of: :user
	has_many :activities, inverse_of: :user
	has_many :items, inverse_of: :user
	has_many :orders, foreign_key: "customer_id", dependent: :destroy
	has_many :customers, through: :orders, source: :customer
	has_many :withdrawal_requests, inverse_of: :user, dependent: :destroy

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

	def timeout_in
		1800.seconds
	end

	private
		def create_btc_account
			label = SecureRandom.uuid
			wallet = Blockchain::Wallet.new(ENV['BLOCKCHAIN_IDENTIFIER'], ENV['BLOCKCHAIN_PASSWORD'])
			response = wallet.new_address(label)

			unless response.nil?
				# create account
				account = BtcAccount.create(
					label: response.label, address: response.address, user_id: self.id
				)

				# create account balance
				account_balance = account.create_btc_account_balance(
					available_balance: response.balance
				)
			end
		end
end
