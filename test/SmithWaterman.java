/*
 * Created on 2004/08/04
 *
 */


/**
 * Smith.Watermanのアルゴリズムによって配列の類似度を求める。
 * 
 * @author yosei
 *
 */
public class SmithWaterman{
    /**
     * この値をtrueにするとデバッグ用のメッセージがあちこちで標準出力に出力されます。
     */
	boolean DEBUG = false;
	public SmithWaterman() {
	}

	/**
	 * 途中経過のマトリックスを表示するためにはDEBUGをtrueに
	 * @param DEBUG
	 */
	public SmithWaterman(boolean DEBUG) {
		this.DEBUG = DEBUG;
	}
	
	/**
	 * アライメントを求める
	 */
	public Alignment getAlignment(String input, String target) {
		Alignment a[] = new Alignment[2];
	    // 0.普通にアライメントを求める
		a[0] = getAlignmentLocal(input,target);
	    // 1.文字列をひっくり返してアライメントを求める
//	    String input2 = new String(new StringBuffer(input).reverse());
//	    a[1] = getAlignmentLocal(input2,target);
//	    a[1].reversed = true;
//	    a[1].startJ = a[1].alignmentJ.length() -a[1].startJ;
//	    a[1].endJ = a[1].alignmentJ.length() -a[1].endJ;
	    // 2.逆の鎖のアライメントも求めてみる
	    String input3 = getAsideSequence(input);
	    a[1] = getAlignmentLocal(input3,target);
	    a[1].aside = true;
	    a[1].startJ = a[1].wholeLengthJ -a[1].startJ -1;
	    a[1].endJ = a[1].wholeLengthJ -a[1].endJ-1;
	    // 2.ひっくり返した逆の鎖のアライメントも求めてみる
//	    String input4 = getAsideSequence(input);
//	    input4 = new String(new StringBuffer(input4).reverse());
//	    a[3] = getAlignmentLocal(input4,target);
//	    a[3].aside = true;
//	    a[3].reversed = true;
//	    a[3].startJ = a[3].alignmentJ.length() -a[3].startJ;
//	    a[3].endJ = a[3].alignmentJ.length() -a[3].endJ;
	    
	    return max(a);
	}

