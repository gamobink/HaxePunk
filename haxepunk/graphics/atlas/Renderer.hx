package haxepunk.graphics.atlas;

@:dox(hide)
class HardwareNotSupportedRenderer
{
	public function new(data:AtlasData) {}

	public function drawTiles(graphics, tileData, smooth, flags, count):Void
	{
		throw "hardware rendering not supported on this platform";
	}
}

@:dox(hide)
#if tile_shader
typedef Renderer = haxepunk.graphics.atlas.renderer.TileShaderRenderer;
#elseif draw_tiles
typedef Renderer = haxepunk.graphics.atlas.renderer.DrawTilesRenderer;
#else
typedef Renderer = HardwareNotSupportedRenderer;
#end
