--------------------
-- Loading assets --
--------------------

Events:Subscribe('Level:LoadResources', function() -- Prepare bundles

    print('Mounting superbundles...')
    
     -- Get Osprey bundles
    ResourceManager:MountSuperBundle('spchunks')
    ResourceManager:MountSuperBundle('levels/sp_earthquake2/sp_earthquake2')

    -- Get F-35B bundles
    ResourceManager:MountSuperBundle('xp1chunks')
    ResourceManager:MountSuperBundle('levels/xp1_004/xp1_004')

end)

Hooks:Install('ResourceManager:LoadBundles', 500, function(hook, bundles, compartment) -- Inject bundles

    if #bundles == 1 and bundles[1] == ServerUtils:GetLevelName() then

        print('Injecting bundles...')

        bundles = {
            'levels/sp_earthquake2/sp_earthquake2',
            'levels/xp1_004/xp1_004',
            'levels/xp1_004/cq_s',
            bundles[1]
        }

    end

    hook:Pass(bundles, compartment)

end)

-- Add registries

Events:Subscribe('Level:RegisterEntityResources', function(levelData)

    print('Adding Uprising registry...')
    local uprisingRegistry = RegistryContainer(ResourceManager:FindInstanceByGuid(Guid('6FD69AE4-5B8A-11E0-BC14-D5B461CF665B'), Guid('7C9240B4-8C13-9DCA-B21F-E436E9A79F8F')))
    ResourceManager:AddRegistry(uprisingRegistry, ResourceCompartment.ResourceCompartment_Game)

    print('Adding Wake Island CQS registry...')
    local wakeIsCqsRegistry = RegistryContainer(ResourceManager:FindInstanceByGuid(Guid('6C5E1DF6-B428-4A11-BA06-15E565B63802'), Guid('A44167A2-B0D1-3EA5-C4DD-517FD23EC6A2')))
    ResourceManager:AddRegistry(wakeIsCqsRegistry, ResourceCompartment.ResourceCompartment_Game)

end)

---------------------
-- Replacing model --
---------------------

--print('Building MV-22B aircraft...')