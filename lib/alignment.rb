class Alignment
  attr_accessor :alignmentI, :alignmentJ, :startI, :startJ, :endI, :endJ, :reversed, :aside, :source

  BLANK = "-"

  def initialize(h=nil)
    return init_from_hash(h) if h
    # 検索対象（データベースに入っていた）配列
    @alignmentI = ""
    # 検索した（クエリ=入力された）配列
    @alignmentJ = ""
    # start （元の配列中の）アライメント開始位置
    # end（元の配列中の）アライメント終了位置
    @startI = 0
    @startJ = 0
    endI = 0
    endJ = 0 
    # 前後の反転
    @reversed = false
    # 逆の鎖
    @aside = false
    # アライメント対象配列の取得先情報(任意)。例えば、データベースのテーブル名やIDなど。
    @source = {}
  end

  def init_from_hash(h)
    # 引数のハッシュから初期化
    @alignmentI = h["alignmentI"]
    @alignmentJ = h["alignmentJ"]
    @startI = h["startI"]
    @startJ = h["startJ"]
    @endI = h["endI"]
    @endJ = h["endJ"]
    @reversed = h["reversed"]
    @aside = h["aside"]
    @source = h["source"]
  end

  def to_h
    # ハッシュに変換
    h = {}
    h["alignmentI"] = @alignmentI
    h["alignmentJ"] = @alignmentJ
    h["startI"] = @startI
    h["startJ"] = @startJ
    h["endI"] = @endI
    h["endJ"] = @endJ
    h["reversed"] = @reversed
    h["aside"] = @aside
    h["source"] = @source
    return h
  end

  # 二つの配列の一致部分と不一致部分を表した文字列を返す。
  # ex. AGTCAAAAAAAAA- :...:::::::::. AT-TAAAAAAAAAG
  # 
  # 戻り値 :と.からなる文字列
  def alignment
    len = @alignmentI.length
    len = @alignmentJ.length if @alignmentJ.length < len
    buf = ""
    len.times do |i|
      ii = @alignmentI[i]
      jj = @alignmentJ[i]
      if ii == jj
        buf += ":"
      else
        buf += "."
      end
    end
    return buf
  end

  # 二つの配列の一致部分の長さを返す
  def alignment_count
    count = 0
    alignment.each_char do |c|
      count += 1 if c == ":"
    end
    return count  
  end

  def number_of_blank
  end

  def score_a
    return 0 if @alignmentI.length == 0
    return alignment_count / @alignmentI.length.to_f
  end

  def score(thresh=20)
    # 長さがthresh以下なら0を返す
    return 0 if @alignmentI.length < thresh
    return alignment_count * score_a
  end

  def to_s
    "score=#{score} I=" + @alignmentI + " J=" + @alignmentJ;
  end
end