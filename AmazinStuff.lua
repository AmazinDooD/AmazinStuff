--- STEAMODDED HEADER
--- MOD_NAME: Amazin Stuff
--- MOD_ID: AmazinStuff
--- MOD_AUTHOR: [AmazinDooD]
--- MOD_DESCRIPTION: A simple-ish mod with a bunch of my ideas. Requires THE OLD VERSION OF JenLib.
--- BADGE_COLOR: 33CC94
--- PREFIX: amazin
--- DEPENDENCIES: [JenLib]


SMODS.Atlas {
    key = "joker_atlas",
    path = "joker_atlas.png",
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = "consumable_atlas",
    path = "consumable_atlas.png",
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = "modicon",
    path = "modicon.png",
    px = 34,
    py = 34
}

-- create a card
local function amaz_create_card(card_type, key)
    if not batchfind(card_type, {"Spectral","Tarot","Planet","Joker"}) then return false end
    if batchfind(card_type, {"Spectral","Tarot","Planet"}) then
        G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
        G.E_MANAGER:add_event(Event({
            trigger = 'before',
            delay = 0.0,
            func = (function()
                local _card = create_card(card_type, G.consumeables, nil, nil, nil, nil, key)
                _card:add_to_deck()
                G.consumeables:emplace(_card)
                G.GAME.consumeable_buffer = 0
                return true
            end)
        }))
    else
        G.GAME.joker_buffer = G.GAME.joker_buffer + 1
        G.E_MANAGER:add_event(Event({
            trigger = 'before',
            delay = 0.0,
            func = (function()
                local _card = create_card("Joker", G.jokers, nil, nil, nil, nil, key)
                _card:add_to_deck()
                G.jokers:emplace(_card)
                G.GAME.joker_buffer = 0
                return true
            end)
        }))
    end
end

local function amaz_has_joker(joker)
    for k, v in ipairs(G.jokers.cards) do
        if v.ability.set == "Joker" and v.config.center_key == joker then
            return true
        end
    end
    return false
end

local function amaz_dolus_create_cards(num, card_type)
    if not batchfind(card_type, {"Spectral","Planet","Tarot","Joker"}) then return false end
    for i=1, num do
        if card_type ~= "Joker" then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                delay = 0.0,
                func = (function()
                    local card = create_card(card_type, G.consumeables)
                    card:add_to_deck()
                    card:set_edition({negative = true}, true)
                    G.consumeables:emplace(card)
                    G.GAME.consumeable_buffer = 0
                    return true
                end)
            }))
        else
            G.GAME.joker_buffer = G.GAME.joker_buffer + 1
            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                delay = 0.0,
                func = (function()
                    local card = create_card(card_type, G.joker)
                    card:add_to_deck()
                    card:set_edition({negative = true}, true)
                    G.jokers:emplace(card)
                    G.GAME.joker_buffer = 0
                    return true
                end)
            }))
        end
    end
end

-- really simple function
local function amaz_get_cardarea(card_type)
    if card_type == "Joker" then return G.jokers end
    return G.consumeables
end
-- create a card with an edition
local function amaz_create_with_edition(edition, card_type, card_key)
    if not batchfind(edition, {"Polychrome","Negative","Holographic","Foil"}) then return false end
    if not batchfind(card_type, {"Spectral","Planet","Tarot","Joker"}) then return false end
    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
    G.E_MANAGER:add_event(Event({
        trigger = 'before',
        delay = 0.0,
        func = (function()
            local card = create_card(card_type, amaz_get_cardarea(card_type), nil, nil, nil, nil, card_key)
            card:add_to_deck()
            if edition == "Negative" then
                card:set_edition({ negative = true }, true)
            elseif edition == "Polychrome" then
                card:set_edition({ polychrome = true }, true)
            elseif edition == "Holographic" then
                card:set_edition({ holographic = true }, true)
            else
                card:set_edition({ foil = true }, true)
            end
            G.consumeables:emplace(card)
            G.GAME.consumeable_buffer = 0
            return true
        end)
    }))
end

