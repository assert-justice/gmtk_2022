import "sprite" for Sprite
import "vmath" for Vector3

class Slider is Sprite {
    construct new(parent, tileMap, player){
        super(parent, 8 * 24, 0, 24, 24)
        _speed = 200
        _vel = Vector3.new(0,0,0)
        _wiggle = 5
        _player = player
        _tileMap = tileMap
        _radius = 12
    }
    sleep(){
        _vel.x = 0
        _vel.y = 0
        super.sleep()
    }
    update(deltaTime){
        if(_vel.length == 0){
            if( (_player.transform.position.x - transform.position.x).abs < _wiggle ){
                _vel.y = (_player.transform.position.y - transform.position.y).sign * _speed * deltaTime
            }
            if( (_player.transform.position.y - transform.position.y).abs < _wiggle ){
                _vel.x = (_player.transform.position.x - transform.position.x).sign * _speed * deltaTime
            }
        }
        var newPos = _tileMap.collide(transform.position, _vel, 24, 24)
        if(newPos.x == transform.position.x && newPos.y == transform.position.y) {
            _vel.x = 0
            _vel.y = 0
        }
        transform.position.x = newPos.x
        transform.position.y = newPos.y
        var dis = _player.transform.position.copy()
        dis.x = dis.x - transform.position.x
        dis.y = dis.y - transform.position.y
        if(dis.length < _radius){
            _player.hit()
        }
        super.update(deltaTime)
    }
}