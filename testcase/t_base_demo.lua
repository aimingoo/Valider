--------------------------------------------------------
--
-- the test of Valider.lua module in NGX_4C
--
--------------------------------------------------------

local sleep = function(n) os.execute("sleep " .. n) end
local Valider = dofile('../Valider.lua')

--------------------------------------------------------
--
-- base and static samples
--
--------------------------------------------------------
local status = {
	false, false, false, false, false, false, false, true, false, false, true, false, false, false, false, false, false, false, 	-- 16
	false, false, true, false, false, false, false, false, false, false, false, false, false, false, false,							-- 14
	false, false, false, false, true, false, true, false, false, false, true, false, true, false, false, false, false, false,		-- 14
	false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, 	-- 18
	false, false, false, false, true, false, true, false, false, false, true, false, true, false, false, false, false, false,		-- 14
	false, false, false, false, false, false, false, false, false, false, true, false, false, false, false, false, false, false, 	-- 17
	false, false, false, false, true, false, true, false, false, false, true, false, true, false, false, false, false, false,		-- 14
}

--
-- test case 1
--		break at #33	invalid over maxTimes:	30
--

-- checker with default setting
local checker = Valider:new({
	-- maxContinuousInterval = 3,
	-- maxContinuous = 100,	-- continuous invalid X times (default 100), or
	-- maxTimes = 30,			-- invalid X times in Y seconds history (default is 30 times in 30s)
	-- maxSeconds = 30			-- (max history seconds, default is 30s)
})
print('==> testcase 1')
local now = os.time()
for i, state in ipairs(status) do
	if not state and checker:invalid('case1') then
		print('run ' .. tostring(os.time()-now) .. 's',
			'break at #' .. tostring(i),
			'invalid over maxTimes:', checker.maxTimes)
		break
	end
	print(i, '-->', state)
	sleep(0.1)
end

--
-- test case 2, output
--		break at #115	invalid over maxContinuous:	100
--

-- invald 100 continuous and interval < 3s
local checker = Valider:new({
	maxContinuousInterval = 3,
	maxContinuous = 100,
	maxTimes = 30000,	-- or, 30000 times in 30s
})
print('\n==> testcase 2')
local now = os.time()
for i, state in ipairs(status) do
	if not state and checker:invalid('case2') then
		print('run ' .. tostring(os.time()-now) .. 's',
			'break at #' .. tostring(i),
			'invalid over maxContinuous:', checker.maxContinuous)
		break
	end
	if i%10 == 0 then print(i, '-->', state) end
end

--------------------------------------------------------
--
-- random samples testcases
--
--------------------------------------------------------

--
-- test case 3, random
--

-- invald 3 continuous and interval < 3s
local checker = Valider:new({
	maxContinuousInterval = 8,
	maxContinuous = 5,
	maxTimes = 30000,	-- or, 30000 times in 30s
})
print('\n==> testcase 3')
local now = os.time()
math.randomseed(os.time())
while true do
	local state = (math.random(100) % 2) == 0
	if not state and checker:invalid('case3') then
		print('run ' .. tostring(os.time()-now) .. 's',
			'break, invalid over maxContinuous in maxContinuousInterval(8s):', checker.maxContinuous)
		break
	end

	print('-->', state,	checker['case3'] and checker['case3'][4])
	sleep(1)
end


--
-- test case 4, multi tags
--

-- invald 3 continuous and interval < 3s
--	1) skip re-create, use more tags in the <checker>
print('\n==> testcase 4')
local now = os.time()
math.randomseed(os.time())
while true do
	local state1 = (math.random(100) % 2) == 0
	if not state1 and checker:invalid('tag1') then
		print('break in tag1, invalid over maxContinuous in maxContinuousInterval(8s):', checker.maxContinuous)
		break
	end

	local state2 = (math.random(5) % 2) == 0
	if not state2 and checker:invalid('tag2') then
		print('break in tag2, invalid over maxContinuous in maxContinuousInterval(8s):', checker.maxContinuous)
		break
	end

	print('--> tag1/tag2 is: ',
		table.concat({tostring(state1), tostring(state2)}, '/'),
		table.concat({checker.tag1 and tostring(checker.tag1[4]),
					  checker.tag2 and tostring(checker.tag2[4])}, '/'))
	sleep(1)
end