-- create n random cards
local function amaz_create_random_cards(num, card_type)
    if not batchfind(card_type, { "Spectral", "Planet", "Tarot", "Joker" }) or num < 1 then return false end
    for i = 1, num do
        if card_type ~= "Joker" then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                delay = 0.0,
                func = (function()
                    local card = create_card(card_type, G.consumeables)
                    card:add_to_deck()
                    G.consumeables:emplace(card)
                    G.GAME.consumeable_buffer = 0
                    return true
                end)
            }))
        else
            G.GAME.joker_buffer = G.GAME.joker_buffer + 1
            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                delay = 0.0,
                func = (function()
                    local card = create_card(card_type, G.joker)
                    card:add_to_deck()
                    G.jokers:emplace(card)
                    G.GAME.joker_buffer = 0
                    return true
                end)
            }))
        end
    end
end

local function amaz_format_emult(num)
    return "^"..num.." Mult"
end

local function amaz_emult_to_xmult_num(emult, cur_mult)
    if emult == 0 or emult == 1 then return emult end
    return (cur_mult^emult)/cur_mult
end

local function amaz_emult_to_xmult_table(emult, cur_mult, card, context)
    return {
        message = amaz_format_emult(emult),
        Xmult_mod = amaz_emult_to_xmult_num(emult, cur_mult),
        card = context.blueprint_card or card,
        colour = G.C.DARK_EDITION
    }
end

local silhouette = SMODS.Joker {
    key = "silhouette",
    loc_txt = {
        name = "Joker Silhouette",
        text = {"{X:mult,C:white}X#1#{} Mult, {C:attention}increases{}",
        "by {X:mult,C:white}X#2#{} when hand is played",
        " "
        ,"{C:inactive,s:0.7}Contrary to popular belief, that is not a shadow."
        ,"{C:inactive,s:0.7}It is the endless void that consumes all."}
    },
    atlas = "joker_atlas",
    config = {extra = {xmult = 1.5, mult_inc = 0.1}},
    pos = {x=0,y=0},
    discovered = false,
    rarity = 2,
    cost = 8,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.xmult, card.ability.extra.mult_inc}}
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                message = localize{type='variable',key='a_xmult',vars={card.ability.extra.xmult}},
                Xmult_mod = card.ability.extra.xmult,
                card = card
            }
        elseif context.after and not context.blueprint then
            card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.mult_inc
            return {
                message = localize{type='variable',key='a_xmult',vars={card.ability.extra.xmult}},
                card = card
            }
        end
    end
}

local consumer = SMODS.Joker {
    key = "consumer",
    loc_txt = {
        name = 'The Consumer',
        text = {
        "This joker gains {X:mult,C:white}X#1#{} Mult", 
        'when a joker is sold.', 
        "{C:inactive}Currently {X:mult,C:white}X#2#{C:inactive} Mult",
        "{C:red}#3# {C:blue}hand{} every round",
        " ",
        "{C:inactive,s:0.7}He's not evil, just misunderstood!{}"
    }
    },
    config = {extra = {xmult = 1.5, mult_inc = 0.75, hands = -1}},
    atlas = "joker_atlas",
    pos = {x=1,y=0},
    discovered = false,
    rarity = 2,
    cost = 7,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.mult_inc, card.ability.extra.xmult, card.ability.extra.hands}}
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                message = localize{type='variable',key='a_xmult',vars={card.ability.extra.xmult}},
                Xmult_mod = card.ability.extra.xmult,
                card = card
            }
        elseif context.selling_card and not context.blueprint then
            card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.mult_inc
            return {
                message = localize{type='variable',key='a_xmult',vars={card.ability.extra.xmult}},
                card = card
            }
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        ease_hands_played(-1)
    end,
    remove_from_deck = function(self, card, from_debuff)
        ease_hands_played(1)
    end
}


local blank = SMODS.Joker {
    key = "blank",
    loc_txt = {
        name = 'Blank Card',
        text = {
        "{X:mult,C:white}X#1#{} mult if played hand only",
        "contains {C:green}enhanced{} cards",
        " ",
        "{C:inactive,s:0.7}Not lazy. Just art."
        }
    },
    config = {extra = {xmult = 4}},
    atlas = "joker_atlas",
    pos = {x=2,y=0},
    discovered = false,
    rarity = 2,
    cost = 5,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.xmult}}
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local add_xmult = true
            for k, v in ipairs(context.scoring_hand) do
                if v.ability.effect == "Base" then
                    add_xmult = false
                end
            end
            if add_xmult then
                return {
                    message = localize{type='variable', key='a_xmult',vars = {card.ability.extra.xmult}},
                    Xmult_mod = card.ability.extra.xmult,
                    card = card
                }
            end
        end
    end
}

