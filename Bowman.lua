SMODS.Atlas {
    key = "Bowman",
    path = "Bowman.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = "willy_t",
    loc_txt = {
        name = "Willy T.",
        text = {
            "Gains {C:mult}+#2#{} Mult for",
            "each card scored,",
            "resets at end of round.",
            "{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult)"
        }
    },
    config = { extra = { mult = 0, mult_gain = 1 } },
    cost = 5,
    rarity = 1,
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,

    atlas = "Bowman",
    pos = { x = 1, y = 0 },
    
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.mult,
                card.ability.extra.mult_gain
            }
        }
    end,
    
    calculate = function(self, card, context)
        -- When a card is scored, upgrade joker
        if context.main_scoring and context.cardarea == G.play and not context.blueprint then
            card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
            return {
                card = card,
                colour = G.C.MULT,
                message = localize("k_upgrade_ex")
            }
        end
        
        -- When joker is triggered, add mult
        if context.joker_main then
            return {
                message = localize {
                    type = "variable",
                    key = "a_mult",
                    vars = {
                        card.ability.extra.mult
                    }
                },
                mult_mod = card.ability.extra.mult
            }
        end

        -- At end of round, reset mult
        if context.end_of_round and context.cardarea == G.jokers then
            card.ability.extra.mult = 0
            return {
                card = card,
                colour = G.C.MULT,
                message = localize("k_reset")
            }
        end
    end
}
