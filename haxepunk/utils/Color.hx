package haxepunk.utils;


abstract Color(UInt) from UInt to UInt
{

/**
	 * Linear interpolation between two colors.
	 * @param	fromColor		First color.
	 * @param	toColor			Second color.
	 * @param	t				Interpolation value. Clamped to the range [0, 1].
	 * return	RGB component-interpolated color value.
	 */
	public static inline function colorLerp(fromColor:Color, toColor:Color, t:Float=1):Color
	{
		if (t <= 0)
		{
			return fromColor;
		}
		else if (t >= 1)
		{
			return toColor;
		}
		else
		{
			var a:Int = fromColor.getAlpha(),
				r:Int = fromColor.getRed(),
				g:Int = fromColor.getGreen(),
				b:Int = fromColor.getBlue(),
				dA:Int = toColor.getAlpha() - a,
				dR:Int = toColor.getRed() - r,
				dG:Int = toColor.getGreen() - g,
				dB:Int = toColor.getBlue() - b;
			a += Std.int(dA * t);
			r += Std.int(dR * t);
			g += Std.int(dG * t);
			b += Std.int(dB * t);
			return a << 24 | r << 16 | g << 8 | b;
		}
	}


	/**
	 * Creates a color value by combining the chosen RGB values.
	 * @param	R		The red value of the color, from 0 to 255.
	 * @param	G		The green value of the color, from 0 to 255.
	 * @param	B		The blue value of the color, from 0 to 255.
	 * @return	The color.
	 */
	public static inline function getColorRGB(r:Int=0, g:Int=0, b:Int=0):Color
	{
		return r << 16 | g << 8 | b;
	}

	/**
	 * Creates a color value with the chosen HSV values.
	 * @param	h		The hue of the color (from 0 to 1).
	 * @param	s		The saturation of the color (from 0 to 1).
	 * @param	v		The value of the color (from 0 to 1).
	 * @return	The color Int.
	 */
	public static function getColorHSV(h:Float, s:Float, v:Float):Color
	{
		h = Std.int(h * 360);
		var hi:Int = Math.floor(h / 60) % 6,
			f:Float = h / 60 - Math.floor(h / 60),
			p:Float = (v * (1 - s)),
			q:Float = (v * (1 - f * s)),
			t:Float = (v * (1 - (1 - f) * s));
		switch (hi)
		{
			case 0: return Std.int(v * 255) << 16 | Std.int(t * 255) << 8 | Std.int(p * 255);
			case 1: return Std.int(q * 255) << 16 | Std.int(v * 255) << 8 | Std.int(p * 255);
			case 2: return Std.int(p * 255) << 16 | Std.int(v * 255) << 8 | Std.int(t * 255);
			case 3: return Std.int(p * 255) << 16 | Std.int(q * 255) << 8 | Std.int(v * 255);
			case 4: return Std.int(t * 255) << 16 | Std.int(p * 255) << 8 | Std.int(v * 255);
			case 5: return Std.int(v * 255) << 16 | Std.int(p * 255) << 8 | Std.int(q * 255);
			default: return 0;
		}
		return 0;
	}

	public inline function getAlpha():UInt return (this >> 24) & 0xff;
	public inline function getRed():UInt return (this >> 16) & 0xff;
	public inline function getGreen():UInt return (this >> 8) & 0xff;
	public inline function getBlue():UInt return this & 0xff;

	public inline function withAlpha(a:Float):Color
	{
		return (Std.int(0xff * a) << 24) | (this & 0xffffff);
	}


	/**
	 * Finds the hue factor of a color.
	 * @return The hue value (from 0 to 1).
	 */
	public inline function getHue():Float
	{
		var h:Int = (this >> 16) & 0xFF;
		var s:Int = (this >> 8) & 0xFF;
		var v:Int = this & 0xFF;

		var max:Int = Std.int(Math.max(h, Math.max(s, v)));
		var min:Int = Std.int(Math.min(h, Math.min(s, v)));

		var hue:Float = 0;

		if (max == min)
		{
			hue = 0;
		}
		else if (max == h)
		{
			hue = (60 * (s - v) / (max - min) + 360) % 360;
		}
		else if (max == s)
		{
			hue = (60 * (v - h) / (max - min) + 120);
		}
		else if (max == v)
		{
			hue = (60 * (h - s) / (max - min) + 240);
		}

		return hue / 360;
	}

	/**
	 * Finds the saturation factor of a color.
	 * @return The saturation value (from 0 to 1).
	 */
	public inline function getSaturation():Float
	{
		var h:Int = (this >> 16) & 0xFF;
		var s:Int = (this >> 8) & 0xFF;
		var v:Int = this & 0xFF;

		var max:Int = Std.int(Math.max(h, Math.max(s, v)));

		if (max == 0)
		{
			return 0;
		}
		else
		{
			var min:Int = Std.int(Math.min(h, Math.min(s, v)));

			return (max - min) / max;
		}
	}

	/**
	 * Finds the value factor of a color.
	 * @return The value value (from 0 to 1).
	 */
	public inline function getValue():Float
	{
		var h:Int = (this >> 16) & 0xFF;
		var s:Int = (this >> 8) & 0xFF;
		var v:Int = this & 0xFF;

		return Std.int(Math.max(h, Math.max(s, v))) / 255;
	}
}
