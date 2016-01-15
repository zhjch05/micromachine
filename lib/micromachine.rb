class MicroMachine
    InvalidEvent = Class.new(NoMethodError)
    InvalidState = Class.new(ArgumentError)

    attr_reader :transitions_for
    attr_reader :state

    def initialize(initial_state)
        @state = initial_state
        @transitions_for = {}
        @callbacks = Hash.new { |hash, key| hash[key] = [] }
    end

    def on(key, &block)
        @callbacks[key] << block
    end

    def when(event, transitions)
        transitions_for[event] = transitions
    end

    def trigger(event)
        trigger?(event) && change(event)
    end

    def trigger!(event)
        trigger(event) ||
            fail(InvalidState.new("Event '#{event}' not valid from state '#{@state}'"))
    end

    def trigger?(event)
        fail InvalidEvent unless transitions_for.key?(event)
        transitions_for[event].key?(state)
    end

    def events
        transitions_for.keys
    end

    def states
        transitions_for.values.map(&:to_a).flatten.uniq
    end

    private

    def change(event)
        @state = transitions_for[event][@state]
        callbacks = @callbacks[@state] + @callbacks[:any]
        callbacks.each { |callback| callback.call(event) }
        true
    end
end
