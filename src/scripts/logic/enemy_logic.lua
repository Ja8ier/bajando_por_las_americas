local AI = require("src.scripts.logic.decision_tree")
local player = require("src.scripts.entities.player")

local EnemyLogic = {}

function EnemyLogic.createTree(enemy_type)

    -- Definimos las acciones (Hojas) de los ataques de enemigos comunes
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

    -- Subárbol de ataque para enemigos comunes (Tiers 1 al 4)
    local attackTree = AI.newCondition(
        function(e) return --[[ player.is_crouching ]]false end, -- Condición de jugador agachado
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

    -- Árbol Principal (Evaluador de Tiers y Eventos)
    return AI.newCondition(
        function(e) return e.tier == 5 end, -- Rama exclusiva para el Boss (Tier 5)
        AI.newCondition(
            function(e) return e.HP < 20 end,
            actionFlee,
            AI.newCondition(
                function(e) return e:get_distance_to_player() < 300 end,
                actionBossSpecial,
                actionWalk
            )
        ),
        -- Rama para enemigos comunes (Tiers 1 a 4)
        AI.newCondition(
            function(e) return e.isHealing or e.HP < 20 end,
            actionFlee,
            AI.newCondition(
                function(e) return e:getDistanceToPlayer(player) <= 300 end,
                attackTree, -- Llama al subárbol de ataque condicional
                actionWalk
            )
        )
    )
end

return EnemyLogic