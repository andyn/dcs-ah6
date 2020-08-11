-- Utility functions/classes


-- rounds the number 'num' to the number of decimal places in 'idp'
--
-- print(round(107.75, -1))     : 110.0
-- print(round(107.75, 0))      : 108.0
-- print(round(107.75, 1))      : 107.8
function round(num, idp)
    local mult = 10^(idp or 0)
    return math.floor(num * mult + 0.5) / mult
end

-- calculates the x,y,z in russian coordinates of the point that is 'radius' distance away
-- from px,py,pz using the x,z angle of 'hdg' and the vertical slant angle
-- of 'slantangle'
function pointFromVector( px, py, pz, hdg, slantangle, radius )
    local x = px + (radius * math.cos(hdg) * math.cos(slantangle))
    local z = pz + (radius * math.sin(-hdg) * math.cos(slantangle))  -- pi/2 radians is west
    local y = py + (radius * math.sin(slantangle))

    return x,y,z
end



-- jumpwheel()
-- 
-- utility function to generate an animation argument for numberwhels that animate from 0.x11 to 0.x19
-- useful for "whole number" output dials, or any case where the decimal component determines when to
-- do the rollover.  All digits will roll at the same time as the ones digit, if they should roll.
--
-- input 'number' is the original raw number (e.g. 397.3275) and which digit position you want to draw
-- input 'position' is which digit position you want to generate an animation argument
--
-- technique: for aBcc.dd, where B is the position we're asking about, we break the number up into
--            component parts:
--            
--            a is throwaway.
--            B will become the first digit of the output.
--            cc tells us whether we're rolling or not.  All digits in cc must be "9".
--            dd is used for 0.Bdd as the return if we're going to be rolling B.
--
function jumpwheel(number, position)
    local rolling = false
    local a,dd = math.modf( number )                -- gives us aBcc in a, and .dd in dd

    a = math.fmod( a, 10^position )                 -- strips a to give us Bcc in a
    local B = math.floor( a / (10^(position-1)) )   -- gives us B by itself
    local cc = math.fmod( a, 10^(position-1) )      -- gives us cc by itself

    if cc == (10^(position-1)-1) then
        rolling = true                              -- if all the digits to the right are 9, then we are rolling based on the decimal component
    end

    if rolling then
        return( (B+dd)/10 )
    else
        return B/10
    end
end


---------------------------------------------
---------------------------------------------
--[[
Weighted moving average class, useful for supplying values to gauges in an exponential decay/growth form (avoid instantaneous step values)
It keeps only a single previous value, the pseudocode is:
  prev_value = (weight*new_value + (1-weight)*prev_value)
Example usage:
myvar=WMA(0.15,0)   -- create the object (once off), first param is weight for newest values, second param is initial value, both params optional
-- use the object repeatedly, the value passed is stored internally in the object and the return value is the weighted moving average
gauge_param:set(myvar:get_WMA(new_val))

0.15 is a good value to use for gauges, it takes about 20 steps to achieve 95% of a new set point value
--]]

WMA = {} -- the table representing the class, which will double as the metatable for the instances
WMA.__index = WMA -- failed table lookups on the instances should fallback to the class table, to get methods
setmetatable(WMA, {
  __call = function (cls, ...)
    return cls.new(...) -- automatically call constructor when class is called like a function, e.g. a=WMA() is equivalent to a=WMA.new()
  end,
})

-- Create a new instance of the object.
-- latest_weight must be between 0.01 and 1,  defaults to 0.5 if not supplied.
-- init_val sets the initial value, if not supplied it will be initialized the first time get_WMA() is called
function WMA.new (latest_weight, init_val)
  local self = setmetatable({}, WMA)

  self.cur_weight=latest_weight or 0.5 -- default to 0.5 if not passed as param
  if self.cur_weight>1.0 then
  	self.cur_weight=1.0
  end
  if self.cur_weight<0.01 then
  	self.cur_weight=0.01
  end
  self.cur_val = init_val  -- can be nil if not passed, will be initialized first time get_WMA() is called
  self.target_val = self.cur_val
  return self
end

-- this updates current value based on weighted moving average with new value v, and returns the weighted moving average
-- the target value v is kept internally and can be retrieved with the get_target_val() function
function WMA:get_WMA (v)
  self.target_val = v
  if not self.cur_val then
  	self.cur_val=v
  	return self.cur_val
  end
  self.cur_val = self.cur_val+(v-self.cur_val)*self.cur_weight
  return self.cur_val
end