local poorly_drawn = SMODS.Joker {
    key = "poorly_drawn",
    loc_txt = {
        name = "Poorly Drawn Joker",
        text = {
            "{C:mult}+#1#{} Mult,",
            "lose {C:money}$#2#{} when scored",
            " ",
            "{C:inactive,s:0.7}Art and design?",
            "{C:inactive,s:0.7}Never heard of it."
        }
    },
    atlas = "joker_atlas",
    pos = {x=3,y=0},
    config = {extra = {mult = 50, dollars = 2}},
    rarity = 1,
    cost = 3,
    discovered = false,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.mult, card.ability.extra.dollars}}
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            ease_dollars(-card.ability.extra.dollars)
            delay(0.3)
            return {
                message = localize{type='variable',key = 'a_mult',vars = {card.ability.extra.mult}},
                mult_mod = card.ability.extra.mult,
                card = card
            }
        end
    end
}

local monochrome = SMODS.Joker {
    key = "monochrome",
    loc_txt = {
        name = "Monochrome Joker",
        text = {
        "This joker gains {C:mult}+#1# Mult{} if played hand",
        "contains a {C:attention}Stone{} Card or a {C:attention}Steel{} Card",
        "{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)",
        " ",
        "{C:inactive,s:0.7}man is grey (skill issue)"
        }
    },
    atlas = "joker_atlas",
    pos = {x=2,y=1},
    config = {extra = {mult_inc = 8, mult = 0}},
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.mult_inc, card.ability.extra.mult}}
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            local add_mult = false
            for k, v in ipairs(context.scoring_hand) do
                if v.ability.effect == "Stone Card" or v.ability.effect == "Steel Card" then
                    add_mult = true
                end
            end
            if add_mult then
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_inc
                return {
                    message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult}},
                    card = card
                }
            end
        elseif context.joker_main then
            return {
                message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult}},
                mult_mod = card.ability.extra.mult,
                card = card
            }
        end
    end
}

local hat = SMODS.Joker {
    key = "hat",
    loc_txt = {
        name = "J",
        text = {
            "{X:mult,C:white}X#1#{} Mult if last card in",
            "{C:attention}scoring hand{} is a {C:green}face{} card",
            " ",
            "{C:inactive,s:0.7}:D"
        }
    },
    atlas = "joker_atlas",
    pos = {x=3,y=1},
    config = {extra = {xmult = 2}},
    rarity = 1,
    blueprint_compat = true,
    cost = 4,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.xmult}}
    end,
    calculate = function(self, card, context)
        if context.joker_main and context.scoring_hand[#context.scoring_hand]:is_face() then
            return {
                message = localize{type='variable', key = 'a_xmult', vars = {card.ability.extra.xmult}},
                Xmult_mod = card.ability.extra.xmult,
                card = card
            }
        end
    end
}

local radiating = SMODS.Joker {
    key = "radiating",
    loc_txt = {
        name = "Radiating Joker",
        text = {
            "Earn {C:money}$#1#{} at end of round",
            "Payout {C:mult}decreases{} by {C:money}$1{} for every card played",
            "{C:inactive}(Currently $#2#)",
            " ",
            "{C:inactive,s:0.7}R.I.P 5-card hand build (emotional)"
        }
    },
    atlas = "joker_atlas",
    pos = {x=0,y=2},
    config = {extra = {dollars = 15, cur_dollars = 15}},
    rarity = 3,
    blueprint_compat = true,
    cost = 5,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.dollars, card.ability.extra.cur_dollars}}
    end,
    calculate = function(self, card, context)
        if context.before then
            card.ability.extra.cur_dollars = card.ability.extra.cur_dollars - #context.full_hand
            if card.ability.extra.cur_dollars > 0 then
                return {
                    message = "-$"..#context.full_hand,
                    card = card
                }
            else
                card.ability.extra.cur_dollars = 0
            end
        elseif context.ending_shop then
            card.ability.extra.cur_dollars = card.ability.extra.dollars
        end
    end,
    calc_dollar_bonus = function(self, card)
        return card.ability.extra.cur_dollars
    end
}

