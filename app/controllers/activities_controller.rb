class ActivitiesController < ApplicationController
	before_action :authenticate_user!
	
	def index
		@activities = Activity.order("created_at desc")
	end
end
