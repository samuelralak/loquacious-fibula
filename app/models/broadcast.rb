class Broadcast < ActiveRecord::Base
    belongs_to :admin_user

    after_create :track_activity

    private
        def track_activity
            Activity.create! action: 'create', trackable: self, admin_user_id: self.admin_user_id
        end
end
