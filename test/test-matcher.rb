require_relative '../lib/gene-matcher'
require_relative './test-common'

# Test class for Matcher

m = Matcher.new("AAAAAAAAAAGGGGGGGGGGT")
assert("AAAAAAAAAAGGGGGGGGGGT",m.input_sequence)
assert(0.6,m.limit)
assert([],m.alignments)

# same pattern
m.scan("CCCAAAAAAAAAAGGGGGGGGGGCCC", {table: "clones", id: "12-34"})
assert(1,m.alignments.length)
assert(190,(m.alignments[0].score * 10).to_i) # 19.04..
assert("AAAAAAAAAAGGGGGGGGGGC",m.alignments[0].alignmentI)
assert("AAAAAAAAAAGGGGGGGGGGT",m.alignments[0].alignmentJ)
assert("::::::::::::::::::::.",m.alignments[0].alignment)
assert(20,m.alignments[0].alignment_count)
assert(3,m.alignments[0].startI)
assert(23,m.alignments[0].endI)
assert(0,m.alignments[0].startJ)
assert(20,m.alignments[0].endJ)
assert(false,m.alignments[0].reversed)
assert(false,m.alignments[0].aside)
assert("12-34",m.alignments[0].source[:id])
assert("clones",m.alignments[0].source[:table])

# not match
m.scan("TGGGGTTCCAAGCTTGGTTTTCCAAATCCTGTCTCTCCAGCTCCTGCTCCNCTTAAGACCATTTGCTGTGTCAACCGGTCTGAACTAGAGGAATCTGAGGTCAGCAGAGGTCACCCAGACTCAGGGTTCAAACAGCTAATGAGGAGACTAAGGAGGTCAGCCTCCTGCTGTCTGTGGCCTACATGGGAGCAGCGGCGATCTGGGAACAACACTGCGGTTTGAG",{table: "clones", id: "12-34"})
assert(1,m.alignments.length)

# match
m.scan("ACCCCCCCCCCTTTTTTTTTT",{table: "clones", id: "56-78"})
assert(2,m.alignments.length)
assert(210,(m.alignments[1].score * 10).to_i) # 21.0..
assert("ACCCCCCCCCCTTTTTTTTTT",m.alignments[1].alignmentI)
assert("ACCCCCCCCCCTTTTTTTTTT",m.alignments[1].alignmentJ)
assert(":::::::::::::::::::::",m.alignments[1].alignment)
assert(21,m.alignments[1].alignment_count)
assert(0,m.alignments[1].startI)
assert(20,m.alignments[1].endI)
assert(0,m.alignments[1].startJ)
assert(20,m.alignments[1].endJ)
assert(false,m.alignments[1].reversed)
assert(true,m.alignments[1].aside)

# match
m.scan("CGAGCCGTGAAAGCCTCCAGGCTTAGCGGAGCCTCGCTCGGAAGCAAGAACTTATTCAACAAGTTTACCCCCCCTGCCTTTCTCTTTTCGATGTGCGTTTTCGGACATGCGGAGGTTACTGGAACCGTGTTGGTGGATTTTGTTCCTGAAAATCACCAGTTCTGTGCTTCATTATGTGGTGTGCTTCCCGGCATTGACTGAAGGCTATGTGGGGACCCTGCAGGAGAGCAGACAGGACAGCTCAGTGCAGATCCGCAGACGAAAGGCATCCGGAGACCCATACTGGGCGTATTCTG", {table: "clones", id: "21-KBW75"})
assert(3,m.alignments.length)
assert(131,(m.alignments[2].score * 10).to_i) # 13.1..
assert("ACCCCCCCTGCCTTTCTCTTTT",m.alignments[2].alignmentI)
assert("ACCCCCCCCC-CTTTTTTTTTT",m.alignments[2].alignmentJ)
assert("::::::::...::::.:.::::",m.alignments[2].alignment)
assert(17,m.alignments[2].alignment_count)
assert(66,m.alignments[2].startI)
assert(87,m.alignments[2].endI)
assert(0,m.alignments[2].startJ)
assert(20,m.alignments[2].endJ)
assert(false,m.alignments[2].reversed)
assert(true,m.alignments[2].aside)
assert("21-KBW75",m.alignments[2].source[:id])

# Another pattern
m = Matcher.new("TAAATCTGCTAATTATGCAAGTCATAATTGAAGCATTTCTGAGGTTATCACCTTGAATGTTCATT",0.5)
m.reserve_target_sequence = true
m.scan("AGTCAATACATCATTTAAGTAGCCTGTGGAACAGGAATTCCATCCCATGTTCTATCTTAATCTGCTAAATCTGCTAATTATGCAAGTCATAATTGAAGCATTTCTGAGGTTATCACCTTGAATGTTCATTGGAGAGGCATGTTGTCCTTGTATTAGGTCCTTAGTTATAACCATGTACTTACTTTCCTCCAAAACATGTGTGAAAAATTACTGACTCATAAATCCTGTTTTAAAAATGAAGGTATTGTTTTGAGGCAGCACCGGCATTTCATGTTAAAGTGTTCTTTGCCTTTGGAACTTTGTTCTGAAGACCGCTGTGAAGGTCTGTGATGGCGCACACCTTTAATTCCAGCACTGGAGAGGCAGAGGCAGGTGGATCACTGAGTTCAAGGACAGCCAGGGCTATACAGAGAAACCCTATCTCGACCCCCCCCCC",{id:"K13G06"})
assert(1,m.alignments.length)
assert("K13G06",m.alignments[0].source[:id])
assert(65,m.alignments[0].score)
assert(65,m.alignments[0].alignment_count)
assert(66,m.alignments[0].startI + 1)
assert(130,m.alignments[0].endI + 1)
assert(1,m.alignments[0].startJ + 1)
assert(65,m.alignments[0].endJ + 1)
assert(false,m.alignments[0].reversed)
assert(false,m.alignments[0].aside)
assert(65,m.input_sequence.length)
# m.reserve_target_sequence must be set to true to get target_sequence
assert(436,m.alignments[0].source[:target_sequence].length)
assert(100,m.alignments[0].score_a * 100)

puts "Fin. #{$n_passed} tests passed."
