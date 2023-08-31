def assert(expected,actual)
  if expected.is_a?(String) || expected.is_a?(Integer) || expected.is_a?(Float) ||
    expected == true || expected == false || expected == nil
    raise "Expected: #{expected}, Actual: #{actual}" unless expected == actual
  elsif expected.is_a? Array
    raise "Expected: #{expected}, Actual: #{actual}" if expected.count != actual.count
    expected.each_with_index do |e,i|
      assert(e,actual[i])
    end
  else
    raise "Unknown class for: #{expected} ,#{actual}"
  end
end
