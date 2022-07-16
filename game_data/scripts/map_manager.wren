import "tilemap" for TileMap
import "node" for Node
import "vmath" for Vector3

class MapManager is Node {
    //
    construct new(parent, player, enemyPool, checkpointPool){
        // 
        super(parent)
        _tileMap = TileMap.new(this, 27, 15, 18, 18, 0, 234)
        _tileMap.addTemplate(234, 0, true)
        _player = player
        // _player.setParent(this)
        _player.tileMap = _tileMap
        _rooms = []
        _currentRoomIdx = 0
        _nextRoomIdx = 0
        _currentRoom = null
        _state = 0 // 0: idle, 1: clearing, 2: building
        _animTime = 0.001
        _animClock = 0
        _animX = 0
        _animY = 0
        // System.print(_tileMap.onGrid(0, 15))
    }

    addRoom(steps, doors, enemies, checkpoints){
        var room = {
            "steps":steps,
            "doors":doors,
            "enemies":enemies,
            "checkpoints":checkpoints
        }
        _rooms.add(room)
        return _rooms.count - 1
    }
    setRoom(idx){
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
        // place enemies and checkpoints
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
            _player.transform.position.y = door[2]
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
                }
            }
        }
        super.update(deltaTime)
    }
}