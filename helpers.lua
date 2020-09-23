local helpers = {}
local client_data = require('client_data')
local resources = require('resources')
local math = require('math')
local ui = require('core.ui')
local enumerable = require('enumerable')
local exclusions = require('exclusions')

function helpers.get()

    self = {}

    self.GetDistanceColor = function(distance)

        local color = {color = ui.color.rgb(119, 247, 237)}
            
        if distance < 15 then

            return color

        elseif distance > 15 and distance < 20.9 then


            color = {color = ui.color.yellow}
            return color

        elseif distance > 20.9 then 

            color = {color = ui.color.red}
            return color

        end
        
    end

    self.GetTPColor = function(tp)

        local color = {color = ui.color.green}
    
        if tp == 3000 then
    
            color = {color = ui.color.gold}
            return color
    
        elseif tp < 3000 and tp > 1000 then
    
            color = {color = ui.color.purple}
            return color
    
        elseif tp < 1000 then
    
            return color
    
        end
    
    end

    self.Round = function(num, numDecimalPlaces)

        local mult = 10^(numDecimalPlaces or 0)
        
        return math.floor(num * mult + 0.5) / mult
      
    end

    self.FormatStr = function(string, formatting)

        if string and formatting then
    
            local str = "[" .. string .. "]" .. "{" .. formatting .. "}"
            return str
    
        end
    
    end

    self.FormatStringTable = function(t1, t2, formatting)
    
        for k,_ in pairs(t1) do
        
            t2[k] = self.FormatStr(t1[k], formatting)
        
        end
        
        return t2
    
    end

    self.ActionString = function(param, t_param, category)
    
        local str = " "
    
        if param and t_param and category then
    
            --magic
    
            if category == 8 then 
    
                str = "[MA] " .. client_data.spells[t_param].name
                return str
    
            --player ws
    
            elseif category == 7 and t_param > 0 and t_param <= 255  then
                
                str = "[WS] " .. resources.weapon_skills[t_param].name
                print(str)
                return str
    
            --trust ws
    
            elseif category == 7 and t_param > 255 and enumerable.contains(exclusions, t_param) == false then
    
                str = "[WS] " .. resources.monster_abilities[t_param].name
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
    
                str = "[Finishing] " .. resources.monster_abilities[param].name
                return str
    
            else return str
    
            end
    
        end
    
    end

    return self

end
return helpers.get()
