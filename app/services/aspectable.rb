# frozen_string_literal: true

module Aspectable
  def aspect(*mns)
    mns.each do |name|
      method = instance_method(name)
      define_method(name) do |*args, **kwargs, &block|
        yield if block_given?
        output = method.bind(self).call(*args, **kwargs, &block)
        self.class.advice(self.class.to_s, name, args, kwargs, output, context: context)
        output
      end
    end
  end

  def advice(*args, context:)
    context.trace ||= []
    context.trace << args
  end
end