local unknown = SMODS.Consumable {
    key = "unknown",
    set = 'Spectral',
    loc_txt = {
        name = "The Unknown",
        text = {
            "{C:green}15%{} chance for {C:money}$20",
            "{C:green}35%{} chance for {C:money}$5",
            "{C:green}35%{} chance for {C:money}-$5",
            "{C:green}15%{} chance for {C:money}-$25",
            "{C:inactive}(Requires $#1# to use)"
        }
    },
    atlas = "consumable_atlas",
    config = {extra = {min_money = 10}},
    pos = {x=0,y=0},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.min_money}}
    end,
    can_use = function(self, card)
        return G.GAME.dollars >= card.ability.extra.min_money
    end,
    use = function(self, card, area, copier)
        local random_num = pseudorandom("c_unknown")
        if random_num < 0.15 then
            ease_dollars(25)
        elseif random_num < 0.5 then
            ease_dollars(5)
        elseif random_num < 0.85 then
            ease_dollars(-5)
        else
            ease_dollars(-25)
        end
    end
}

local sky = SMODS.Consumable {
    key = "sky",
    set = "Spectral",
    loc_txt = {
        name = "The Sky",
        text = {
            "Create three random {C:dark_edition}Negative",
            "{C:green}Planet{} cards"
        }
    },
    atlas = "consumable_atlas",
    pos = {x=1,y=0},
    config = {extra = {planets = 3}},
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        amaz_dolus_create_cards(card.ability.extra.planets, "Planet")
    end
}

local stranger = SMODS.Joker {
    key = "stranger",
    loc_txt = {
        name = "Stranger",
        text = {
            "Create {C:attention}The Unknown{} if",
            "all cards in played hand are {C:green}scored",
            " ",
            "{C:inactive,s:0.7}...how'd he get here?"
        }
    },
    atlas = "joker_atlas",
    pos = {x=1,y=2},
    rarity = 3,
    calculate = function(self, card, context)
        if context.before and #context.full_hand == #context.scoring_hand then
            amaz_create_card("Spectral","c_amazin_unknown")
            return {
                message = localize('k_plus_spectral'),
                colour = G.C.SECONDARY_SET.Spectral,
                card = card
            }
        end
    end
}


local marine = SMODS.Joker {
    key = "marine",
    loc_txt = {
        name = "Marine Joker",
        text = {
        'Played cards with ranks {C:attention}Ace to 7{} give',
        '{X:mult,C:white}X#1#{} mult when scored',
        'Played cards with ranks {C:attention}8 to King{} give',
        '{X:mult,C:white}X#2#{} mult when scored',
        ' ',
        '{C:inactive,s:0.7}PLEASE ADD A FUSION :cry:'}
    },
    config = {extra = {ace_to_seven_xmult = 0.5, eight_to_king_xmult = 3}},
    atlas = "joker_atlas",
    pos = {x=0,y=1},
    discovered = false,
    rarity = 2,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.ace_to_seven_xmult, card.ability.extra.eight_to_king_xmult}}
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            local card_rank = SMODS.Ranks[context.other_card.base.value].key
            if batchfind(card_rank, {"Ace","2","3","4","5","6","7"}) then
                return {
                    x_mult = card.ability.extra.ace_to_seven_xmult,
                    card = card
                }
            else
                return {
                    x_mult = card.ability.extra.eight_to_king_xmult,
                    card = card
                }
            end
        end
    end
}

local crimson = SMODS.Joker {
    key = "crimson",
    loc_txt = {
        name = "Crimson Joker",
        text = {
        'Played cards with ranks {C:attention}Ace to 7{} give',
        '{X:mult,C:white}X#1#{} mult when scored',
        'Played cards with ranks {C:attention}8 to King{} give',
        '{X:mult,C:white}X#2#{} mult when scored',
        ' ',
        '{C:inactive,s:0.7}PLEASE ADD A FUSION :cry:'}
    },
    config = {extra = {ace_to_seven_xmult = 3, eight_to_king_xmult = 0.5}},
    atlas = "joker_atlas",
    pos = {x=1,y=1},
    discovered = false,
    rarity = 2,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.ace_to_seven_xmult, card.ability.extra.eight_to_king_xmult}}
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            local card_rank = SMODS.Ranks[context.other_card.base.value].key
            if batchfind(card_rank, {"Ace","2","3","4","5","6","7"}) then
                return {
                    x_mult = card.ability.extra.ace_to_seven_xmult,
                    card = card
                }
            else
                return {
                    x_mult = card.ability.extra.eight_to_king_xmult,
                    card = card
                }
            end
        end
    end
}



