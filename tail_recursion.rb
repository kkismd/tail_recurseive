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
