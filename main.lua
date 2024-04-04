-- FLAPPY BIRD

function start()

	pipes.instances = {}
	pipes.timer = 0

	bird.dead = false
	bird.score = 0
	bird.y = ground.y/2-bird.height/2
	bird.dy = 0
	bird.timer = 0
	bird.imageNo = 2

end

function drawPipes()

	for pipeNo=1, #pipes.instances, 1 do

		love.graphics.draw(pipes.image, pipes.instances[pipeNo].x, pipes.instances[pipeNo].y, 0, scale, scale)
		love.graphics.draw(pipes.image, pipes.instances[pipeNo].x+pipes.width, pipes.instances[pipeNo].y-pipes.gap, math.pi, scale, scale)

	end

end

function moveGround()

	ground.x = ground.x - gameSpeed

	if ground.x+ground.width < 0 then ground.x = 0 end

end

function spawnPipes()

	if pipes.timer % pipes.frequency == 0 then
		pipes.instances[#pipes.instances+1] = {x=window.width, y=love.math.random(ground.y-pipes.height, ground.y-pipes.height/4)}
	end

  pipes.timer = pipes.timer+1

end

function movePipes()

	for pipeNo=1, #pipes.instances, 1 do
		pipes.instances[pipeNo].x = pipes.instances[pipeNo].x - gameSpeed
	end

	for pipeNo=1, #pipes.instances, 1 do
  
		if pipes.instances[pipeNo].x < 0-pipes.width then
			table.remove(pipes.instances, pipeNo)
		end
	
		break
  
	end

end

function animateBird()

	bird.timer = bird.timer + 1
	
	if bird.timer % bird.animationSpeed == 0 then
		bird.imageNo = bird.imageNo % #bird.images + 1
	end

end

function moveBird()

	bird.y = bird.y - bird.dy
	bird.dy = bird.dy - bird.gravity

	function love.keypressed(key)
		if key == "up" or key == "w" then
			bird.dy = bird.jumpStr
		end
	end

	function love.mousepressed(x, y, button, istouch, presses)
		if button == 1 then
			bird.dy = bird.jumpStr
		end
	end

end

function collideBird()

	if bird.y+bird.height >= ground.y then bird.dead = true end

	for pipeNo=1, #pipes.instances, 1 do
		
		if bird.x+bird.width >= pipes.instances[pipeNo].x and bird.x <= pipes.instances[pipeNo].x+pipes.width then
	
			if bird.y <= 0 then bird.dead = true end
	
			if bird.y <= pipes.instances[pipeNo].y-pipes.gap or bird.y+bird.height >= pipes.instances[pipeNo].y then bird.dead = true end
	
		end
		
		if bird.x == pipes.instances[pipeNo].x+pipes.width then
	
			bird.score = bird.score + 1
	
			if #tostring(bird.score) > 8 then bird.dead = true end
	
		end
	
	end

  if bird.dead then start() end

end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function love.load()

	scale = 3
	gameSpeed = 3

	love.graphics.setDefaultFilter("nearest")

	background = {image=love.graphics.newImage("images/background.png")}

	window = {
		width=background.image:getWidth()*scale,
		height=background.image:getHeight()*scale
	}

	love.window.setMode(window.width, window.height)
	love.window.setTitle("flappyBird")

	font = love.graphics.newFont("flappy_bird_font.ttf", 20)
	love.graphics.setFont(font)

	ground = {x=0, image=love.graphics.newImage("images/ground.png")}
	ground.width = ground.image:getWidth()*scale
	ground.height = ground.image:getHeight()*scale
	ground.y = window.height - ground.height

	bird = {
		gravity=0.5,
		jumpStr=2.5*scale,
		animationSpeed=15/gameSpeed,
		images={love.graphics.newImage("images/bird0.png"), love.graphics.newImage("images/bird1.png"), love.graphics.newImage("images/bird2.png")}
	}

	bird.width, bird.height = bird.images[1]:getWidth()*scale, bird.images[1]:getHeight()*scale
	bird.x = window.width/2-bird.width

	pipes = {
		frequency=300/gameSpeed,
		gap=bird.height*4,
		image=love.graphics.newImage("images/pipe.png")
	}

	pipes.width, pipes.height = pipes.image:getWidth()*scale, pipes.image:getHeight()*scale

	start()

end

function love.update(dt)

	if love.keyboard.isDown("escape") then love.event.quit() end

	moveGround()
	spawnPipes()
	movePipes()
	animateBird()
	moveBird()
	collideBird()

end

function love.draw()

  love.graphics.draw(background.image, 0, 0, 0, scale, scale)

  drawPipes()

  love.graphics.draw(ground.image, ground.x, ground.y, 0, scale, scale)

  love.graphics.draw(ground.image, ground.x+ground.width, ground.y, 0, scale, scale)

  love.graphics.draw(bird.images[bird.imageNo], bird.x, bird.y, 0, scale, scale)

  love.graphics.print(bird.score, window.width/2-font:getWidth(bird.score)*scale/2, window.height/8, 0, scale, scale)

end