-----------------
-- Legendaries --
-----------------


local potentia = SMODS.Joker {
    key = "potentia",
    loc_txt = {
        name = "Potentia",
        text = {
            "Every card gives {C:mult,s:1.3}+#1#{} Mult",
            "This joker gives {X:mult,C:white,s:1.3}X#2#{} Mult",
            "Earn {C:money,s:1.3}$#3#{} at end of round",
            "{C:green}Increases{} by {C:mult,s:1.3}+#4#{} when a {C:attention}Tarot{} card is sold,",
            "{C:green}Increases{} by {X:mult,C:white,s:1.3}X#5#{} when a {C:attention}Spectral{} card is sold",
            "{C:green}Increases{} payout by {C:money,s:1.3}$#6#{} when a {C:attention}Planet{} card is sold"
        }
    },
    rarity = 4,
    atlas = "joker_atlas",
    cost = 50,
    pos = {x=2,y=2},
    soul_pos = {x=2,y=3},
    config = {extra = {xmult = 5, mult = 500, dollars = 7, tarot_mult = 100, spectral_xmult = 15, planet_dollars = 3}},
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        return {vars = {
        card.ability.extra.mult,
        card.ability.extra.xmult,
        card.ability.extra.dollars,
        card.ability.extra.tarot_mult,
        card.ability.extra.spectral_xmult,
        card.ability.extra.planet_dollars
    }}
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                message = localize{type='variable',key='a_xmult',vars = {card.ability.extra.xmult}},
                Xmult_mod = card.ability.extra.mult,
                colour = G.C.RED,
                card = context.blueprint_card or card
            }
        elseif context.individual and context.cardarea == G.play then
            return {
                mult = card.ability.extra.mult,
                card = context.blueprint_card or card
            }
        elseif context.selling_card and not context.blueprint then
            if context.card.ability.set == "Spectral" then
                card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.spectral_xmult
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type='variable',key='a_xmult',vars={card.ability.extra.xmult}}})
            elseif context.card.ability.set == "Tarot" then
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.tarot_mult
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult}}})
            elseif context.card.ability.set == "Planet" then
                card.ability.extra.dollars = card.ability.extra.dollars + card.ability.extra.planet_dollars
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = "$"..card.ability.extra.dollars})
            end
        end
    end,
    calc_dollar_bonus = function(self, card)
        return card.ability.extra.dollars
    end
}


local dolus = SMODS.Joker {
    key = "Dolus",
    loc_txt = {
        name = "Dolus",
        text = {
            "After {C:green}hand is played{}, do one of the following {C:attention}four{} things,",
            "{C:inactive,s:0.7}(Equal chance for each)",
            "Earn {C:money,s:1.3}$#1#{}",
            "Create {C:attention,s:1.3}#2#{} random {C:dark_edition,s:1.3}Negative{} {C:green,s:1.3}Spectral{} cards",
            "{C:green}Permanently{} gain {C:red,s:1.3}+#3#{} discard every round",
            "{C:green}Increase{} this card's mult by {C:mult,s:1.3}+#4#",
            "{C:inactive}(Currently #5# mult)"
        }
    },
    atlas = "joker_atlas",
    rarity = 4,
    cost = 50,
    pos = {x=0,y=3},
    soul_pos = {x=1,y=3},
    config = {extra = {dollars = 25, spectrals = 3, discards = 1, discards_to_remove = 0, mult = 200, mult_inc = 100}},
    loc_vars = function(self, info_queue, card)
        return {vars =
            {card.ability.extra.dollars,
            card.ability.extra.spectrals,
            card.ability.extra.discards,
            card.ability.extra.mult_inc,
            card.ability.extra.mult}
    }
    end,
    calculate = function(self, card, context)
        if context.after then
            local random_num = pseudorandom("amazin_dolus")
            if random_num < 0.25 then
                ease_dollars(card.ability.extra.dollars)
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil,
                { message = "$" .. card.ability.extra.dollars })
            elseif random_num < 0.5 then
                amaz_dolus_create_cards(card.ability.extra.spectrals, "Spectral")
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil,
                    { message = "+" .. card.ability.extra.spectrals .. " Spectrals", colour = G.C.Spectrals })
            elseif random_num < 0.75 then
                card.ability.extra.discards_to_remove = card.ability.extra.discards_to_remove + 1
                ease_discard(card.ability.extra.discards)
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil,
                    { message = "+" .. card.ability.extra.discards .. " Discard", colour = G.C.RED })
            else
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_inc
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult}}})
            end
        elseif context.joker_main then
            return {
                message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult}},
                mult_mod = card.ability.extra.mult,
                card = context.blueprint_card or card
            }
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        ease_discard(-card.ability.extra.discards_to_remove)
    end,
    add_to_deck = function(self, card, from_debuff)
        if from_debuff then
            ease_discard(card.ability.extra.discards_to_remove)
        end
    end
}

