require 'strscan'

# Token:
#   DIGIT  ::= [0-9]+
#   WS   ::= \s+
#   PLUS ::= '+'
#
# expr ::= DIGIT | DIGIT ws PLUS ws DIGIT

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
    left = parse_int
    advance
    if match?(:PLUS)
      advance
      right = parse_int
      left + right
    else
      left
    end
  end

  def parse_int
    @cur_pos[1].to_i
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
