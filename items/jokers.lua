--- STEAMODDED HEADER
--- MOD_NAME: PDUBMod
--- MOD_ID: PDUBMod
--- MOD_AUTHOR: Jonah Falder
--- MOD_DESCRIPTION: hi
--- PREFIX: pdub
----------------------------------------------------------
----------- MOD CODE -------------------------------------


---Sexy Sam

SMODS.Atlas{
    key = 'Sam',
    path = 'Sam.png',
    px = 350,
    py = 520,
}


SMODS.Joker{
    key = 'Sam',
    loc_txt= {
        name = 'Sexy Sam',
        text = {
            'This Joker Gains {X:mult,C:white}X#1#{} Mult when a {C:attention}Royal Flush{} is Played',
            '(Currently : {X:mult,C:white}X#2#{} Mult)'  
        }
    },
    atlas = "Sam",
    rarity = 1,
    cost = 6,
    pools = {["pdubmodaddition"] = true},

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    pos = {x = 0, y = 0},
    
    config = { 
        extra = { 
            add = 1,
            xmult = 1.5 
        } 
    },

    loc_vars = function(self, info_queue, center)
        return { vars = {center.ability.extra.add, center.ability.extra.xmult} }
    end,

    calculate = function(self, card, context)
        -- Only trigger on scoring hands (before scoring)
        if context.joker_main and next(context.poker_hands['Straight Flush']) then
            _royal = true
            for i = 1, #G.play.cards do
                local _rank = G.play.cards[i]:get_id()
                if _rank < 10 then
                    _royal = false
                end
                if _royal == true then
                    card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.add
                    return {
                        message = "All in!",
                        xmult = card.ability.extra.xmult
                    }
                end
                
            end
        end

        -- Always apply multiplier if joker_main
        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end
}

---KSAC Hours

SMODS.Atlas{
    key = 'KSAC',
    path = 'Lucas.png',
    px = 200,
    py = 250,
}


SMODS.Joker{
    key = 'KSAC',
    loc_txt = {
        name = 'KSAC Hours?',
        text = {
            'If the KSAC is Open, {C:red}+#1#{} Mult',
        }
    },
    atlas = 'KSAC',
    rarity = 1,
    cost = 4,
    pools = {["pdubmodaddition"] = true},

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    pos = {x=0, y= 0},
    config = { extra = {mult = 25}},


    loc_vars = function(self, info_queue, center)
        return { vars = {center.ability.extra.mult}}
    end,

    calculate = function(self, card, context)
        local t = os.date("*t")
        local weekday = t.wday
        local hour = t.hour
        local min = t.min

        local is_weekday = weekday >= 2 and weekday <= 6

        local after_open = (hour >= 6) or (hour == 5 and min >= 30)
        local before_close = hour < 23

        local ksac_open = is_weekday and after_open and before_close

        if context.open then return end

        if ksac_open and context.joker_main then
            return {
                message = "KSAC OPEN!",
                mult = card.ability.extra.mult
            }
        end
    end,


    check_for_unlock = function(self, args)
        if args.type == 'test' then --not a real type, just a joke
            unlock_card(self)
        end
        unlock_card(self) --unlocks the card if it isnt unlocked
    end,
   
}

---ShangChi

SMODS.Atlas{
    key = "ShangChi",
    path = "shang-chi.png",
    px = '500',
    py = '500',
}

SMODS.Joker{
    key = 'ShangChi',
    loc_txt = {
        name = "Shang-Chi",
        text = { "Removes {C:attention}10%{} of required score from the current blind"},
    },
    atlas = 'ShangChi',
    rarity = 1,
    cost = 6,
    pools = {["pdubmodaddition"] = true},

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    pos = {x=0, y=0},

    calculate = function(self, card, context)
        if context.setting_blind then
            G.GAME.blind.chips = G.GAME.blind.chips * 0.9
        end
    end,
}

---Dirk Nowitzki

SMODS.Atlas{
    key = "Dirk0",
    path = "dirksheet.png",
    px= 73,
    py = 110,
}




