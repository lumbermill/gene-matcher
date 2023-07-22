/*
 * Created on 2004/08/04
 *
 */

import java.io.IOException;
import java.io.StringReader;

/**
 * アライメント。
 * 
 * @author yosei
 * 
 */
public class Alignment implements Comparable<Alignment> {
	/**
	 * ブランク。
	 */
	protected static final String BLANK = "-";

	public static final int FROM_CLONE_SEQUENCE = 1;

	public static final int FROM_ACCESSION_SEQUENCE = 2;

	/**
	 * 検索対象（データベース内）配列
	 */
	public String alignmentI;
	/**
	 * 検索（入力された）配列
	 */
	public String alignmentJ;
	/**
	 * 配列の全長
	 */
	public int wholeLengthI;
	/**
	 * 配列の全長
	 */
	public int wholeLengthJ;
	/*
	 * iは検索対象（データベースに入ってた）配列 jは検索した（検索用に入力された）配列
	 * 
	 * alignment アライメント wholeLength 元の配列の全長 start （元の配列中の）アライメント開始位置 end
	 * （元の配列中の）アライメント終了位置
	 */
	public int startI, startJ, endI, endJ;

	/**
	 * スコア
	 */
	protected double score;


	/**
	 * 前後の反転
	 */
	public boolean reversed = false;
	/**
	 * 逆の鎖
	 */
	public boolean aside = false;

	/**
	 * アライメント対象配列の取得先。クローンテーブルまたはアクセッションテーブル
	 */
	public int source;

	/**
	 * 二つの配列の一致部分と不一致部分を表した文字列を返す。 ex. AGTCAAAAAAAAA- :...:::::::::.
	 * AT-TAAAAAAAAAG
	 * 
	 * @return :と.からなる文字列
	 */
	public String getAlignment() {
		StringReader i = new StringReader(alignmentI);
		StringReader j = new StringReader(alignmentJ);
		StringBuffer sb = new StringBuffer();
		try {
			while (true) {
				int ii = i.read();
				int jj = j.read();
				if (ii == -1 || jj == -1)
					break;
				else if (ii == jj)
					sb.append(":");
				else
					sb.append(".");
			}
		} catch (IOException e) {
			e.printStackTrace();
			return null;
		}
		return new String(sb);
	}

	/**
	 * 二つの配列の一致部分の長さを返す
	 * 
	 * @return
	 */
	public int getAlignmentCount() {
		StringReader sr = new StringReader(getAlignment());
		int count = 0;
		int ch;
		try {
			while ((ch = sr.read()) != -1) {
				if (ch == ':')
					count++;
			}
			return count;
		} catch (IOException e) {
			e.printStackTrace();
			return -1;
		}
	}

	public int getNumberOfBlank() {
		StringReader sr = null;
		int count = 0;
		int ch;
		try {
			sr = new StringReader(alignmentJ);
			while ((ch = sr.read()) != -1) {
				if (ch == BLANK.charAt(0))
					count++;
			}
			sr = new StringReader(alignmentI);
			while ((ch = sr.read()) != -1) {
				if (ch == BLANK.charAt(0))
					count++;
			}
		} catch (IOException e) {
			e.printStackTrace();
			count = -1;
		} finally {
			sr.close();
		}
		return count;
	}

	public String toString() {
		return "score=" + score + " I=" + alignmentI + " J=" + alignmentJ;
	}

	/**
	 * 設定されたスコア順に並ぶ
	 */
	public int compareTo(Alignment a) {
			return new Double(score).compareTo(new Double(a.score));
	}

	public double getScore() {
		return score;
	}
}