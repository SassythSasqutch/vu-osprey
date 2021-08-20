--------------------
-- Loading assets --
--------------------

print('Loading assets...')

Events:Subscribe('Level:LoadResources', function() -- Prepare bundles
    
     -- Get Osprey bundles
    ResourceManager:MountSuperBundle('spchunks')
    ResourceManager:MountSuperBundle('levels/sp_earthquake2/sp_earthquake2')

    -- Get F-35B bundles
    ResourceManager:MountSuperBundle('xp1chunks')
    ResourceManager:MountSuperBundle('levels/xp1_004/xp1_004')

end)

-- Note server crash on round restart - maybe unsubscribe to this (problem could also be with Janssent's bicycle)

Hooks:Install('ResourceManager:LoadBundles', 500, function(hook, bundles, compartment) -- Inject bundles

    if #bundles == 1 and bundles[1] == ServerUtils:GetLevelName() then

        bundles = {
            'levels/sp_earthquake2/sp_earthquake2',
            'levels/xp1_004/xp1_004',
            bundles[1]
        }

end)

print('Assets loaded!')

---------------------
-- Replacing model --
---------------------

--print('Building MV-22B aircraft...')