SMODS.Joker{
    key = 'Dirk',

    atlas = 'Dirk0',
    rarity = 1,
    cost = 6,
    pools = {["pdubmodaddition"] = true},

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    pos = {x = 0, y = 0},

    config = {
        extra = {
            chosen = 0,
            count = 0,
            dollaramt = 3
        }
    },

    loc_vars = function(self, info_queue, center)
        return {
            key = center.ability.extra.chosen and ((center.ability.extra.chosen == 0 and "j_pdub_key_alt0") or
            (center.ability.extra.chosen == 1 and "j_pdub_key_alt1") or 
            (center.ability.extra.chosen == 2 and "j_pdub_key_alt2") or
            (center.ability.extra.chosen == 3 and "j_pdub_key_alt3") or
            (center.ability.extra.chosen == 4 and "j_pdub_key_alt4") or
            (center.ability.extra.chosen == 5 and "j_pdub_key_alt5") or
            (center.ability.extra.chosen == 6 and "j_pdub_key_alt6")) or nil,
        }
    end,


    calculate = function(self, card, context)
        

        if context.after then
            card.ability.extra.chosen = math.random(1,6)          
        
            if card.ability.extra.chosen == 1 then
                G.E_MANAGER:add_event(Event({
                    trigger = 'immediate',
                    blocking = false,
                    delay = 0,
                        func = function()
                            card_eval_status_text(card,'extra',nil,nil,nil,{message = "SWITCH!"})
                            card.children.center:set_sprite_pos({x=1, y=0})
                            return true
                        end,

                }))
            end
            if card.ability.extra.chosen == 2 then 
                 G.E_MANAGER:add_event(Event({
                    trigger = 'immediate',
                    blocking = false,
                    delay = 0,
                        func = function()
                            card_eval_status_text(card,'extra',nil,nil,nil,{message = "SWITCH!"})
                            card.children.center:set_sprite_pos({x=2, y=0})
                            return true
                        end,

                    }))
            end
            if card.ability.extra.chosen == 3 then
                G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                blocking = false,
                delay = 0,
                    func = function()
                        card_eval_status_text(card,'extra',nil,nil,nil,{message = "SWITCH!"})
                        card.children.center:set_sprite_pos({x=3, y=0})
                        return true
                    end,

                }))
               
            end
            if card.ability.extra.chosen == 4 then
                G.E_MANAGER:add_event(Event({
                    trigger = 'immediate',
                    blocking = false,
                    delay = 0,
                        func = function()
                            card_eval_status_text(card,'extra',nil,nil,nil,{message = "SWITCH!"})
                            card.children.center:set_sprite_pos({x=0, y=1})
                            return true
                        end,

                    }))
            
            end
            if card.ability.extra.chosen == 5 then

                G.E_MANAGER:add_event(Event({
                    trigger = 'immediate',
                    blocking = false,
                    delay = 0,
                        func = function()
                            card_eval_status_text(card,'extra',nil,nil,nil,{message = "SWITCH!"})
                            card.children.center:set_sprite_pos({x=1, y=1})
                            return true
                        end,

                    }))
            end
            if card.ability.extra.chosen == 6 then

                 G.E_MANAGER:add_event(Event({
                    trigger = 'immediate',
                    blocking = false,
                    delay = 0,
                        func = function()
                            card_eval_status_text(card,'extra',nil,nil,nil,{message = "SWITCH!"})
                            card.children.center:set_sprite_pos({x=2, y=1})
                            return true
                        end,

                    }))
        
            end
        end

        if context.joker_main then 
            if card.ability.extra.chosen == 1 then
                return {
                    mult = 15
                }
            end
            if card.ability.extra.chosen == 2 then 
                return {
                    xmult = 2
                }
            end
            if card.ability.extra.chosen == 3 then
                return {
                    chips = 250
                }
            end
            if card.ability.extra.chosen == 4 then
                return {
                    x_chips = 4
                }
            end
            if card.ability.extra.chosen == 5 then
                return {
                    ease_dollars(card.ability.extra.dollaramt),
                    card_eval_status_text(card,'extra',nil,nil,nil,{message = "$"..card.ability.extra.dollaramt})
                }
            end
            if card.ability.extra.chosen == 6 then
                return {
                    emult = 2
                }
            end
        end
    end,
}


---Hangman

SMODS.Atlas{
    key = "hang",
    path = "hangman.jpeg",
    px = 600,
    py = 420,
}


