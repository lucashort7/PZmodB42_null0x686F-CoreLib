if debugScenarios == nil then
  debugScenarios = {}
end

debugScenarios.HortWizQA = {
  name = "HortWiz QA Testing Suite",
  forceLaunch = false,
  startLoc = { x = 10645, y = 10437, z = 0 },

  setSandbox = function()
    SandboxVars.Zombies = 2
    SandboxVars.VehicleEasyUse = true
  end,

  onStart = function()
    local player = getPlayer()
    if not player then return end
    local inv = player:getInventory()

    inv:AddItem("Base.Axe")
    inv:AddItem("Base.BathTowel")
    inv:AddItem("Base.BathTowel")
    inv:AddItem("Base.AlarmClock2")
    inv:AddItem("Base.Shirt_FormalWhite")
    inv:AddItem("Base.Trousers_Suit")
    inv:AddItem("Base.PetrolCan")
    inv:AddItem("Base.BookCooking1")

    if player.LevelPerk then
      player:LevelPerk(Perks.Fitness)
      player:LevelPerk(Perks.Strength)
    end
  end
}