local tristis = SMODS.Joker {
    key = "tristis",
    loc_txt = {
        name = "Tristis",
        text = {
            "{X:mult,C:white,s:1.3}X#1#{} Mult",
            "{C:green,s:1.3}#8# in #2#{} chance to multiply by {C:attention,s:1.3}#3#",
            "{C:green,s:1.3}#8# in #4#{} chance to multiply by {C:attention,s:1.3}#5#",
            "{C:green,s:1.3}#8# in #6#{} chance to multiply by {C:attention,s:1.3}#7#",
            "If played hand has exactly {C:attention}#9#{} cards, {C:green}double{} all listed probabilities",
            "and consume 1 {C:green}Energy{}",
            "Create {C:green,s:1.3}The Sky{} at end of shop",
            "{X:green,C:white}Energy:#10#/3",
            "{C:inactive}(Restores one energy at end of shop)"
        }
    },
    atlas = "joker_atlas",
    rarity = 4,
    cost = 50,
    pos = {x=3,y=2},
    soul_pos = {x=4,y=2},
    config = {extra = {base_mult = 50, odds_1 = 2, mult_1 = 2, odds_2 = 4, mult_2 = 5, odds_3 = 8, mult_3 = 25, cards_req = 3, energy = 3}},
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        return {vars = {
            card.ability.extra.base_mult,
            card.ability.extra.odds_1,
            card.ability.extra.mult_1,
            card.ability.extra.odds_2,
            card.ability.extra.mult_2,
            card.ability.extra.odds_3,
            card.ability.extra.mult_3,
            G.GAME.probabilities.normal,
            card.ability.extra.cards_req,
            card.ability.extra.energy
        }}
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            if chance("tristis", card.ability.extra.odds_3, false) then
                return {
                    message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.base_mult * card.ability.extra.mult_3 } },
                    Xmult_mod = card.ability.extra.base_mult * card.ability.extra.mult_3,
                    card = context.blueprint_card or card
                }
            elseif chance("tristis",card.ability.extra.odds_2,false) then
                return {
                    message = localize{type='variable',key='a_xmult',vars={card.ability.extra.base_mult * card.ability.extra.mult_2}},
                    Xmult_mod = card.ability.extra.base_mult * card.ability.extra.mult_2,
                    card = context.blueprint_card or card
                }
            elseif chance("tristis", card.ability.extra.odds_1, false) then
                return {
                    message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.base_mult * card.ability.extra.mult_1 } },
                    Xmult_mod = card.ability.extra.base_mult * card.ability.extra.mult_1,
                    card = context.blueprint_card or card
                }
            else
                return {
                    message = localize{type='variable',key='a_xmult',vars={card.ability.extra.base_mult}},
                    Xmult_mod = card.ability.extra.base_mult,
                    card = context.blueprint_card or card
                }
            end
        elseif context.ending_shop then
            amaz_create_card("Spectral","c_amazin_sky")
            if card.ability.extra.energy < 3 then
                card.ability.extra.energy = card.ability.extra.energy + 1
            end
            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "+1 Spectral", colour = G.C.SPECTRAL})
        elseif context.before then
            if #context.full_hand == 3 then
                if card.ability.extra.energy > 0 then
                    G.GAME.probabilities.normal = G.GAME.probabilities.normal * 2
                    card.ability.extra.energy = card.ability.extra.energy - 1
                    card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil,
                        { message = "Double Probabilities!", colour = G.C.RED})
                else
                    card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil,
                        { message = "No Energy!", colour = G.C.RED})
                end
            end
        end
    end
}