SMODS.Joker{
    key = 'hang',
    loc_txt = {
        name = "Hangman",
        text = {"This Joker Gains {X:mult,C:white}X#1#{} Mult",
                "when {C:attention}The Hanged Man{} is Used",
                "Currently {X:mult,C:white}X#2#{} Mult"}
    },
    atlas = 'hang',
    rarity = 1,
    cost = 7,
    pools = {["pdubmodaddition"] = true},

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,


    config = { 
        extra = { 
            add = 0.5,
            count = 1,
        } 
    },




    loc_vars = function(self, info_queue, center)
        return { vars = {center.ability.extra.add, center.ability.extra.count} }
    end,



    calculate = function(self, card, context)
        if context.consumeable then
            if context.consumeable.ability.name == "The Hanged Man" then
                card.ability.extra.count = card.ability.extra.count + card.ability.extra.add
                return {
                    message = "+x".. card.ability.extra.add
                }
            end
        end

        if context.joker_main then 
            return {
                mult = card.ability.extra.count
            }
        end
    end,
}



---Triple Swipe
SMODS.Atlas{
    key = "Triple",
    path = "TripleSwipe.png",
    px= 650,
    py = 1050,
}


SMODS.Joker{
    key = 'Triple',
    loc_txt = {
        name = "Triple Swipe",
        text = {"This Joker Gains {C:red}+#1#{} Mult ",
                "when a {C:attention}Three of a Kind {}",
                "is played {C:attention}3 Times{} in a row",
                "Currently: {C:red}+#2#{} Mult"}
    },
    atlas = 'Triple',
    rarity = 1,
    cost = 6,
    pools = {["pdubmodaddition"] = true},

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    pos = {x=0, y=0},

    config = { 
        extra = { 
            add = 33,
            mult = 0,
            count = 0 
        } 
    },



    loc_vars = function(self, info_queue, center)
        return { vars = {center.ability.extra.add, center.ability.extra.mult} }
    end,

    calculate = function(self, card, context)
        if context.before then 
           
            if card.ability.extra.count == 2 and next(context.poker_hands["Three of a Kind"]) then 
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.add
                card.ability.extra.count = 0
                return {
                    message = "TRIPLE SWIPE!"
                }
        
            end
           
            if context.poker_hands and next(context.poker_hands["Three of a Kind"]) then
                card.ability.extra.count = card.ability.extra.count + 1
                local temp = card.ability.extra.count
                temp = tostring(temp)
                return{
                    message = temp .."!"
                }
            else 
                card.ability.extra.count = 0
                return{
                    message = 'Reset!'  
                }
            end

            
            
        end

        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end


    end,
}

--Kinda Homeless
SMODS.Atlas{
    key = "homeless",
    path = "homeless.jpg",
    px= 320,
    py = 420,
}

SMODS.Joker{
    key = 'homeless',
    loc_txt = {
        name = "Kinda Homeless",
        text = {"{X:mult,C:white}x1.5{} mult if played hand",
                "{C:blue} IS NOT{} a{C:attention} Full House{}" }
    },
    atlas = 'homeless',
    rarity = 3,
    cost = 6,
    pools = {["pdubmodaddition"] = true},

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    pos = {x=0, y=0},

    calculate = function(self, card, context)
        if context.joker_main then
            local is_full_house = context.poker_hands and next(context.poker_hands["Full House"] or {})
            if not is_full_house then
                return {
                    x_mult = 1.5
                }
            end
        end
    end,
}


---Mr. President

SMODS.Atlas{
    key = "President",
    path = "President.png",
    px= 450,
    py = 750,
}


SMODS.Joker{
    key = 'President',
    loc_txt = {
        name = "Mr.President",
        text = {" {X:black,C:white}^2{} to your Mult",
                "{C:inactive}One Body Who?{}"}
    },
    atlas = 'President',
    rarity = 4,
    cost = 6,
    pools = {["pdubmodaddition"] = true},

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    pos = {x=0, y=0},

    calculate = function(self, card, context)
       if context.joker_main then
            return {
                emult = 2
            }
        end
    end,
}

---Cucumber?

SMODS.Atlas{
    key = 'Cucumber',
    path = 'Cucumber.png',
    px = 450,
    py = 750,
}


