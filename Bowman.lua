SMODS.Atlas {
    key = "Jokers",
    px = 71,
    py = 95,
    path = "jokers-bowman.png",
}

SMODS.Joker {
    key = "willy_t",
    loc_txt = {
        name = "Willy T.",
        text = {
            "This Joker gains {C:mult}+#2#{} Mult",
            "for each card scored,",
            "resets at end of round",
            "{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult)"
        }
    },
    atlas = "Jokers", pos = { x = 0, y = 0 },
    config = {
        extra = {
            mult = 0,
            mult_gain = 1
        }
    },
    rarity = 1, -- Common
    cost = 5,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.mult, -- #1#
                card.ability.extra.mult_gain, -- #2#
            }
        }
    end,
    
    calculate = function(self, card, context)
        -- When a card is scored, upgrade Joker
        if context.individual and context.cardarea == G.play and not context.blueprint then
            card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
            return {
                card = card,
                colour = G.C.MULT,
                message = localize("k_upgrade_ex"),
            }
        end
        
        -- When Joker is triggered, add Mult
        if context.joker_main then
            return {
                message = localize {
                    type = "variable",
                    key = "a_mult",
                    vars = {
                        card.ability.extra.mult,
                    },
                },
                mult_mod = card.ability.extra.mult,
            }
        end

        -- At end of round, reset Mult
        if context.end_of_round and context.cardarea == G.jokers and not context.blueprint then
            card.ability.extra.mult = 0
            return {
                card = card,
                colour = G.C.MULT,
                message = localize("k_reset"),
            }
        end
    end
}
