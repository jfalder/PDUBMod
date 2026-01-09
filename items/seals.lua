SMODS.Atlas {
    key = "freak_seal",
    path = "freak_seal.png",
    px = 25,
    py = 20,
}


SMODS.Seal {
    name = 'freak_seal',
    key = 'freak_seal',
    badge_colour = HEX("FF00FF"),
    loc_txt = {
        label = 'FREAK SEAL',
        name = 'FREAK SEAL',
        text = {  "{X:blue,C:white}x1.25{} {C:blue}Chips{}"}
    },


    atlas = 'freak_seal',
    pos = {x=0,y=0},

    calculate = function (self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            return {x_chips = 1.25}
        end

    end,
}