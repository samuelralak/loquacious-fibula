class Report < ActiveRecord::Base
	belongs_to :user, inverse_of: :reports
  	belongs_to :item, inverse_of: :report
  	belongs_to :report_status
end
