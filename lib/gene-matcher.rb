
require_relative 'smith-waterman'

class Matcher
  attr_accessor :input_sequence, :limit
  attr_reader :alignments

  def initialize(input_sequence, limit = 0.6)
    @limit = limit
    @input_sequence = input_sequence
    @alignments = []
  end

  def scan(target_sequence,source = {})
    sw = SmithWaterman.instance
    a = sw.alignment(target_sequence, @input_sequence)
    a.source = source
    @alignments += [a] if a.score >= @limit
  end
end

