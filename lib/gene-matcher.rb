
require_relative 'smith-waterman'

class Matcher
  attr_accessor :input_sequence, :limit, :reserve_target_sequence
  attr_reader :alignments

  def initialize(input_sequence, limit = 0.6)
    @limit = limit
    @reserve_target_sequence = false
    @input_sequence = input_sequence
    @alignments = []
  end

  def scan(target_sequence,source = {})
    sw = SmithWaterman.instance
    a = sw.alignment(target_sequence, @input_sequence)
    a.source = {}.merge(source)
    a.source[:target_sequence] = target_sequence if @reserve_target_sequence
    puts "#{a.score} / #{a.alignment_count} = #{a.score / a.alignment_count}" if ENV["DEBUG"]
    @alignments += [a] if a.score / a.alignment_count >= @limit
  end
end

