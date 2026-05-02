local AI = {}

-- Nodo que hace una pregunta
function AI.newCondition(testFunc, trueChild, falseChild)
    return {
        evaluate = function(self, object, dt)
            if testFunc(object) then
                return trueChild:evaluate(object, dt)
            else
                return falseChild:evaluate(object, dt)
            end
        end
    }
end

-- Nodo que ejecuta una acción (Hoja)
function AI.newAction(actionFunc)
    return {
        evaluate = function(self, objeto, dt)
            actionFunc(objeto, dt)
        end
    }
end

return AI