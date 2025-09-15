# frozen_string_literal: true

GC.start
before = GC.stat(:total_allocated_objects)
1000.times { 'x' * 10_000 }
after = GC.stat(:total_allocated_objects)
puts "allocations: #{after - before}"
