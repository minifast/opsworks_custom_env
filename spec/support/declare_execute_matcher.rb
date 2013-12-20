RSpec::Matchers.define :declare_execute do |name = nil|
  define_method :is_execute? do |resource|
    resource.resource_name == :execute
  end

  define_method :is_nothing? do |resource|
    resource.action.include?(:nothing)
  end

  define_method :same_name? do |resource|
    name.nil? || resource.name == name
  end

  match_for_should do |chef_runner|
    chef_runner.resource_collection.all_resources.any? do |resource|
      is_execute?(resource) && is_nothing?(resource) && same_name?(resource)
    end
  end
end