    /**
     * 二つの配列のアライメントを求める
     * 
     * @param input 入力配列
     * @param target 対象配列
     * @return アライメント（類似部分）
     */
    private Alignment getAlignmentLocal(String input, String target) {
        if(input == null) throw new NullPointerException("input can't be null.");
        if(input == null) throw new NullPointerException("target can't be null.");
        
		int matrix[][] = new int[target.length()][input.length()];
		int maxScore = 0, maxI = 0, maxJ = 0;
		for (int i = 0; i < matrix.length; i++) {
			// 検索対象文字
			char ci = target.charAt(i);
			for (int j = 0; j < matrix[i].length; j++) {
				char cj = input.charAt(j);
				int candidate[] = new int[4];
				candidate[0] = 0;
				if (i != 0 && j != 0) {
					candidate[1] = matrix[i - 1][j - 1] + s(ci, cj);
				} else
					candidate[1] = s(ci, cj);
				// d = 1でよいのか？
				if (i != 0)
					candidate[2] = matrix[i - 1][j] - 1;
				if (j != 0)
					candidate[3] = matrix[i][j - 1] - 1;
				matrix[i][j] = max(candidate);
				// スコアの最大点を記憶
				if (matrix[i][j] >= maxScore) {
					maxScore = matrix[i][j];
					maxI = i;
					maxJ = j;
				}
			}
			// -- デバッグ --
			// matrix[][]の中身を表示する。
			if (DEBUG) {
				System.out.print(ci + " ");
				for (int j = 0; j < matrix[i].length; j++) {
					System.out.print(matrix[i][j] + " ");
				}
				System.out.println();
			}
			// -- デバッグ --
		}
		// -- デバッグ --
		// 最大点
		if (DEBUG) {
			System.out.println(
				"max= " + maxScore + "(" + maxI + "," + maxJ + ")");
		}
		// -- デバッグ --

		// アライメント生成
		Alignment a = new Alignment();
		// スコアを決定(0~1に正規化)
	//	a.score = (double) maxScore / input.length();
		
		// 配列の全長を一応保管しとこ（スコア決定に使えそうだから）
		a.wholeLengthI = target.length();
		a.wholeLengthJ = input.length();
		
		// スコア最大点から逆向きにトレース
		// アライメントシーケンスを求める。
		int i = maxI, j = maxJ;
		a.endI = i;
		a.endJ = j;
		StringBuffer bufI = new StringBuffer();
		StringBuffer bufJ = new StringBuffer();
		if(target.length()>0)bufI.append(target.charAt(i));
		if(input.length() > 0)bufJ.append(input.charAt(j));

		while (i > 0 && j > 0) {
			int dst[] = new int[3];
			dst[0] = matrix[i - 1][j - 1];
			if (i > 0)
				dst[1] = matrix[i - 1][j];
			if (j > 0)
				dst[2] = matrix[i][j - 1];
			// 行き先がなければ終了
			if (max(dst) == 0)
				break;
			switch (maxIndex(dst)) {
				case 0 :
					i--;
					j--;
					bufI.append(target.charAt(i));
					bufJ.append(input.charAt(j));
					break;
				case 1 :
					i--;
					bufI.append(target.charAt(i));
					bufJ.append(Alignment.BLANK);
					break;
				case 2 :
					j--;
					bufI.append(Alignment.BLANK);
					bufJ.append(input.charAt(j));
					break;
			}
		}
		a.alignmentI = new String(bufI.reverse());
		a.alignmentJ = new String(bufJ.reverse());
		a.startI = i;
		a.startJ = j;

		// スコア決定
		// 配列長が20以下の場合、スコアは0に。
		if(a.alignmentI.length() <= 20) a.score = 0.0;
		else{
		    double scoreA = a.getAlignmentCount()/(double)a.alignmentI.length();
			a.score = a.getAlignmentCount()*scoreA;
		}
		return a;
	}

	/**
	 * 配列中の最大値を返す。
	 * 
	 * @param array
	 * @return 最大値
	 */
	private int max(int array[]) {
		int max = 0;
		for (int i = 0; i < array.length; i++) {
			if (array[i] > max)
				max = array[i];
		}
		return max;
	}
	
	/**
	 * 与えられたアライメント配列のうちスコアが最大のものを返す。
	 * 
	 * @param a アライメントの配列
	 * @return スコア最大だったアライメント
	 */
	private Alignment max(Alignment a[]){
		int max = 0;
		for (int i = 1; i < a.length; i++) {
			if(a[i].getScore() > a[max].getScore()) max = i;
		}
		return a[max];
	}

	/**
	 * 配列中の最大値が格納されたインデックスを返す。
	 * 
	 * @param array 
	 * @return 最大値の入ったインデックス(0~array.lenght-1)
	 */
	private int maxIndex(int[] array) {
		int max = 0, index = -1;
		for (int i = 0; i < array.length; i++) {
			if (array[i] > max) {
				max = array[i];
				index = i;
			}
		}
		return index;
	}

	/**
	 * スコアリング関数。一致したら1、そうでなければ0を返す。
	 * 
	 * @param a 塩基１
	 * @param b 塩基２
	 * @return　1 or 0
	 */
	private int s(char a, char b) {
		if (a == b)
			return 1;
		else
			return 0;
	}

	private String getAsideSequence(String seq){
		StringBuffer sb = new StringBuffer();
		for (int i = 0; i < seq.length(); i++) {
			char ch = seq.charAt(i);
			switch(ch){
			case 'A':
				sb.append("T");
				break;
			case 'G': 
				sb.append("C");
				break;
			case 'T': 
				sb.append("A");
				break;
			case 'C': 
				sb.append("G");
				break;
				default:
					sb.append(ch);
			}
		}
		return new String(sb.reverse());
	}
	
	public static void main(String args[]) {
        String input = "ATCA";
        String target = "TATCGAGT";

        SmithWaterman sw = new SmithWaterman(true);
        Alignment a = sw.getAlignment(input, target);
        System.out.println(a);
		System.out.println(a.getAlignment());
    }
}
