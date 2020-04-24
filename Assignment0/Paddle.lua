--[[
    GD50 2018
    Pong Remake

    -- Paddle Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents a paddle that can move up and down. Used in the main
    program to deflect the ball back toward the opponent.
]]

Paddle = Class{}

--[[
    The `init` function on our class is called just once, when the object
    is first created. Used to set up all variables in the class and get it
    ready for use.

    Our Paddle should take an X and a Y, for positioning, as well as a width
    and height for its dimensions.

    Note that `self` is a reference to *this* object, whichever object is
    instantiated at the time this function is called. Different objects can
    have their own x, y, width, and height values, thus serving as containers
    for data. In this sense, they're very similar to structs in C.
]]
function Paddle:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.dy = 0
    self.ai = false
    self.center_y = y
    self.variance = 15 
end

function Paddle:ai_move()

    -- give the cpu a bit of a shaky hand to give us humans
    -- a chance
    human_factor = math.random(-self.variance, self.variance)

    -- we use center_y to avoid worrying about the ball width
    -- as it's always shooting to be with the center point
    if ball.y < self.y then
        self.dy = -PADDLE_SPEED + human_factor
    elseif ball.y > (self.y + self.height) then
        self.dy = PADDLE_SPEED + human_factor
    else
        self.dy = 0
    end
end

function Paddle:update(dt)
    -- math.max here ensures that we're the greater of 0 or the player's
    -- current calculated Y position when pressing up so that we don't
    -- go into the negatives; the movement calculation is simply our
    -- previously-defined paddle speed scaled by dt
    if self.dy < 0 then
        self.y = math.max(0, self.y + self.dy * dt)
    -- similar to before, this time we use math.min to ensure we don't
    -- go any farther than the bottom of the screen minus the paddle's
    -- height (or else it will go partially below, since position is
    -- based on its top left corner)
    else
        self.y = math.min(VIRTUAL_HEIGHT - self.height, self.y + self.dy * dt)
    end

    -- assumes that x,y corner is top left corner
    self.center_y = self.y + ( self.height / 2 )
end

--[[
    To be called by our main function in `love.draw`, ideally. Uses
    LÖVE2D's `rectangle` function, which takes in a draw mode as the first
    argument as well as the position and dimensions for the rectangle. To
    change the color, one must call `love.graphics.setColor`. As of the
    newest version of LÖVE2D, you can even draw rounded rectangles!
]]
function Paddle:render()
    r,g,b,a = love.graphics.getColor()
    if self.ai == true then
        love.graphics.setColor(255, 0, 255, 255)
        -- cheap trick to just eyeball if we're left side or right side.
        if VIRTUAL_WIDTH - self.x > 100 then
            -- left side
            love.graphics.print( 'CPU', self.x + 20 , self.y - 10 )
        else
            -- right side
            love.graphics.print( 'CPU', self.x - 20 , self.y - 10 )
        end
    else
        love.graphics.setColor(0,255,0,255)
    end
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
    love.graphics.setColor(r,g,b,a)
end