-- if necessary to update the current value instantaneously (bypass weighted moving average)
function WMA:set_current_val (v)
    self.cur_val = v
    self.target_val = v
end

-- if necessary to read the current weighted average value (without updating the weighted moving average with a new value)
function WMA:get_current_val ()
    return self.cur_val
end

-- read the target value (latest value passed to the get_WMA() function)
function WMA:get_target_val ()
    return self.target_val
end


---------------------------------------------
--[[
Weighted moving average class that treats [range_min,range_max] as wraparound, useful for supplying values to circular gauges in an exponential decay/growth form (avoid instantaneous step values)
It keeps only a single previous value, the pseudocode is:
  prev_value = ((prev_value+weight*(wrapped(new_value-old_value)))
Example usage:
myvar=WMA_wrap(0.15,0)   -- create the object (once off), first param is weight for newest values, second param is initial value, both params optional
-- use the object repeatedly, the value passed is stored internally in the object and the return value is the weighted moving average wrapped between range_min and range_max
gauge_param:set(myvar:get_WMA_wrap(new_val))

0.15 is a good value to use for gauges, it takes about 20 steps to achieve 95% of a new set point value
--]]

WMA_wrap = {} -- the table representing the class, which will double as the metatable for the instances
WMA_wrap.__index = WMA_wrap -- failed table lookups on the instances should fallback to the class table, to get methods
setmetatable(WMA_wrap, {
  __call = function (cls, ...)
    return cls.new(...) -- automatically call constructor when class is called like a function, e.g. a=WMA_wrap() is equivalent to a=WMA_wrap.new()
  end,
})

-- Create a new instance of the object.
-- latest_weight must be between 0.01 and 1,  defaults to 0.5 if not supplied.
-- init_val sets the initial value, if not supplied it will be initialized the first time get_WMA_wrap() is called
-- range_min defaults to 0, range_max defaults to 1
function WMA_wrap.new (latest_weight, init_val, range_min, range_max)
  local self = setmetatable({}, WMA_wrap)

  self.cur_weight=latest_weight or 0.5 -- default to 0.5 if not passed as param
  if self.cur_weight>1.0 then
  	self.cur_weight=1.0
  end
  if self.cur_weight<0.01 then
  	self.cur_weight=0.01
  end
  self.cur_val = init_val  -- can be nil if not passed, will be initialized first time get_WMA_wrap() is called
  self.target_val = self.cur_val
  self.range_min=math.min(range_min or 0.0, range_max or 1.0)
  self.range_max=math.max(range_min or 0.0, range_max or 1.0)
  self.range_delta=range_max-range_min;
  self.range_thresh=self.range_delta/8192
  return self
end

-- this can almost certainly be simplified, but I was lazy and did it the straightforward way
local function get_shortest_delta(target,cur,min,max)
	local d1,d2,delta
	if target>=cur then
		d1=target-cur
		d2=cur-min+(max-target)
		if d2<d1 then
			delta=-d2
		else
			delta=d1
		end
	else
		d1=cur-target
		d2=target-min+(max-cur)
		if d1<d2 then
			delta=-d1
		else
			delta=d2
		end
	end
	return delta
end

-- this updates current value based on weighted moving average with new value v, and returns the weighted moving average
-- the target value v is kept internally and can be retrieved with the get_target_val() function
-- it wraps within [range_min,range_max] and also moves in the shortest direction (clockwise or anticlockwise) between two points
function WMA_wrap:get_WMA_wrap (v)
  self.target_val = v
  if not self.cur_val then
  	self.cur_val=v
  	return self.cur_val
  end
  delta=get_shortest_delta(v, self.cur_val, self.range_min, self.range_max)
  self.cur_val=self.cur_val+(delta*self.cur_weight)
  if math.abs(delta)<self.range_thresh then
    self.cur_val=self.target_val
  end
  if self.cur_val>self.range_max then
  	self.cur_val=self.cur_val-self.range_delta
  elseif self.cur_val<self.range_min then
  	self.cur_val=self.cur_val+self.range_delta
  end
  return self.cur_val
end

-- if necessary to update the current value instantaneously (bypass weighted moving average)
function WMA_wrap:set_current_val (v)
    self.cur_val = v
    self.target_val = v
end

-- if necessary to read the current weighted average value (without updating the weighted moving average with a new value)
function WMA_wrap:get_current_val ()
    return self.cur_val
end

-- read the target value (latest value passed to the get_WMA_wrap() function)
function WMA_wrap:get_target_val ()
    return self.target_val
end

