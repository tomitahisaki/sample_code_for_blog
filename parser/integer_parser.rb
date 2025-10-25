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
    @token = if @scan.scan(/\d+/)
               @scan.matched
             elsif @scan.scan(/\+/)
               :PLUS
             end
  end

  def skip_whitespace
    @scan.skip(/\s+/)
  end
end

class Parser
  def initialize(value)
    @lexer = Lexer.new(value)
  end

  def parse
    @lexer.next_token
    parse_integer
  end

  private

  def parse_integer
    @lexer.token.to_i
  end
end

# puts Parser.new(1).parse # => 1
# puts Parser.new('1').parse # => 1
# puts Parser.new(' 1 ').parse # => 1
# puts Parser.new(' 234 ').parse # => 234
# puts Parser.new(234).parse # => 234
puts Parser.new('1 + 1').parse # => 2
puts Parser.new('1 + 3').parse # => 4
