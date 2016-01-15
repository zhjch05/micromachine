require 'micromachine'

# This example can be run with ruby -I lib/ ./examples/basic.rb

fsm = MicroMachine.new(:pending)

fsm.when(:confirm,  pending: :confirmed)
fsm.when(:ignore,   pending: :ignored)
fsm.when(:reset,    confirmed: :pending, ignored: :pending)

puts 'Should print Confirmed, Reset and Ignored:'

puts 'Confirmed' if fsm.trigger(:confirm)

puts 'Ignored' if fsm.trigger(:ignore)

puts 'Reset' if fsm.trigger(:reset)

puts 'Ignored' if fsm.trigger(:ignore)