SMODS.Joker{
    key = 'Cucumber',
    loc_txt = {
        name = "Cucumber?",
        text = {"For Each Sister Wing Joker {C:red}+#1#{} Mult",
                "Currently {C:red}+#2#{} Mult"}
    },
    atlas = 'Cucumber',
    rarity = 1,
    cost = 6,
    pools = {["pdubmodaddition"] = true, ["SisterWing"] = true},

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    pos = {x=0, y=0},

    config = { 
        extra = { 
            mult = 10,
            multtotal = 0,
        } 
    },
    
    
    loc_vars = function(self, info_queue, center)
		return { vars = {center.ability.extra.mult, center.ability.extra.multtotal} } 
	end,


    calculate = function(self, card, context)
        siscount = 0
        for i = 1, #G.jokers.cards do
            if G.jokers.cards[i].config.center.pools and G.jokers.cards[i].config.center.pools.SisterWing then
                siscount = siscount + 1
            end
        end
        card.ability.extra.multtotal =  siscount * card.ability.extra.mult
        if context.joker_main then
            return {
                color = G.C.RED,
                message = "+".. card.ability.extra.multtotal,
                mult_mod = card.ability.extra.multtotal
            }
        end
    end,
}


---Balkema

SMODS.Atlas{
    key = 'Balkema',
    path = 'Balkema.png',
    px = 100,
    py = 150,
}

SMODS.Joker{
    key = 'Balkema',
    loc_txt = {
        name = "Luke Balkema",
        text = {"{X:mult,C:white}x3.5{} Mult",
                "Crashes your Game if you lose",
                "{C:inactive}I'm just making the game more fun!{}"}
    },


    atlas = 'Balkema',
    rarity = 3,
    cost = 6,
    pools = {["pdubmodaddition"] = true},

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    pos = {x=0, y=0},



    calculate = function(self, card, context)
        if context.joker_main then
            return{
                xmult = 3.5
            }
        end

        if context.game_over then
            local crash = nil
            crash.do_it = true
        end
    end,
}


--Hairline


SMODS.Atlas{
    key = 'hairline',
    path = 'hairline.jpg',
    px = 410,
    py = 575,
}

SMODS.Joker{
    key = 'hairline',
    loc_txt = {
        name = "Lebron James Hairline",
        text = {"{C:purple}+1 Joker Slot{}",
                "Also Removes {C:red}Oblelisk{} From All Shops",
                "{C:inactive}WE ARE NOT DOING DUNK, DUNK, DUNK{}"}
    },

    atlas = 'hairline',
    rarity = 2,
    cost = 4,
    pools = {["pdubmodaddition"] = true},

    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,

    pos = {x=0, y=0},


    add_to_deck = function(self, card, from_debuff)
        G.jokers.config.card_limit = G.jokers.config.card_limit + 1
        G.GAME.banned_keys['obelisk'] = true
    end,

    remove_from_deck = function(self, card, from_debuff)
		G.jokers.config.card_limit = G.jokers.config.card_limit - 1
        G.GAME.banned_keys['obelisk'] = false
	end,


}


--Freaky


