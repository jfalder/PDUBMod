

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

--enchantress

local function strip_joker_mods(j)
    if not j then return end

    if j.set_edition then 
        j:set_edition(nil, true, true)
    else
        j.edition = nil
    end



    if j.ability then 

        j.ability.eternal = nil
        j.ability.perishable = nil 
        j.ability.rental = nil


        if j.ability.perish_tally  ~= nil then j.ability.perish_tally = 0 end
        if j.ability.perish ~= nil then j.ability.perish = 0 end
        j.ability.rental_rate = nil
    end


    if j.sticker then 
        j.sticker = nil
    end


    if j.juice_up then 
        j:juice_up(0.3,0.4) 
        
    end
end

SMODS.Atlas{
    key = 'enchant',
    path = 'enchant.png',
    px = 170,
    py = 250,
}


SMODS.Consumable{
    key = 'enchant',
    set = 'Spectral',
    loc_txt = {
        name = 'Enchantress',
        text = {
            "Removes {C:attention}EVERY{} modification of a Random Joker",
            "{C:red}Positive{} or {C:purple}Negative{}"
        }
    },

    unlocked = true,
    cost = 4,
    atlas = 'enchant',
    pos = {x=0.25, y=0},


    can_use = function(self,card)
        return G and G.jokers and G.jokers.cards and #G.jokers.cards > 0
    end,


    use = function(self, card, area, copier)
        if not (G and G.jokers and G.jokers.cards) then return end
        
        
        local pool ={}
        for i=1 , #G.jokers.cards do
            local j = G.jokers.cards[i]
            if j then pool[#pool+1] = j end 
        end
        if #pool == 0 then return end

        local target = pseudorandom_element(pool, pseudoseed('enchantress'))
        if not target then return end

        strip_joker_mods(target)
    
    end,


}


--seth baker 


SMODS.Atlas{
    key = 'seth_baker',
    path = 'seth_baker.JPG',
    px = 575,
    py = 1000,
}

SMODS.Consumable{
    key = 'seth_baker',
    set = 'Tarot',
    loc_txt = {
        name = 'Seth Baker Legendary Joker',
        text = {
            "{C:green}1 in 735,529{} chance to add",
             "{C:attention}4{} {C:purple}Negative{} Legendary Jokers"
        }
    },

    unlocked = true,
    cost = 1,
    atlas = 'seth_baker',
    pos = {x=0, y=0},


    can_use = function(self, card)
        return true
    end,


    use = function(self, card, area, copier)
        if pseudorandom('seth_baker') < 1/735529 then 
            local legendaries = {
                'j_caino',
                'j_triboulet',
                'j_yorick',
                'j_chicot',
                'j_perkeo',
                'j_pdub_President'
            }

            for i = 1, 4 do
            local index = pseudorandom(
                pseudoseed('seth_baker_legendary_' .. i),
                1,
                #legendaries
                )

                local legendary_key = legendaries[index]

                table.remove(legendaries, index)


                local new_card = create_card('Joker', G.jokers, nil, nil, nil, nil, legendary_key, 'seth_baker')

                new_card:set_edition({negative = true}, true)
                new_card:add_to_deck()
                G.jokers:emplace(new_card)

            end
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.3,
                func = function()
                    attention_text({
                        text = "I guess it is possible",
                        scale = 1.3,
                        hold = 1.4,
                        backdrop_colour = G.C.PURPLE,
                        align = 'cm',
                        major = G.ROOM_ATTACH,
                        offset = {x = 0, y = 0},
                        silent = true
                    })

                    play_sound('tarot2', 1, 0.4)
                    card:juice_up(0.3, 0.5)

                    return true
                end
            }))
        else
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                attention_text({
                    text = localize('k_nope_ex'),
                    scale = 1.3, 
                    hold = 1.4,
                    major = card,
                    backdrop_colour = G.C.SECONDARY_SET.Tarot,
                    align = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK) and 'tm' or 'cm',
                    offset = {x = 0, y = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK) and -0.2 or 0},
                    silent = true
                    })
                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.06*G.SETTINGS.GAMESPEED, blockable = false, blocking = false, func = function()
                        play_sound('tarot2', 0.76, 0.4);return true end}))
                    play_sound('tarot2', 1, 0.4)
                    card:juice_up(0.3, 0.5)
            return true end }))
        end
    end
}