class Fibonacci
  include TailRecusion
  def fib(n)
    if n < 2
      return n
    else
      return fib(n-2) + fib(n-1)
    end
  end
  tail_recurse :fib
end
