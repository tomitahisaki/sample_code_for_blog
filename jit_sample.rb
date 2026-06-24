# frozen_string_literal: true

def calculate_total(prices)
  total = 0

  prices.each do |price|
    total += price * 1.1
  end

  total
end

prices = (1..1_000).to_a

start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)

10_000.times do
  calculate_total(prices)
end

elapsed_time = Process.clock_gettime(Process::CLOCK_MONOTONIC) - start_time

puts "result: #{calculate_total(prices)}"
puts "elapsed: #{elapsed_time.round(3)} sec"
puts "YJIT enabled?: #{RubyVM::YJIT.enabled?}"

# ----------------------------
# ruby jit_sample.rb
# result: 550550.0
# elapsed: 0.545 sec
# YJIT enabled?: false

# ----------------------------
# ruby --yjit jit_sample.rb
# result: 550550.0
# elapsed: 0.136 sec
# YJIT enabled?: true

# ruby --yjit --yjit-stats jit_sample.rb
# YJITで実行できた比率
# ratio_in_yjit:                 99.7%
# Rubyの命令列をどれくらいコンパイルしたか
# compiled_iseq_count:               4
# YJITの想定が外れ、通常VMへ戻った回数
# side_exit_count:                   0
# 作ったJITコードを無効化した回数
# invalidation_count:                0
