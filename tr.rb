class TR
  CONT = Object.new

  def initialize(&func)
    @first = true
    @func = func
  end

  def call(*args)
    if @first
      @first = false
      begin
        loop do
          result = @func.call(*args)
          if result.equal? CONT
            args = @args
          else
            return result
          end
        end
      ensure
        @first = true
      end
    else
      @args = args
      return CONT
    end
  end
end

def fib(n)
  loop = TR.new do |i, a, b|
    if i == 0
      a
    else
      loop.call(i - 1, b, a + b)
    end
  end
  loop.call(n, 1, 1)
end

p fib(10000) #=> 5443837311356528133...