local decorus = SMODS.Joker {
    key = "decorus",
    loc_txt = {
        name = "Decorus",
        text = {
            "Selling a Joker gives {C:attention,s:1.3}+1 hand size{}",
            "{C:inactive}(Currently +#1# hand size)",
            "If the Joker has an {C:green}edition{}, then create a random",
            "{C:dark_edition,s:1.3}Negative{} Joker and consume one {s:1.3,C:dark_edition}Energy",
            "After {C:green}#2#{C:inactive} (Currently #3#){} enhanced cards are played,",
            "this joker gives {X:mult,C:white,s:1.3}X#4#{} Mult for one hand",
            "{X:green,C:white,s:1.3}Energy: #5# / 3",
            "{C:inactive}(Restores one Energy at end of shop)"
        }
    },
    atlas = "joker_atlas",
    pos = {x=0,y=4},
    soul_pos = {x=1,y=4},
    rarity = 4,
    cost = 50,
    config = {extra = {hand_size = 0, enhanced_cards_req = 5, enhanced_cards_played = 0, xmult = 1000, xmult_active = false, energy = 3}},
    loc_vars = function(self, info_queue, card)
        return {vars = {
            card.ability.extra.hand_size,
            card.ability.extra.enhanced_cards_req,
            card.ability.extra.enhanced_cards_played,
            card.ability.extra.xmult,
            card.ability.extra.energy
        }}
    end,
    calculate = function(self, card, context)
        if context.joker_main and card.ability.extra.xmult_active then
            card.ability.extra.xmult_active = false
            card.ability.extra.enhanced_cards_played = 0
            return {
                message = localize{type = 'variable',key = 'a_xmult',vars = {card.ability.extra.xmult}},
                Xmult_mod = card.ability.extra.xmult,
                card = context.blueprint_card or card
            }
        elseif context.selling_card then
            if context.card.ability.set == "Joker" then
                card.ability.extra.hand_size = card.ability.extra.hand_size + 1
                G.hand:change_size(1)
                if context.card.edition ~= nil and card.ability.extra.energy ~= 0 then
                    card.ability.extra.energy = card.ability.extra.energy - 1
                    amaz_dolus_create_cards(1, "Joker")
                    card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "+1 Joker", colour = G.C.dark_edition})
                else
                    card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "+1 Hand Size"})
                end
            end
        elseif context.ending_shop and not context.blueprint then
            if card.ability.extra.energy < 3 then
                card.ability.extra.energy = card.ability.extra.energy + 1
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, { message = "+1 Energy" })
            end
        elseif context.before and not context.blueprint then
            local prev_enhanced_played = card.ability.extra.enhanced_cards_played
            for k, v in ipairs(context.full_hand) do
                if v.ability.effect ~= "Base" then
                    card.ability.extra.enhanced_cards_played = card.ability.extra.enhanced_cards_played + 1
                end
            end
            if prev_enhanced_played ~= card.ability.extra.enhanced_cards_played then
                if card.ability.extra.enhanced_cards_played > 5 then card.ability.extra.enhanced_cards_played = 5 end
                if card.ability.extra.enhanced_cards_played == 5 then
                    card_eval_status_text(card, 'extra',nil,nil,nil,{message="Active!"})
                    card.ability.extra.xmult_active = true
                else
                    card_eval_status_text(card, 'extra',nil,nil,nil,{message=""..card.ability.extra.enhanced_cards_played})
                end
            end
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.hand:change_size(-card.ability.extra.hand_size)
    end
}

