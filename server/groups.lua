-- ============================================
-- RealRPG Dashboard - Groups/Frakciók
-- ESX Legacy - jobs rendszer
-- ============================================

ESX = exports['es_extended']:getSharedObject()

-- ============================================
-- REQUEST GROUPS/JOBS DATA
-- ============================================
RegisterNetEvent('dashboard:requestGroups')
AddEventHandler('dashboard:requestGroups', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    local job = xPlayer.getJob()
    local groups = {}

    -- If player has a job (not 'unemployed')
    if job.name ~= 'unemployed' then
        -- Count members in same job
        local memberCount = 0
        local xPlayers = ESX.GetExtendedPlayers('job', job.name)
        memberCount = #xPlayers

        -- Get all job grades
        local grades = MySQL.Sync.fetchAll('SELECT grade, label FROM job_grades WHERE job_name = ? ORDER BY grade ASC', { job.name })

        local allMembers = {}
        -- Get all members of this job from DB (online + offline)
        local jobMembers = MySQL.Sync.fetchAll([[
            SELECT u.identifier, u.firstname, u.lastname, u.job_grade, u.last_login
            FROM users u
            WHERE u.job = ?
            ORDER BY u.job_grade DESC, u.lastname ASC
        ]], { job.name })

        local totalMembers = #(jobMembers or {})

        -- Build member list (max 50)
        for i, member in ipairs(jobMembers or {}) do
            if i > 50 then break end
            local isOnline = false
            local xMemberPlayers = ESX.GetExtendedPlayers()
            for _, xP in pairs(xMemberPlayers) do
                if xP.getIdentifier() == member.identifier then
                    isOnline = true
                    break
                end
            end

            local gradeName = 'Ismeretlen'
            if grades then
                for _, g in ipairs(grades) do
                    if g.grade == member.job_grade then
                        gradeName = g.label
                        break
                    end
                end
            end

            table.insert(allMembers, {
                name = (member.firstname or '') .. ' ' .. (member.lastname or ''),
                grade = member.job_grade,
                gradeLabel = gradeName,
                online = isOnline,
                lastLogin = member.last_login,
            })
        end

        -- Grade list
        local gradeList = {}
        for _, g in ipairs(grades or {}) do
            table.insert(gradeList, { grade = g.grade, label = g.label })
        end

        table.insert(groups, {
            id = job.name,
            name = job.label,
            rank = job.grade_label,
            rankGrade = job.grade,
            memberCount = totalMembers,
            onlineCount = memberCount,
            members = allMembers,
            grades = gradeList,
        })
    end

    -- Check if player has a second job (gang/society etc.)
    -- Some servers use job2 field or separate gang system
    local job2Result = MySQL.Sync.fetchScalar('SELECT job2 FROM users WHERE identifier = ?', { xPlayer.getIdentifier() })
    if job2Result and job2Result ~= '' and job2Result ~= 'none' and job2Result ~= 'unemployed' then
        local job2Name = job2Result
        local job2Info = MySQL.Sync.fetchAll('SELECT label FROM jobs WHERE name = ?', { job2Name })
        local job2Label = (job2Info and job2Info[1]) and job2Info[1].label or job2Name

        local job2Grade = MySQL.Sync.fetchScalar('SELECT job2_grade FROM users WHERE identifier = ?', { xPlayer.getIdentifier() }) or 0
        local job2GradeInfo = MySQL.Sync.fetchAll('SELECT label FROM job_grades WHERE job_name = ? AND grade = ?', { job2Name, job2Grade })
        local job2GradeLabel = (job2GradeInfo and job2GradeInfo[1]) and job2GradeInfo[1].label or 'Tag'

        local job2Members = MySQL.Sync.fetchScalar('SELECT COUNT(*) FROM users WHERE job2 = ?', { job2Name }) or 0

        table.insert(groups, {
            id = job2Name,
            name = job2Label,
            rank = job2GradeLabel,
            rankGrade = job2Grade,
            memberCount = job2Members,
            onlineCount = 0,
            members = {},
            grades = {},
        })
    end

    TriggerClientEvent('dashboard:receiveGroups', src, groups)
end)