local function edition_signature()
    local parts = {}
    for i, j in ipairs(G.jokers.cards) do
        local t = (j.edition and j.edition.type) and j.edition.type or "none"
        parts[#parts+1] = tostring(i) .. ":" .. t
    end
    return table.concat(parts, "|")
end


function get_edition_joker_count()
    local count = 0
    for _, joker in ipairs(G.jokers.cards) do
        if joker.edition and joker.edition.type then
            count = count + 1
        end
    end
    return count
end

SMODS.Atlas {
    key = 'Freaky',
    path = 'Freak.png',
    px = 600,
    py = 900,
}


SMODS.Joker{
    key = 'Freaky',
    loc_txt = {
        name = "Freaky Gogis",
        text = {
            "When {C:attention}Wheel of Fortune{} fails, {C:red}+#1#{} Mult",
            "Currently: {C:red}+#2#{} Mult",
            "Puts a {C:attention}Wheel of Fortune{} in Every Shop"
        }
    },
    atlas = 'Freaky',
    rarity = 2,
    cost = 4,
    pools = {["pdubmodaddition"] = true},

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    pos = {x=0, y=0.1},

    config = {
        extra = {
            add = 5,
            mult = 0,
            tag_added_this_round = false, -- <--- store state here
        },
    },

    loc_vars = function(self, info_queue, center)
        -- use the SAME key you actually add
        info_queue[#info_queue + 1] = { key = 'tag_pdub_tag_wof', set = 'Tag' }
        return { vars = { center.ability.extra.add, center.ability.extra.mult } }
    end,

    add_to_deck = function(self, card, from_debuff)
        G.GAME.shop.joker_max = G.GAME.shop.joker_max + 1
        if G.shop then
            G.shop:recalculate()
            G.shop_jokers.T.w = 6*1.02*G.CARD_W
            G.shop_jokers.T.h = 1.05*G.CARD_H
        end
    end,

    remove_from_deck = function(self, card, from_debuff)
        G.GAME.shop.joker_max = G.GAME.shop.joker_max - 1
    end,

    calculate = function(self, card, context)
        -- Prevent blueprint copies from also injecting tags
        if context.blueprint then return end

        -- Reset once per round (this is a common reliable hook)
        if context.setting_blind then
            card.ability.extra.tag_added_this_round = false
        end

        -- Add the tag once per round
        if context.end_of_round and not card.ability.extra.tag_added_this_round then
            add_tag(Tag('tag_pdub_tag_wof'))
            card.ability.extra.tag_added_this_round = true
        end
       if context.using_consumeable
        and context.consumeable
        and context.consumeable.ability
        and context.consumeable.ability.name == "The Wheel of Fortune"
        then
            local wof = context.consumeable

            if not wof._freaky_pending then
                wof._freaky_pending = true
                wof._freaky_sig_before = edition_signature()

                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.6, -- Wheel resolves later; give it time
                    func = function()
                        local after = edition_signature()
                        local before = wof._freaky_sig_before

                        -- if nothing about editions changed, Wheel failed
                        if after == before then
                            card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.add
                            card_eval_status_text(card, 'extra', nil, nil, nil, {
                                message = "+" .. card.ability.extra.add .. " Mult"
                            })
                        end

                        wof._freaky_pending = nil
                        wof._freaky_sig_before = nil
                        return true
                    end
                }))
            end
        end




        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end
    end,
}




-- 21 kid


SMODS.Atlas{
    key = '21kid',
    path = '21kid.png',
    px = 40,
    py = 50,
}

SMODS.Sound({key = "nine", path = "nine.ogg",})
SMODS.Sound({key = "ten", path = "ten.ogg",})
SMODS.Sound({key = "twennyone", path = "twennyone.ogg",})

SMODS.Joker{
    key = '21kid',
    loc_txt= {
        name = '21 Kid',
        text = { "{X:mult,C:white} X#1# {} Mult if scored hand" ,
                    "contains a {C:attention}9{} and a {}{C:attention}10{}",
                    "{C:inactive}you stupid{}",
                    "{C:inactive}no i'm not{}",
                    "{C:inactive}what's nine plus ten?{}",
                    "{C:inactive}twenty one{}",
                    "{C:inactive}you stupid{}"}
    },
    atlas = '21kid',
    rarity = 1,
    cost = 4,
    pools = {["pdubmodaddition"] = true},
    
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,

    pos = {x=0, y= 0},
    config = { extra = {Xmult = 2.1}},

    loc_vars = function(self, info_queue, center)
		return { vars = { center.ability.extra.Xmult}  }
	end,

    calculate = function(self, card, context)
		if context.joker_main then
            local hasnine = false
            local hasten = false

            local hastwo = false -- achievement check
            local hasace = false

            for i = 1, #context.scoring_hand do
				if context.full_hand[i]:get_id() == 9 then
                    hasnine = true
                end
                if context.full_hand[i]:get_id() == 10 then
                    hasten = true
                end
                if context.full_hand[i]:get_id() == 14 then
                    hasace = true
                end
                if context.full_hand[i]:get_id() == 2 then
                    hastwo = true
                end
            end

            if hasnine == true and hasten == true then   
			return {
				message = "21!",
				Xmult_mod = card.ability.extra.Xmult,
                sound= "pdub_twennyone",
			}
            end
		end
        if context.cardarea == G.play and context.individual and context.other_card then
            local rank = context.other_card:get_id()
			if rank == 9 then
				return {
                    sound = 'pdub_nine',
                    message = '9!',
                }
			end
            if rank == 10 then
				return {
                    sound = 'pdub_ten',
                    message = '10!',
                }
			end
		end

    end,

    check_for_unlock = function(self, args)
        if args.type == 'test' then --not a real type, just a joke
            unlock_card(self)
        end
        unlock_card(self) --unlocks the card if it isnt unlocked
    end,
}



