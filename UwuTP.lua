local ui = require('core.ui')
local player = require('player')
local packet = require('packet')
local party = require('party')
local resources = require('resources')
local enumerable = require('enumerable')
local coroutine = require('coroutine')
local target = require('target')
local math = require('math')
local exclusions = require('exclusions')
local table = require('table')

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
            x = 1509,
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
            x = 1509,
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


function Round(num, numDecimalPlaces)

    local mult = 10^(numDecimalPlaces or 0)
    
    return math.floor(num * mult + 0.5) / mult
  
end


--Build strings based on 0x028 fields
function ActionString(param, t_param, category)
    
    local res = resources
    local str = " "

    if param and t_param and category then

        --magic

        if category == 8 then 

            str = "[MA] " .. res.spells[t_param].name
            return str

        --player ws

        elseif category == 7 and param <= 255  then
            
            str = "[WS] " .. res.weapon_skills[t_param].name
            return str

        --trust ws

        elseif category == 7 and t_param > 255 and enumerable.contains(exclusions, t_param) == false then

            str = "[WS] " .. res.monster_abilities[t_param].name
            return str

        --finish categories        

        elseif category == 4 or category == 3 then

            str = " "
            return str
        
        --don't return nameless weaponskills(AoE Melee attacks are the most prominent)    

        elseif category == 7 or category == 8 or category == 11 and enumerable.contains(exclusions, param) == true then

            str = " "
            return str
            
        elseif category == 11 and enumerable.contains(exclusions, param) == false then

            str = "[Finishing] " .. res.monster_abilities[param].name
            return str

        else return str

        end

    end

end
 
--our registered handler for 0x028 packets
function ActionHandler(packet_obj, packet_info)

    local actor = packet_obj['actor']
    local category = packet_obj['category']
    local param = packet_obj['param']
    local target1_param = packet_obj['targets'][1]['actions'][1]['param']
    local targeted = target.t or target.st
     
    --build our strings depending on actor field and populate our table

    if actor == player.id then
               
        tUwuStates["P1"]["Strings"]["Using"] = ActionString(param, target1_param, category)
    
    end
    
    if party[2] ~= nil then
    
        if actor == party[2].id then

            tUwuStates["P2"]["Strings"]["Using"] = ActionString(param, target1_param, category)

        end

    end

    if party[3] ~= nil then

        if actor == party[3].id then

            tUwuStates["P3"]["Strings"]["Using"] = ActionString(param, target1_param, category)

        end

    end

    if party[4] ~= nil then 

        if actor == party[4].id then

            tUwuStates["P4"]["Strings"]["Using"] = ActionString(param, target1_param, category)

        end

    end

    if party[5] ~= nil then 

        if actor == party[5].id then 

            tUwuStates["P5"]["Strings"]["Using"] = ActionString(param, target1_param, category)

        end

    end

    if party[6] ~= nil then 

        if actor == party[6].id then

            tUwuStates["P6"]["Strings"]["Using"] = ActionString(param, target1_param, category)

        end

    end

    if targeted ~= nil then

        if actor == targeted.id then

            tUwuStates["Target"]["Strings"]["Using"] = ActionString(param, target1_param, category)

            --solution to adding magic cast and abilities used by target to movelist without 
            --having to send actor to ActionString and check it against target again

            if category == 8 then

                tUwuStates["Target"]["Strings"]["Using"] = ActionString(param, target1_param, category)
                table.insert(tMovelist, resources.spells[target1_param].name)

            elseif category == 11 and enumerable.contains(exclusions, param) == false then
                
                tUwuStates["Target"]["Strings"]["Using"] = ActionString(param, target1_param, category)
                table.insert(tMovelist, resources.monster_abilities[param].name)

            end

        end

    end 
    
end

--ez string formatting 

