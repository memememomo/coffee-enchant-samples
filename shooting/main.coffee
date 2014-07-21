enchant()

core = undefined
player = undefined
scoreLabel = undefined
lifeLabel = undefined
enemies = []

window.onload = ->

  core = new Core 320, 320
  core.fps = 24

  core.score = 0
  core.life = 3
  core.wait = 0
  core.death = false
  core.over = false

  core.preload 'images/spritesheet.png', 'images/bg.png', 'images/exp.png'

  core.onload = ->

    background = new Background()

    player = new Player 144, 138

    scoreLabel = new ScoreLabel 5, 0
    scoreLabel.score = 0
    scoreLabel.easing = 0
    core.rootScene.addChild scoreLabel

    lifeLabel = new LifeLabel 180, 0, 3
    core.rootScene.addChild lifeLabel

    enemies = []


  core.rootScene.addEventListener 'enterframe', ->

    scoreLabel.score = core.score

    lifeLabel.life = core.life
    if core.over== true
      core.end()

    if core.death == true
      core.wait++
      player.visible = if player.visible then false else true
      if core.wait == core.fps * 5
        core.death = false
        player.visible = true
        core.wait = 0

    if rand(100) < 5
      enemy = new Enemy rand(320), 0, rand(3)
      enemy.id = core.frame
      enemies[enemy.id] = enemy

    if core.frame % 8 == 0
      s = new PlayerBullet @x+12, @y-8

  core.start()



Player = Class.create Sprite,
  initialize: (x,y) ->
    Sprite.call @, 32, 32

    image = new Surface 128, 32
    image.draw core.assets['images/spritesheet.png'], 0, 0, 128, 32, 0, 0, 128, 32
    @image = image
    @frame = 0
    @x = x
    @y = y

    @.addEventListener 'enterframe', ->

      if core.input.left && @x >= 0
        @x -= 8
        @frame = 0

      if core.input.right && @x <= core.width - 32
        @x += 8
        @frame = 0

      if core.input.up && @y >= 0
        @y -= 8
        @frame = 1

      if core.input.down && @y <= core.height - 32
        @y += 8
        @frame = 2

      if core.frame % 8 == 0
        s = new PlayerBullet @x+12, @y-8

    core.rootScene.addChild @

Background = Class.create Sprite,
  initialize: ->
    Sprite.call @, 320, 320
    @x = 0
    @y = -320
    @frame = 0
    @image = core.assets['images/bg.png']

    @.addEventListener 'enterframe', ->
      @y++

      if @y >= 0
        @y = -320

    core.rootScene.addChild @

Enemy = Class.create Sprite,
  initialize: (x,y,type) ->
    Sprite.call @, 32, 32
    @image = core.assets['images/spritesheet.png']
    @x = x
    @y = y
    @vx = 4
    @type = type
    @tick = 0
    @angle = 0

    @.addEventListener 'enterframe', ->

      if @type == 0
        @frame = 15 + core.frame % 3
        @y += 3

      if @type == 1
        @frame = 22 + core.frame % 3
        @y += 6

      if @type == 2
        @frame = 25 + core.frame % 4
        if @x < player.x - 64
          @x += @vx
        else if @x > player.y + 64
          @x -= @vx
        else
          @vx = 0
          @y += 8

    if @y > 280 || @x > 320 || @x < -@width || @y < -@height
      @.remove()
    else if @tick++ % 32 == 0
      if rand(100) < 50
        sx = player.x + player.width / 2 - @x
        sy = player.y + player.height / 2 - @y
        angle = Math.atan(sx/sy)

        s = new EnemyBullet @x+@width/2, @y+@height/2, angle

    core.rootScene.addChild @

  remove: ->
    core.rootScene.removeChild @
    delete enemies[@id]
    delete @

Bullet = Class.create Sprite,
  initialize: (x,y,angle) ->
    Sprite.call @, 8, 8
    image = new Surface 32, 32
    image.draw core.assets['images/spritesheet.png'], 32, 64, 32, 32, 0, 0, 32, 32
    @image = image
    @x = x
    @y = y
    @angle = angle
    @speed = 10

    @.addEventListener 'enterframe', ->
      @x += @speed * Math.sin(@angle)
      @y += @speed * Math.cos(@angle)

      if @y > 320 || @x > 320 || @x < -@width || @y < -@height
        @.remove()

    core.rootScene.addChild @

  remove: ->
    core.rootScene.removeChild @
    delete @


PlayerBullet = Class.create Bullet,
  initialize: (x,y) ->
    Bullet.call @, x, y, Math.PI
    @frame = 10

    @.addEventListener 'enterframe', ->
      for i in enemies
        if i && i.intersect(@, 8) && core.death == false
          i.remove()
          core.score += 100


EnemyBullet = Class.create Bullet,
  initialize: (x,y,angle) ->
    Bullet.call @, x, y, angle
    @speed = 4
    @frame = 7

    @.addEventListener 'enterframe', ->
      if player.within(@, 8) && core.death == false
       effect = new Explosion player.x-player.width/2, player.y-player.height/2
       core.death = true
       player.visible = false
       core.life--

       if core.life == 0
         core.over = true

Explosion = Class.create Sprite,
  initialize: (x,y) ->
    Sprite.call @, 64, 64
    @x = x
    @y = y
    @frame = 0
    @image = core.assets['images/exp.png']
    @tick = 0

    @.addEventListener 'enterframe', ->
      @frame = @tick++
      if @frame == 16
        @.remove()
    core.rootScene.addChild @

  remove: ->
    core.rootScene.removeChild @
    delete @

