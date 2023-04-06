return function (registry)
	registry:RegisterHook("BeforeRun", function(context)
		if context.Executor.UserId ~= 99976297 and context.Executor.UserId ~= 75268253 then
			return "You don't have permission to use this command"
		end
	end)
end

--alexander 1j's userID and Ranything's userID
-- 99976297