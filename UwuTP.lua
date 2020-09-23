local ui = require('core.ui')
local player = require('player')
local packet = require('packet')
local party = require('party')
local enumerable = require('enumerable')
local target = require('target')
local math = require('math')
local exclusions = require('exclusions')
local table = require('table')
local entities = require('entities')
local client_data = require('client_data')
local resources = require('resources')
local helpers = require('helpers')
--Contains window settings and associated strings

local tUwuStates = 
{
    --your target
    ["Target"] = 
    {
        ["Window"] = {
            title = "Target",
            style = "chromeless",
            x = 850,
            y = 219,
            width = 300,
            height = 300,
            color = ui.color.transparent,
            movable = true,
            closable = true,      
        },
        ["Strings"] = 
        {
            ["HP"] = " ",
            ["Distance"] = " ",
            ["Enmity"] = "<Enmity> ",
            ["Using"] = " ",
        }

    },
    --you
    ["P1"] = 
    {
        ["Window"] = {
            title = "P1",
            style = "chromeless",
            x = 1259,
            y = 383,
            width = 300,
            height = 300,
            color = ui.color.transparent,
            movable = true,
            closable = true,      
        },
        ["Strings"] = 
        {
            ["HP"] = player.name .. "\n[HP%] " .. player.hp_percent,
            ["MP"] = "[MP%] " .. player.mp_percent,
            ["TP"] = "[TP] " .. player.tp,
            ["Distance"] = " ",
            ["Using"] = " ",
        }

    },
    --first party member
    ["P2"] = 
    {
        ["Window"] = {
            title = "P2",
            style = "chromeless",
            x = 1389,
            y = 383,
            width = 300,
            height = 300,
            color = ui.color.transparent,
            movable = true,
            closable = true,      
        },
        ["Strings"] = 
        {
            ["HP"] = " ",
            ["MP"] = " ",
            ["TP"] = " ",
            ["Distance"] = " ",
            ["Using"] = " ",
        }

    },
    --second party member
    ["P3"] = 
    {
        ["Window"] = {
            title = "P3",
            style = "chromeless",
            x = 1529,
            y = 383,
            width = 300,
            height = 300,
            color = ui.color.transparent,
            movable = true,
            closable = true,      
        },
        ["Strings"] = 
        {
            ["HP"] = " ",
            ["MP"] = " ",
            ["TP"] = " ",
            ["Distance"] = " ",
            ["Using"] = " ",
        }

    },
        --third party member
    ["P4"] = 
    {
        ["Window"] = {
            title = "P4",
            style = "chromeless",
            x = 1259,
            y = 533,
            width = 300,
            height = 300,
            color = ui.color.transparent,
            movable = true,
            closable = true,      
        },
        ["Strings"] = 
        {
            ["HP"] = " ",
            ["MP"] = " ",
            ["TP"] = " ",
            ["Distance"] = " ",
            ["Using"] = " ",
        }

    },
        --fourth party member
    ["P5"] = 
    {
        ["Window"] = {
            title = "P5",
            style = "chromeless",
            x = 1389,
            y = 533,
            width = 300,
            height = 300,
            color = ui.color.transparent,
            movable = true, 
            closable = true,      
        },
        ["Strings"] = 
        {
            ["HP"] = " ",
            ["MP"] = " ",
            ["TP"] = " ",
            ["Distance"] = " ",
            ["Using"] = " ",
        }
    
    },
        --fifth party member
    ["P6"] = 
    {
        ["Window"] = {
            title = "P6",
            style = "chromeless",
            x = 1539,
            y = 533,
            width = 300,
            height = 300,
            color = ui.color.transparent,
            movable = true,
            closable = true,      
        },
        ["Strings"] = 
        {
            ["HP"] = " ",
            ["MP"] = " ",
            ["TP"] = " ",
            ["Distance"] = " ",
            ["Using"] = " ",
        }

    },
        --moves used by enemy
        ["Movelist"] = 
        {
            ["Window"] = {
                title = "Movelist",
                style = "chromeless",
                x = 1050,
                y = 219,
                width = 300,
                height = 300,
                color = ui.color.transparent,
                movable = true,
                closable = true,      
            },
            ["Strings"] =
            {
                ["List"] = " ",
            }
        }

}

