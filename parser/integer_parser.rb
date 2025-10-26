require 'strscan'

# Token:
#   DIGIT  ::= [0-9]+
#   WS   ::= \s+
#   PLUS ::= '+'
#
# Grammer:
#   expr ::= INT ((PLUS | MINUS) INT)*

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
    result = parse_int
    while match?(:PLUS) || match?(:MINUS)
      op = @cur_pos[0]
      advance
      rhs = parse_int
      result = op == :PLUS ? result + rhs : result - rhs
    end
    result
  end

  def parse_int
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

puts Parser.new('1').parse # => 1
puts Parser.new(' 1 ').parse # => 1
puts Parser.new(' 234 ').parse # => 234
puts Parser.new(234).parse # => 234
puts Parser.new('1 + 1').parse # => 2
puts Parser.new('1 + 3').parse # => 4
puts Parser.new('1 + 1 + 1').parse # => 3
puts Parser.new('10 + 10 + 10').parse # => 30
puts Parser.new('50 - 20 + 10').parse # => 40
