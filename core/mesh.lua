--[[
-- Mesh help and helper functions 
--]]

require 'table'

require 'core.util'
require 'core.nloop'
require 'core.pos'
require 'core.extrude'

-- move things into global namespace
mesh = fg.mesh
face = fg.face
vertex = fg.vertex

-- help

-- types
document[[a vertex is a part of a mesh.
	Attributes:
	p -- position
	n -- normal	(read-only)
	c -- colour
	valid -- true if the vertex is still part of a mesh
	Member functions:
	calculate_normal -- recalculate the normal based on the adjacent faces	
	set_uv(u,v) -- set the uv coordinates
	get_adjacent_face -- returns an adjacent face	
]](vertex)

document[[a face is a triangle within a mesh.
	Attributes:
	n -- normal
	valid -- true if the face is still part of a mesh
	Member functions:
	calculate_normal -- recalculate the normal
	v(i) -- return the i'th vertex of this face (i = 0 to 2)
]](face)

document[[mesh is a triangular mesh. You construct a mesh as a primitive (cube,icosahedron,etc.) or with load_mesh().
	Member functions:
	subdivide(n) -- subdivide the mesh n times
	smooth_subdivide(n) -- smooth subdivide the mesh n times (Loop Subdivision)
	sync() -- recalculate all the vertex and face normals
	apply_transform(mtx) -- apply the transform matrix to the mesh vertices
	clone():mesh -- copy the mesh 		
]](mesh)

foreach({mesh,vertex,face}, function(_,f) categorise(f,"mesh") end)

-- primitives
document[[cube() makes a cube mesh]](cube)
document[[sphere() makes a spherical mesh]](sphere)
document[[icosahedron() makes an icosahedron mesh]](icosahedron)
document[[tetrahedron() makes a tetrahedron mesh]](tetrahedron)
document[[dodecahedron() makes a dodecahedron mesh]](dodecahedron)
document[[octahedron() makes an octahedron mesh]](octahedron)
document[[cone(outer_radius,inner_radius,resolution) makes a cone mesh]](cone)
document[[cylinder(res) makes a cylinder mesh]](cylinder)
document[[iso(res,f) creates an isosurface from function f(x,y,z) within a 2x2x2 space of resolution res]](iso)

foreach({cube,sphere,icosahedron,tetrahedron,dodecahedron,octahedron,cone,cylinder,iso}, function(_,f) categorise(f,"mesh") end)

load_mesh = fg.mesh.load
document[[load_mesh(file) loads a mesh from a file. supported formats: obj]](load_mesh)
categorise(load_mesh,"mesh")

-- operations

split_edge = fg.split_edge
document[[split_edge(mesh,pos) splits the edge in pos into two and retriangulates the adjacent faces]](split_edge) 
categorise(split_edge, "mesh")

-- helpers


-- return a list of all vertices in a mesh
function vertexlist(mesh)
	local vl = {}
 	local all = mesh:selectAllVertices()
	for v in all.verts do
		table.insert(vl,v)
	end
	return vl
end
document[[vertexlist(m:mesh) returns a list of all vertices in the mesh m]](vertexlist)
categorise(vertexlist,"mesh")

-- return a list of all faces in a mesh
function facelist(mesh)
	local fl = {}
 	local all = mesh:selectAllFaces()
	for f in all.faces do
		table.insert(fl,f)
	end
	return fl
end
document[[facelist(m:mesh) returns a list of all faces in the mesh m]](facelist)
categorise(facelist,"mesh")

-- applies f to each vertex in the mesh
function foreachv(mesh,f)
	local all = mesh:selectAllVertices()
	for v in all.verts do
		f(v)
	end
end
document[[foreachv(m:mesh,f:function) applies f to each vertex in m]](foreachv)
categorise(foreachv,"mesh")

-- return a list of vertices within edge distance n to v
function nearbyv(mesh, v, n)
	local vl = {}
	local near = fg.getVerticesWithinDistance(mesh,v,n)
	for v in near.verts do
		table.insert(vl,v)
	end
	return vl
end
document[[nearbyv(m:mesh,v:vertex,n:integer) returns a list of vertices with edge distance n of v]](nearbyv)
categorise(nearbyv,"mesh")

-- convert a list of vertices to a list of all adjacent faces
function tofaces(vl)
	local unique = {}
	
	local function addUnique(f)
		for _,u in ipairs(unique) do 
			if u==f then return end
		end
		table.insert(unique,f)
	end
	
	for i,v in ipairs(vl) do		
		local pl = fgx.nloop.loopp(v)
		for _,f in fgx.pos.ifaces(pl) do
			addUnique(f)
		end
	end
		
	return unique
end
document[[tofaces(vl:list) returns a list of those faces adjacent to the vertices in vl]](tofaces)
categorise(tofaces,"mesh")

-- inset the edge loop around a vertex
function inset(mesh,vertex,scale)
	local direction = vertex.n	
	local ddotd = dot(direction,direction)	
	local vdotd = dot(vertex.p,direction)
	local vp = vertex.p
		
	-- do a basic extrude
	extrude(mesh,vertex,direction,0)
	
	-- then scale the vertex positions
	local posfan = loopp(vertex)
	for _,pos in ipairs(posfan) do
		-- to get the outside vertex we need to flipV the pos
		pos:flip_v()
		n = pos.v
		-- n.p = n.p + direction*(magnitude + (vdotd-dot(n.p,direction))/ddotd)		
		n.p = lerp(vp,n.p,scale)
		pos:flip_v()
	end
	return posfan		
end
document[[inset(m:mesh,v:vertex,s:number) insets all the faces surrounding vertex v and scales them by s]](inset) 
categorise(inset,"mesh")

-- flatten a list of vertices so they align on the plane specified by position and normal
function flattenvl(mesh,vertexlist,position,normal)
	table.foreachi(vertexlist, function(i,v)
		v.p = v.p - normal*dot(v.p-position,normal)
	end)
end
document[[flattenvl(m:mesh,vl:list,p:vec3,n:vec3) flattens a list of vertices, vl, so they align on the plane specified by p and n]](flattenvl)
categorise(flattenvl,"mesh")
