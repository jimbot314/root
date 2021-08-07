local Maid = {}
Maid.__index = Maid

function Maid:New()
	local maid = {}
	maid._tasks = {}
	setmetatable(maid, Maid)
	return maid
end

function Maid:GiveTask(task)
	local tasks = self._tasks
	local len = #tasks
	tasks[len + 1] = task
	return len
end

function Maid:Destroy(id)
	local tasks = self._tasks
	for i=1,#tasks do
		local task = tasks[i]
		
		self:_DoCleaning(task)
	end
	table.clear(self._tasks)
end

function Maid:_DoCleaning(task)
	local taskType = typeof(task)
	if (taskType == "function") then
		task()
	elseif (taskType == "RBXScriptConnection") then
		task:Disconnect()
	end
end

return Maid
