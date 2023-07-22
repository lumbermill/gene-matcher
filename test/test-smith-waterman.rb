require_relative '../lib/smith-waterman'

def assert(expected,actual)
  if expected.is_a?(String) || expected.is_a?(Integer) ||
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

# Test class for SmithWaterman

sw = SmithWaterman.instance

target = "TATCGAGT"
input = "ATCA"
a = sw.alignment(target,input)
assert("ATCGA",a.alignmentI)
assert("ATC-A",a.alignmentJ)
assert(":::.:",a.alignment)
assert(4,a.alignment_count)
assert(0,a.score.to_i) # because the length is shorter than the threshold(20).

target = "TGGGGTTCCAAGCTTGGTTTTCCAAATCCTGTCTCTCCAGCTCCTGCTCCNCTTAAGACCATTTGCTGTGTCAACCGGTCTGAACTAGAGGAATCTGAGGTCAGCAGAGGTCACCCAGACTCAGGGTTCAAACAGCTAATGAGGAGACTAAGGAGGTCAGCCTCCTGCTGTCTGTGGCCTACATGGGAGCAGCGGCGATCTGGGAACAACACTGCGGTTTGAG"
input = "GGAATGGGACAGCAGAGGGGGCTGTGTTTCATCTCAGCGATCAACTGGTTGACCTAT"
a = sw.alignment(target,input)
assert("ACTCAGGGTTCAAACAGCTAAT-GAGGAGACTAAGGAGGTCAGCCTCCTGCTGTCTGTGGCCTACA",a.alignmentI)
assert("A-T-AGG--TCAACCAGTTGATCGCTGAGATGAAACA---CAGCCCCCT-CTG-CTGTCCCATTCC",a.alignmentJ)
assert(":.:.:::..::::.:::.:.::.:..::::..::..:...:::::.:::.:::.::::..:.:.:.",a.alignment)
assert(4,a.alignment_count)
assert(254,(a.score*10).to_i) # 25.47
