require './tail_recursion'

def getc
  STDIN.getc
end

class NilClass
  def eof?
    true
  end
end

class String
  def eof?
    false
  end
end

class Example3
  def count_lines
    cl_loop(0)
  end

  def cl_loop(count)
    c = getc
    if c.eof?
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
end

if __FILE__ == $0
 p Example3.new.count_lines
end