function FormatStr(string, formatting)

    if string and formatting then

        local str = "[" .. string .. "]" .. "{" .. formatting .. "}"
        return str

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
              movestr = FormatStr("<Used>\n" .. table.concat(tMovelist,'\n'), t_format)
            
            elseif #tMovelist > 15 then

                tMovelist = {}

            else
                ui.location(20, 0)
                move_opt = {color = ui.color.grey}
                movestr = FormatStr("<No Moves Used>", t_format)

            end

            ui.text(movestr, move_opt)


        end)

        ui.window('target_window', tUwuStates["Target"]["Window"], function()  

            tUwuStates["Target"]["Strings"]["HP"] = targeted.name .. "\n[HP%] " .. targeted.hp_percent
            tUwuStates["Target"]["Strings"]["Distance"] = "[D] " .. Round(math.sqrt(targeted.distance), 3)
            local hpp = FormatStr(tUwuStates["Target"]["Strings"]["HP"], t_format)
            local using = FormatStr(tUwuStates["Target"]["Strings"]["Using"], t_format)
            local distance = FormatStr(tUwuStates["Target"]["Strings"]["Distance"], t_format)
            --colors
            local target_hp = {color = ui.color.accent}
        
            ui.location(0, 0)
            ui.text(hpp, text_opt)
            ui.location(120, 22)
            ui.text(distance, text_opt)
            ui.location(0, 45)
            ui.size(80, 10)
            ui.progress(targeted.hp_percent/100, target_hp)
            ui.location(0, 60)
            ui.text(using, text_opt)            
       
        end)
    
    elseif targeted == nil then

        tMovelist = {}


    end
    
    --first party member window

    ui.window('p1_window', tUwuStates["P1"]["Window"], function()

        if player then
            

            tUwuStates["P1"]["Strings"]["HP"] = party[1].name .. "\n[HP%] " .. party[1].hp_percent
            tUwuStates["P1"]["Strings"]["MP"] = "[MP%] " .. party[1].mp_percent
            tUwuStates["P1"]["Strings"]["TP"] = "[TP] " .. party[1].tp

            local hpp = FormatStr(tUwuStates["P1"]["Strings"]["HP"], format)
            local mpp = FormatStr(tUwuStates["P1"]["Strings"]["MP"], format)
            local tp = FormatStr(tUwuStates["P1"]["Strings"]["TP"], format)
            local using = FormatStr(tUwuStates["P1"]["Strings"]["Using"], format)
            --colors
            local p1_tp = {color = ui.color.green}
            local p1_hp = {color = ui.color.accent}
            local p1_mp = {color = ui.color.blue}
            
            if player.tp == 3000 then

                p1_tp = {color = ui.color.gold}

            elseif player.tp < 3000 and player.tp > 1000 then

                p1_tp = {color = ui.color.purple}

            elseif player.tp < 1000 then

                p1_tp = {color = ui.color.green}

            end

            ui.location(0, 0)
            ui.text(hpp, text_opt)
            ui.size(80, 10)
            ui.progress(player.hp_percent/100, p1_hp)
            ui.location(0, 50)
            ui.text(mpp, text_opt)
            ui.size(80, 10)
            ui.progress(player.mp_percent/100, p1_mp)
            ui.location(0, 80)
            ui.text(tp, text_opt)
            ui.size(80, 10) 
            ui.progress(player.tp/3000, p1_tp)
            ui.location(0, 110)
            ui.text(using, text_opt)

        end

    end)

    --second party member window
    
    if party[2] ~= nil then

        ui.window('p2_window', tUwuStates["P2"]["Window"], function()

            tUwuStates["P2"]["Strings"]["HP"] = party[2].name .. "\n[HP%] " .. party[2].hp_percent
            tUwuStates["P2"]["Strings"]["MP"] = "[MP%] " .. party[2].mp_percent
            tUwuStates["P2"]["Strings"]["TP"] = "[TP] " .. party[2].tp
            --strings
            local hpp = FormatStr(tUwuStates["P2"]["Strings"]["HP"], format)
            local mpp = FormatStr(tUwuStates["P2"]["Strings"]["MP"], format)
            local tp = FormatStr(tUwuStates["P2"]["Strings"]["TP"], format)
            local using = FormatStr(tUwuStates["P2"]["Strings"]["Using"], format)
            --colors
            local p2_tp = {color = ui.color.green}
            local p2_hp = {color = ui.color.accent}
            local p2_mp = {color = ui.color.blue}

            if party[2].tp == 3000 then

                p2_tp = {color = ui.color.gold}

            elseif party[2].tp < 3000 and party[2].tp > 1000 then

                p2_tp = {color = ui.color.purple}

            elseif party[2].tp < 1000 then

                p2_tp = {color = ui.color.green}

            end

            ui.location(0, 0)
            ui.text(hpp, text_opt)
            ui.size(80, 10)
            ui.progress(party[2].hp_percent/100, p2_hp)
            ui.location(0, 50)
            ui.text(mpp, text_opt)
            ui.size(80, 10)
            ui.progress(party[2].mp_percent/100, p2_mp)
            ui.location(0, 80)
            ui.text(tp, text_opt)
            ui.size(80, 10) 
            ui.progress(party[2].tp/3000, p2_tp)
            ui.location(0, 110)
            ui.text(using, text_opt)
       
        end)

    end

    --third party member window

    if party[3] ~= nil then

        ui.window('p3_window', tUwuStates["P3"]["Window"], function()
                
            tUwuStates["P3"]["Strings"]["HP"] = party[3].name .. "\n[HP%] " .. party[3].hp_percent
            tUwuStates["P3"]["Strings"]["MP"] = "[MP%] " .. party[3].mp_percent
            tUwuStates["P3"]["Strings"]["TP"] = "[TP] " .. party[3].tp

            local hpp = FormatStr(tUwuStates["P3"]["Strings"]["HP"], format)
            local mpp = FormatStr(tUwuStates["P3"]["Strings"]["MP"], format)
            local tp = FormatStr(tUwuStates["P3"]["Strings"]["TP"], format)
            local using = FormatStr(tUwuStates["P3"]["Strings"]["Using"], format)
            --clors
            local p3_tp = {color = ui.color.green}
            local p3_hp = {color = ui.color.accent}
            local p3_mp = {color = ui.color.blue}

            if party[3].tp == 3000 then

                p3_tp = {color = ui.color.gold}

            elseif party[3].tp < 3000 and party[3].tp > 1000 then

                p3_tp = {color = ui.color.purple}
            
            elseif party[3].tp < 1000 then

                p3_tp = {color = ui.color.green}

            end


            ui.location(0, 0)
            ui.text(hpp, text_opt)
            ui.size(80, 10)
            ui.progress(party[3].hp_percent/100, p3_hp)
            ui.location(0, 50)
            ui.text(mpp, text_opt)
            ui.size(80, 10)
            ui.progress(party[3].mp_percent/100, p3_mp)
            ui.location(0, 80)
            ui.text(tp, text_opt)
            ui.size(80, 10) 
            ui.progress(party[3].tp/3000, p3_tp)
            ui.location(0, 110)
            ui.text(using, text_opt)  
    
        end)

    end

    --fourth party member window

    if party[4] ~= nil then

        ui.window('p4_window', tUwuStates["P4"]["Window"], function()
             
            tUwuStates["P4"]["Strings"]["HP"] = party[4].name .. "\n[HP%] " .. party[4].hp_percent
            tUwuStates["P4"]["Strings"]["MP"] = "[MP%] " .. party[4].mp_percent
            tUwuStates["P4"]["Strings"]["TP"] = "[TP] " .. party[4].tp
            local hpp = FormatStr(tUwuStates["P4"]["Strings"]["HP"], format)
            local mpp = FormatStr(tUwuStates["P4"]["Strings"]["MP"], format)
            local tp = FormatStr(tUwuStates["P4"]["Strings"]["TP"], format)
            local using = FormatStr(tUwuStates["P4"]["Strings"]["Using"], format)
            --colors
            local p4_tp = {color = ui.color.green}
            local p4_hp = {color = ui.color.accent}
            local p4_mp = {color = ui.color.blue}

            if party[4].tp == 3000 then

                p4_tp = {color = ui.color.gold}

            elseif party[4].tp < 3000 and party[4].tp > 1000 then

                p4_tp = {color = ui.color.purple}
            
            elseif party[3].tp < 1000 then

                p4_tp = {color = ui.color.green}

            end

            ui.location(0, 0)
            ui.text(hpp, text_opt)
            ui.size(80, 10)
            ui.progress(party[4].hp_percent/100, p4_hp)
            ui.location(0, 50)
            ui.text(mpp, text_opt)
            ui.size(80, 10)
            ui.progress(party[4].mp_percent/100, p4_mp)
            ui.location(0, 80)
            ui.text(tp, text_opt)
            ui.size(80, 10) 
            ui.progress(party[4].tp/3000, p4_tp)
            ui.location(0, 110)
            ui.text(using, text_opt)
      
        end)

    end    

    --fifth party member window

    if party[5] ~= nil then

        ui.window('p5_window', tUwuStates["P5"]["Window"], function()

            tUwuStates["P5"]["Strings"]["HP"] = party[5].name .. "\n[HP%] " .. party[5].hp_percent
            tUwuStates["P5"]["Strings"]["MP"] = "[MP%] " .. party[5].mp_percent
            tUwuStates["P5"]["Strings"]["TP"] = "[TP] " .. party[5].tp

            local hpp = FormatStr(tUwuStates["P5"]["Strings"]["HP"], format)
            local mpp = FormatStr(tUwuStates["P5"]["Strings"]["MP"], format)
            local tp = FormatStr(tUwuStates["P5"]["Strings"]["TP"], format)
            local using = FormatStr(tUwuStates["P5"]["Strings"]["Using"], format)
            --colors
            local p5_tp = {color = ui.color.green}
            local p5_hp = {color = ui.color.accent}
            local p5_mp = {color = ui.color.blue}

            if party[5].tp == 3000 then

                p5_tp = {color = ui.color.gold}

            elseif party[5].tp < 3000 and party[5].tp > 1000 then

                p5_tp = {color = ui.color.purple}
            
            elseif party[5].tp < 1000 then

                p5_tp = {color = ui.color.green}

            end

            ui.location(0, 0)
            ui.text(hpp, text_opt)
            ui.size(80, 10)
            ui.progress(party[5].hp_percent/100, p5_hp)
            ui.location(0, 50)
            ui.text(mpp, text_opt)
            ui.size(80, 10)
            ui.progress(party[5].mp_percent/100, p5_mp)
            ui.location(0, 80)
            ui.text(tp, text_opt)
            ui.size(80, 10) 
            ui.progress(party[5].tp/3000, p5_tp)
            ui.location(0, 110)
            ui.text(using, text_opt)   
    
        end)

    end  

    --sixth party member window

    if party[6] ~= nil then

        ui.window('p6_window', tUwuStates["P6"]["Window"], function()

            tUwuStates["P6"]["Strings"]["HP"] = party[6].name .. "\n[HP%] " .. party[6].hp_percent
            tUwuStates["P6"]["Strings"]["MP"] = "[MP%] " .. party[6].mp_percent
            tUwuStates["P6"]["Strings"]["TP"] = "[TP] " .. party[6].tp
            local hpp = FormatStr(tUwuStates["P6"]["Strings"]["HP"], format)
            local mpp = FormatStr(tUwuStates["P6"]["Strings"]["MP"], format)
            local tp = FormatStr(tUwuStates["P6"]["Strings"]["TP"], format)
            local using = FormatStr(tUwuStates["P6"]["Strings"]["Using"], format)
            --colors
            local p6_tp = {color = ui.color.green}
            local p6_hp = {color = ui.color.accent}
            local p6_mp = {color = ui.color.blue}

            if party[6].tp == 3000 then

                p6_tp = {color = ui.color.gold}

            elseif party[6].tp < 3000 and party[6].tp > 1000 then

                p6_tp = {color = ui.color.purple}
            
            elseif party[6].tp < 1000 then

                p6_tp = {color = ui.color.green}

            end

            ui.location(0, 0)
            ui.text(hpp, text_opt)
            ui.size(80, 10)
            ui.progress(party[6].hp_percent/100, p6_hp)
            ui.location(0, 50)
            ui.text(mpp, text_opt)
            ui.size(80, 10)
            ui.progress(party[6].mp_percent/100, p6_mp)
            ui.location(0, 80)
            ui.text(tp, text_opt)
            ui.size(80, 10) 
            ui.progress(party[6].tp/3000, p6_tp)
            ui.location(0, 110)
            ui.text(using, text_opt)
        
        end)

    end  

end)

--register our function on incoming 0x028

packet.incoming[0x028]:register(ActionHandler)

--[[
Copyright © 2020, Uwu/Darkdoom
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of Chiaia nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL Chiaia BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
]]


