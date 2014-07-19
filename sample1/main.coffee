enchant()

window.onload = ->

  core = new Core(320, 320)

  core.fps = 16

  core.preload 'betty.png', 'flowers.png', 'one_0.mp3', 'Ready.wav'

  core.onload = ->

    # 音
    core.assets['one_0.mp3'].play()
    core.assets['Ready.wav'].play()

    # サーフィスを作成
    image = new Surface(320, 320)
    image.draw(core.assets['flowers.png'], 0, 96, 126, 64, 64, 64, 126, 64)

    bg = new Sprite(320, 320)
    bg.image = image
    core.rootScene.addChild(bg)

    # キャラクター
    player = new Sprite(48, 48)
    player.image = core.assets['betty.png']
    player.frame = 3
    player.x = 120
    player.y = 50
    player.tick = 0

    core.rootScene.addChild(player)

    # キー入力
    player.addEventListener 'enterframe', (e) ->
      if core.input.left
        @x -= 4
        @frame = @tick % 4 * 4 + 1
        @tick++
      if core.input.right
        @x += 4
        @frame = @tick % 4 * 4 + 3
        @tick++
      if core.input.up
        @y -= 4
        @frame = @tick % 4 * 4 + 2
        @tick++
      if core.input.down
        @y += 4
        @frame = @tick % 4 * 4
        @tick++

    # キャラクタークリック
    player.addEventListener 'touchmove', (e) ->
      @x = e.x - @width / 2
      @y = e.y - @height / 2

    # ラベル作成
    infoLabel = new Label('enchant.js サンプル')
    infoLabel.x = 16
    infoLabel.y = 0
    infoLabel.color = '#0000FF'
    infoLabel.font = '14px sens-serif'
    core.rootScene.addChild(infoLabel)

  core.start()
