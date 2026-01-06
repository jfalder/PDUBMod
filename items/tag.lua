
--Wheel of Fortune (adds a Wheel to every shop)

SMODS.Atlas {
    key = 'tag_wof',
    path = 'Work in Progress.png',
    px = 1,
    py = 2,
}


SMODS.Tag{
    key = 'tag_wof',
    loc_txt = {
        name = 'wof'
    },
    atlas = 'tag_wof',
    pos = { x = 0, y = 0 },
    min_ante = 25,
    config = { type = "store_joker_create" },
    

    apply = function(self, tag, context)
		if context.type == "store_joker_create" then
			local card
            card = create_card("Joker", context.area, nil, nil, nil, nil, "c_wheel_of_fortune")
            create_shop_card_ui(card, "Joker", context.area)
            card.states.visible = false
            tag:yep("+", G.C.FILTER, function()
				card:start_materialize()
				return true
			end)
			tag.triggered = true
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.5,
				func = function()
					save_run() --fixes savescum bugs hopefully?
					return true
				end,
			}))
			return card
		end
	end,
}