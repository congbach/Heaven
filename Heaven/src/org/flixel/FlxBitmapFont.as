/**
 * FlxBitmapFont
 * 
 * Note the package is set-up such that it expects you to place this file into the org/flixel/ structure
 * 
 * @author Richard Davey, Photon Storm, http://www.photonstorm.com
 * @version 1 - 20th May 2010
 */

package org.flixel 
{
	import errors.IllegalArgumentException;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class FlxBitmapFont extends FlxSprite
	{
		/**
		 * Predesigned font
		 */
		[Embed(source = 'data/bluepink_font.png')] private static const bluepinkFont:Class;
		[Embed(source = 'data/bubbles_font.png')] private static const bubblesFont:Class;
		[Embed(source = 'data/deltaforce_font.png')] private static const deltaForceFont:Class;
		[Embed(source = 'data/knighthawks_font.png')] private static const knighthawksFont:Class;
		[Embed(source = 'data/naos_font.png')] private static const naosFont:Class;
		[Embed(source = 'data/spaz_font.png')] private static const spazFont:Class;
		[Embed(source = 'data/robocop_font.png')] private static const robocopFont:Class;
		[Embed(source = 'data/anuvverbubbla_8x8.png')] private static const anuvverbubblaFont:Class;
		[Embed(source = 'data/bloxxit_8x8.png')] private static const bloxxitFont:Class;
		[Embed(source = 'data/bubblemad_8x8.png')] private static const bubblemadFont:Class;
		[Embed(source = 'data/digifont_16x16.png')] private static const digifontFont:Class;
		[Embed(source = 'data/fasttracker2-style_12x12.png')] private static const fasttracker2_styleFont:Class;
		[Embed(source = 'data/geebeeyay_8x16.png')] private static const geebeeyay_8x16Font:Class;
		[Embed(source = 'data/geebeeyay-8x8.png')] private static const geebeeyay_8x8Font:Class;
		[Embed(source = 'data/gold_8x8.png')] private static const goldFont:Class;
		[Embed(source = 'data/gradbubble-32x32-wip.png')] private static const gradbubbleFont:Class;
		[Embed(source = 'data/kromagrad_16x16.png')] private static const kromagradFont:Class;
		[Embed(source = 'data/kromasky_16x16.png')] private static const kromaskyFont:Class;
		[Embed(source = 'data/mig68000_8x16.png')] private static const mig68000Font:Class;
		[Embed(source = 'data/nfo-font_6x8.png')] private static const nfo_fontFont:Class;
		[Embed(source = 'data/nuskool_krome_64x64.png')] private static const nuskool_kromeFont:Class;
		[Embed(source = 'data/outline_24x32.png')] private static const outlineFont:Class;
		[Embed(source = 'data/proportional_8x8.png')] private static const proportional_8x8Font:Class;
		[Embed(source = 'data/proportional_16x16.png')] private static const proportional_16x16Font:Class;
		[Embed(source = 'data/simple_6x8.png')] private static const simpleFont:Class;
		[Embed(source = 'data/teenyshadow_5x9.png')] private static const teenyshadowFont:Class;
		[Embed(source = 'data/verifier_font_8x8.png')] private static const verifier_fontFont:Class;
		/**
		 * Enum for all the pre-designed font
		 */
		static public const BLUE_PINK_32x32:int = 0;
		static public const BUBBLES_32x32:int = 1;
		static public const DELTA_FORCE_16x16:int = 2;
		static public const KNIGHT_HAWKS_31x25:int = 3;
		static public const NAOS_32x32:int = 4;
		static public const SPAZ_32x32:int = 5;
		static public const ROBOCOP_26x32:int = 6;
		static public const ANUVVERBUBBLA_8X8:int = 7;
		static public const BLOXXIT_8X8:int = 8;
		static public const BUBBLEMAD_8X8:int = 9;
		static public const DIGIFONT_16X16:int = 10;
		static public const FASTTRACKER2_STYLE_12X12:int = 11;
		static public const GEEBEEYAY_8X16:int = 12;
		static public const GEEBEEYAY_8X8:int = 13;
		static public const GOLD_8X8:int = 14;
		static public const GRADBUBBLE_32X32:int = 15;
		static public const KROMAGRAD_16X16:int = 16;
		static public const KROMASKY_16X16:int = 17;
		static public const MIG68000_8X16:int = 18;
		static public const NFO_FONT_6X8:int = 19;
		static public const NUSKOOL_KROME_64X64:int = 20;
		static public const OUTLINE_24X32:int = 21;
		static public const PROPORTIONAL_8X8:int = 22;
		static public const PROPORTIONAL_16X16:int = 23;
		static public const SIMPLE_6X8:int = 24;
		static public const TEENYSHADOW_5X9:int = 25;
		static public const VERIFIER_FONT_8X8:int = 26;
		/**
		 * Convenient constructor to obtain a pre-designed font
		 * 
		 * @param	fontType
		 * 			is the type of the font, must be one of the enum defined above
		 * 
		 * @return	the predesigned font with the given type
		 * @throw 	IllegalArgumentsException if there is no predesigned font with the give type
		 */
		static public function getDesignedFont(fontType:int):FlxBitmapFont {
			switch(fontType) {
				case BLUE_PINK_32x32: return new FlxBitmapFont(bluepinkFont, 32, 32, FlxBitmapFont.TEXT_SET2, 10);
				case BUBBLES_32x32: return new FlxBitmapFont(bubblesFont, 32, 32, " FLRX!AGMSY?BHNTZ-CIOU. DJPV, EKQW' ", 6);
				case DELTA_FORCE_16x16: return new FlxBitmapFont(deltaForceFont, 16, 16, FlxBitmapFont.TEXT_SET4 + ".:;!?\"'()^-,/abcdefghij", 20, 0, 1);
				case KNIGHT_HAWKS_31x25: new FlxBitmapFont(knighthawksFont, 31, 25, FlxBitmapFont.TEXT_SET2, 10, 1, 0);
				case NAOS_32x32: return new FlxBitmapFont(naosFont, 31, 32, FlxBitmapFont.TEXT_SET10 + "4()!45789", 6, 16, 1);
				case SPAZ_32x32: return new FlxBitmapFont(spazFont, 32, 32, FlxBitmapFont.TEXT_SET11 + "#", 9, 1, 1);
				case ROBOCOP_26x32: new FlxBitmapFont(robocopFont, 26, 32, " !\"aao '()  ;-./          :; = ?*ABCDEFGHIJKLMNOPQRSTUVWXYZ", 10, 6, 0, 3, 0);
				case ANUVVERBUBBLA_8X8: return new FlxBitmapFont(anuvverbubblaFont, 8, 8, FlxBitmapFont.TEXT_SET2, FlxBitmapFont.TEXT_SET2.length);
				case BLOXXIT_8X8: return new FlxBitmapFont(bloxxitFont, 8, 8, FlxBitmapFont.TEXT_SET10, FlxBitmapFont.TEXT_SET10.length);
				case BUBBLEMAD_8X8: return new FlxBitmapFont(bubblemadFont, 8, 8, FlxBitmapFont.TEXT_SET2, FlxBitmapFont.TEXT_SET2.length);
				case DIGIFONT_16X16: return new FlxBitmapFont(digifontFont, 16, 16, FlxBitmapFont.TEXT_SET2, FlxBitmapFont.TEXT_SET2.length);
				case FASTTRACKER2_STYLE_12X12: return new FlxBitmapFont(fasttracker2_styleFont, 12, 12, FlxBitmapFont.TEXT_SET1, 1);
				case GEEBEEYAY_8X16: return new FlxBitmapFont(geebeeyay_8x16Font, 8, 16, FlxBitmapFont.TEXT_SET2, FlxBitmapFont.TEXT_SET2.length);
				case GEEBEEYAY_8X8: return new FlxBitmapFont(geebeeyay_8x8Font, 8, 8, FlxBitmapFont.TEXT_SET2, FlxBitmapFont.TEXT_SET2.length);
				case GOLD_8X8: return new FlxBitmapFont(goldFont, 8, 8, FlxBitmapFont.TEXT_SET10, FlxBitmapFont.TEXT_SET10.length);
				case GRADBUBBLE_32X32: return new FlxBitmapFont(gradbubbleFont, 32, 32, FlxBitmapFont.TEXT_SET10, 1);
				case KROMAGRAD_16X16: return new FlxBitmapFont(kromagradFont, 16, 16, FlxBitmapFont.TEXT_SET2, FlxBitmapFont.TEXT_SET2.length);
				case KROMASKY_16X16: return new FlxBitmapFont(kromaskyFont, 16, 16, FlxBitmapFont.TEXT_SET2, FlxBitmapFont.TEXT_SET2.length);
				case MIG68000_8X16: return new FlxBitmapFont(mig68000Font, 8, 16, FlxBitmapFont.TEXT_SET10, FlxBitmapFont.TEXT_SET10.length);
				case NFO_FONT_6X8: return new FlxBitmapFont(nfo_fontFont, 6, 8, FlxBitmapFont.TEXT_SET2, FlxBitmapFont.TEXT_SET2.length);
				case NUSKOOL_KROME_64X64: return new FlxBitmapFont(nuskool_kromeFont, 64, 64, FlxBitmapFont.TEXT_SET2, FlxBitmapFont.TEXT_SET2.length);
				case OUTLINE_24X32: return new FlxBitmapFont(outlineFont, 24, 3, FlxBitmapFont.TEXT_SET1, FlxBitmapFont.TEXT_SET1.length);
				case PROPORTIONAL_8X8: return new FlxBitmapFont(proportional_8x8Font, 8, 8, FlxBitmapFont.TEXT_SET2, 1);
				case PROPORTIONAL_16X16: return new FlxBitmapFont(proportional_16x16Font, 16, 16, FlxBitmapFont.TEXT_SET2, 1);
				case SIMPLE_6X8: return new FlxBitmapFont(simpleFont, 6, 8, FlxBitmapFont.TEXT_SET1, FlxBitmapFont.TEXT_SET1.length);
				case TEENYSHADOW_5X9: return new FlxBitmapFont(teenyshadowFont, 5, 9, FlxBitmapFont.TEXT_SET2, FlxBitmapFont.TEXT_SET2.length);
				case VERIFIER_FONT_8X8: return new FlxBitmapFont(verifier_fontFont, 8, 8, "!\"#$%&'()*+,-./0123456789:;<=>?@abcdefghijklmnopqrstuvwxyz", "!\"#$%&'()*+,-./0123456789:;<=>?@abcdefghijklmnopqrstuvwxyz".length);
				default:
					throw new IllegalArgumentException("fontType", fontType);
			}
			return null;
		}
		
		
		/**
		 * Alignment of the text when multiLine = true. Set to FlxBitmapFont.ALIGN_LEFT (default), FlxBitmapFont.ALIGN_RIGHT or FlxBitmapFont.ALIGN_CENTER.
		 */
		public var align:String = "left";
		
		/**
		 * If set to true all carriage-returns in text will form new lines (see align). If false the font will only contain one single line of text (the default)
		 */
		public var multiLine:Boolean = false;
		
		/**
		 * Automatically convert any text to upper case. Lots of old bitmap fonts only contain upper-case characters, so the default is true.
		 */
		public var autoUpperCase:Boolean = true;
		
		/**
		 * Adds horizontal spacing between each character of the font, in pixels. Default is 0.
		 */
		public var customSpacingX:uint = 0;
		
		/**
		 * Adds vertical spacing between each line of multi-line text, set in pixels. Default is 0.
		 */
		public var customSpacingY:uint = 0;
		/** The text which is displayed */
		private var _text:String;
		
		/**
		 * Align each line of multi-line text to the left.
		 */
		public static const ALIGN_LEFT:String = "left";
		
		/**
		 * Align each line of multi-line text to the right.
		 */
		public static const ALIGN_RIGHT:String = "right";
		
		/**
		 * Align each line of multi-line text in the center.
		 */
		public static const ALIGN_CENTER:String = "center";
		
		/**
		 * Text Set 1 = !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~
		 */
		public static const TEXT_SET1:String = " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~";
		
		/**
		 * Text Set 2 =  !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ
		 */
		public static const TEXT_SET2:String = " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ";
		
		/**
		 * Text Set 3 = ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 
		 */
		public static const TEXT_SET3:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 ";
		
		/**
		 * Text Set 4 = ABCDEFGHIJKLMNOPQRSTUVWXYZ 0123456789
		 */
		public static const TEXT_SET4:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ 0123456789";
		
		/**
		 * Text Set 5 = ABCDEFGHIJKLMNOPQRSTUVWXYZ.,/() '!?-*:0123456789
		 */
		public static const TEXT_SET5:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ.,/() '!?-*:0123456789";
		
		/**
		 * Text Set 6 = ABCDEFGHIJKLMNOPQRSTUVWXYZ!?:;0123456789\"(),-.' 
		 */
		public static const TEXT_SET6:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ!?:;0123456789\"(),-.' ";
		
		/**
		 * Text Set 7 = AGMSY+:4BHNTZ!;5CIOU.?06DJPV,(17EKQW\")28FLRX-'39
		 */
		public static const TEXT_SET7:String = "AGMSY+:4BHNTZ!;5CIOU.?06DJPV,(17EKQW\")28FLRX-'39";
		
		/**
		 * Text Set 8 = 0123456789 .ABCDEFGHIJKLMNOPQRSTUVWXYZ
		 */
		public static const TEXT_SET8:String = "0123456789 .ABCDEFGHIJKLMNOPQRSTUVWXYZ";
		
		/**
		 * Text Set 9 = ABCDEFGHIJKLMNOPQRSTUVWXYZ()-0123456789.:,'\"?!
		 */
		public static const TEXT_SET9:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ()-0123456789.:,'\"?!";
		
		/**
		 * Text Set 10 = ABCDEFGHIJKLMNOPQRSTUVWXYZ
		 */
		public static const TEXT_SET10:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
		
		/**
		 * Text Set 11 = ABCDEFGHIJKLMNOPQRSTUVWXYZ.,\"-+!?()':;0123456789
		 */
		public static const TEXT_SET11:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ.,\"-+!?()':;0123456789";
		
		
		
		/**
		 * Internval values. All set in the constructor. They should not be changed after that point.
		 */
		private var fontSet:BitmapData;
		private var offsetX:uint;
		private var offsetY:uint;
		private var characterWidth:uint;
		private var characterHeight:uint;
		private var characterSpacingX:uint;
		private var characterSpacingY:uint;
		private var characterPerRow:uint;
		private var grabData:Array
		
		/**
		 * Loads 'font' and prepares it for use by future calls to .text
		 * 
		 * @param	font		The font set graphic class (as defined by your embed)
		 * @param	width		The width of each character in the font set.
		 * @param	height		The height of each character in the font set.
		 * @param	chars		The characters used in the font set, in display order. You can use the TEXT_SET consts for common font set arrangements.
		 * @param	charsPerRow	The number of characters per row in the font set.
		 * @param	xSpacing	If the characters in the font set have horizontal spacing between them set the required amount here.
		 * @param	ySpacing	If the characters in the font set have vertical spacing between them set the required amount here
		 * @param	xOffset		If the font set doesn't start at the top left of the given image, specify the X coordinate offset here.
		 * @param	yOffset		If the font set doesn't start at the top left of the given image, specify the Y coordinate offset here.
		 */
        public function FlxBitmapFont(font:Class, width:uint, height:uint, chars:String, charsPerRow:uint, xSpacing:uint = 0, ySpacing:uint = 0, xOffset:uint = 0, yOffset:uint = 0):void
        {
			//	Take a copy of the font for internal use
			fontSet = (new font).bitmapData;
			
			characterWidth = width;
			characterHeight = height;
			characterSpacingX = xSpacing;
			characterSpacingY = ySpacing;
			characterPerRow = charsPerRow;
			offsetX = xOffset;
			offsetY = yOffset;
			
			grabData = new Array();
			
			//	Now generate our rects for faster copyPixels later on
			var currentX:uint = offsetX;
			var currentY:uint = offsetY;
			var r:uint = 0;
			
			for (var c:uint = 0; c < chars.length; c++)
			{
				//	The rect is hooked to the ASCII value of the character
				grabData[chars.charCodeAt(c)] = new Rectangle(currentX, currentY, characterWidth, characterHeight);
				
				r++;
				
				if (r == characterPerRow)
				{
					r = 0;
					currentX = offsetX;
					currentY += characterHeight + characterSpacingY;
				}
				else
				{
					currentX += characterWidth + characterSpacingX;
				}
			}
        }
		
		/**
		 * Set this value to update the text in this sprite. Carriage returns are automatically stripped out if multiLine is false. Text is converted to upper case if autoUpperCase is true.
		 * 
		 * @return	void
		 */ 
		public function set text(content:String):void
		{
			// TODO? We could do a smarter update here, only changing the characters that are different,
			// but there is a trade-off between the processing cost of string comparison / building vs. just copying a few pixels anyway.
			
			if (autoUpperCase)
			{
				_text = content.toUpperCase();
			}
			else
			{
				_text = content;
			}
			
			removeUnsupportedCharacters(!multiLine);
			if (multiLine) autoBreakLine();
			buildBitmapFontText();
		}
		
		public function get text():String
		{
			return _text;
		}
		
		/**
		 * A helper function that quickly sets lots of variables at once, and then updates the text.
		 * 
		 * @param	content				The text of this sprite
		 * @param	multiLines			Set to true if you want to support carriage-returns in the text and create a multi-line sprite instead of a single line (default is false).
		 * @param	characterSpacing	To add horizontal spacing between each character specify the amount in pixels (default 0).
		 * @param	lineSpacing			To add vertical spacing between each line of text, set the amount in pixels (default 0).
		 * @param	lineAlignment		Align each line of multi-line text. Set to FlxBitmapFont.ALIGN_LEFT (default), FlxBitmapFont.ALIGN_RIGHT or FlxBitmapFont.ALIGN_CENTER.
		 * @param	allowLowerCase		Lots of bitmap font sets only include upper-case characters, if yours needs to support lower case then set this to true.
		 */
		public function setText(content:String, multiLines:Boolean = false, characterSpacing:uint = 0, lineSpacing:uint = 0, lineAlignment:String = "left", allowLowerCase:Boolean = false):void
		{
			customSpacingX = characterSpacing;
			customSpacingY = lineSpacing;
			align = lineAlignment;
			multiLine = multiLines;
			
			if (allowLowerCase)
			{
				autoUpperCase = false;
			}
			else
			{
				autoUpperCase = true;
			}
			
			text = content;
		}
		
		/**
		 * Updates the BitmapData of the Sprite with the text
		 * 
		 * @return	void
		 */
		public function buildBitmapFontText():void
		{
			var temp:BitmapData;
			
			if (multiLine)
			{
				var lines:Array = _text.split("\n");
				
				var cx:int = 0;
				var cy:int = 0;
			
				temp = new BitmapData(getLongestLine() * (characterWidth + customSpacingX), (lines.length * (characterHeight + customSpacingY)) - customSpacingY, true, 0xf);
				
				//	Loop through each line of text
				for (var i:uint = 0; i < lines.length; i++)
				{
					//	This line of text is held in lines[i] - need to work out the alignment
					switch (align)
					{
						case ALIGN_LEFT:
							cx = 0;
							break;
							
						case ALIGN_RIGHT:
							cx = temp.width - (lines[i].length * (characterWidth + customSpacingX));
							break;
							
						case ALIGN_CENTER:
							cx = (temp.width / 2) - ((lines[i].length * (characterWidth + customSpacingX)) / 2);
							cx += customSpacingX / 2;
							break;
					}
					
					pasteLine(temp, lines[i], cx, cy, customSpacingX);
					
					cy += characterHeight + customSpacingY;
				}
			}
			else
			{
				temp = new BitmapData(_text.length * (characterWidth + customSpacingX), characterHeight, true, 0xf);
			
				pasteLine(temp, _text, 0, 0, customSpacingX);
			}
			
			pixels = temp;
		}
		
		/**
		 * Returns a single character from the font set as an FlxsSprite.
		 * 
		 * @param	char	The character you wish to have returned.
		 * 
		 * @return	An <code>FlxSprite</code> containing a single character from the font set.
		 */
		public function getCharacter(char:String):FlxSprite
		{
			var output:FlxSprite = new FlxSprite();
			
			var temp:BitmapData = new BitmapData(characterWidth, characterHeight, true, 0xf);

			if (grabData[char.charCodeAt(0)] is Rectangle && char.charCodeAt(0) != 32)
			{
				temp.copyPixels(fontSet, grabData[char.charCodeAt(0)], new Point(0, 0));
			}
			
			output.pixels = temp;
			
			return output;
		}
		
		/**
		 * Internal function that takes a single line of text (2nd parameter) and pastes it into the BitmapData at the given coordinates.
		 * Used by getLine and getMultiLine
		 * 
		 * @param	output			The BitmapData that the text will be drawn onto
		 * @param	line			The single line of text to paste
		 * @param	x				The x coordinate
		 * @param	y
		 * @param	customSpacingX
		 */
		private function pasteLine(output:BitmapData, line:String, x:uint = 0, y:uint = 0, customSpacingX:uint = 0):void
		{
			for (var c:uint = 0; c < line.length; c++)
			{
				//	If it's a space then there is no point copying, so leave a blank space
				if (line.charAt(c) == " ")
				{
					x += characterWidth + customSpacingX;
				}
				else
				{
					//	If the character doesn't exist in the font then we don't want a blank space, we just want to skip it
					if (grabData[line.charCodeAt(c)] is Rectangle)
					{
						output.copyPixels(fontSet, grabData[line.charCodeAt(c)], new Point(x, y));
						x += characterWidth + customSpacingX;
					}
				}
			}
		}
		
		/**
		 * Works out the longest line of text in _text and returns its length
		 * 
		 * @return	A value
		 */
		private function getLongestLine():uint
		{
			var longestLine:uint = 0;
			
			if (_text.length > 0)
			{
				var lines:Array = _text.split("\n");
				
				for (var i:uint = 0; i < lines.length; i++)
				{
					if (lines[i].length > longestLine)
					{
						longestLine = lines[i].length;
					}
				}
			}
			
			return longestLine;
		}
		
		/**
		 * Internal helper function that removes all unsupported characters from the _text String, leaving only characters contained in the font set.
		 * 
		 * @param	stripCR		Should it strip carriage returns as well? (default = true)
		 * 
		 * @return	A clean version of the string
		 */
		private function removeUnsupportedCharacters(stripCR:Boolean = true):String
		{
			var newString:String = "";
			
			for (var c:uint = 0; c < _text.length; c++)
			{
				if (grabData[_text.charCodeAt(c)] is Rectangle || _text.charCodeAt(c) == 32 || (stripCR == false && _text.charAt(c) == "\n"))
				{
					newString = newString.concat(_text.charAt(c));
				}
			}
			
			return newString;
		}
		
		/**
		 * Auto break the line, based on the text, char width and the width of this sprite
		 */
		private function autoBreakLine():void {
			var textAfterBreakLine:String = "";
			var word:String = "";
			var charactersPerLine:int = Math.max(1, width / characterWidth);
			var currentLineLength:int = 0;
			
			for (var i:uint = 0; i < _text.length; i++) {
				// If this is end of line
				if (_text.charAt(i) == '\n') {
					textAfterBreakLine += word + "\n";
					word = ""; currentLineLength = 0;
				
				// If this is end of word
				} else if (_text.charCodeAt(i) == 32) {
					// If both the word and the space can fit into the line
					if (currentLineLength + word.length < charactersPerLine) {
						textAfterBreakLine += word + " ";
						currentLineLength += word.length + 1;
						word = "";
						
					// If only the word can fit into the line
					} else if (currentLineLength + word.length == charactersPerLine) {
						textAfterBreakLine += word + "\n";
						currentLineLength = 0;
						word = "";
					
					// If the word cannot fit into the line
					} else {
						// Strip space at the last of string if any
						if (textAfterBreakLine.charCodeAt(textAfterBreakLine.length -1) == 32)
							textAfterBreakLine = textAfterBreakLine.substr(0, textAfterBreakLine.length - 1);
						textAfterBreakLine += "\n" + word;
						currentLineLength = word.length;
						word = "";
						
						// If the space can fit into the line
						if (currentLineLength < charactersPerLine)
							textAfterBreakLine += " ";
					}
				
				} else {
					word += _text.charAt(i);
					
					// If this is the end of the string
					if (i == _text.length - 1) {
						// If the word can fit into current line
						if (currentLineLength + word.length <= charactersPerLine)
							textAfterBreakLine += word;
							
						// Extreme case: if the word's length is larger than charactersPerLine
						// and currently there is no character on the line
						else if (word.length > charactersPerLine && currentLineLength == 0)
							textAfterBreakLine += word;
							
						else
							// No
							textAfterBreakLine += "\n" + word;
					}
				}
			}
			_text = textAfterBreakLine;
		}
		
	}

}