dofile("finditems.lua")
dofile("spelltable.lua")
dofile("craftscrollsengine.lua")

--Alain's spellbook filler
--Version 1.2, 04/1/2012


--For this script you need  two seperate containers, one for resources and one for finished books.

ExScrollChest = 0 --Change to 1 if you have a chest of scrolls from hunting/etc you want to use to help fill your books.
ManaRegen = 4 --Your mana regen rate per second. You'll need to guess your own, 100% accuracy is not necessary.

--Preps and drags pens/books/blank scrolls--
function BookRestock()
    books = ScanItems(true, {Type = 3834, ContID = resourcecontainer})
       if #books < 1 then
          print("You are out of books.")
          stop()
       else
          activebook = books[1].ID
          UO.Drag(activebook)
          UO.DropC(UO.CharID)
          wait(500)
       end    
end

function OpenContainer(container)
         UO.LObjectID = container
         UO.Macro(17,0)
         wait(500)
end

--Identifies your resource container--
print("You have 5 seconds to target your resource container")
UO.TargCurs = true
wait(5000)
resourcecontainer = UO.LTargetID
OpenContainer(resourcecontainer)

--Identifies your finished book container--
print("You have 5 seconds to target your finished book container")
UO.TargCurs = true
wait(5000)
finishedcontainer = UO.LTargetID

--Identifies your chest of existing scrolls, if this option is selected--
if ExScrollChest == 1 then
UO.TargCurs = true
print ("You have 5 seconds to target your chest of existing scrolls")
wait(5000)
exscrollcontainer = UO.LTargetID
OpenContainer(exscrollcontainer)
end

OpenContainer(UO.BackpackID)
BooksCrafted = 0

--Crafts your scrolls then fills the book. Substitutes existing scrolls if applicable--
while BooksCrafted < #books do

      BookRestock()

      for i = 1,64 do
         scrolls = ScanItems(true)
         scrolls = FindItems(scrolls, {Type = spells[i].type})
            if #scrolls > 0 then
               UO.Drag(scrolls[1].ID)
               UO.DropC(activebook)
            else
               ManaCheck(circlemana[spells[i].circle])
               CraftScrolls(spells[i].circle,spells[i].spell,spells[i].type)
               print("Crafted " ..spells[i].name)
            end
            
            activescroll = ScanItems(true, {Type = spells[i].type})
            UO.Drag(activescroll[1].ID)
            UO.DropC(activebook)
            wait(500)    
      end
      
      UO.Drag(activebook)
      UO.DropC(finishedcontainer)
      wait(500)
      
      print("Spellbook filled. Moving to Secure")
           
      BooksCrafted = BooksCrafted + 1
end  