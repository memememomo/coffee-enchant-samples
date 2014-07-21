enchant()

Player = Class.create Sprite, ->
  initialize: (x,y,map) ->
    Sprite.call(@, 48, 48)

    @image = core.assets['betty.png']
    @frame = 3
    @x = x
    @y = y
    @tick = 0
    @hp = 1000

    @.addEventListener 'enterframe', (e) ->
      if core.input.left
        @x -= 4
        if map.hitTest(@x + 16, @y + 40)
          @x += 4
        @frame = @tick % 4 * 4 + 1
        @tick++
      if core.input.right
        @x += 4
        if map.hitTest(@x + 24, @y + 40)
          @x -= 4
        @frame = @tick % 4 * 4 + 3
        @tick++
      if core.input.up
        @y -= 4
        if map.hitTest(@x + 24, @y + 40)
          @y += 4
        @frame = @tick % 4 * 4 + 2
        @tick++
      if core.input.down
        @y += 4
        if map.hitTest(@x + 24, @y + 40)
          @y -= 4
        @frame = @tick % 4 * 4
        @tick++

    @.addEventListener 'touchmove', (e) ->
      @x = e.x - @width / 2
      @y = e.y - @height / 2



window.onload = ->


  player = new Player(120, 50, map)
  core.rootScene.addChild(player)

  infoLabel = new Label('enchant.js サンプル')
