# gene-matcher
Algorithm for determining similar regions between nucleic acid sequences.


```
require 'gene-matcher'

# Obtain regions from 2 sequences.
sw = SmithWaterman.instance
a = sw.alignment("AGTCAGTC","CAGC")
a.alignmentI # => "CAGTC"
a.alignmentJ # => "CAG-C"
a.alignment  # => ":::.:"

# Store alignments which satisfy the score condition.
m = Matcher.new("GGAATGGGACAGCAGAGGGGGCTGTGTTTCATCTCAGCGATCAACTGGTTGACCTAT",0.1)
m.scan("TGGGGTTCCAAGCTTGGTTTTCCAAATCCTGTCTCTCCAGCTCCTGCTCCNCTTAAGACCATTTGCTGTGTCAACCGGTCTGAACTAGAGGAATCTGAGGTCAGCAGAGGTCACCCAGACTCAGGGTTCAAACAGCTAATGAGGAGACAAGGAGGTCAGCCTCCTGCTGTCTGTGGCCTACATGGGAGCAGCGGCGATCTGGGAACAACACTGCGGTTTGAG")
m.alignments # => #<Alignment:0x0000000108b02ff8>
#   @alignmentI="ACTCAGGGTTCAAACAGCTAAT-GAGGAGACTAAGGAGGTCAGCCTCCTGCTGTCTGTGGCCTACA",
#   @alignmentJ="A-T-AGG--TCAACCAGTTGATCGCTGAGATGAAACA---CAGCCCCCT-CTG-CTGTCCCATTCC",
#   @score=25.46969696969697,
```

See `test/test-matcher.rb` for more exsamples.

## Histories
- 23.08.02 Released the first version.
- 23.09.11 Stop having scores as property, they are converted into methods.

## Contributors
- [EGTC, Gene Technology Center, Kumamoto University, Japan](https://egtc.jp)
- [LumberMill, Inc.](https://lmlab.net) (Author)
