import "sprite" for Sprite
import "vmath" for Vector2
import "renderer" for Renderer

class TextBox is Sprite {
    construct new(parent, textOffset, text){
        var alpha = "01234567890!?(){}[]$abcdefghijklmnopqrstuvwxyz"
        // 18
        var width = 9
        var height = 12
        _brushSprite = Renderer.addSprite()
        var cursorX = 0
        var cursorY = 0
        var maxWidth = 0
        var maxHeight = 0

        for (c in text) {
            var idx = alpha.indexOf(c)
            if(idx == -1){
                if (c == "\n"){
                    // newline
                    if (cursorX + width > maxWidth) maxWidth = cursorX + width
                    maxHeight = maxHeight + height
                    cursorX = 0
                    cursorY = cursorY + height
                }
                cursorX = cursorX + width
            } else{
                var brushPosition = textOffset.copy()
                brushPosition.x = brushPosition.x + cursorX
                brushPosition.y = brushPosition.y + cursorY
                var brushOffset = Vector2.new(88,0)
                if(idx > 18){
                    brushOffset.y = brushOffset.y + height
                    idx = idx - 18
                }
                Renderer.setSpriteDimensions(_brushSprite, brushOffset.x, brushOffset.y, width, height)
                Renderer.setSpriteTransform(_brushSprite, brushPosition.x, brushPosition.y, 0, width, height, 0)
                Renderer.blitSpriteToAtlas(_brushSprite)
                cursorX = cursorX + width
            }
        }
        super(parent, textOffset.x, textOffset.y, maxWidth, maxHeight)
    }
}