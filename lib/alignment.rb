class Alignment
  attr_accessor :score, :alignmentI, :alignmentJ, :startI, :startJ, :endI, :endJ, :reversed, :aside, :source

  BLANK = "-"

  def initialize(h=nil)
    return init_from_hash(h) if h
    # スコア
    @score = 0
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
    # アライメント対象配列の取得先。egtcの場合、クローンテーブルまたはアクセッションテーブル
    @source = ""
  end

  def init_from_hash(h)
    # 引数のハッシュから初期化
    @score = h[:score]
    @alignmentI = h[:alignmentI]
    @alignmentJ = h[:alignmentJ]
    @startI = h[:startI]
    @startJ = h[:startJ]
    @endI = h[:endI]
    @endJ = h[:endJ]
    @reversed = h[:reversed]
    @aside = h[:aside]
    @source = h[:source]
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

  def to_s
    "score=#{@score} I=" + @alignmentI + " J=" + @alignmentJ;
  end
end