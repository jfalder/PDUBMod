

-- Free PDUB Card

SMODS.Atlas{
    key = 'pdub_card',
    path = 'jony.png',
    px = 35,
    py = 45,
}


SMODS.Consumable({
    key = "pdub_card",
    set = "Tarot",
    object_type = "Consumable",
    name = "pdubworld",
    loc_txt = {
        name = "pdubworld",
        text={
        "Creates a random",
        "{C:attention}PDUBMod Joker{}",
        "{C:inactive}(must have room){}",
        },
    },
	
	
	pos = {x=0, y= 0},
	order = 99,
	atlas = "pdub_card",
    unlocked = true,
    cost = 4,

    use = function(self, card, area, copier)
        local card = create_card("pdubmodaddition", G.Jokers, nil, nil, nil, nil, nil, 'pdubworld')
        card:add_to_deck()
        G.jokers:emplace(card)
    end,

    can_use = function(self, card)
        if #G.jokers.cards < G.jokers.config.card_limit then
            return true
        end
	end,

	check_for_unlock = function(self, args)
		if args.type == "win_deck" then
            unlock_card(self)
        else
			unlock_card(self)
		end
	end,
})


-- sus? Card

SMODS.Atlas{
    key = 'sus',
    path = 'sus.png',
    px = 550,
    py = 755,
}

SMODS.Consumable{
    key = 'sus',
    set = 'Tarot',
    config = {
        max_highlighted = 1,
        extra = 'freak_seal',
    },
    loc_vars = function(self, info_queue, card)
        -- Handle creating a tooltip with seal args.
        info_queue[#info_queue+1] = G.P_SEALS[(card.ability or self.config).extra]
        -- Description vars
        return {vars = {(card.ability or self.config).max_highlighted}}
    end,
    loc_txt = {
        name = 'sus?',
        text = {
            "Select {C:attention}#1#{} card to",
            "apply a {C:red}FREAKY{} Seal to it"
        }
    },
    cost = 4,
    atlas = 'sus',
    pos = {x=0, y=0},
    use = function(self, card, area, copier)
        for i = 1, math.min(#G.hand.highlighted, card.ability.max_highlighted) do
            G.E_MANAGER:add_event(Event({func = function()
                card:juice_up(0.3, 0.5)
                return true end }))
            
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
                G.hand.highlighted[i].seal = "pdub_freak_seal"
                return true end }))
            
            delay(0.5)
        end
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2,func = function() G.hand:unhighlight_all(); return true end }))
    end,
}