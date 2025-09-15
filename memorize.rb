# frozen_string_literal: true

require 'benchmark'

def build_object
  # not I/O, but it still takes time
  Array.new(10_000) { rand }.sum
  'x' * 10_000
end

def no_memo
  build_object
end

def memorized
  @memorized ||= build_object
end

# chceck object_id
puts '=== object_id ==='
3.times { p [:no_memo, no_memo.object_id] }
3.times { p [:memo,    memorized.object_id] }

# check allocations
puts '=== allocations (GC.stat) ==='
GC.start
before = GC.stat[:total_allocated_objects]
1000.times { no_memo }
after = GC.stat[:total_allocated_objects]
puts "no_memo allocations: #{after - before}"

GC.start
before = GC.stat[:total_allocated_objects]
1000.times { memorized }
after = GC.stat[:total_allocated_objects]
puts "memoized allocations: #{after - before}"

# check speed
puts '=== speed (Benchmark.bm) ==='
Benchmark.bm do |x|
  x.report('no_memo x10000') { 10_000.times { no_memo } }
  x.report('memorized x10000') { 10_000.times { memorized } }
end
