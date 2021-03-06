set(SRC 
	armature.cpp
	bindings.cpp
	face.cpp
	fg.cpp
	functions.cpp
	geometry.cpp
	glrenderer.cpp
	glrenderer_glutprimitives.cpp	
	mat4.cpp	
	mesh.cpp	
	meshimpl.cpp
	meshoperators.cpp
	meshoperators_vcg.cpp
	meshnode.cpp
	node.cpp
	nodegraph.cpp	
	phyllo.cpp
	plylib.cpp
	pos.cpp	
	ppm.cpp
	proxy.cpp
	quat.cpp	
	universe.cpp	
	vec3.cpp
	vertex.cpp	

	gc/crosssectioncircular.cpp	
	gc/generalisedcylinder.cpp	
	gc/interpcrosssec.cpp	
	gc/lincarrier.cpp
	gc/morphcrosssec.cpp
	gc/pbezcarrier.cpp
	gc/pbezinterpdiv.cpp
	gc/recsubdiv.cpp	
	gc/scaleinterpcrosssec.cpp
	gc/turtle.cpp	

	gc/generalisedcylinderimpl.cpp
	gc/frontpoly.cpp
	gc/impltri.cpp
	)

set(HDRS
	armature.h
	bindings.h
	exportmeshnode.h
	face.h
	fg.h
	functions.h
	geometry.h
	glrenderer.h
	mat4.h
	mesh.h
	meshimpl.h
	meshnode.h
	meshoperators.h
	meshoperators_vcg.h
	node.h
	nodegraph.h
	operator.h
	phyllo.h
	pos.h
	ppm.h
	proxy.h	
	quat.h
	universe.h
	util.h
	vec3.h
	vertex.h
	
	gc/bezinterp.h
	gc/carriercurve.h
	gc/crinterp.h
	gc/lincarrier.h
	gc/pbezcarrier.h
	gc/crosssection.h
	gc/crosssectioncircular.h
	gc/generalisedcylinder.h
	gc/interpcrosssec.h
	gc/interpolator.h
	gc/lininterp.h
	gc/morphcrosssec.h
	gc/pbezinterp.h
	gc/pbezinterpdiv.h
	gc/recsubdiv.h
	gc/scaleinterpcrosssec.h
	gc/turtle.h

	gc/generalisedcylinderimpl.h
	gc/frontpoly.h
	gc/impltri.h
	)

set(INLS
	functions.inl
	proxy.inl 
	
	gc/bezinterp.inl
	gc/crinterp.inl
	gc/interpolator.inl
	gc/lininterp.inl
	gc/pbezinterp.inl
)

# FILE(GLOB HEADERS "*.h")
# FILE(GLOB HEADER_INC "*.inc")

add_library(fg ${SRC} ${HDRS} ${INLS})
target_link_libraries(fg ${LUA_LIBS} ${GL_LIBS})
