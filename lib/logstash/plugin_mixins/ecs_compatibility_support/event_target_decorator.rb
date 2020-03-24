# encoding: utf-8

require 'forwardable'

module LogStash; module PluginMixins; module ECSCompatibilitySupport

  class EventTargetDecorator
    extend Forwardable

    def self.wrap(event, target = nil)
      self.new(event, target)
    end

    def initialize(event, target)
      @event = event
      namespace = target.to_s.strip
      if namespace.empty? || namespace.start_with?('[')
        @target_ns = namespace
      else
        @target_ns = "[#{namespace}]"
      end
    end

    # Event interface

    def_delegators :@event, :cancel, :uncancel, :cancelled?, :clone # no args
    def_delegators :@event, :overwrite, :append # event arg
    def_delegators :@event, :sprintf, :to_s
    def_delegators :@event, :to_hash, :to_hash_with_metadata, :to_json
    def_delegators :@event, :tag, :timestamp

    def get(ref)
      @event.get(target_ref(ref))
    end

    def set(ref, value)
      @event.set(target_ref(ref), value)
    end

    def include?(ref)
      @event.include?(target_ref(ref))
    end

    def remove(ref)
      @event.remove(target_ref(ref))
    end

    # Extensions

    def get_raw(ref)
      @event.get(ref)
    end

    def set_raw(ref, value)
      @event.set(ref, value)
    end

    # Support

    def __unwrap__
      @event
    end

    private

    def target_ref(ref)
      ref = ref.to_str
      if ref.start_with?('[')
        @target_ns + ref
      else
        "#{@target_ns}[#{ref}]"
      end
    end

end end end
