class CheckerWorker
    include Sidekiq::Worker

    def perform(item_id)
        item = Item.find(item_id)
        # change status
        item.sell!
        # can no longer perform check
        item.can_check = false
        item.save!
    end
end
