local aspectRatio = display.pixelHeight / display.pixelWidth

application = {
	content = {
		
        --width = 320,
		--height = 480, 
		width = 320,
        height = 320 * aspectRatio,
        scale = "letterBox",
		fps = 30,
		
		--[[
        imageSuffix = {
		    ["@2x"] = 2,
		}
		--]]
	},

    --[[
    -- Push notifications

    notification =
    {
        iphone =
        {
            types =
            {
                "badge", "sound", "alert", "newsstand"
            }
        }
    }
    --]]    
}
