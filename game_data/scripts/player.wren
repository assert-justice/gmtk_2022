import "sprite" for Sprite
import "node" for Node
import "vmath" for VMath, Vector2, Vector3
import "input" for Input
import "audio_system" for AudioSystem
import "pool" for Pool
import "bullet" for Bullet

class Player is Node {
    construct new(parent, tileMap){
        super(parent)
        _sprite = Sprite.new(this, 0, 0, 24, 24)
        _sprite.transform = transform
        _tileMap = tileMap
        _vel = Vector3.new(0,0,0)
        _speed = 200
        _gravity = 10
        _jumpSpeed = 400
        _audioHandle = AudioSystem.addAudioSource()
        AudioSystem.loadAudioSource(_audioHandle, "game_data/sfx/Climb_Rope_Loop_00.wav", false)
        _pool = Pool.new(0){Bullet.new(null, Vector2.new(7*18,72+18*3), Vector2.new(18,18), Vector3.new(0,0,0))}
    }

    update(deltaTime){
        var move = Input.getAxis2("move", 0)
        move.mulScalar(_speed * deltaTime)
        _vel.x = move.x
        _vel.y = _vel.y + _gravity * deltaTime
        if(Input.getButtonPressed("jump", 0)) {
            _vel.y = -_jumpSpeed * deltaTime
        }
        if(Input.getButtonPressed("fire", 0)) {
            AudioSystem.playAudioSource(_audioHandle)
            // var bullet = _pool.get(this)
            // bullet.transform.position.x = transform.position.x
            // bullet.transform.position.y = transform.position.y
            // bullet.velocity.x = 400
        }
        if (_vel.x > 0){_sprite.hflip = true}
        if (_vel.x < 0){_sprite.hflip = false}
        var newPos = _tileMap.collide(transform.position, _vel, 24, 24)
        if (newPos.y == transform.position.y) _vel.y = 0
        transform.position = newPos
        super.update(deltaTime)
    }
}