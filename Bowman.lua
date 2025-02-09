SMODS.Atlas {
    key = "Jokers",
    px = 71,
    py = 95,
    path = "jokers-bowman.png",
}

-- Joker: Willy T.
SMODS.Joker {
    key = "willy_t",
    loc_txt = {
        name = "Willy T.",
        text = {
            "This Joker gains {C:mult}+#2#{} Mult",
            "for each card scored,",
            "resets at end of round",
            "{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult)",
        },
    },
    atlas = "Jokers", pos = { x = 0, y = 0 },
    config = {
        extra = {
            mult = 0,
            mult_gain = 1,
        },
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
            },
        }
    end,
    
    calculate = function(self, card, context)
        -- When a card is scored, upgrade Joker
        if (context.individual) and (context.cardarea == G.play) and (not context.blueprint) then
            card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
            return {
                card = card,
                colour = G.C.MULT,
                message = localize("k_upgrade_ex"),
            }
        end
        
        -- When Joker is triggered and Mult is >0, add Mult
        if (context.joker_main) and (card.ability.extra.mult > 0) then
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
        if (context.end_of_round) and (context.cardarea == G.jokers) and (not context.blueprint) then
            card.ability.extra.mult = 0
            return {
                card = card,
                colour = G.C.MULT,
                message = localize("k_reset"),
            }
        end
    end,
}

-- Joker: Wildcat
SMODS.Joker {
    key = "wildcat",
    loc_txt = {
        name = "Wildcat",
        text = {
            "This Joker gains {C:mult}+#2#{}",
            "Mult every {C:attention}#3#{} {C:inactive}[#4#]{} cards",
            "played and scored",
            "{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult)",
        },
    },
    atlas = "Jokers", pos = { x = 1, y = 0 },
    config = {
        extra = {
            mult = 0,
            mult_gain = 1,
            cards_to_score = 7,
            scored_cards = 7,
        },
    },
    rarity = 2, -- Uncommon
    cost = 6,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.mult, -- #1#
                card.ability.extra.mult_gain, -- #2#
                card.ability.extra.cards_to_score, -- #3#
                card.ability.extra.scored_cards, -- #4#
            },
        }
    end,
    
    calculate = function(self, card, context)
        -- When a card is scored, decrease scored cards counter
        if (context.individual) and (context.cardarea == G.play) and (not context.blueprint) then
            card.ability.extra.scored_cards = card.ability.extra.scored_cards - 1

            -- If scored cards counter reaches 0, upgrade Joker and reset counter
            if (card.ability.extra.scored_cards <= 0) then
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
                card.ability.extra.scored_cards = card.ability.extra.scored_cards + card.ability.extra.cards_to_score
                return {
                    card = card,
                    colour = G.C.MULT,
                    message = localize("k_upgrade_ex"),
                }
            end
        end
        
        -- When Joker is triggered and Mult is >0, add Mult
        if (context.joker_main) and (card.ability.extra.mult > 0) then
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
    end,
}
