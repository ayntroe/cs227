dofile("finditems.lua")
dofile("spelltable.lua")

--Crafts scrolls--
function CraftScrolls(circle,spell,spelltype)
         ResourceCheck()
         
         UO.LObjectID = penID
         UO.Macro(17,0)
         wait(1000)
     
         UO.Click((UO.ContPosX + 25),(UO.ContPosY + (circle * 20) + 70),true,true,true,false)
         wait(1000)
         UO.Click((UO.ContPosX + 230),(UO.ContPosY + (spell * 20) + 50),true,true,true,false)
         wait(3000)
         
        CraftCheck(circle,spell,spelltype)
end

--Crafts last item. Not used in bookfiller--
function CraftLast()
         UO.LObjectID = penID
         UO.Macro(17,0)
            wait(250)
            UO.Click((UO.ContPosX + 285),(UO.ContPosY + 410),true,true,true,false)
            wait(3000)
end

--Checks to see if your craft attempt as successful or not, then re-attempts until it is--
function CraftCheck(circle,spell,spelltype)
         local s = ScanItems(true)
         local s = FindItems(s,{Type = spelltype, ContID = UO.BackpackID})
         if #s < 1  then 
            CraftScrolls(circle,spell,spelltype)
            CraftCheck(circle,spell,spelltype)
         end
end

--Checks mana, meditates based on the circle you're scribing--
function ManaCheck(minmana)
         if UO.Mana < minmana then
            UO.Macro(13,46)
            print("Meditating...")
            wait(((UO.MaxMana - UO.Mana) / ManaRegen) * 1000)
            print("At Peace")
         end         
end

--Checks to make sure you have a pen in your pack--
function ResourceCheck()
         local r = ScanItems(true)
         local pen = FindItems(r,{Type = 4031, ContID = UO.BackpackID})
         if #pen < 1 then
            local backupPen = FindItems(r, {Type = 4031, ContID = resourcecontainer})
            penID = backupPen[1].ID
            UO.Drag(penID)
            UO.DropC(UO.CharID)
            wait(500)
         else penID = pen[1].ID
         end
         local blanks = FindItems(r,{Type = 3827, ContID = UO.BackpackID})
         if #blanks < 1 then
            local backupBlanks = FindItems(r, {Type = 3827, ContID = resourcecontainer})
            UO.Drag(backupBlanks[1].ID,100)
            UO.DropC(UO.CharID)
            wait(500)
         end            
end
            