class Module
  def tail_recursive(name)
    method = instance_method(name)
    define_method("#{name}_old", method)
    first = true
    cont = Object.new
    _args = nil
    define_method(name) do |*args|
      if first
        first = false
        _method = method.bind(self)
        begin
          loop do
            result = _method.call(*args)
            if result.equal? cont
              args = _args
            else
              return result
            end
          end
        ensure
          first = true
        end
      else
        _args = args
        return cont
      end
    end
  end
end

class Calc
  def fib(n, a = 1, b = 1)
    if n == 0
      a
    else
      fib(n - 1, b, a + b)
    end
  end
  tail_recursive :fib

  def sum(n, acc = 0)
    return acc if n == 0
    sum(n - 1, acc + n)
  end
  tail_recursive :sum

  def even(n)
    if n == 0
      true
    else
      odd(n - 1)
    end
  end
  tail_recursive :even

  def odd(n)
    if n == 0
      false
    else
      even(n - 1)
    end
  end
  tail_recursive :odd

  def count_lines
    cl_loop(0)
  end

  def cl_loop(count)
    c = getc
    if c.nil?
      count
    else
      if c == "\n"
        cl_loop(count + 1)
      else
        cl_loop(count)
      end
    end
  end
  tail_recursive :cl_loop

  def count_words
    cw_loop(getc, true, 0)
  end

  def cw_loop(c, ws, count)
    if c.nil?
      count
    elsif c =~ /\s/
      cw_loop(getc, true, count)
    elsif ws
      cw_loop(getc, false, count + 1)
    else
      cw_loop(getc, false, count)
    end
  end
  tail_recursive :cw_loop

  def count_words2
    in_space(getc, 0)
  end

  def in_word(c, count)
    if c.nil?
      count
    elsif c =~ /\s/
      in_space(getc, count)
    elsif c == '"'
      in_quote(getc, count + 1)
    else
      in_word(getc, count)
    end
  end
  tail_recursive :in_word

  def in_space(c, count)
    if c.nil?
      count
    elsif c =~ /\s/
      in_space(getc, count)
    elsif c == '"'
      in_quote(getc, count + 1)
    else
      in_word(getc, count + 1)
    end
  end
  tail_recursive :in_space

  def in_quote(c, count)
    if c.nil?
      raise "EOF in quoted word"
    elsif c == '"'
      in_space(getc, count)
    elsif c == "\\"
      getc
      in_quote(getc, count)
    else
      in_quote(getc, count)
    end
  end
  tail_recursive :in_quote

  def getc
    STDIN.getc
  end
end

require 'stringio'

def nil.eof?
  true
end

class String
  def eof?
    false
  end

  def whitespace?
    self =~ /\A\s\Z/
  end
end

class WordCounter
  def getc
    @input.getc
  end

  def main
    if ARGV.empty?
      @input = STDIN
    elsif FileTest.exists? ARGV[0]
      @input = File.open ARGV[0]
    else
      @input = StringIO.new ARGV[0]
    end
    in_space(getc, 0)
  end

  def in_word(c, count)
    if c.eof?
      count
    elsif c.whitespace?
      in_space(getc, count)
    elsif c == "\""
      in_quote(getc, count + 1, false)
    elsif c == "("
      in_paren(getc, count + 1, false)
    else
      in_word(getc, count)
    end
  end
  tail_recursive :in_word

  def in_space(c, count)
    if c.eof?
      count
    elsif c.whitespace?
      in_space(getc, count)
    elsif c == "\""
      in_quote(getc, count + 1, false)
    elsif c == "("
      in_paren(getc, count + 1, false)
    else
      in_word(getc, count + 1)
    end
  end
  tail_recursive :in_space

  def in_quote(c, count, nested)
    if c.eof?
      raise "EOF in quoted word"
    elsif c == "\""
      if nested
        count
      else
        in_space(getc, count)
      end
    elsif c == "\\"
      getc
      in_quote(getc, count, nested)
    else
      in_quote(getc, count, nested)
    end
  end
  tail_recursive :in_quote

  def in_paren(c, count, nested)
    if c.eof?
      raise "EOF in parenthesis"
    elsif c == "("
      in_paren(getc, count, true)
      in_paren(getc, count, nested)
    elsif c == ")"
      if nested
        count
      else
        in_space(getc, count)
      end
    elsif c == "\""
      in_quote(getc, count, true)
      in_paren(getc, count, nested)
    else
      in_paren(getc, count, nested)
    end
  end
  tail_recursive :in_paren
end

if __FILE__ == $0
  # p Calc.new.fib(10000)
  # p Calc.new.sum(10000)
  # p Calc.new.even(ARGV[0].to_i)
  # p Calc.new.count_lines
  # p Calc.new.count_words
  # p Calc.new.count_words2
  p WordCounter.new.main
end
