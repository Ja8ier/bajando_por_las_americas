local AI = require("src.scripts.logic.decision_tree")
local player = require("src.scripts.entities.player")

local EnemyLogic = {}

function EnemyLogic.createTree()

    --ataques con armas
    local actionCommonWeapon = AI.newAction(function(e, dt) e:commonWeaponAttack(dt, player) end)
    local actionSpecialBottle = AI.newAction(function(e, dt) e:specialBottleAttack(dt, player) end)
    local actionSpecialKnife = AI.newAction(function(e, dt) e:specialKnifeAttack(dt, player) end)
    local actionSpecialBat = AI.newAction(function(e, dt) e:specialBatAttack(dt, player) end)
    local actionSpecialWrench = AI.newAction(function(e, dt) e:specialWrenchAttack(dt, player) end)

    -- ataques sin armas
    local actionJab = AI.newAction(function(e, dt) e:jabAttack(dt, player) end)
    local actionCombo = AI.newAction(function(e, dt) e:comboAttack(dt, player) end)
    local actionSweep = AI.newAction(function(e, dt) e:sweepKick(dt, player) end)
    local actionSlam = AI.newAction(function(e, dt) e:groundSlam(dt, player) end)
    local actionHeavy = AI.newAction(function(e, dt) e:heavySmash(dt, player) end)

    -- Acción del Boss
    local actionBossSpecial = AI.newAction(function(e, dt) e:specialAttackBoss(dt, player) end)

    -- Acciones de movimiento y estado
    local actionFlee = AI.newAction(function(e, dt) e:stateFlee(dt, player) end)
    local actionWalk = AI.newAction(function(e, dt) e:statePatrol(dt) end)

    -- Subárbol para enemigos desarmados (Tiers 1 al 4)
    local unarmedAttackTree = AI.newCondition(
        function(e) return player.isCrouching end, -- Condición de jugador agachado
        actionSweep,
        AI.newCondition(
            function(e) return e.tier == 1 end,
            AI.newCondition( -- Tier 1: 20% Combo, 80% Jab
                function(e) return math.random() < 0.20 end,
                actionCombo,
                actionJab
            ),
            AI.newCondition(
                function(e) return e.tier == 2 end,
                AI.newCondition( -- Tier 2: 35% Slam, 15% Combo, 50% Jab
                    function(e) return math.random() < 0.35 end,
                    actionSlam,
                    AI.newCondition(
                        function(e) return math.random() < 0.23 end,
                        actionCombo,
                        actionJab
                    )
                ),
                AI.newCondition(
                    function(e) return e.tier == 3 end,
                    AI.newCondition( -- Tier 3: 25% Slam, 33% Heavy, 42% Combo/Jab
                        function(e) return math.random() < 0.25 end,
                        actionSlam,
                        AI.newCondition(
                            function(e) return math.random() < 0.33 end,
                            actionHeavy,
                            AI.newCondition(
                                function(e) return math.random() < 0.50 end,
                                actionCombo,
                                actionJab
                            )
                        )
                    ),
                    -- Tier 4: Mayor probabilidad de ataques pesados y especiales
                    AI.newCondition( 
                        function(e) return math.random() < 0.20 end,
                        actionSlam,
                        AI.newCondition(
                            function(e) return math.random() < 0.35 end,
                            actionHeavy,
                            AI.newCondition(
                                function(e) return math.random() < 0.60 end,
                                actionCombo,
                                actionJab
                            )
                        )
                    )
                )
            )
        )
    )

    -- Subárbol para cuando el enemigo tiene un arma
    local weaponAttackTree = AI.newCondition(
        function(e) return player.isCrouching end, -- Condición de jugador agachado
        actionSweep,
        AI.newCondition(
            function(e) return math.random() < e:getSpecialProbability() end, -- Probabilidad de ataque especial
            AI.newCondition(
                function(e) return e.weapon == "bottle" end,
                actionSpecialBottle,
                AI.newCondition(
                    function(e) return e.weapon == "knife" end,
                    actionSpecialKnife,
                    AI.newCondition(
                        function(e) return e.weapon == "bat" end,
                        actionSpecialBat,
                        actionSpecialWrench -- Por defecto, si el arma es "wrench"
                    )
                )
            ),
            actionCommonWeapon -- Por defecto, si no se cumple la probabilidad del especial, golpea normal
        )
    )

    local bossWeaponAttackTree = AI.newCondition(
        function(e) return e.weapon == "bottle" end,
        actionSpecialBottle,
        AI.newCondition(
            function(e) return e.weapon == "knife" end,
            actionSpecialKnife,
            AI.newCondition(
                function(e) return e.weapon == "bat" end,
                actionSpecialBat,
                actionSpecialWrench -- Por defecto, si el arma es "wrench"
            )
        )
    )

    -- Árbol Principal (Evaluador de Tiers y Eventos)
    return AI.newCondition(
        function(e) return e.tier == 5 end, -- Rama exclusiva para el Boss (Tier 5)
        AI.newCondition(
            function(e) return e.isHealing or e.HP < e.maxHP * 0.20 end,
            actionFlee,
            AI.newCondition(
                function(e) return e:getDistanceToPlayer(player) <= 350 end,
                AI.newCondition(
                    function(e) return math.random() < 0.2 end,
                    actionBossSpecial,
                    bossWeaponAttackTree
                ),
                actionWalk
            )
        ),
        -- Rama para enemigos comunes
        AI.newCondition(
            function(e) return e.isHealing or e.HP < e.maxHP * 0.15 end,
            actionFlee,
            AI.newCondition(
                function(e) return e:getDistanceToPlayer(player) <= 300 end,
                -- Bifurcación entre atacante desarmado o con arma
                AI.newCondition(
                    function(e) return e.hasWeapon == true end,
                    weaponAttackTree,
                    unarmedAttackTree
                ),
                actionWalk
            )
        )
    )
end

return EnemyLogic