local basalt = require("basalt")

local main = basalt.createFrame():setTheme({
    BaseFrameBG = colors.black,
    BaseFrameText = colors.white,
    FrameBG = colors.black,
    FrameText = colors.white,
    ButtonBG = colors.gray,
    ButtonText = colors.white,
    CheckboxBG = colors.lightGray,
    CheckboxText = colors.black,
    InputBG = colors.black,
    InputText = colors.lightGray,
    TextfieldBG = colors.black,
    TextfieldText = colors.white,
    ListBG = colors.black,
    ListText = colors.lightGray,
    MenubarBG = colors.gray,
    MenubarText = colors.white,
    DropdownBG = colors.gray,
    DropdownText = colors.white,
    RadioBG = colors.black,
    RadioText = colors.green,
    SelectionBG = colors.black,
    SelectionText = colors.white,
    GraphicBG = colors.black,
    ImageBG = colors.black,
    PaneBG = colors.black,
    ProgramBG = colors.black,
    ProgressbarBG = colors.gray,
    ProgressbarText = colors.black,
    ProgressbarActiveBG = colors.black,
    ScrollbarBG = colors.lightGray,
    ScrollbarText = colors.gray,
    ScrollbarSymbolColor = colors.black,
    SliderBG = false,
    SliderText = colors.gray,
    SliderSymbolColor = colors.black,
    SwitchBG = colors.lightGray,
    SwitchText = colors.gray,
    LabelBG = false,
    LabelText = colors.black,
    GraphBG = colors.gray,
    GraphText = colors.black
})

local debugFrame = main:addFrame():setSize("parent.w", 5):setPosition(1, "parent.h - 3"):setZIndex(1000):hide()
local messages = {}

local function debug(...)
    local str = ""
    for i = 1, select("#", ...) do
        str = str .. tostring(select(i, ...)) .. " "
    end
    table.insert(messages, str)

    if #messages > 5 then
        table.remove(messages, 1)
    end

    debugFrame:removeChildren()
    for i = 1, #messages do
        debugFrame:addLabel():setText(messages[i]):setPosition(1, 5 - i):setSize("parent.w", 1):setBackground(colors.gray)
        debugFrame:show()
    end
end

return {frame = main, debug = debug}