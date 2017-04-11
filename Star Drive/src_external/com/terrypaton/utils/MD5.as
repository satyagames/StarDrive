/*
 * A JavaScript implementation of the RSA Data Security, Inc. MD5 Message
 * Digest Algorithm, as defined in RFC 1321.
 * Copyright (C) Paul Johnston 1999 - 2000.
 * Updated by Greg Holt 2000 - 2001.
 * See http://pajhome.org.uk/site/legal.html for details.
 * Updated by Ger Hobbelt 2001 (Flash 5) - works for totally buggered MAC Flash player and, of course, Windows / Linux as well.
 * Updated by Ger Hobbelt 2008 (Flash 9 / AS3) - quick fix.
 */
package com.terrypaton.utils {
	/*
	   The 32 bit AND/OR/XOR operations are public as an extra service (I haven't tested if the MM/Adobe Flash bums
	   still haven't learned what 32-bit arith means in AS3).

	   The important interface here is the calculate() which does all the magic, including HEX-encoding the MD5 result.

	   This code is a minimal edit of my Flash5 days' research. When I looked in here to make it Flash 9 / AS 3.0 'tauglich'
	   I had a bad case of Total Recall about the effort it took at that time to make this stuff work on all three
	   platforms. Thinking of flame throwers and roasted flesh (or was that 'Flash'?)...
	 */
	public class MD5 {
		/*
		 * Convert a 32-bit number to a hex string with ls-byte first
		 */
		protected static var hex_chr:String = "0123456789abcdef";

		// 
		// somehow the expression (bitAND(b, c) | bitAND((~b), d)) didn't return correct results on Mac
		// for: 
		// b&c = a8a20450, ((~b)&d) = 0101c88b, (bitAND(b, c) | bitAND((~b), d)) = a8a20450 <-- !!!
		// looks like the OR is not executed at all.
		//
		// let's try to trick the P-code compiler into working with us... Prayer beads are GO!
		// 
		public static function bitOR(a:Number, b:Number):Number {
			var lsb:Number = (a & 0x1) | (b & 0x1);
			var msb31:Number = (a >>> 1) | (b >>> 1);
			// trace("MD5 OR #1: a,b = "+rhex(a)+", "+rhex(b)+", (a|b) = "+rhex((a | b))+", return = "+rhex((msb31 << 1) | lsb));
			return (msb31 << 1) | lsb;
			// return (a | b);
		}

		//  
		// will bitXOR be the only one working...?
		// Nope. XOR fails too if values with bit31 set are XORed. 
		//
		// Note however that OR (and AND and XOR?!) works alright for the statement
		//   (msb31 << 1) | lsb
		// even if the result of the left-shift operation has bit 31 set.
		// So there might be an extra condition here (Guessmode turned on):
		// Mac Flash fails (OR, AND and XOR) if either one of the input operands has bit31 set
		// *and* both operands have one or more bits both set to 1. In other words: when both
		// input bit-patterns 'overlap'.
		// Stuff to munch on for the MM guys, I guess...
		//
		public static function bitXOR(a:Number, b:Number):Number {
			var lsb:Number = (a & 0x1) ^ (b & 0x1);
			var msb31:Number = (a >>> 1) ^ (b >>> 1);
			// trace("MD5 XOR #1: a,b = "+rhex(a)+", "+rhex(b)+", (a^b) = "+rhex((a ^ b))+", return = "+rhex((msb31 << 1) ^ lsb));
			return (msb31 << 1) | lsb;
			// return (a ^ b);
		}

		// 
		// bitwise AND for 32-bit integers. This uses 31 + 1-bit operations internally
		// to work around bug in some AS interpreters. (Mac Flash!)
		// 
		public static function bitAND(a:Number, b:Number):Number {
			var lsb:Number = (a & 0x1) & (b & 0x1);
			var msb31:Number = (a >>> 1) & (b >>> 1);
			return (msb31 << 1) | lsb;
			// return (a & b);
		}

		// 
		// Add integers, wrapping at 2^32. This uses 16-bit operations internally
		// to work around bugs in some AS interpreters. (Mac Flash!)
		// 
		protected static function addme(x:Number, y:Number):Number {
			var lsw:Number = (x & 0xFFFF) + (y & 0xFFFF);
			var msw:Number = (x >> 16) + (y >> 16) + (lsw >> 16);
			// trace("MD5 ADDME #1: x,y = "+rhex(x)+", "+rhex(y)+", msw, lsw = "+rhex(msw)+", "+rhex(lsw));
			return (msw << 16) | (lsw & 0xFFFF);
			// return (a + b);
		}

		protected static function rhex(num:Number):String {
			var str:String = "";
			var j:int;
			for (j = 0; j <= 3; j++) {
				str += hex_chr.charAt((num >> (j * 8 + 4)) & 0x0F) + hex_chr.charAt((num >> (j * 8)) & 0x0F);
			}
			return str;
		}

		/*
		 * Convert a string to a sequence of 16-word blocks, stored as an array.
		 * Append padding bits and the length, as described in the MD5 standard.
		 */
		protected static function str2blks_MD5(str:String):Array {
			var nblk:Number = ((str.length + 8) >> 6) + 1; // 1 + (len + 8)/64
			var blks:Array = new Array(nblk * 16);
			var i:int;
			for (i = 0; i < nblk * 16; i++) {
				blks[i] = 0;
			}
			/*
			   Input:

			   'willi' without the quotes.

			   trace() Output on Intel (and MAC now?):

			   see TXT files: *.Output.txt

			 */
			for (i = 0; i < str.length; i++) {
				blks[i >> 2] |= str.charCodeAt(i) << (((str.length * 8 + i) % 4) * 8);
					// trace("str2blks_MD5: chr["+i+"] = "+str.charCodeAt(i)+",shift:"+(((str.length * 8 + i) % 4)*8)+",shifted:"+rhex(blks[i >> 2]));
			}
			blks[i >> 2] |= 0x80 << (((str.length * 8 + i) % 4) * 8);
			// trace("str2blks_MD5: END - idx:"+i+" = "+0x80+",shift:"+(((str.length * 8 + i) % 4)*8)+",shifted:"+rhex(blks[i >> 2]));
			// blks[nblk * 16 - 2] = str.length * 8;
			var l:Number = str.length * 8;
			blks[nblk * 16 - 2] = (l & 0xFF);
			blks[nblk * 16 - 2] |= ((l >>> 8) & 0xFF) << 8;
			blks[nblk * 16 - 2] |= ((l >>> 16) & 0xFF) << 16;
			blks[nblk * 16 - 2] |= ((l >>> 24) & 0xFF) << 24;
			// trace("str2blks_MD5: LEN - idx*4:"+(nblk * 16 - 2)+" = "+rhex(blks[nblk * 16 - 2]));
			return blks;
		}

		/*
		 * Bitwise rotate a 32-bit number to the left
		 */
		protected static function rol(num:Number, cnt:Number):Number {
			return (num << cnt) | (num >>> (32 - cnt));
		}

		/*
		 * These functions implement the basic operation for each round of the
		 * algorithm.
		 */
		protected static function cmn(q:Number, a:Number, b:Number, x:Number, s:Number, t:Number):Number {
			// trace("MD5 CMN #1: q = "+rhex(q)+", (a + q + x + t) = "+rhex(a + q + x + t)+", rol() = "+rhex(rol((a + q + x + t), s))+", return = "+rhex(rol((a + q + x + t), s) + b)+", returnALT = "+rhex(addme(rol((addme(addme(a, q), addme(x, t))), s), b)));
			return addme(rol((addme(addme(a, q), addme(x, t))), s), b);
		}

		protected static function ff(a:Number, b:Number, c:Number, d:Number, x:Number, s:Number, t:Number):Number {
			// trace("MD5 FF #1: a,b,c,d,x,s,t = "+rhex(a)+","+rhex(b)+","+rhex(c)+","+rhex(d)+","+rhex(x)+","+rhex(s)+","+rhex(t));
			// trace("MD5 FF #2: b&c = "+rhex(bitAND(b, c))+", ((~b)&d) = "+rhex(bitAND((~b), d))+", cmn("+rhex(bitOR(bitAND(b, c), bitAND((~b), d)))+",...)");
			return cmn(bitOR(bitAND(b, c), bitAND((~b), d)), a, b, x, s, t);
		}

		protected static function gg(a:Number, b:Number, c:Number, d:Number, x:Number, s:Number, t:Number):Number {
			// trace("MD5 GG #1: a,b,c,d,x,s,t = "+rhex(a)+","+rhex(b)+","+rhex(c)+","+rhex(d)+","+rhex(x)+","+rhex(s)+","+rhex(t));
			// trace("MD5 GG #2: b&d = "+rhex(bitAND(b, d))+", (c&(~d)) = "+rhex(bitAND(c, (~d)))+", cmn("+rhex(bitOR(bitAND(b, d), bitAND(c, (~d))))+",...)");
			return cmn(bitOR(bitAND(b, d), bitAND(c, (~d))), a, b, x, s, t);
		}

		protected static function hh(a:Number, b:Number, c:Number, d:Number, x:Number, s:Number, t:Number):Number {
			// trace("MD5 HH #1: a,b,c,d,x,s,t = "+rhex(a)+","+rhex(b)+","+rhex(c)+","+rhex(d)+","+rhex(x)+","+rhex(s)+","+rhex(t));
			// trace("MD5 HH #2: (b^c) = "+rhex(b ^ c)+", (b^c^d) = "+rhex(b ^ c ^d)+", cmn("+rhex(bitXOR(bitXOR(b, c), d))+",...)");
			return cmn(bitXOR(bitXOR(b, c), d), a, b, x, s, t);
		}

		protected static function ii(a:Number, b:Number, c:Number, d:Number, x:Number, s:Number, t:Number):Number {
			// trace("MD5 II #1: a,b,c,d,x,s,t = "+rhex(a)+","+rhex(b)+","+rhex(c)+","+rhex(d)+","+rhex(x)+","+rhex(s)+","+rhex(t));
			// trace("MD5 II #2: (b|(~d)) = "+rhex(bitOR(b, (~d)))+", (c^(b|(~d)) = "+rhex(c ^ bitOR(b, (~d)))+", cmn("+rhex(bitXOR(c, bitOR(b, (~d))))+",...)");
			return cmn(bitXOR(c, bitOR(b, (~d))), a, b, x, s, t);
		}

		/*
		 * Take a string and return the hex representation of its MD5.
		 */
		public static function calculate(str:String):String {
			var x:Array = str2blks_MD5(str);
			var a:Number = 1732584193;
			var b:Number = -271733879;
			var c:Number = -1732584194;
			var d:Number = 271733878;
			// trace("MD5INIT: a,b,c,d = "+rhex(a)+","+rhex(b)+","+rhex(c)+","+rhex(d));
			var step:Number;
			var i:int;
			for (i = 0; i < x.length; i += 16) {
				var olda:Number = a;
				var oldb:Number = b;
				var oldc:Number = c;
				var oldd:Number = d;
				step = 0;
				// trace("MD5LOOP: i = "+i+", step = "+(++step)+", a,b,c,d = "+rhex(a)+","+rhex(b)+","+rhex(c)+","+rhex(d));
				a = ff(a, b, c, d, x[i + 0], 7, -680876936);
				// trace("MD5LOOP: i = "+i+", step = "+(++step)+", a,b,c,d = "+rhex(a)+","+rhex(b)+","+rhex(c)+","+rhex(d)+",x[i+ 0] = "+rhex(x[i+ 0]));
				d = ff(d, a, b, c, x[i + 1], 12, -389564586);
				// trace("MD5LOOP: i = "+i+", step = "+(++step)+", a,b,c,d = "+rhex(a)+","+rhex(b)+","+rhex(c)+","+rhex(d)+",x[i+ 1] = "+rhex(x[i+ 1]));
				c = ff(c, d, a, b, x[i + 2], 17, 606105819);
				// trace("MD5LOOP: i = "+i+", step = "+(++step)+", a,b,c,d = "+rhex(a)+","+rhex(b)+","+rhex(c)+","+rhex(d)+",x[i+ 2] = "+rhex(x[i+ 2]));
				b = ff(b, c, d, a, x[i + 3], 22, -1044525330);
				// trace("MD5LOOP: i = "+i+", step = "+(++step)+", a,b,c,d = "+rhex(a)+","+rhex(b)+","+rhex(c)+","+rhex(d)+",x[i+ 3] = "+rhex(x[i+ 3]));
				a = ff(a, b, c, d, x[i + 4], 7, -176418897);
				d = ff(d, a, b, c, x[i + 5], 12, 1200080426);
				c = ff(c, d, a, b, x[i + 6], 17, -1473231341);
				b = ff(b, c, d, a, x[i + 7], 22, -45705983);
				// trace("MD5LOOP: i = "+i+", step = "+(++step)+", a,b,c,d = "+rhex(a)+","+rhex(b)+","+rhex(c)+","+rhex(d)+",x[i+ 4],x[i+ 5],x[i+ 6],x[i+ 7] = "+rhex(x[i+ 4])+","+rhex(x[i+ 5])+","+rhex(x[i+ 6])+","+rhex(x[i+ 7]));
				a = ff(a, b, c, d, x[i + 8], 7, 1770035416);
				d = ff(d, a, b, c, x[i + 9], 12, -1958414417);
				c = ff(c, d, a, b, x[i + 10], 17, -42063);
				b = ff(b, c, d, a, x[i + 11], 22, -1990404162);
				// trace("MD5LOOP: i = "+i+", step = "+(++step)+", a,b,c,d = "+rhex(a)+","+rhex(b)+","+rhex(c)+","+rhex(d)+",x[i+ 8],x[i+ 9],x[i+10],x[i+11] = "+rhex(x[i+ 8])+","+rhex(x[i+ 9])+","+rhex(x[i+10])+","+rhex(x[i+11]));
				a = ff(a, b, c, d, x[i + 12], 7, 1804603682);
				d = ff(d, a, b, c, x[i + 13], 12, -40341101);
				c = ff(c, d, a, b, x[i + 14], 17, -1502002290);
				b = ff(b, c, d, a, x[i + 15], 22, 1236535329);
				// trace("MD5LOOP: i = "+i+", step = "+(++step)+", a,b,c,d = "+rhex(a)+","+rhex(b)+","+rhex(c)+","+rhex(d)+",x[i+12],x[i+13],x[i+14],x[i+15] = "+rhex(x[i+12])+","+rhex(x[i+13])+","+rhex(x[i+14])+","+rhex(x[i+15]));
				a = gg(a, b, c, d, x[i + 1], 5, -165796510);
				d = gg(d, a, b, c, x[i + 6], 9, -1069501632);
				c = gg(c, d, a, b, x[i + 11], 14, 643717713);
				b = gg(b, c, d, a, x[i + 0], 20, -373897302);
				// trace("MD5LOOP: i = "+i+", step = "+(++step)+", a,b,c,d = "+rhex(a)+","+rhex(b)+","+rhex(c)+","+rhex(d)+",x[i+ 1],x[i+ 6],x[i+11],x[i+ 0] = "+rhex(x[i+ 1])+","+rhex(x[i+ 6])+","+rhex(x[i+11])+","+rhex(x[i+ 0]));
				a = gg(a, b, c, d, x[i + 5], 5, -701558691);
				d = gg(d, a, b, c, x[i + 10], 9, 38016083);
				c = gg(c, d, a, b, x[i + 15], 14, -660478335);
				b = gg(b, c, d, a, x[i + 4], 20, -405537848);
				// trace("MD5LOOP: i = "+i+", step = "+(++step)+", a,b,c,d = "+rhex(a)+","+rhex(b)+","+rhex(c)+","+rhex(d)+",x[i+ 5],x[i+10],x[i+15],x[i+ 4] = "+rhex(x[i+ 5])+","+rhex(x[i+10])+","+rhex(x[i+15])+","+rhex(x[i+ 4]));
				a = gg(a, b, c, d, x[i + 9], 5, 568446438);
				d = gg(d, a, b, c, x[i + 14], 9, -1019803690);
				c = gg(c, d, a, b, x[i + 3], 14, -187363961);
				b = gg(b, c, d, a, x[i + 8], 20, 1163531501);
				// trace("MD5LOOP: i = "+i+", step = "+(++step)+", a,b,c,d = "+rhex(a)+","+rhex(b)+","+rhex(c)+","+rhex(d)+",x[i+ 9],x[i+14],x[i+ 3],x[i+ 8] = "+rhex(x[i+ 9])+","+rhex(x[i+14])+","+rhex(x[i+ 3])+","+rhex(x[i+ 8]));
				a = gg(a, b, c, d, x[i + 13], 5, -1444681467);
				d = gg(d, a, b, c, x[i + 2], 9, -51403784);
				c = gg(c, d, a, b, x[i + 7], 14, 1735328473);
				b = gg(b, c, d, a, x[i + 12], 20, -1926607734);
				// trace("MD5LOOP: i = "+i+", step = "+(++step)+", a,b,c,d = "+rhex(a)+","+rhex(b)+","+rhex(c)+","+rhex(d)+",x[i+13],x[i+ 2],x[i+ 7],x[i+12] = "+rhex(x[i+13])+","+rhex(x[i+ 2])+","+rhex(x[i+ 7])+","+rhex(x[i+12]));
				a = hh(a, b, c, d, x[i + 5], 4, -378558);
				d = hh(d, a, b, c, x[i + 8], 11, -2022574463);
				c = hh(c, d, a, b, x[i + 11], 16, 1839030562);
				b = hh(b, c, d, a, x[i + 14], 23, -35309556);
				// trace("MD5LOOP: i = "+i+", step = "+(++step)+", a,b,c,d = "+rhex(a)+","+rhex(b)+","+rhex(c)+","+rhex(d)+",x[i+ 5],x[i+ 8],x[i+11],x[i+14] = "+rhex(x[i+ 5])+","+rhex(x[i+ 8])+","+rhex(x[i+11])+","+rhex(x[i+14]));
				a = hh(a, b, c, d, x[i + 1], 4, -1530992060);
				d = hh(d, a, b, c, x[i + 4], 11, 1272893353);
				c = hh(c, d, a, b, x[i + 7], 16, -155497632);
				b = hh(b, c, d, a, x[i + 10], 23, -1094730640);
				// trace("MD5LOOP: i = "+i+", step = "+(++step)+", a,b,c,d = "+rhex(a)+","+rhex(b)+","+rhex(c)+","+rhex(d)+",x[i+ 1],x[i+ 4],x[i+ 7],x[i+10] = "+rhex(x[i+ 1])+","+rhex(x[i+ 4])+","+rhex(x[i+ 7])+","+rhex(x[i+10]));
				a = hh(a, b, c, d, x[i + 13], 4, 681279174);
				d = hh(d, a, b, c, x[i + 0], 11, -358537222);
				c = hh(c, d, a, b, x[i + 3], 16, -722521979);
				b = hh(b, c, d, a, x[i + 6], 23, 76029189);
				// trace("MD5LOOP: i = "+i+", step = "+(++step)+", a,b,c,d = "+rhex(a)+","+rhex(b)+","+rhex(c)+","+rhex(d)+",x[i+13],x[i+ 0],x[i+ 3],x[i+ 6] = "+rhex(x[i+13])+","+rhex(x[i+ 0])+","+rhex(x[i+ 3])+","+rhex(x[i+ 6]));
				a = hh(a, b, c, d, x[i + 9], 4, -640364487);
				d = hh(d, a, b, c, x[i + 12], 11, -421815835);
				c = hh(c, d, a, b, x[i + 15], 16, 530742520);
				b = hh(b, c, d, a, x[i + 2], 23, -995338651);
				// trace("MD5LOOP: i = "+i+", step = "+(++step)+", a,b,c,d = "+rhex(a)+","+rhex(b)+","+rhex(c)+","+rhex(d)+",x[i+ 9],x[i+12],x[i+15],x[i+ 2] = "+rhex(x[i+ 9])+","+rhex(x[i+12])+","+rhex(x[i+15])+","+rhex(x[i+ 2]));
				a = ii(a, b, c, d, x[i + 0], 6, -198630844);
				d = ii(d, a, b, c, x[i + 7], 10, 1126891415);
				c = ii(c, d, a, b, x[i + 14], 15, -1416354905);
				b = ii(b, c, d, a, x[i + 5], 21, -57434055);
				// trace("MD5LOOP: i = "+i+", step = "+(++step)+", a,b,c,d = "+rhex(a)+","+rhex(b)+","+rhex(c)+","+rhex(d)+",x[i+ 0],x[i+ 7],x[i+14],x[i+ 5] = "+rhex(x[i+ 0])+","+rhex(x[i+ 7])+","+rhex(x[i+14])+","+rhex(x[i+ 5]));
				a = ii(a, b, c, d, x[i + 12], 6, 1700485571);
				d = ii(d, a, b, c, x[i + 3], 10, -1894986606);
				c = ii(c, d, a, b, x[i + 10], 15, -1051523);
				b = ii(b, c, d, a, x[i + 1], 21, -2054922799);
				// trace("MD5LOOP: i = "+i+", step = "+(++step)+", a,b,c,d = "+rhex(a)+","+rhex(b)+","+rhex(c)+","+rhex(d)+",x[i+12],x[i+ 3],x[i+10],x[i+ 1] = "+rhex(x[i+12])+","+rhex(x[i+ 3])+","+rhex(x[i+10])+","+rhex(x[i+ 1]));
				a = ii(a, b, c, d, x[i + 8], 6, 1873313359);
				d = ii(d, a, b, c, x[i + 15], 10, -30611744);
				c = ii(c, d, a, b, x[i + 6], 15, -1560198380);
				b = ii(b, c, d, a, x[i + 13], 21, 1309151649);
				// trace("MD5LOOP: i = "+i+", step = "+(++step)+", a,b,c,d = "+rhex(a)+","+rhex(b)+","+rhex(c)+","+rhex(d)+",x[i+ 8],x[i+15],x[i+ 6],x[i+13] = "+rhex(x[i+ 8])+","+rhex(x[i+15])+","+rhex(x[i+ 6])+","+rhex(x[i+13]));
				a = ii(a, b, c, d, x[i + 4], 6, -145523070);
				d = ii(d, a, b, c, x[i + 11], 10, -1120210379);
				c = ii(c, d, a, b, x[i + 2], 15, 718787259);
				b = ii(b, c, d, a, x[i + 9], 21, -343485551);
				// trace("MD5LOOP: i = "+i+", step = "+(++step)+", a,b,c,d = "+rhex(a)+","+rhex(b)+","+rhex(c)+","+rhex(d)+",x[i+ 4],x[i+11],x[i+ 2],x[i+ 9] = "+rhex(x[i+ 4])+","+rhex(x[i+11])+","+rhex(x[i+ 2])+","+rhex(x[i+ 9]));
				a = addme(a, olda);
				b = addme(b, oldb);
				c = addme(c, oldc);
				d = addme(d, oldd);
					// trace("MD5LOOP: i = "+i+", step = "+(++step)+", a,b,c,d = "+rhex(a)+","+rhex(b)+","+rhex(c)+","+rhex(d));
			}
			// trace("MD5FINISH: a,b,c,d = "+rhex(a)+","+rhex(b)+","+rhex(c)+","+rhex(d));
			return rhex(a) + rhex(b) + rhex(c) + rhex(d);
		}
	}
}