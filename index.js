var t_game = require('voxel-engine');
var t_highlight = require('voxel-highlight');
var t_player = require('voxel-player');
var t_texture_path_x = require('painterly-textures');
var t_texture_path = t_texture_path_x(__dirname);
var t_voxel = require('voxel');
var t_extend = require('extend');
var t_chunk_size = 2;
var t_chunk_distance = 32;
var terrain = require('voxel-perlin-terrain');
var t_generator = terrain({ chunkDistance : t_chunk_distance,
                            chunkSize : t_chunk_size,
                            scaleFactor : 3 / (t_chunk_distance * t_chunk_size)
                          });
var t_make_tree = require('voxel-forest');
module.exports = function (opts) {
    var defaults = { generateVoxelChunk : t_generator,
                     cubeSize : 25,
                     chunkSize : t_chunk_size,
                     chunkDistance : t_chunk_distance,
                     worldOrigin : [0, 0, 0],
                     materials : [['grass', 'dirt', 'grass_dirt'], 'obsidian', 'brick', 'grass', 'plank'],
                     startingPosition : [0, 0, 0],
                     texturePath : t_texture_path,
                     controls : { discreteFire : true, jump : 4 }
                   };
    opts = extend({  }, defaults, opts || {  });
    var game = createGame(opts);
    window.game = game;
    var container = opts.container || document.body;
    game.appendTo(container);
    var createPlayer = player(game);
    var substack = createPlayer('player.png');
    substack.posess();
    substack.yaw.position.set(2, 14, 4);
    var blockPosPlace = null;
    var blockPosErase = null;
    var hl = highlight(game, { color : 0x00ff00,
                               distance : 20,
                               adjacentAnimate : true
                             });
    game.highlighter = hl;
    hl.on('highlight', function (voxelPos) {
        return blockPosErase = voxelPos;
    });
    hl.on('remove', function (vp) {
        return blockPosErase = null;
    });
    hl.on('highlight-adjacent', function (vp) {
        return blockPosPlace = vp;
    });
    hl.on('remove-adjacent', function (vp) {
        return blockPosPlace = null;
    });
    window.addEventListener('keydown', function (ev) {
        return ev.keyCode === 'R'.charCodeAt(0) ? substack.toggle() : null;
    });
    return game;
}; (ev.keyCode === 'R'.charCodeAt(0)) substack.toggle()
  })

  // block interaction stuff, uses highlight data
  var currentMaterial = 1



    var t_snow = require('voxel-snow')({
        game: game,
        count: 1000,
        size: 20,
        speed: 0.1,
        drift: 1
    });

    game.on('tick', function() {
        t_snow.tick();
    });

  game.on('fire', function (target, state) {
      var position = blockPosPlace
      if (position) {
          game.createBlock(position, currentMaterial)
      } else {
          position = blockPosErase
          if (position) game.setBlock(position, 0)
      }
  });

  return game
}
