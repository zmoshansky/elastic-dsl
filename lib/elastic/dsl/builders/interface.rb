module Elastic::DSL::Builders::Interface

  def elastic_dsl_methods
    set_union = Elastic::DSL::Builders::Core::All.instance_methods | Elastic::DSL::Builders::Filters::All.instance_methods#| Elastic::DSL::Builders::Queries::All.instance_methods
    intersect = Elastic::DSL::Builders::Core::All.instance_methods & Elastic::DSL::Builders::Filters::All.instance_methods#& Elastic::DSL::Builders::Queries::All.instance_methods
    return set_union - intersect
  end

  def around(*names, before, after)
    names.each do |name|
      original_method = self.class.instance_method(name)
      self.class.send(:define_method, name) do |*args, &block|
        before.call(*args)
        original_method.bind(self).(*args, &block)
        after.call
      end
    end
  end

end
