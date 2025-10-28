require 'strscan'

# Token:
#   DIGIT  ::= [0-9]+
#   WS   ::= \s+
#   PLUS ::= '+'
#
# expr   ::= term ( (PLUS | MINUS) term )*
# term   ::= factor ( MUL )  factor )*
# factor ::= (PLUS | MINUS) factor | INT

class Lexer
  def initialize(value)
    @scan = StringScanner.new(value.to_s)
    @token = nil
  end

  attr_reader :token

  def next_token
    skip_whitespace
    @token = if n = @scan.scan(/\d+/)
               [:DIGIT, n]
             elsif @scan.scan(/\+/)
               [:PLUS, '+']
             elsif @scan.scan(/-/)
               [:MINUS, '-']
             elsif @scan.scan(/\*/)
               [:MUL, '*']
             elsif @scan.scan(%r{/})
               [:DIV, '/']
             end
  end

  def skip_whitespace
    @scan.skip(/\s+/)
  end
end

class Parser
  def initialize(value)
    @lexer = Lexer.new(value)
    @cur_pos = nil
  end

  def parse
    advance
    parse_expr
  end

  private

  def parse_expr
    left = parse_term
    while match?(:PLUS) || match?(:MINUS)
      op = @cur_pos[0]
      advance # 演算子を進める
      rhs = parse_term
      left = op == :PLUS ? left + rhs : left - rhs
    end
    left
  end

  def parse_term
    left = parse_factor
    while match?(:MUL) || match?(:DIV)
      op = @cur_pos[0]
      advance # 演算子を進める
      right = parse_factor
      left = op == :MUL ? left * right : left / right
    end
    left
  end

  def parse_factor
    v = @cur_pos[1].to_i
    advance
    v
  end

  def advance
    @cur_pos = @lexer.next_token
  end

  def match?(type)
    @cur_pos && @cur_pos[0] == type
  end
end

# tests for addition and subtraction
# puts Parser.new('1').parse # 1
# puts Parser.new(' 1 ').parse # => 1
# puts Parser.new(' 234 ').parse # => 234
# puts Parser.new(234).parse # => 234
# puts Parser.new('1 + 1').parse # => 2
# puts Parser.new('1 + 3').parse # => 4
# puts Parser.new('1 + 1 + 1').parse # => 3
# puts Parser.new('10 + 10 + 10').parse # => 30
# puts Parser.new('50 - 20 + 10').parse # => 40

# test for multiplication
# puts Parser.new('2 * 3').parse # => 6
# puts Parser.new('1 + 2 * 3').parse # => 7   (1 + (2*3))
# puts Parser.new('2 * 3 + 4').parse      # => 10  ((2*3) + 4)
# puts Parser.new('2 + 3 * 4 + 5').parse  # => 19
# puts Parser.new('2 * 3 * 4').parse      # => 24  (左結合)

# tests for division
# puts Parser.new('10 / 2').parse # => 5
# puts Parser.new('20 + 10 / 2').parse # => 25
# puts Parser.new('20 / 2 + 10').parse # => 20
# puts Parser.new('20 / 2 * 3').parse # => 30
# puts Parser.new('20 / 2 - 5').parse # => 5
