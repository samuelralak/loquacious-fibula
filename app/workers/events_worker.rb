class EventsWorker
    include Sidekiq::Worker

    def perform(item_id)
        item = Item.find(item_id)
        item.activate!
    end
end
