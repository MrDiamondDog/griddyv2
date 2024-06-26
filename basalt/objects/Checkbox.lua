local utils = require("utils")
local tHex = require("tHex")

return function(name, basalt)
    -- Checkbox
    local base = basalt.getObject("ChangeableObject")(name, basalt)
    local objectType = "Checkbox"

    base:setZIndex(5)
    base:setValue(false)
    base:setSize(1, 1)

    local symbol,inactiveSymbol,text,textPos = "\7"," ","","right"

    local object = {
        load = function(self)
            self:listenEvent("mouse_click", self)
            self:listenEvent("mouse_up", self)
        end,

        getType = function(self)
            return objectType
        end,
        isType = function(self, t)
            return objectType==t or base.isType~=nil and base.isType(t) or false
        end,

        setSymbol = function(self, sym, inactive)
            symbol = sym or symbol
            inactiveSymbol = inactive or inactiveSymbol
            self:updateDraw()
            return self
        end,

        setActiveSymbol = function(self, sym)
            return self:setSymbol(sym, nil)
        end,

        setInactiveSymbol = function(self, inactive)
            return self:setSymbol(nil, inactive)
        end,

        getSymbol = function(self)
            return symbol, inactiveSymbol
        end,

        getActiveSymbol = function(self)
            return symbol
        end,

        getInactiveSymbol = function(self)
            return inactiveSymbol
        end,

        setText = function(self, _text)
            text = _text
            return self
        end,

        getText = function(self)
            return text
        end,

        setTextPosition = function(self, pos)
            textPos = pos or textPos
            return self
        end,

        getTextPosition = function(self)
            return textPos
        end,

        setChecked = base.setValue,

        getChecked = base.getValue,

        mouseHandler = function(self, button, x, y)
            if (base.mouseHandler(self, button, x, y)) then
                if(button == 1)then
                    if (self:getValue() ~= true) and (self:getValue() ~= false) then
                        self:setValue(false)
                    else
                        self:setValue(not self:getValue())
                    end
                self:updateDraw()
                return true
                end
            end
            return false
        end,

        draw = function(self)
            base.draw(self)
            self:addDraw("checkbox", function()
                local obx, oby = self:getPosition()
                local w,h = self:getSize()
                local verticalAlign = utils.getTextVerticalAlign(h, "center")
                local bg,fg = colors.black, colors.green
                if (self:getValue()) then
                    self:addBlit(1, verticalAlign, utils.getTextHorizontalAlign(symbol, w, "center"), tHex[fg], tHex[bg])
                else
                    self:addBlit(1, verticalAlign, utils.getTextHorizontalAlign(inactiveSymbol, w, "center"), tHex[fg], tHex[bg])
                end
                if(text~="")then
                    local align = textPos=="left" and -text:len() or 3
                    self:addText(align, verticalAlign, text)
                end
            end)
        end,
    }

    object.__index = object
    return setmetatable(object, base)
end