tMovelist = {

}

--registered handler for clearing using messages on mob death(0x02D)

function ClearMessages(packet_obj, packet_info)

    for k,_ in pairs(tUwuStates) do 

        tUwuStates[k]["Strings"]["Using"] = " "

        if k == "Target" then

            tUwuStates[k]["Strings"]["Enmity"] = "<Enmity> "
            tUwuStates[k]["Strings"]["Using"] = " "

        end

    end

end

--registered handler for 0x028 packets

function ActionHandler(packet_obj, packet_info)

    local actor = packet_obj['actor']
    local category = packet_obj['category']
    local param = packet_obj['param']
    local target1_param = packet_obj['targets'][1]['actions'][1]['param']
    local enemy_target = entities:by_id(packet_obj['targets'][1]['id'])
    local targeted = target.t or target.st
     
    --build our strings depending on actor field and populate our table

    if actor == player.id then
               
        tUwuStates["P1"]["Strings"]["Using"] = helpers.ActionString(param, target1_param, category)

    end
    
    if party[2] ~= nil then
    
        if actor == party[2].id then

            tUwuStates["P2"]["Strings"]["Using"] = helpers.ActionString(param, target1_param, category)

        end

    end

    if party[3] ~= nil then

        if actor == party[3].id then

            tUwuStates["P3"]["Strings"]["Using"] = helpers.ActionString(param, target1_param, category)

        end

    end

    if party[4] ~= nil then 

        if actor == party[4].id then

            tUwuStates["P4"]["Strings"]["Using"] = helpers.ActionString(param, target1_param, category)

        end

    end

    if party[5] ~= nil then 

        if actor == party[5].id then 

            tUwuStates["P5"]["Strings"]["Using"] = helpers.ActionString(param, target1_param, category)

        end

    end

    if party[6] ~= nil then 

        if actor == party[6].id then

            tUwuStates["P6"]["Strings"]["Using"] = helpers.ActionString(param, target1_param, category)

        end

    end

    if targeted ~= nil then

        if actor == targeted.id then

            tUwuStates["Target"]["Strings"]["Using"] = helpers.ActionString(param, target1_param, category)
            
            --enmity check, it's not consistent but it's better than nothing
            
            if not enemy_target then

                tUwuStates["Target"]["Strings"]["Enmity"] = "<Enmity> "

            else

                tUwuStates["Target"]["Strings"]["Enmity"] = "<Enmity> " .. enemy_target.name

            end

            --solution to adding magic cast and abilities used by target to movelist without 
            --having to send actor to ActionString and check it against target again

            if category == 8 then

                tUwuStates["Target"]["Strings"]["Using"] = helpers.ActionString(param, target1_param, category)
                table.insert(tMovelist, client_data.spells[target1_param].name)

            elseif category == 11 and enumerable.contains(exclusions, param) == false then
                
                tUwuStates["Target"]["Strings"]["Using"] = helpers.ActionString(param, target1_param, category)
                table.insert(tMovelist, resources.monster_abilities[param].name)

            end

        end

    end 
    
end

--render everything