--DMike


SMODS.Atlas{
    key = 'dmike',
    path ='dmike.jpeg',
    px = 100,
    py = 115,
}


SMODS.Joker{
    key = 'dmike',
    loc_txt = {
        name = "D Mike",
        text = {"{C:red}+1{} Mult per sell value",
                "takes {C:attention}$1{} of sell value from each joker at end of round",
                "Currently {C:red}+#1#{} Mult"}
    },
    atlas= 'dmike',
    rarity = 1,
    cost = 4,
    pools = {["pdubmodaddition"] = true},
    
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,

    pos = {x=0.05,y=0},
    config = { extra = {mult = 0}},

    loc_vars = function(self, info_queue, center)
		return { vars = { center.ability.extra.mult}  }
	end,

    calculate = function(self, card, context)
        if context.joker_main then
            return {mult = card.ability.extra.mult}
        end

        if context.end_of_round and context.main_eval and not context.repetition and not context.individual then
            local gained = 0

            if G and G.jokers and G.jokers.cards then 
                for _, j in ipairs(G.jokers.cards) do
                    if j ~= card and j.ability then 
                        local before = j.sell_cost or 0

                        j.ability.extra_value = (j.ability.extra_value or 0) - 1

                        if j.set_cost then j:set_cost() end 

                        local after = j.sell_cost or before

                        if after < before then 
                            gained = gained + (before - after)
                        end
                    end
                end
            end
        
            if gained > 0 then
                card.ability.extra.mult = (card.ability.extra.mult or 0) + gained
                card.sell_cost = card.sell_cost + gained
                return {
                    message = "+"..tostring(gained).."Mult",
                    color = G.C.MULT,
                }
            end
        end
    end,

}



--chud joker



SMODS.Atlas{
    key = 'chud',
    path = 'chud.jpg',
    px = 285,
    py = 400,
}




local function deep_copy(t)
    if type(t) ~= 'table' then return t end
    local out  = {}
    for k, v in pairs(t) do
        out[k] = deep_copy(v)
    end
    return out
end

local function zero_numeric_leaves(t)
    if type(t) ~= 'table' then return t end
    for k, v in pairs(t) do 
        if type(v) == 'number' then 
            t[k] = 0
        elseif type(v) == 'table' then 
            zero_numeric_leaves(v)
        end
    end
end


SMODS.Joker{
    key = 'chud',
    loc_txt ={
        name = 'Chud Joker',
        text = {
                "All listed probabilities are now {C:attention}0%{}",
                '{C:inactive}frick my big fat chungus life{}'
        }
    },
    atlas = 'chud',
    rarity = 1,
    cost = 4,
    pools = {["pdubmodaddition"] = true},
    
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,

    pos = {x=0,y=0},


    add_to_deck = function(self, card, from_debuff)
        if not (G and G.GAME) then return end
        G.GAME._chud_count = (G.GAME._chud_count or 0) + 1


        if G.GAME._chud_count == 1 then
            G.GAME._chud_prob_backup = deep_copy(G.GAME.probabilities or {})
            if G.GAME.probabilities then 
                zero_numeric_leaves(G.GAME.probabilities)
            end
        end
    end,


    remove_from_deck = function(self, card, from_debuff)
        if not (G and G.GAME) then return end
        G.GAME._chud_count = (G.GAME._chud_count or 1) - 1


        if G.GAME._chud_count <= 0 then
            G.GAME._chud_count = 0
            if G.GAME._chud_prob_backup then
                G.GAME.probabilities = G.GAME._chud_prob_backup
                G.GAME._chud_prob_backup = nil
            end
        end
    end,


}




-- mega knight jensen

SMODS.Atlas {
    key = 'mkj',
    path = "MKJ.jpg",
    px = 400,
    py = 600,
}


SMODS.Joker{
    key = 'mkj',
    loc_txt ={
        name = 'Mega Knight Jensen',
        text = {
                "In Progress"
        }
    },
    atlas = 'mkj',
    rarity = 1,
    cost = 4,
    pools = {["pdubmodaddition"] = true, ["SisterWing"] = true},
    
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,

    pos = {x=0,y=0},


}



--