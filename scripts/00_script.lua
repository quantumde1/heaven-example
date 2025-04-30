-- Функция для сравнения двух таблиц
function tablesEqual(table1, table2)
    if #table1 ~= #table2 then
        return false
    end
    for i = 1, #table1 do
        if table1[i] ~= table2[i] then
            return false
        end
    end
    return true
end

function checkCoordinatesEquality(x_current, y_current, z_current, x_needed, y_needed, z_needed)
    local deviation = 4
    if (x_current >= x_needed - deviation and x_current <= x_needed + deviation) then
        if (y_current >= y_needed - deviation and y_current <= y_needed + deviation) then
            if (z_current >= z_needed - deviation and z_current <= z_needed + deviation) then
                return true
            else
                return false
            end
        else
            return false
        end
    else
        return false
    end
    return false
end

local cameraMoveStartTime = 0
local cameraMoveDuration = 2.0
local isCameraMoving = false
local cameraStartPos = {x = 0, y = 0, z = 0}
local cameraTargetPos = {x = 0, y = 0, z = 0}

function startSmoothCameraMove(targetX, targetY, targetZ, duration)
    cameraStartPos.x = getCameraX()
    cameraStartPos.y = getCameraY()
    cameraStartPos.z = getCameraZ()
    cameraTargetPos.x = targetX
    cameraTargetPos.y = targetY
    cameraTargetPos.z = targetZ
    cameraMoveStartTime = getTime()
    cameraMoveDuration = duration or 2.0
    isCameraMoving = true
end

function updateSmoothCameraMove()
    if not isCameraMoving then return end
    
    local elapsed = getTime() - cameraMoveStartTime
    local progress = math.min(elapsed / cameraMoveDuration, 1.0)
    
    local smoothProgress = progress * progress * (3 - 2 * progress)
    
    local currentX = cameraStartPos.x + (cameraTargetPos.x - cameraStartPos.x) * smoothProgress
    local currentY = cameraStartPos.y + (cameraTargetPos.y - cameraStartPos.y) * smoothProgress
    local currentZ = cameraStartPos.z + (cameraTargetPos.z - cameraStartPos.z) * smoothProgress
    
    changeCameraPosition(currentX, currentY, currentZ)
    
    if progress >= 1.0 then
        isCameraMoving = false
    end
end

function _2dEventLoopCoroutine()
    dialogCoroutine = coroutine.create(function()
        if currentStage == 0 then
            disallowControl()
            startTime = getTime()
            while getTime() - startTime < 1.0 do
                coroutine.yield() -- Wait for 1 second
            end
            
            rotateCamera(50, 40)
            while isCameraRotating() do
                coroutine.yield()
            end
            
            startTime = getTime()
            while getTime() - startTime < 0.5 do
                coroutine.yield()
            end
            
            rotateCamera(130, 40)
            while isCameraRotating() do
                coroutine.yield()
            end
            
            startTime = getTime()
            while getTime() - startTime < 0.5 do
                coroutine.yield()
            end
            
            rotateCamera(90, 40)
            while isCameraRotating() do
                coroutine.yield()
            end
            
            showHint("Where... where am I?...")
            startTime = getTime()
            while getTime() - startTime < 2.0 do
                coroutine.yield()
            end
            hideHint()
            
            dialogBox("Announcer", {
                "Our next story tonight concerns the upcoming virtual city, \"Paradigm X\"",
                "While its public opening is coming soon, creator Algon Software is reportedly being flooded with beta applications.",
                "The number of users is so great that the company is unable to shut down the site for new user registrations."
            }, "news_reporter.png", -1, {""}, 0)
            
            while isDialogExecuted() do
                coroutine.yield()
            end
            
            startTime = getTime()
            while getTime() - startTime < 2.0 do
                coroutine.yield()
            end
            hideHint()
            allowControl()
            currentStage = 1
        end
        
        if currentStage == 2 then
            hideHint()
            showHint("Picked up an \"Old key.\"")
            startTime = getTime()
            while getTime() - startTime < 2.0 do
                coroutine.yield()
            end
            hideHint()
            currentStage = 3
        end
        
        if currentStage == 3 then
            stopMusic()
            startTime = getTime()
            while getTime() - startTime < 2.0 do
                coroutine.yield()
            end
            
            reloadShaderFragment("res/normal_shader.fs")
            reloadShaderVertex("res/normal_shader.vs")
            loadScene("res/scene2.json")
            loadMusicExternal("res/heavens_night.mp3")
            playMusic()
            disallowControl()
            saveCameraState()
            local playerX, playerY, playerZ = getPlayerX(), getPlayerY(), getPlayerZ()
            startSmoothCameraMove(playerX-10.0, playerY+5.0, playerZ+5.0, 2.0)
            changeCameraTarget(0.0, 5.0, 0.0)
            changeCameraUp(0.0, 1.0, 0.0)
            while isCameraMoving do
                rotateCamera(200.0, 60)
                coroutine.yield()
            end
            while isCameraRotating() do
                coroutine.yield()
            end
            startTime = getTime()
            while getTime() - startTime < 2.0 do
                coroutine.yield()
            end
            rotateCamera(getOldCameraAngle(), 0)
            while isCameraRotating() do
                coroutine.yield()
            end
            resetCameraState()
            allowControl()
        end
    end)
end

function EventLoop()
    if currentStage == 1 then
        if checkCoordinatesEquality(getPlayerX(), getPlayerY(), getPlayerZ(), 0, 0, -10) == true then
            showHint("Key is lying here.")
            if isKeyPressed(getButtonName("dialog")) then
                startTime = getTime()
                currentStage = 2
                addToInventoryTab("Old key", 0)
                _2dEventLoopCoroutine()
            end
        else
            hideHint()
        end
    end
    if currentStage == 3 then
        if checkCoordinatesEquality(getPlayerX(), getPlayerY(), getPlayerZ(), 0.34, 0, 25) == true then
            showHint("Open the door?")
            if isKeyPressed(getButtonName("dialog")) then
                startTime = getTime()
                currentStage = 1
                _2dEventLoopCoroutine()
            end
        else
            hideHint()
        end
    end
    updateSmoothCameraMove()
    
    if dialogCoroutine and coroutine.status(dialogCoroutine) ~= "dead" then
        coroutine.resume(dialogCoroutine)
    end
end

setFriendlyZone(1)
setPlayerModel("res/mc.glb", 1.0, 1.0, 1.0)
setPlayerCollisionSize(3.0, 3.0, 3.0)
setCameraRotationSpeed(1.16)
addPartyMember(120, 0, "quantumde1", 1, 0, 0)
walkAnimationValue(10)
idleAnimationValue(2)
runAnimationValue(6)
changeCameraPosition(0.0, 10.0, 15.0)
changeCameraTarget(0.0, 4.0, 0.0)
changeCameraUp(0.0, 1.0, 0.0)
drawPlayerModel(1);
configureInventoryTabs({"Items", "System"})
addToInventoryTab("Exit game", 1)
reloadShaderFragment("res/fog_shader.fs")
reloadShaderVertex("res/normal_shader.vs")
loadScene("res/scene1.json")
animationsState(1)
_2dEventLoopCoroutine()
