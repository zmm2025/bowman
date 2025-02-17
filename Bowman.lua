SMODS.Atlas {
    key = "Jokers",
    px = 71,
    py = 95,
    path = "jokers-bowman.png",
}

SMODS.Joker { -- Joker: Willy T.
    key = "willy_t",
    loc_txt = {
        name = "Willy T.",
        text = {
            "This Joker gains {C:mult}+#2#{} Mult when",
            "each played card is scored,",
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
                message = localize("k_upgrade_ex"),
                delay = 0.4,
            }
        end

        -- When Joker is triggered and Mult is >0, add Mult
        if (context.joker_main) and (card.ability.extra.mult > 0) then
            return {
                mult = card.ability.extra.mult,
            }
        end

        -- At end of round, reset Mult
        if (context.end_of_round) and (context.cardarea == G.jokers) and (not context.blueprint) then
            card.ability.extra.mult = 0
            return {
                message = localize("k_reset"),
            }
        end
    end,
}

SMODS.Joker { -- Joker: Wildcat
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
            mult_gain = 2,
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
                    message = localize("k_upgrade_ex"),
                }
            end
        end

        -- When Joker is triggered and Mult is >0, add Mult
        if (context.joker_main) and (card.ability.extra.mult > 0) then
            return {
                mult = card.ability.extra.mult,
            }
        end

        -- At end of round, meow
        if (context.end_of_round) and (context.cardarea == G.jokers) and (not context.game_over) then
            return {
                message = "Meow!", -- TODO: Localize
            }
        end
    end,
}

SMODS.Joker { -- Joker: Scratch
    key = "scratch",
    loc_txt = {
        name = "Scratch",
        text = {
            "Played {C:attention}number{} cards have",
            "a {C:green}#2# in #3#{} chance to give",
            "{C:chips}+#1#{} Chips when scored",
        },
    },
    atlas = "Jokers", pos = { x = 2, y = 0 },
    config = {
        extra = {
            chips = 50,
            odds = 2,
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
                card.ability.extra.chips, -- #1#
                G.GAME.probabilities.normal or 1, -- #2#
                card.ability.extra.odds, -- #3#
            },
        }
    end,

    calculate = function(self, card, context)
        -- When a card is scored, add Chips if random odds succeed
        if (context.individual) and (context.cardarea == G.play) then
            if (2 <= context.other_card:get_id()) and (context.other_card:get_id() <= 10) then
                if (pseudorandom("scratch") < G.GAME.probabilities.normal / card.ability.extra.odds) then
                    return {
                        chips = card.ability.extra.chips,
                    }
                end
            end
        end

        -- At end of round, meow
        if (context.end_of_round) and (context.cardarea == G.jokers) and (not context.game_over) then
            return {
                message = "Meow!", -- TODO: Localize
            }
        end
    end,
}

SMODS.Joker { -- Joker: Tallest Building in the World
    key = "tallest_building",
    loc_txt = {
        name = "Tallest Building in the World",
        text = {
            "This Joker gains {X:mult,C:white}X#2#{} Mult per",
            "{C:attention}consecutive{} hand played while",
            "playing your most played {C:attention}poker hand{}",
            "{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive} Mult)",
        },
    },
    atlas = "Jokers", pos = { x = 3, y = 0 },
    config = {
        extra = {
            xmult = 1,
            xmult_gain = 0.1,
        },
    },
    rarity = 3, -- Rare
    cost = 8,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.xmult, -- #1#
                card.ability.extra.xmult_gain, -- #2#
            },
        }
    end,

    calculate = function(self, card, context)
        -- When hand is played, if it's a most played hand, upgrade Joker, otherwise reset
        if (context.before) and (not context.blueprint) then
            -- Track data for most played hands
            local mphands_names = {}
            local mphands_times_played = -1

            -- Find most played hands
            for _key, hand_name in pairs(G.handlist) do
                if (G.GAME.hands[hand_name].visible) and (G.GAME.hands[hand_name].played > mphands_times_played) then
                    mphands_names = {hand_name}
                    mphands_times_played = G.GAME.hands[hand_name].played
                elseif (G.GAME.hands[hand_name].played == mphands_times_played) then
                    mphands_names[#mphands_names + 1] = hand_name
                end
            end

            -- Check if played hand is a most played hand
            local is_mphand = false
            for _key, mphand_name in pairs(mphands_names) do
                if (mphand_name == context.scoring_name) then
                    is_mphand = true
                end
            end

            -- Upgrade Joker if played hand is a most played hand, otherwise reset Joker
            if (is_mphand) then
                card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_gain
                return {
                    message = localize("k_upgrade_ex"),
                }
            else
                card.ability.extra.xmult = 1
                return {
                    message = localize("k_reset"),
                }
            end

        end

        -- When Joker is triggered, apply xMult
        if (context.joker_main) then
            return {
                xmult = card.ability.extra.xmult,
            }
        end
    end,
}