ui.display(function()

    local text_opt = {color = ui.color.rgb(119, 247, 237)}
    local move_opt = {color = ui.color.grey}
    local format = '"Segoe UI" 13px bold stroke:"2px black"'
    local targeted = target.t or target.st

    --targeted window & movelist window

    if targeted then
       
        local t_format = '"Segoe UI" 16px bold stroke:"2px black"' 
        
        ui.window('move_list', tUwuStates["Movelist"]["Window"], function()
            
            local movestr = " "

            if #tMovelist > 0 and #tMovelist < 15 then
              
                ui.location(20, 0)  
                move_opt = text_opt
                movestr = helpers.FormatStr("<Used>\n" .. table.concat(tMovelist,'\n'), t_format)
            
            elseif #tMovelist > 15 then

                tMovelist = {}

            else
            
                ui.location(20, 0)
                move_opt = {color = ui.color.grey}
                movestr = helpers.FormatStr("<No Moves Used>", t_format)

            end

            ui.text(movestr, move_opt)


        end)

        ui.window('target_window', tUwuStates["Target"]["Window"], function()  

            tUwuStates["Target"]["Strings"]["HP"] = targeted.name .. "\n[HP%] " .. targeted.hp_percent
            tUwuStates["Target"]["Strings"]["Distance"] = "[D] " .. helpers.Round(math.sqrt(targeted.distance), 3)

            local t_values = {
                ["HP"] = {},
                ["Distance"] = {},
                ["Enmity"] = {},
                ["Using"] = {}
            }

            t_values = helpers.FormatStringTable(tUwuStates["Target"]["Strings"], t_values, t_format)

            local target_hp = {color = ui.color.accent}
            local dist_color = helpers.GetDistanceColor(math.sqrt(targeted.distance))
            
            ui.location(0, 0)
            ui.text(t_values["HP"], text_opt)
            ui.location(120, 22)
            ui.text(t_values["Distance"], dist_color)
            ui.location(0, 45)
            ui.size(80, 10)
            ui.progress(targeted.hp_percent/100, target_hp)
            ui.location(0, 55)
            ui.text(t_values["Enmity"], text_opt)
            ui.location(0, 80)
            ui.text(t_values["Using"], text_opt)            
       
        end)
    
    elseif targeted == nil then

        tMovelist = {}


    end
    
    --first party member window

    ui.window('p1_window', tUwuStates["P1"]["Window"], function()

        if player then
            
            --update main table
            tUwuStates["P1"]["Strings"]["HP"] = party[1].name .. "\n[HP%] " .. party[1].hp_percent
            tUwuStates["P1"]["Strings"]["MP"] = "[MP%] " .. party[1].mp_percent
            tUwuStates["P1"]["Strings"]["TP"] = "[TP] " .. party[1].tp
            --setup local string table
            local p1_values = {
                ["HP"] = {},
                ["MP"] = {},
                ["TP"] = {},
                ["Distance"] = {},
                ["Using"] = {},
            }
            --apply formatting and values
            p1_values = helpers.FormatStringTable(tUwuStates["P1"]["Strings"], p1_values, format)
            --apply colors//todo: add hp/mp% based changing colors
            local p1_tp = helpers.GetTPColor(party[1].tp)
            local p1_hp = {color = ui.color.accent}
            local p1_mp = {color = ui.color.blue}
            --render
            ui.location(0, 0)
            ui.text(p1_values["HP"], text_opt)
            ui.size(80, 10)
            ui.progress(player.hp_percent/100, p1_hp)
            ui.location(0, 50)
            ui.text(p1_values["MP"], text_opt)
            ui.size(80, 10)
            ui.progress(player.mp_percent/100, p1_mp)
            ui.location(0, 80)
            ui.text(p1_values["TP"], text_opt)
            ui.size(80, 10) 
            ui.progress(player.tp/3000, p1_tp)
            ui.location(0, 110)
            ui.text(p1_values["Using"], text_opt)

        end

    end)

    --second party member window
    
    if party[2] ~= nil then

        ui.window('p2_window', tUwuStates["P2"]["Window"], function()
            
            local distance = 0
            
            if party[2].id ~= nil then

                distance = helpers.Round(math.sqrt(entities:by_id(party[2].id).distance), 1)

            end

            tUwuStates["P2"]["Strings"]["HP"] = party[2].name .. "\n[HP%] " .. party[2].hp_percent
            tUwuStates["P2"]["Strings"]["MP"] = "[MP%] " .. party[2].mp_percent
            tUwuStates["P2"]["Strings"]["TP"] = "[TP] " .. party[2].tp
            tUwuStates["P2"]["Strings"]["Distance"] = "[D] " .. distance

            local p2_values = {
                ["HP"] = {},
                ["MP"] = {},
                ["TP"] = {},
                ["Distance"] = {},
                ["Using"] = {},
            }

            p2_values = helpers.FormatStringTable(tUwuStates["P2"]["Strings"], p2_values, format)

            local p2_tp = helpers.GetTPColor(party[2].tp)
            local p2_hp = {color = ui.color.accent}
            local p2_mp = {color = ui.color.blue}
            local p2_dist = helpers.GetDistanceColor(distance)

            ui.location(0, 0)
            ui.text(p2_values["HP"], text_opt)
            ui.size(80, 10)
            ui.progress(party[2].hp_percent/100, p2_hp)
            ui.location(0, 50)
            ui.text(p2_values["MP"], text_opt)
            ui.size(80, 10)
            ui.progress(party[2].mp_percent/100, p2_mp)
            ui.location(0, 80)
            ui.text(p2_values["TP"], text_opt)
            ui.size(80, 10) 
            ui.progress(party[2].tp/3000, p2_tp)
            ui.location(0, 110)
            ui.text(p2_values["Using"], text_opt)
            ui.location(70, 50)
            ui.text(p2_values["Distance"], p2_dist)
       
        end)

    end

    --third party member window

    if party[3] ~= nil then

        ui.window('p3_window', tUwuStates["P3"]["Window"], function()
            
            local distance = 0
            
            if party[3].id ~= nil then

                distance = helpers.Round(math.sqrt(entities:by_id(party[3].id).distance), 1)

            end

            tUwuStates["P3"]["Strings"]["HP"] = party[3].name .. "\n[HP%] " .. party[3].hp_percent
            tUwuStates["P3"]["Strings"]["MP"] = "[MP%] " .. party[3].mp_percent
            tUwuStates["P3"]["Strings"]["TP"] = "[TP] " .. party[3].tp
            tUwuStates["P3"]["Strings"]["Distance"] = "[D] " .. distance

            local p3_values = {
                ["HP"] = {},
                ["MP"] = {},
                ["TP"] = {},
                ["Distance"] = {},
                ["Using"] = {},
            }

            p3_values = helpers.FormatStringTable(tUwuStates["P3"]["Strings"], p3_values, format)

            local p3_tp = helpers.GetTPColor(party[3].tp)
            local p3_hp = {color = ui.color.accent}
            local p3_mp = {color = ui.color.blue}
            local p3_dist = helpers.GetDistanceColor(distance)

            ui.location(0, 0)
            ui.text(p3_values["HP"], text_opt)
            ui.size(80, 10)
            ui.progress(party[3].hp_percent/100, p3_hp)
            ui.location(0, 50)
            ui.text(p3_values["MP"], text_opt)
            ui.size(80, 10)
            ui.progress(party[3].mp_percent/100, p3_mp)
            ui.location(0, 80)
            ui.text(p3_values["TP"], text_opt)
            ui.size(80, 10) 
            ui.progress(party[3].tp/3000, p3_tp)
            ui.location(0, 110)
            ui.text(p3_values["Using"], text_opt)  
            ui.location(70, 50)
            ui.text(p3_values["Distance"], p3_dist)
    
        end)

    end

    --fourth party member window

    if party[4] ~= nil then

        ui.window('p4_window', tUwuStates["P4"]["Window"], function()
             
            local distance = 0
            
            if party[4].id ~= nil then

                distance = helpers.Round(math.sqrt(entities:by_id(party[4].id).distance), 1)

            end

            tUwuStates["P4"]["Strings"]["HP"] = party[4].name .. "\n[HP%] " .. party[4].hp_percent
            tUwuStates["P4"]["Strings"]["MP"] = "[MP%] " .. party[4].mp_percent
            tUwuStates["P4"]["Strings"]["TP"] = "[TP] " .. party[4].tp
            tUwuStates["P4"]["Strings"]["Distance"] = "[D] " .. distance

            local p4_values = {
                ["HP"] = {},
                ["MP"] = {},
                ["TP"] = {},
                ["Distance"] = {},
                ["Using"] = {},
            }

            p4_values = helpers.FormatStringTable(tUwuStates["P4"]["Strings"], p4_values, format)

            local p4_tp = helpers.GetTPColor(party[4].tp)
            local p4_hp = {color = ui.color.accent}
            local p4_mp = {color = ui.color.blue}
            local p4_dist = helpers.GetDistanceColor(distance)

            ui.location(0, 0)
            ui.text(p4_values["HP"], text_opt)
            ui.size(80, 10)
            ui.progress(party[4].hp_percent/100, p4_hp)
            ui.location(0, 50)
            ui.text(p4_values["MP"], text_opt)
            ui.size(80, 10)
            ui.progress(party[4].mp_percent/100, p4_mp)
            ui.location(0, 80)
            ui.text(p4_values["TP"], text_opt)
            ui.size(80, 10) 
            ui.progress(party[4].tp/3000, p4_tp)
            ui.location(0, 110)
            ui.text(p4_values["Using"], text_opt)
            ui.location(70, 50)
            ui.text(p4_values["Distance"], p4_dist)
      
        end)

    end    

    --fifth party member window

    if party[5] ~= nil then

        ui.window('p5_window', tUwuStates["P5"]["Window"], function()

            local distance = 0
            
            if party[5].id ~= nil then

                distance = helpers.Round(math.sqrt(entities:by_id(party[5].id).distance), 1)

            end

            tUwuStates["P5"]["Strings"]["HP"] = party[5].name .. "\n[HP%] " .. party[5].hp_percent
            tUwuStates["P5"]["Strings"]["MP"] = "[MP%] " .. party[5].mp_percent
            tUwuStates["P5"]["Strings"]["TP"] = "[TP] " .. party[5].tp
            tUwuStates["P5"]["Strings"]["Distance"] = "[D] " .. distance
            
            local p5_values = {
                ["HP"] = {},
                ["MP"] = {},
                ["TP"] = {},
                ["Distance"] = {},
                ["Using"] = {},
            }

            p5_values = helpers.FormatStringTable(tUwuStates["P5"]["Strings"], p5_values, format)

            local p5_tp = helpers.GetTPColor(party[5].tp)
            local p5_hp = {color = ui.color.accent}
            local p5_mp = {color = ui.color.blue}
            local p5_dist = helpers.GetDistanceColor(distance)

            ui.location(0, 0)
            ui.text(p5_values["HP"], text_opt)
            ui.size(80, 10)
            ui.progress(party[5].hp_percent/100, p5_hp)
            ui.location(0, 50)
            ui.text(p5_values["MP"], text_opt)
            ui.size(80, 10)
            ui.progress(party[5].mp_percent/100, p5_mp)
            ui.location(0, 80)
            ui.text(p5_values["TP"], text_opt)
            ui.size(80, 10) 
            ui.progress(party[5].tp/3000, p5_tp)
            ui.location(0, 110)
            ui.text(p5_values["Using"], text_opt) 
            ui.location(70, 50)
            ui.text(p5_values["Distance"], p5_dist)  
    
        end)

    end  

    --sixth party member window

    if party[6] ~= nil then

        ui.window('p6_window', tUwuStates["P6"]["Window"], function()
            
            local distance = 0
            
            if party[6].id ~= nil then

                distance = helpers.Round(math.sqrt(entities:by_id(party[6].id).distance), 1)

            end

            tUwuStates["P6"]["Strings"]["HP"] = party[6].name .. "\n[HP%] " .. party[6].hp_percent
            tUwuStates["P6"]["Strings"]["MP"] = "[MP%] " .. party[6].mp_percent
            tUwuStates["P6"]["Strings"]["TP"] = "[TP] " .. party[6].tp
            tUwuStates["P6"]["Strings"]["Distance"] = "[D] " .. distance
            
            local p6_values = {
                ["HP"] = {},
                ["MP"] = {},
                ["TP"] = {},
                ["Distance"] = {},
                ["Using"] = {},
            }

            p6_values = helpers.FormatStringTable(tUwuStates["P6"]["Strings"], p6_values, format)

            local p6_tp = helpers.GetTPColor(party[6].tp)
            local p6_hp = {color = ui.color.accent}
            local p6_mp = {color = ui.color.blue}
            local p6_dist = helpers.GetDistanceColor(distance)

            ui.location(0, 0)
            ui.text(p6_values["HP"], text_opt)
            ui.size(80, 10)
            ui.progress(party[6].hp_percent/100, p6_hp)
            ui.location(0, 50)
            ui.text(p6_values["MP"], text_opt)
            ui.size(80, 10)
            ui.progress(party[6].mp_percent/100, p6_mp)
            ui.location(0, 80)
            ui.text(p6_values["TP"], text_opt)
            ui.size(80, 10) 
            ui.progress(party[6].tp/3000, p6_tp)
            ui.location(0, 110)
            ui.text(p6_values["Using"], text_opt)
            ui.location(70, 50)
            ui.text(p6_values["Distance"], p6_dist)

        end)

    end  

end)

--register functions to packets

packet.incoming[0x028]:register(ActionHandler)
packet.incoming[0x02D]:register(ClearMessages)


