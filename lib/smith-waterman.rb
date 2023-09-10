# Calculate the similarity of two sequences.
# Originally created in Java language on 2004/08/04
# Migrated to Ruby on 2023/07/10
require_relative 'alignment'
require 'singleton'

class SmithWaterman
  include Singleton

  def alignment(target,input)
    alignments = [] * 2
    alignments[0] = alignment_local(target,input)
    alignments[1] = alignment_local(target,aside_sequence(input))
    alignments[1].aside = true

    # TODO: wholeLengthI, wholeLengthJを設定する
    # a[1].startJ = a[1].wholeLengthJ -a[1].startJ -1;
    # a[1].endJ = a[1].wholeLengthJ -a[1].endJ-1;
    return max(alignments)
  end

  def alignment_local(target,input)
    raise "input is nil or empty" if input.nil? || input.empty?
    raise "target is nil or empty" if target.nil? || target.empty?

    # 行列の初期化

    matrix = Array.new(target.length) { Array.new(input.length,0) }
    maxScore = 0; maxI = 0; maxJ = 0
    target.length.times do |i|
      ci = target[i] # 検索対象文字
      input.length.times do |j|
        cj = input[j] # 検索文字
        candidates = [0] * 4
        candidates[0] = 0 # 未使用(常に0)
        if i > 0 && j > 0
          candidates[1] = matrix[i-1][j-1] + s(ci,cj)
        else
          candidates[1] = s(ci,cj)
        end

        if i > 0
          candidates[2] = matrix[i-1][j] - 1
        end
        if j > 0
          candidates[3] = matrix[i][j-1] - 1
        end
        matrix[i][j] = candidates.max
        # スコアの最大点を記憶
        if matrix[i][j] >= maxScore
          maxScore = matrix[i][j]
          maxI = i
          maxJ = j
        end
      end
      puts ci+" "+matrix[i].join(" ") if ENV["DEBUG"]      
    end
    puts "maxScore=#{maxScore} maxI=#{maxI} maxJ=#{maxJ}" if ENV["DEBUG"]

    a = Alignment.new
    a.endI = maxI
    a.endJ = maxJ
    i = maxI; j = maxJ; bufI = target[i]; bufJ = input[j]
    while i > 0 && j > 0 do
      dst = [] * 3
      dst[0] = matrix[i-1][j-1]
      dst[1] = matrix[i-1][j] if i > 0
      dst[2] = matrix[i][j-1] if j > 0
      break if dst.max == 0 # 行き先がなければ終了
      case dst.index(dst.max)
      when 0
        i -= 1
        j -= 1
        bufI += target[i]
        bufJ += input[j]
      when 1
        i -= 1
        bufI += target[i]
        bufJ += Alignment::BLANK        
      when 2
        j -= 1
        bufI += Alignment::BLANK
        bufJ += input[j]
      end
    end
    a.alignmentI = bufI.reverse
    a.alignmentJ = bufJ.reverse
    a.startI = i
    a.startJ = j

    # スコアはここでは求めない(Java版ではここで決定していた)
    return a
  end

  private
    # 与えられたアライメント配列のうちスコアが最大のものを返す。
    def max(alignments)
      max_alignment = alignments[0]
      alignments.each do |a|
        if a.score > max_alignment.score
          max_alignment = a
        end
      end
      max_alignment
    end

    # スコアリング関数。一致したら1、そうでなければ0を返す。
    def s(a,b)
      return a == b ? 1 : 0
    end

    def aside_sequence(seq)
      seq.reverse.tr("AGTC", "TCAG")
    end
end