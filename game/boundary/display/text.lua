-- 
-- text.lua
-- Contains font drawing functions
--

local Text = {}
Text.__tileWidth = 8
Text.__tileHeight = 8
Text.__quads = {}
Text.__numQuads = {}
Text.__tileSet = love.graphics.newImage ("resources/font.png")
Text.__numberSet = love.graphics.newImage ("resources/numbers.png")
Text.__setBase = "A"
Text.__setNumBase = "0"
Text.__base = Text.__setBase:byte (1) - 1
Text.__numBase = Text.__setNumBase:byte (1) - 1

-- Set quads (currently: 26)
for x = 0, 26 do
    table.insert (Text.__quads, love.graphics.newQuad (x * Text.__tileWidth, 0, Text.__tileWidth, Text.__tileHeight, 208, 8))
end

for x = 0, 10 do
    table.insert (Text.__numQuads, love.graphics.newQuad (x * Text.__tileWidth, 0, Text.__tileWidth, Text.__tileHeight, 80, 8))
end

-- Draw a string at position
function Text.string (text, x, y)
    text = tostring (text)
    text = string.upper (text)
    for i = 1, #text do
        if text:byte (i) > Text.__base then
            Text.drawChar (text:byte (i), x + i * Text.__tileWidth, y)
        elseif text:byte (i) > Text.__numBase then
            Text.drawNum (text:byte (i), x + i * Text.__tileWidth, y)
        end
    end
end

function Text.drawChar (i, x, y)
    love.graphics.draw (Text.__tileSet, Text.__quads [i - Text.__base], x, y)
end

function Text.drawNum (i, x, y)
    love.graphics.draw (Text.__numberSet, Text.__numQuads [i - Text.__numBase], x, y)
end


return Text
