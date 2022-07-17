import "tilemap" for TileMap
import "node" for Node
import "vmath" for Vector2, Vector3
import "pool" for Pool
import "goomba" for Goomba
import "slider" for Slider
import "text_box" for TextBox
import "audio_source" for AudioSource

class MapManager is Node {
    //
    construct new(parent, player){
        // 
        super(parent)
        _tileMap = TileMap.new(this, 27, 15, 18, 18, 0, 234)
        _tileMap.addTemplate(234, 0, true)
        _player = player
        _player.manager = this
        // _player.setParent(this)
        _player.tileMap = _tileMap
        _rooms = []
        _currentRoomIdx = 0
        _currentRoom = null
        _state = 0 // 0: idle, 1: clearing, 2: building
        _animTime = 0.001
        _animClock = 0
        _animX = 0
        _animY = 0
        _enemyPool = Pool.new(0){Goomba.new(this, _tileMap, player)}
        _sliderPool = Pool.new(0){Slider.new(this, _tileMap, player)}
        _activeEnemies = []
        _checkpointRoom = 0
        _checkpointX = 100
        _checkpointY = 100
        _textBox = TextBox.new(this, 200, 100, Vector2.new(800, 200), "")

        _music = AudioSource.new(this,"game_data/music/cute_track.mp3",true)
        _music.looping = true
        _music.play()
    }

    addRoom(steps, doors, enemies, sliders, text){
        var room = {
            "steps":steps,
            "doors":doors,
            "enemies":enemies,
            "sliders":sliders,
            "text":text,
        }
        _rooms.add(room)
        return _rooms.count - 1
    }
    hit(){
        _player.transform.position.x = _checkpointX
        _player.transform.position.y = _checkpointY
        _player.update(0)
        setRoom(_checkpointRoom)
    }
    setRoom(idx){
        for (enemy in _activeEnemies) {
            enemy.transform.position.x = -100
            enemy.update(0)
            enemy.sleep()
        }
        _activeEnemies.clear()
        _currentRoomIdx = idx
        _currentRoom = _rooms[_currentRoomIdx]
        _tileMap.clear()
        _tileMap.redraw()
        for(step in _currentRoom["steps"]){
            _tileMap.setArea(step[0],step[1],step[2],step[3],step[4])
        }
        _state = 2
        _player.setParent(null)
        _animX = 0
        _animY = 0
        // place enemies
        if (_currentRoom["enemies"]){
            for(position in _currentRoom["enemies"]){
                // System.print("%(position.x) %(position.y)")
                var enemy = _enemyPool.get(this)
                _activeEnemies.add(enemy)
                enemy.transform.position.x = position.x
                enemy.transform.position.y = position.y
                enemy.update(0)
            }
        }
        if(_currentRoom["sliders"]){
            for(position in _currentRoom["sliders"]){
                // System.print("%(position.x) %(position.y)")
                var enemy = _sliderPool.get(this)
                _activeEnemies.add(enemy)
                enemy.transform.position.x = position.x
                enemy.transform.position.y = position.y
                enemy.update(0)
            }
        }
        _textBox.clear()
        if(_currentRoom["text"]){
            var data = _currentRoom["text"]
            _textBox.transform.position.x = data[0]
            _textBox.transform.position.y = data[1]
            _textBox.setText(data[2])
        }
    }
    lerp(a,b,t){
        return (b-a) * t + a
    }
    update(deltaTime){
        var door = [0,200,200]
        var maxX = _tileMap.width * 18
        var minX = 0
        var maxY = _tileMap.height * 18
        var minY = 0
        if(_player.transform.position.x > maxX){
            door = _currentRoom["doors"] ? _currentRoom["doors"][0] : door
        } else if(_player.transform.position.y < minY){
            door = _currentRoom["doors"] ? _currentRoom["doors"][1] : door
        } else if(_player.transform.position.x < minX){
            door = _currentRoom["doors"] ? _currentRoom["doors"][2] : door
        } else if(_player.transform.position.y > maxY){
            door = _currentRoom["doors"] ? _currentRoom["doors"][3] : door
        } else{
            door = null
        }
        if(door){
            setRoom(door[0])
            _player.transform.position.x = door[1]
            // _player.transform.position.y = door[2]
            _player.update(0)
            _checkpointRoom = door[0]
            _checkpointX = door[1]
            _checkpointY = door[2]
        }
        if(_state == 2){
            _animClock = _animClock - deltaTime
            if(_animClock < 0){
                // System.print("here")
                _animClock = _animTime
                var placed = false
                var hack = false
                var time = deltaTime
                while(time > 0){
                    while(!placed){
                        var data = _tileMap.getCellData(_animX,_animY)
                        if(data){
                            placed = true
                            _tileMap.setTile(data[0],_animX,_animY)
                        }
                        _animX = _animX + 1
                        if(!_tileMap.onGrid(_animX, _animY)){
                            _animX = 0
                            _animY = _animY + 1
                            if(!_tileMap.onGrid(_animX, _animY)) {
                                placed = true
                                hack = true
                            }
                        }
                    }
                    time = time - _animTime
                }
                if(hack){
                    // if we are done drawing the map
                    _state = 0
                    _player.setParent(this)
                    for(enemy in _activeEnemies){
                        enemy.setParent(this)
                    }
                }
            }
        }
        super.update(deltaTime)
    }
}