-- With help from Janssent's bicycle mod

--------------------
-- Loading assets --
--------------------

Events:Subscribe('Level:LoadResources', function() -- Prepare bundles

    print('Mounting superbundles...')
    
     -- Uprising, for the MV-22B
    ResourceManager:MountSuperBundle('spchunks')
    ResourceManager:MountSuperBundle('levels/sp_earthquake2/sp_earthquake2')

    -- Wake Island, for the F-35B
    --ResourceManager:MountSuperBundle('xp1chunks')
    --ResourceManager:MountSuperBundle('levels/xp1_004/xp1_004')

end)

Hooks:Install('ResourceManager:LoadBundles', 500, function(hook, bundles, compartment) -- Inject bundles

    if #bundles == 1 and bundles[1] == SharedUtils:GetLevelName() then

        print('Injecting bundles...')

        bundles = {
            'levels/sp_earthquake2/sp_earthquake2',
            'levels/sp_earthquake2/stagingarea_sub',
            --'levels/xp1_004/xp1_004',
            --'levels/xp1_004/cq_s',
            bundles[1]
        }

    end

    hook:Pass(bundles, compartment)

end)

-- Add registries

Events:Subscribe('Level:RegisterEntityResources', function(levelData)

    print('Adding Uprising StagingArea SubWorld registry...')
    local uprisingRegistry = RegistryContainer(ResourceManager:FindInstanceByGuid(Guid('91B1E43F-5B21-47BA-8E8B-5DC2E900EC8C'), Guid('B0160744-D0B3-6E76-5BD3-C6166B8955AA')))
    ResourceManager:AddRegistry(uprisingRegistry, ResourceCompartment.ResourceCompartment_Game)

    --[[print('Adding Wake Island CQ(A)S registry...')
    local wakeIsCqsRegistry = RegistryContainer(ResourceManager:FindInstanceByGuid(Guid('6C5E1DF6-B428-4A11-BA06-15E565B63802'), Guid('A44167A2-B0D1-3EA5-C4DD-517FD23EC6A2')))
    ResourceManager:AddRegistry(wakeIsCqsRegistry, ResourceCompartment.ResourceCompartment_Game)]]

end)

---------------------
-- Replacing model --
---------------------

local weaponMeshInstances = {}

Events:Subscribe('Partition:Loaded', function(partition)

    if partition == nil then return end

    for _, instance in pairs(partition.instances) do

        if instance.instanceGuid == Guid('5400AEEF-4B57-7EF1-32EE-FB6240FF2F61') then

            --print('Found F-35B mesh...')
            lightningMesh = CompositeMeshAsset(instance)

        end

        if instance.instanceGuid == Guid('992001FC-266E-E61A-02BF-623814E3B09F') then

            --print('Found MV-22B body mesh...')
            ospreyMesh = RigidMeshAsset(instance)

        end

        if instance.instanceGuid == Guid('73EB0373-2F17-6305-05BF-952BED53A0E7') then

            --print('Found F-35B chassis component data...')
            lightningChassisComponentData = ChassisComponentData(instance)

        end

        if instance.instanceGuid == Guid('542473D7-5DA2-CBA1-6995-D808D2293FE3') then

            ospreyLeftNacelleMesh = RigidMeshAsset(instance)

        end

        if instance.instanceGuid == Guid('3044BF51-3C4B-635E-485B-7A2633D1B6C5') then

            ospreyRightNacelleMesh = RigidMeshAsset(instance)

        end

        if instance.typeInfo.name == 'MeshComponentData' and instance.partitionGuid == Guid('EB06DA1E-4B21-11E0-AC22-92ED36F00269') then

            --print('Found weapon/weapon pylon mesh...')
            table.insert(weaponMeshInstances, MeshComponentData(instance))

        end

        if instance.instanceGuid == Guid('2872F88C-F9EE-4A3C-8078-514401B5897C') then

            thirdPersonCameraComponentData = CameraComponentData(instance)

        end

    end

    if finished == nil 
    and lightningMesh ~= nil 
    and ospreyMesh ~= nil 
    and lightningChassisComponentData ~= nil 
    and ospreyLeftNacelleMesh ~= nil
    and ospreyRightNacelleMesh ~= nil
    and thirdPersonCameraComponentData ~= nil
    and #weaponMeshInstances == 6 then

        -- Replace main chassis

        --print('Removing F-35 mesh, adding MV-22 mesh...')

        lightningMesh:ReplaceReferences(ospreyMesh)

        lightningChassisComponentData:MakeWritable()
        local ospreyMeshComponentData = MeshComponentData()
        ospreyMeshComponentData.transform = LinearTransform(
            Vec3(1,0,0),
            Vec3(0,1,0),
            Vec3(0,0,1),
            Vec3(0,1.45,0)
        )
        ospreyMeshComponentData.mesh = ospreyMesh
        lightningChassisComponentData.components:add(ospreyMeshComponentData)

        -- Add left nacelle

        local ospreyLeftNacelleMeshComponentData = MeshComponentData()
        ospreyLeftNacelleMeshComponentData.transform = LinearTransform(
            Vec3(1,0,0),
            Vec3(0,1,0),
            Vec3(0,0,1),
            Vec3(7.8,2.82,0.67)
        )
        ospreyLeftNacelleMeshComponentData.mesh = ospreyLeftNacelleMesh
        lightningChassisComponentData.components:add(ospreyLeftNacelleMeshComponentData)

        -- Add right nacelle

        local ospreyLeftNacelleMeshComponentData = MeshComponentData()
        ospreyLeftNacelleMeshComponentData.transform = LinearTransform(
            Vec3(1,0,0),
            Vec3(0,1,0),
            Vec3(0,0,1),
            Vec3(-7.8,2.82,0.67)
        )
        ospreyLeftNacelleMeshComponentData.mesh = ospreyRightNacelleMesh
        lightningChassisComponentData.components:add(ospreyLeftNacelleMeshComponentData)

        -- Add ramp (down posn)

        -- Add board (???)

        -- Remove F-35B weapons and weapon pylons

        for _, weapon in pairs(weaponMeshInstances) do

            --print('Excluding weapon/weapon pylon \''..RigidMeshAsset(weapon.mesh).name..'\'...')
            weapon:MakeWritable()
            weapon.excluded = true

        end

        -- Move first person camera to right (pilot's) seat

        -- Move third person camera further away, higher up

        thirdPersonCameraComponentData:MakeWritable()
        thirdPersonCameraComponentData.transform = LinearTransform(
            Vec3(1,0,0),
            Vec3(0,1,0),
            Vec3(0,0,1),
            Vec3(0,2.5,-7)
        )

        finished = true

    end

end)