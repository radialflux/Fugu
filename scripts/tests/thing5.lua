--[[
	A thing	
--]]

module(...,package.seeall)

require "table"

local m = nil -- the mesh
local time = 0
local tentacle = nil
local sphereVerts = nil -- all verts on the initial sphere

local suckers = {}

function randomElement(t)
	return t[math.floor(random(1,#t+1))]	
end

function convertToTable(vtxSet)
	local t = {}
	for v in vtxSet.all do
		table.insert(t,v)
	end
	return t
end

function setup()
	m = fg.mesh.primitives.sphere()	
	m:smoothSubdivide(1)
	fgu:addMesh(m)
	
	sphereVerts = convertToTable(m:selectAllVertices())

	for i=1,200 do
		local el = sphereVerts[i] -- randomElement(sphereVerts)
		table.insert(suckers,new_thing(el,random(0,10),random(1,3)))
	end
end

function update(dt)
	time = time + dt

	table.foreachi(suckers, 
		function(i,thing)
			if (thing~=nil) then
				if (not thing:update(dt)) then suckers[i] = nil end		
			end
		end)

end

-- Give step function a list of (x,t) pairs (0<=x<=1)
-- and it returns a function which maps from 0<x<1 to t
function stepFunction(list)
	local f = function(x)
		for i,xt in ipairs(list) do
			if (x < xt[1]) then return xt[2] end
		end -- for
		-- else
		return list[#list][2]
	end -- f
	return f
end

function new_thing(v,p,s) -- use the global mesh m
	local obj = {
		vertex = v,
		phase = p,
		speed = s,
		numSegments = 10,
		totalLength = 1,
		hasGrown = false, -- has this sucker gone through the grow phase?
		edgeRings = {} -- keep track of the rings of vertices so we can animate them
	}

	obj.growSucker = function(self,dt)
		-- specifies the length of the extrusion, expansion, and direction
		-- as a function of u, where u is between 0 and 1
		local n = self.vertex:getN()
		n:normalise()
		expandFactor = 1
		dir = vec3(0,0,0)
		function f(u)
			--local len = stepFunction({{0.5,random(.6,.8)},{.6,.01},{.7,-.2},{1.1,-.1}})(u)
			local len = 1
			local du = 0 -- normalised within section

			if (u<.2) then 
				du = u/.2
				len = lerp(-.05,-.6,du)
			elseif (u<.3) then
				len = 0
			else 
				len = 1
				du = (u-.3)/.7
			end

			local exp = nil 
			if (u < .2) then exp = lerp(-.3,0,du)
			elseif (u<.3) then exp = -.3
			else exp = lerp(0,-.4,du)
			end

			--[[
			if (u<.6) then 
				exp = lerp(-.2,0,u/.6) 
			elseif (u<.8) then
				exp = lerp(2,0,(u-.6)/.2) 
			else
				exp = lerp(0,-.3,(u-.8)/.2)
			end
			--]]

			-- stepFunction({{.1,random(0,.1)},{.3,random(.1,.5)},{.6,0},{1.1,-.3}})(u)
			local d = nil
			local R = .2
			local r = vec3(0,1.5*u,0) -- vec3(random(-R,R),random(-R,R),random(-R,R))
			if (len > 0) then d = n else d = n*-1 end
			d = (d+r)
			d:normalise()
			return math.abs(len)*self.totalLength/self.numSegments, expandFactor*exp, d
		end
		
		for k=1,self.numSegments do
			len,exp,dir = f((k-1)/(self.numSegments-1))
			fg.extrude(m,self.vertex,1,dir,len,exp)
			
			-- store the center, edge ring, and original edge ring positions			
			local ring = convertToTable(fg.getVerticesAtDistance(m,self.vertex,1))

			local ringDP = {}
			table.foreachi(ring,function(i,r) 			
				table.insert(ringDP,r:getPos() - self.vertex:getPos()) 
			end)
			table.insert(self.edgeRings,
				{center=self.vertex:getPos(),
				ring=ring,
				ringDP=ringDP})
			-- recompute the normals if needed
			m:sync()										
		end	

		self.hasGrown = true
	end

	obj.animateSucker = function(self,dt)
		--[[
		table.foreachi(self.edgeRings, function(i, er)
			for i=1,#er.ring do
				if (er.ring[i].valid) then
					local s = math.sin(self.speed*2*time + self.phase)
					s = math.pow(s,4)
					er.ring[i]:setPos(er.center + er.ringDP[i]*(1+0.5*s))
				end
			end
		end)
		m:sync()
		--]]
	end

	obj.update = function(self,dt)
		if (not self.vertex.valid) then 
			print("a sucker's leading vertex has become invalid!")
			return false
		end

		if (not self.hasGrown) then 
			self:growSucker() 
		else 
			self:animateSucker()
		end

		return true

	end
	return obj
end


