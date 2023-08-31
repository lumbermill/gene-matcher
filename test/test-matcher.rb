require_relative '../lib/gene-matcher'
require_relative './test-common'

# Test class for Matcher

m = Matcher.new("AAAAAAAAAAGGGGGGGGGGT")
assert("AAAAAAAAAAGGGGGGGGGGT",m.input_sequence)
assert(0.6,m.limit)
assert([],m.alignments)

m.scan("AAAAAAAAAAGGGGGGGGGGC", {table: "clones", id: "12-34"})
assert(1,m.alignments.length)
assert(190,(m.alignments[0].score * 10).to_i) # 19.04..
assert("AAAAAAAAAAGGGGGGGGGGC",m.alignments[0].alignmentI)
assert("AAAAAAAAAAGGGGGGGGGGT",m.alignments[0].alignmentJ)
assert("::::::::::::::::::::.",m.alignments[0].alignment)
assert(20,m.alignments[0].alignment_count)
assert("12-34",m.alignments[0].source[:id])

m.scan("TGGGGTTCCAAGCTTGGTTTTCCAAATCCTGTCTCTCCAGCTCCTGCTCCNCTTAAGACCATTTGCTGTGTCAACCGGTCTGAACTAGAGGAATCTGAGGTCAGCAGAGGTCACCCAGACTCAGGGTTCAAACAGCTAATGAGGAGACTAAGGAGGTCAGCCTCCTGCTGTCTGTGGCCTACATGGGAGCAGCGGCGATCTGGGAACAACACTGCGGTTTGAG",{table: "clones", id: "12-34"})
assert(2,m.alignments.length)
assert(45,(m.alignments[1].score * 10).to_i) # 4.5..
assert("AGGTCAGCCTCCTGCTGTCTGT",m.alignments[1].alignmentI)