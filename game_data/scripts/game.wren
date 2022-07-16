import "engine" for Engine
import "node" for Node
import "input" for Input
import "window" for Window
import "renderer" for Renderer
import "audio_system" for AudioSystem
import "tilemap" for TileMap
import "sprite" for Sprite
import "vmath" for VMath, Vector2, Vector3
import "animated_sprite" for AnimatedSprite
import "audio_source" for AudioSource
import "pool" for Pool
import "bullet" for Bullet
import "random" for Random
import "player" for Player
import "goomba" for Goomba
import "dice" for Dice
import "text_box" for TextBox
import "map_manager" for MapManager

class Game is Node {
    construct new(){
        super(null)
        var tracker = 0
        var fnames = [
            "game_data/sprites/characters_packed.png",
            "game_data/sprites/tiles_packed.png",
            // "game_data/sprites/dice.png",
            "game_data/sprites/kenny_mini_square_mono_12x9.png",
        ]
        // for (fname in fnames) {
        //     var stats = Renderer.blitFileToAtlas(fname, 0, tracker)
        //     var height = stats["height"]
        //     // if (height == 3 * 24){
        //     //     tracker = tracker + 24
        //     // } else{
        //     //     tracker = tracker + height
        //     // }
        //     tracker = tracker + height
        //     // System.print(stats["width"])
        // }
        Renderer.blitFileToAtlas("game_data/sprites/characters_packed.png", 0, 0)
        Renderer.blitFileToAtlas("game_data/sprites/tiles_packed.png", 234, 0)
        Renderer.blitFileToAtlas("game_data/sprites/dice.png", 0, 72)
        Renderer.blitFileToAtlas("game_data/sprites/kenny_mini_square_mono_12x9.png", 0, 88)
        _random = Random.new()
        _player = Player.new(null, _tileMap, _random)
        _player.transform.position.x = 100
        _player.transform.position.y = 100

        _mapManager = MapManager.new(this, _player, null, null)
        _mapManager.addRoom([
            [0,0,0,27,15],
            [-1,1,1,25,13],
            [0,8,13,8,1],
        ],null,null,null)
        _mapManager.addRoom([
            [0,0,0,27,15],
            [-1,1,1,25,13],
        ],null,null,null)
        _mapManager.setRoom(0)

        // _tileMap = TileMap.new(this, 27, 15, 18, 18, 0, 234)
        // _tileMap.addTemplate(234, 0, true)
        // _tileMap.setArea(0, 0, 0, _tileMap.width, _tileMap.height)
        // _tileMap.setArea(-1, 1, 1, _tileMap.width-2, _tileMap.height-2)
        // _tileMap.setArea(0, 8, 13, 8, 1)
        // _tileMap.redraw()
        // _goomba = Goomba.new(this, _tileMap)
        // _goomba.transform.position.x = 200
        // _goomba.transform.position.y = 200
        // var statNames = [
        //     ["health", 3],
        //     ["speed", 4],
        //     ["jump power", 2],
        //     ["air jumps", 1],
        // ]
        // _dice = []
        // for (i in 0...statNames.count) {
        //     var name = statNames[i][0]
        //     var val = statNames[i][1]
        //     var die = Dice.new(this, _random)
        //     die.transform.position.x = 25
        //     die.transform.position.y = 25 + i * 30
        //     die.value = val

        //     _textBox = TextBox.new(this, Vector2.new(0, 88 + 36 + i * 30), name)
        //     _textBox.transform.position.x = 35
        //     _textBox.transform.position.y = die.transform.position.y - 5
        //     _dice.add(die)
        // }
        // _atlas = Sprite.new(this, 0,0,1024, 1024)
        // _player.setVisible(true)
        // _pool = Pool.new(0) {Bullet.new(null, Vector2.new(4 * 24, 24), Vector2.new(24, 24), Vector2.new(0, 3) )}
        // _markPool = Pool.new(0) {Bullet.new(null, Vector2.new(3 * 24, 2 * 24), Vector2.new(24, 24), Vector2.new(0, 3) )}
        // _emitClock = 0
        // _emitTime = 0.25
        // Engine.enableLogging("logging.txt")
        // _spr = _pool.get(this)
        // _source = AudioSource.new(this, "game_data/sfx/Climb_Rope_Loop_00.wav")
        // _source.volume = 0.25
        // _tileMap.setTile(0, 1, 1)
        // _tileMap.setTile(1, 1, 1)
        // _x = 100
        // _y = 100
        // _speed = 200
        // _colors = ["green", "blue", "pink", "orange", "cream"]
        // _anim = "green"
        // _player = AnimatedSprite.new(this, Vector2.new(0,0), Vector2.new(24, 24), 5)
        // var i = 0
        // for (color in _colors) {
        //     var x = i * 48
        //     var y = 0
        //     if (i == 4){
        //         x = 0
        //         y = 24
        //     }
        //     _player.newAnim(color)
        //     _player.addFrame(color,Vector2.new(x,y), Vector2.new(24, 24))
        //     _player.addFrame(color,Vector2.new(x+24,y), Vector2.new(24, 24))
        //     i = i + 1
        // }
        // // _player.play(_anim)
        // _player.transform.position.x = _x
        // _player.transform.position.y = _y
        // _atlas = Sprite.new(this, 0,0,24, 24)
        // _atlas.transform.position.x = _x
        // _atlas.transform.position.y = _y
        // _atlas.transform.position.x = _x
        // _atlas.transform.position.y = _y
        // _vel = Vector3.new(0,0,0)
    }
    update(deltaTime){
        if(Input.getButtonPressed("ui_cancel", 0)){
            Engine.quit()
        }
        // System.print(_player.visible)
        // if(_emitClock > 0){
        //     _emitClock = _emitClock - deltaTime
        // } else{
        //     _emitClock = _emitTime
        //     var bullet = _pool.get(this)
        //     var mark = _markPool.get(this)
        //     bullet.transform.position.x = _random.float() * 400
        //     bullet.transform.position.y = 0
        //     mark.transform.position.x = bullet.transform.position.x
        //     mark.transform.position.y = bullet.transform.position.y
        //     bullet.transform.angle = VMath.degToRad(45)
        //     bullet.transform.scale.x = 2
        //     bullet.transform.origin.x = bullet.dimensions.x / 2
        //     bullet.transform.origin.y = bullet.dimensions.y / 2
        // }
        if(Input.getButtonPressed("fire", 0)){
            _mapManager.setRoom(1)
            // AudioSystem.playAudioSource(0)
            // _source.play()
            // var i = _colors.indexOf(_anim) + 1
            // if (i == _colors.count) i = 0
            // _anim = _colors[i]
        }
        // var move = Input.getAxis2("move", 0)
        // move.mulScalar(_speed * deltaTime)
        // _vel.x = move.x
        // _vel.y = move.y
        // var newPos = _tileMap.collide(_player.transform.position, _vel, 24, 24)
        // if (newPos.x == _player.transform.position.x) _player.pause()
        // if (newPos.x != _player.transform.position.x && !_player.playing) _player.play(_anim)
        // _player.transform.position = newPos
        // _atlas.transform.position.x = _atlas.transform.position.x + _vel.x
        // _atlas.transform.position.y = _atlas.transform.position.y + _vel.y
        // it's important to call the super method
        // typically after we have handled our own updates
        // that way if we change a child it will update accordingly *this* tick
        super.update(deltaTime)
    }
}