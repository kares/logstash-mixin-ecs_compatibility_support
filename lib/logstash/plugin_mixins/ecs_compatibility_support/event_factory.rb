# encoding: utf-8

module LogStash; module PluginMixins; module ECSCompatibilitySupport

  class EventFactory

    INSTANCE = new

    def new_event(hash = {})
      event = LogStash::Event.new(hash)
      # TODO
      #created_at = event.get('@timestamp')
    end

  end

  class LegacyEventFactory

    INSTANCE = new

    def new_event(hash = {})
      LogStash::Event.new(hash)
    end

  end

end end end