----------------
---this thing---
----------------


    local chroma = SMODS.Joker {
        key = "chroma",
        loc_txt = {
            name = "{s:1.5}Chroma",
            text = {
                "{X:dark_edition,C:white,s:1.7}^#1#{} Mult",
                "{C:attention}Retrigger{} all played cards {C:green,s:1.7}#2#{} times",
                "All {C:green}Aces{} give {X:mult,C:white,s:1.7}X#3#{} Mult",
                "All {C:green}Twos{} give {C:chips,s:1.7}+#4#{} Chips",
                "All {C:green}Threes{} give {C:money,s:1.7}$#5#",
                "All {C:green}Fours{} create one random {C:tarot,s:1.7}Planet",
                "All {C:green}Fives{} create one random {C:tarot,s:1.7}Tarot",
                "All {C:green}Sixes{} with enhancements create one random {C:tarot,s:1.7}Spectral",
                "All {C:green}Sevens{} give {C:attention,s:1.7}+#6# hand size{} until end of round {C:inactive}(Does not apply to retriggers)",
                "All {C:green}Eights{} are retriggered {C:attention,s:1.7}#7#{} extra times",
                "All {C:green}Nines{} give {X:dark_edition,C:white,s:1.7}^#8#{} Mult, {C:mult,s:1.2}BUT{} take {C:money}$#9#"
            }
        },
        atlas = "joker_atlas",
        pos = {x=4,y=3},
        soul_pos = {x=3,y=4,extra={x=4,y=4}},
        config = {extra = {
            emult = 2,
            retriggers = 3,
            ace_xmult = 500,
            two_chips = 1000,
            three_dollars = 10,
            seven_hand_size = 1,
            seven_cur_hand_size = 0,
            eight_retriggers = 2,
            nine_emult = 2,
            nine_dollars = 1,
        }},
        rarity = 'cry_exotic',
        cost = 250,
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            return {vars = {
                card.ability.extra.emult,
                card.ability.extra.retriggers,
                card.ability.extra.ace_xmult,
                card.ability.extra.two_chips,
                card.ability.extra.three_dollars,
                card.ability.extra.seven_hand_size,
                card.ability.extra.eight_retriggers,
                card.ability.extra.nine_emult,
                card.ability.extra.nine_dollars
            }}
        end,
        calculate = function(self, card, context)
            if context.joker_main then
                return amaz_emult_to_xmult_table(card.ability.extra.emult, mult, card, context)
            elseif context.cardarea == G.play then
                local card_rank = SMODS.Ranks[context.other_card.base.value].key
                if context.repetition then
                    if card_rank == "8" then
                        return {
                            message = localize('k_again_ex'),
                            repetitions = card.ability.extra.retriggers + card.ability.extra.eight_retriggers,
                            card = context.blueprint_card or card
                        }
                    else
                        return {
                            message = localize('k_again_ex'),
                            repetitions = card.ability.extra.retriggers,
                            card = context.blueprint_card or card
                        }
                    end
                elseif context.individual then
                    if card_rank == "Ace" then
                        return {
                            message = localize{type = 'variable', key='a_xmult',vars={card.ability.extra.ace_xmult}},
                            x_mult = card.ability.extra.ace_xmult,
                            card = context.blueprint_card or card
                        }
                    elseif card_rank == "2" then
                        return {
                            message = localize { type = 'variable', key = 'a_chips', vars = { card.ability.extra.two_chips } },
                            x_mult = card.ability.extra.two_chips,
                            card = context.blueprint_card or card
                        }
                    elseif card_rank == "3" then
                        ease_dollars(card.ability.extra.three_dollars)
                        card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil,
                            { message = "$" .. card.ability.extra.three_dollars })
                    elseif card_rank == "4" then
                        amaz_create_random_cards(1, "Planet")
                        card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, { message = "+1 Planet"})
                    elseif card_rank == "5" then
                        amaz_create_random_cards(1, "Tarot")
                        card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil,
                        { message = "+1 Tarot" })
                    elseif card_rank == "6" and context.other_card.ability.effect ~= "Base" then
                        amaz_create_random_cards(1, "Spectral")
                        card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil,
                        { message = "+1 Spectral" })
                    elseif card_rank == "7" and not context.repetition then
                        G.hand:change_size(card.ability.extra.seven_hand_size)
                        card.ability.extra.seven_cur_hand_size = card.ability.extra.seven_cur_hand_size + card.ability.extra.seven_hand_size
                        card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil,
                        { message = "+1 Hand Size" })
                    elseif card_rank == "9" then
                        ease_dollars(-card.ability.extra.nine_dollars)
                        return amaz_emult_to_xmult_table(card.ability.extra.nine_emult, mult, card, context)
                    end
                elseif context.ending_shop then
                    G.hand:change_size(-card.ability.extra.seven_cur_hand_size)
                    card.ability.extra.seven_cur_hand_size = 0
                    card_eval_status_text(card, 'extra', nil, nil, nil, { message = "Hand Size Reset", colour = G.C.RED})
                end
            end
        end
    }