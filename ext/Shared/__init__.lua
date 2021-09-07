-- With help from Janssent's bicycle mod

local taskComplete = false

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

    --print('Adding Uprising StagingArea SubWorld registry...')
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
local engineAfterburnerEffects = {}
local vehicleExitPointComponentData = {}

Events:Subscribe('Partition:Loaded', function(partition)

    if partition == nil then return end

    for _, instance in pairs(partition.instances) do

        if instance.instanceGuid == Guid('5400AEEF-4B57-7EF1-32EE-FB6240FF2F61') then

            print('F-35B CompositeMeshAsset ready...')
            lightningCompositeMesh = CompositeMeshAsset(instance)

        end

        if instance.instanceGuid == Guid('992001FC-266E-E61A-02BF-623814E3B09F') then 

            print('MV-22B body RigidMeshAsset ready...')
            ospreyRigidMesh = RigidMeshAsset(instance)

        end

        if instance.instanceGuid == Guid('922E0FF3-5BEA-78C1-4FD1-EDAE142D2289') then

            print('F-35B VehicleEntityData ready...')
            lightningVehicleEntityData = VehicleEntityData(instance)

        end

        if instance.instanceGuid == Guid('73EB0373-2F17-6305-05BF-952BED53A0E7') then

            print('F-35B ChassisComponentData ready...')
            lightningChassisComponentData = ChassisComponentData(instance)

        end

        if instance.instanceGuid == Guid('8090DADA-710C-43F3-5367-A9C0C4FC6CBB') then

            print('MV-22B body PhysicsEntityData ready...')
            ospreyBodyPhysicsEntityData = PhysicsEntityData(instance)

        end

        if instance.instanceGuid == Guid('C5B13172-7304-A345-D641-D0FA261CBBD1') then

            print('F-35B PhysicsEntityData ready...')
            lightningPhysicsEntityData = PhysicsEntityData(instance)

        end

        if instance.instanceGuid == Guid('542473D7-5DA2-CBA1-6995-D808D2293FE3') then

            print('MV-22B left nacelle RigidMeshAsset ready...')
            ospreyLeftNacelleMesh = RigidMeshAsset(instance)

        end

        if instance.instanceGuid == Guid('3044BF51-3C4B-635E-485B-7A2633D1B6C5') then

            print('MV-22B right nacelle RigidMeshAsset ready...')
            ospreyRightNacelleMesh = RigidMeshAsset(instance)

        end

        if instance.instanceGuid == Guid('D4B1A0F1-AD8F-9DF0-8C82-0E0011D9F3A2') then

            print('MV-22B still rotor RigidMeshAsset ready...')
            ospreyRotorStillMesh = RigidMeshAsset(instance)

        end

        if instance.instanceGuid == Guid('D7FFC20A-62BD-82AC-3124-8CB402720B50') then

            print('MV-22B blurred rotor RigidMeshAsset ready...')
            ospreyRotorBlurredMesh = RigidMeshAsset(instance)

        end

        if instance.instanceGuid == Guid('DEF48665-0C58-A018-135B-2792091E5B08') then

            print('MV-22B ramp RigidMeshAsset ready...')
            ospreyRampMesh = RigidMeshAsset(instance)

        end

        if instance.typeInfo.name == 'VehicleExitPointComponentData' and instance.partitionGuid == Guid('EB06DA1E-4B21-11E0-AC22-92ED36F00269') then

            print('F-35B VehicleExitPointComponentData ready...')
            table.insert(vehicleExitPointComponentData, VehicleExitPointComponentData(instance))

        end

        if instance.typeInfo.name == 'EffectComponentData' and instance.partitionGuid == Guid('EB06DA1E-4B21-11E0-AC22-92ED36F00269') then

            thisInstance = EffectComponentData(instance)

            if string.find(EffectBlueprint(thisInstance.effect).name, 'JetEngine') or string.find(EffectBlueprint(thisInstance.effect).name, 'Afterburner') then

                print('F-35B engine afterburner EffectComponentData ready...')
                table.insert(engineAfterburnerEffects, thisInstance)

            end

        end

        if instance.typeInfo.name == 'MeshComponentData' and instance.partitionGuid == Guid('EB06DA1E-4B21-11E0-AC22-92ED36F00269') then

            print('F-35B weapon/weapon pylon MeshComponentData ready...')
            table.insert(weaponMeshInstances, MeshComponentData(instance))

        end

        if instance.instanceGuid == Guid('2330C639-01C1-C569-D53C-32776FFC94D5') then

            print('Transparent glass ShaderGraph ready...')
            transparentGlassShaderGraph = ShaderGraph(instance)

        end

        if instance.instanceGuid == Guid('45E5D356-43A0-4430-A63D-92D3450895DE') then -- Alt 7E34ABFB-218A-4384-8372-2D34243757DD

            print('F-35B first person CameraComponentData ready...')
            firstPersonCameraComponentData = CameraComponentData(instance)

        end

        if instance.instanceGuid == Guid('EB898E2A-1B43-4B5C-A28D-6614A1D08D24') then

            print('F-35B first person freelock AlternateCameraViewData ready...')
            fpFreelookAlternateCameraViewData = AlternateCameraViewData(instance)

        end

        if instance.instanceGuid == Guid('ABEBE282-0A9F-4110-9F27-1E20107BA972') then

            print('F-35B pilot mesh LogicReferenceObjectData ready...')
            pilotBpLogicReferenceObjectData = LogicReferenceObjectData(instance)

        end

        if instance.instanceGuid == Guid('6DCD4D7B-34C9-4957-BB25-BCAFE8C49EF2') then

            print('UH-1Y first person CameraComponentData ready...')
            hueyFirstPersonCameraComponentData = CameraComponentData(instance)

        end

        if instance.instanceGuid == Guid('2872F88C-F9EE-4A3C-8078-514401B5897C') then

            print('F-35B third person CameraComponentData ready...')
            thirdPersonCameraComponentData = CameraComponentData(instance)

        end

        if instance.instanceGuid == Guid('B8F16C19-6A7A-45D8-B624-FBD0E30E1873') then

            print('F-35B PlayerEntryComponentData ready...')
            lightningPlayerEntryComponentData = PlayerEntryComponentData(instance)

        end

        if instance.instanceGuid == Guid('1D7E9FCA-5372-49C7-B784-746064AD768A') then

            print('UH-1Y passenger SoldierEntryComponentData ready...')
            hueyPaxSoldierEntryComponentData = SoldierEntryComponentData(instance)

        end

        if instance.instanceGuid == Guid('22BB75BD-31D9-45B9-3785-F2AF08A75460') then

            print('Test AAV-7A1 CompositeMeshAsset ready...')
            testAmtracCompositeMeshAsset = CompositeMeshAsset(instance)

        end

    end

    if taskComplete == false
    and lightningCompositeMesh ~= nil 
    and ospreyRigidMesh ~= nil 
    and lightningVehicleEntityData ~= nil
    and lightningChassisComponentData ~= nil 
    and lightningPhysicsEntityData ~= nil
    and ospreyBodyPhysicsEntityData ~= nil
    and ospreyLeftNacelleMesh ~= nil
    and ospreyRightNacelleMesh ~= nil
    and ospreyRotorStillMesh ~= nil
    and ospreyRotorBlurredMesh ~= nil
    and ospreyRampMesh ~= nil
    and transparentGlassShaderGraph ~= nil
    and firstPersonCameraComponentData ~= nil
    and fpFreelookAlternateCameraViewData ~= nil
    and pilotBpLogicReferenceObjectData ~= nil
    and thirdPersonCameraComponentData ~= nil
    and hueyFirstPersonCameraComponentData ~= nil
    and lightningPlayerEntryComponentData ~= nil
    and hueyPaxSoldierEntryComponentData ~= nil
    --and testAmtracCompositeMeshAsset ~= nil
    and #weaponMeshInstances == 6
    and #engineAfterburnerEffects == 3
    and #vehicleExitPointComponentData == 5 then

        print('All components ready: building MV-22B Osprey...')

        lightningVehicleEntityData:MakeWritable()

        -- Delete F-35 mesh

        lightningCompositeMesh:ReplaceReferences(ospreyRigidMesh)

        -- Add MV-22 main body mesh

        lightningChassisComponentData:MakeWritable()
        local ospreyMeshComponentData = MeshComponentData()
        ospreyMeshComponentData.transform = LinearTransform(
            Vec3(1,0,0),
            Vec3(0,1,0),
            Vec3(0,0,1),
            Vec3(0,1.45,0)
        )
        ospreyMeshComponentData.mesh = ospreyRigidMesh
        lightningChassisComponentData.components:add(ospreyMeshComponentData)

        --[[ospreyRigidMesh:MakeWritable()
        local ospreyCompositeMesh = CompositeMeshAsset()
        ospreyCompositeMesh.lodGroup = ospreyRigidMesh.lodGroup
        ospreyCompositeMesh.lodScale = ospreyRigidMesh.lodScale
        ospreyCompositeMesh.cullScale = ospreyRigidMesh.cullScale
        ospreyCompositeMesh.nameHash = ospreyRigidMesh.nameHash
        ospreyRigidMesh.nameHash = 3654729455
        ospreyCompositeMesh.enlightenType = ospreyRigidMesh.enlightenType
        ospreyCompositeMesh.materials:add(ospreyRigidMesh.materials[1])
        ospreyCompositeMesh.materials:add(ospreyRigidMesh.materials[2])
        ospreyCompositeMesh.materials:add(ospreyRigidMesh.materials[3])
        ospreyCompositeMesh.occluderHighPriority = ospreyRigidMesh.occluderHighPriority
        ospreyCompositeMesh.streamingEnable = ospreyRigidMesh.streamingEnable
        ospreyCompositeMesh.destructionMaterialEnable = ospreyRigidMesh.destructionMaterialEnable
        ospreyCompositeMesh.occluderMeshEnable = ospreyRigidMesh.occluderMeshEnable
        lightningCompositeMesh:ReplaceReferences(ospreyCompositeMesh)]]

        -- TODO: Replace physics

        --lightningPhysicsEntityData:ReplaceReferences(ospreyRigidMesh)

        --lightningChassisComponentData.components:add(ospreyBodyPhysicsEntityData)

        -- Add left nacelle

        lightningChassisComponentData:MakeWritable()
        local ospreyLeftNacelleMeshComponentData = MeshComponentData()
        ospreyLeftNacelleMeshComponentData.transform = LinearTransform(
            Vec3(1,0,0),
            Vec3(0,0.748,-0.6696),
            Vec3(0,0.6696,0.748), -- q = 0.93 +0.36i +0.00j +0.00k (45 degree ACW rot in x axis, as a quaternion)
            Vec3(7.8,2.82,0.67)
        )
        ospreyLeftNacelleMeshComponentData.mesh = ospreyLeftNacelleMesh
        lightningChassisComponentData.components:add(ospreyLeftNacelleMeshComponentData)

        -- Add right nacelle

        local ospreyRightNacelleMeshComponentData = MeshComponentData()
        ospreyRightNacelleMeshComponentData.transform = LinearTransform(
            Vec3(1,0,0),
            Vec3(0,0.748,-0.6696),
            Vec3(0,0.6696,0.748),
            Vec3(-7.8,2.82,0.67)
        )
        ospreyRightNacelleMeshComponentData.mesh = ospreyRightNacelleMesh
        lightningChassisComponentData.components:add(ospreyRightNacelleMeshComponentData)

        -- Add left rotor

        local ospreyLeftRotorMeshComponentData = MeshComponentData()
        ospreyLeftRotorMeshComponentData.transform = LinearTransform(
            Vec3(1,0,0),
            Vec3(0,0.748,-0.6696),
            Vec3(0,0.6696,0.748),
            Vec3(8.7,4,2)
        )
        ospreyLeftRotorMeshComponentData.mesh = ospreyRotorBlurredMesh
        lightningChassisComponentData.components:add(ospreyLeftRotorMeshComponentData)

        -- Add right rotor

        local ospreyRightRotorMeshComponentData = MeshComponentData()
        ospreyRightRotorMeshComponentData.transform = LinearTransform(
            Vec3(1,0,0),
            Vec3(0,0.748,-0.6696),
            Vec3(0,0.6696,0.748),
            Vec3(-8.7,4,2)
        )
        ospreyRightRotorMeshComponentData.mesh = ospreyRotorBlurredMesh
        lightningChassisComponentData.components:add(ospreyRightRotorMeshComponentData)

        -- Add ramp

        local ospreyRampMeshComponentData = MeshComponentData()
        ospreyRampMeshComponentData.transform = LinearTransform(
            Vec3(1,0,0),
            Vec3(0,1,0),
            Vec3(0,0,1),
            Vec3(0,-0.75,-4.25)
        )
        ospreyRampMeshComponentData.mesh = ospreyRampMesh
        lightningChassisComponentData.components:add(ospreyRampMeshComponentData)

        -- TODO: Add Huey sounds (or other, unused helo to distinguish sound? Adjust Huey sounds (louder, deeper)?)

        -- TODO: Prevent ejection (dysfunctional)

        for _, exitPoint in pairs(vehicleExitPointComponentData) do

            exitPoint:MakeWritable()
            exitPoint.velocity = 0.0

        end

        -- Remove F-35 cockpit
 
        lightningVehicleEntityData.cockpitMesh = nil

        -- Remove F-35B weapons and weapon pylons

        for _, weapon in pairs(weaponMeshInstances) do

            --print('Excluding weapon/weapon pylon \''..RigidMeshAsset(weapon.mesh).name..'\'...')
            weapon:MakeWritable()
            weapon.excluded = true

        end

        -- Remove afterburner effect

        for _, afterburnerEffect in pairs(engineAfterburnerEffects) do

            afterburnerEffect:MakeWritable()
            afterburnerEffect.excluded = true

        end

        -- TODO: Change glass (dysfunctional) -- for now, remove highest LOD

        local ospreyMeshLodGroup = MeshLodGroup(ospreyRigidMesh.lodGroup)
        ospreyMeshLodGroup:MakeWritable()

        ospreyRigidMesh:MakeWritable()
        ospreyRigidMesh.lodGroup = nil
        ospreyRigidMesh.lodScale = 0
        ospreyRigidMesh.cullScale = 0
        ospreyRigidMesh.materials:clear()
        ospreyRigidMesh.occluderHighPriority = true
        ospreyRigidMesh.streamingEnable = true
        ospreyRigidMesh.destructionMaterialEnable = true
        ospreyRigidMesh.occluderMeshEnable = true

        -- Move pilot

        lightningPlayerEntryComponentData:MakeWritable()
        lightningPlayerEntryComponentData.transform = LinearTransform(
            Vec3(1,0,0),
            Vec3(0,1,0),
            Vec3(0,0,1),
            Vec3(-0.75,0.5,5.2)
        )

        -- Set pilot HUD and miscellaneous UI data (minimap icon, entry interaction)

        firstPersonCameraComponentData:MakeWritable()
        RegularCameraViewData(firstPersonCameraComponentData.regularView).mesh = nil -- Remove HUD
        fpFreelookAlternateCameraViewData:MakeWritable()
        fpFreelookAlternateCameraViewData.mesh = nil -- Remove freelook HUD

        local ospreyHudData = VehicleHudData()
        ospreyHudData.customizationOffset = Vec3(0,0,0)
        ospreyHudData.customization = nil
        ospreyHudData.minimapIcon = 155 -- UIHudIcon_Gunship
        ospreyHudData.texture = nil
        ospreyHudData.vehicleItemHash = 2336931505 -- CivilianCar

        lightningVehicleEntityData.hudData = ospreyHudData

        -- TODO: Move pilot model

        pilotBpLogicReferenceObjectData:MakeWritable()
        pilotBpLogicReferenceObjectData.blueprintTransform = LinearTransform(
            Vec3(1,0,0),
            Vec3(0,1,0),
            Vec3(0,0,1),
            Vec3(-0.75,0,-0.75)
        )

        -- Move third person camera further away, higher up

        thirdPersonCameraComponentData:MakeWritable()
        thirdPersonCameraComponentData.transform = LinearTransform(
            Vec3(1,0,0),
            Vec3(0,1,0),
            Vec3(0,0,1),
            Vec3(0,2.5,-7)
        )

        -- Move exit posn and entry interaction UI element to ramp

        lightningVehicleEntityData.interactionOffset = Vec3(0,0,-4)

        for _, exitPoint in pairs(vehicleExitPointComponentData) do

            exitPoint.transform = LinearTransform(
                Vec3(-1,0,0),
                Vec3(0,1,0),
                Vec3(0,0,-1),
                Vec3(0,0,-8)
            )

        end

        -- Increase entry radius

        lightningPlayerEntryComponentData.entryRadius = 13.0

        -- TODO: Modify fwd flight maneuveribiity (pitch/roll rate)

        -- TODO: Remove wreck

        -- TODO: Add passenger seats (12) -- potentially six maximum as a hardcoded limitation (ignore entry order numbers?)

        --lightningPlayerEntryComponentData:MakeWritable()
        --lightningPlayerEntryComponentData.entryOrderNumber = 0 -- Make pilots the last to enter

        passengerPlayerEntryComponentData1 = hueyPaxSoldierEntryComponentData:Clone(Guid('A0000000-0000-0000-0000-000000OSPREY'))
        passengerPlayerEntryComponentData1.entryOrderNumber = 1
        passengerPlayerEntryComponentData1.transform = LinearTransform(
            Vec3(1,0,0),
            Vec3(0,1,0),
            Vec3(0,0,1),
            Vec3(0,-0.5,-7)
        )

        passengerPlayerEntryComponentData2 = hueyPaxSoldierEntryComponentData:Clone(Guid('B0000000-0000-0000-0000-000000OSPREY'))
        passengerPlayerEntryComponentData2.entryOrderNumber = 2

        passengerPlayerEntryComponentData3 = hueyPaxSoldierEntryComponentData:Clone(Guid('C0000000-0000-0000-0000-000000OSPREY'))
        passengerPlayerEntryComponentData3.entryOrderNumber = 3

        passengerPlayerEntryComponentData4 = hueyPaxSoldierEntryComponentData:Clone(Guid('D0000000-0000-0000-0000-000000OSPREY'))
        passengerPlayerEntryComponentData4.entryOrderNumber = 4

        passengerPlayerEntryComponentData5 = hueyPaxSoldierEntryComponentData:Clone(Guid('E0000000-0000-0000-0000-000000OSPREY'))
        passengerPlayerEntryComponentData5.entryOrderNumber = 5

        -- Six seats seems to be a hardcoded roof

        --[[passengerPlayerEntryComponentData6 = hueyPaxSoldierEntryComponentData:Clone(Guid('F0000000-0000-0000-0000-000000OSPREY'))
        passengerPlayerEntryComponentData6.entryOrderNumber = 5

        passengerPlayerEntryComponentData7 = hueyPaxSoldierEntryComponentData:Clone(Guid('G0000000-0000-0000-0000-000000OSPREY'))
        passengerPlayerEntryComponentData7.entryOrderNumber = 6

        passengerPlayerEntryComponentData8 = hueyPaxSoldierEntryComponentData:Clone(Guid('H0000000-0000-0000-0000-000000OSPREY'))
        passengerPlayerEntryComponentData8.entryOrderNumber = 7

        passengerPlayerEntryComponentData9 = hueyPaxSoldierEntryComponentData:Clone(Guid('I0000000-0000-0000-0000-000000OSPREY'))
        passengerPlayerEntryComponentData9.entryOrderNumber = 8

        passengerPlayerEntryComponentData10 = hueyPaxSoldierEntryComponentData:Clone(Guid('J0000000-0000-0000-0000-000000OSPREY'))
        passengerPlayerEntryComponentData10.entryOrderNumber = 9

        passengerPlayerEntryComponentData11 = hueyPaxSoldierEntryComponentData:Clone(Guid('K0000000-0000-0000-0000-000000OSPREY'))
        passengerPlayerEntryComponentData11.entryOrderNumber = 10

        passengerPlayerEntryComponentData12 = hueyPaxSoldierEntryComponentData:Clone(Guid('L0000000-0000-0000-0000-000000OSPREY'))
        passengerPlayerEntryComponentData12.entryOrderNumber = 11]]

        --[[lightningChassisComponentData.components:add(passengerPlayerEntryComponentData1)
        lightningChassisComponentData.components:add(passengerPlayerEntryComponentData2)
        lightningChassisComponentData.components:add(passengerPlayerEntryComponentData3)
        lightningChassisComponentData.components:add(passengerPlayerEntryComponentData4)
        lightningChassisComponentData.components:add(passengerPlayerEntryComponentData5)
        --[[lightningChassisComponentData.components:add(passengerPlayerEntryComponentData6)
        lightningChassisComponentData.components:add(passengerPlayerEntryComponentData7)
        lightningChassisComponentData.components:add(passengerPlayerEntryComponentData8)
        lightningChassisComponentData.components:add(passengerPlayerEntryComponentData9)
        lightningChassisComponentData.components:add(passengerPlayerEntryComponentData10)
        lightningChassisComponentData.components:add(passengerPlayerEntryComponentData11)
        lightningChassisComponentData.components:add(passengerPlayerEntryComponentData12)]]

        -- Register taskComplete

        taskComplete = true

    end

end)

-- Mod reset on round end

Events:Subscribe('Level:Destroy', function()

    print('Level destroy: mod resetting...')
    taskComplete = false

end)