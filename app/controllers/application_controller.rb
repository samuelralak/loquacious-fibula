class ApplicationController < ActionController::Base
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception

	before_filter :configure_permitted_parameters, if: :devise_controller?
	before_filter :check_cart_items
	before_filter :set_wallet
	rescue_from StandardError, with: :send_stack_trace

	def blockchain_callback
		puts params[:input_transaction_hash]
	end

	private
		def track_activity(trackable, action = params[:action])
			current_user.activities.create! action: action, trackable: trackable
		end

		# Redirect to sign in page after successful sign out
		def after_sign_out_path_for(resource_or_scope)
			new_user_session_path
		end

		def check_cart_items
			if current_user
				@cart = current_user.shopping_cart
				@cart_items = @cart ? @cart.shopping_cart_items.count : 0
			end
		end

		def set_wallet
			@wallet = Blockchain::Wallet.new(ENV['BLOCKCHAIN_IDENTIFIER'], ENV['BLOCKCHAIN_PASSWORD'])
		end

	private
		def send_stack_trace
			ErrorMailer.send_error(StandardError).deliver
		end
	protected
 		def configure_permitted_parameters
			devise_parameter_sanitizer.for(:sign_up) { |u|
				u.permit(
					:username, :email, :icq_number, :password, :password_confirmation, :remember_me
				)
			}

			devise_parameter_sanitizer.for(:sign_in) { |u|
				u.permit(
					:login, :username, :email, :password, :remember_me
				)
			}
		end
end
