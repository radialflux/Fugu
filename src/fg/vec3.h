/**
 * \file
 * \author ben
 * 
 * \cond showlicense
 * \verbatim
 * --------------------------------------------------------------
 *    ___     
 *   |  _|___ 
 *   |  _| . | fg: real-time procedural 
 *   |_| |_  | animation and generation 
 *       |___| of 3D forms
 *
 *   Copyright (c) 2011 Centre for Electronic Media Art (CEMA)
 *   Monash University, Australia. All rights reserved.
 *
 *   Use of this software is governed by the terms outlined in 
 *   the LICENSE file.
 * 
 * --------------------------------------------------------------
 * \endverbatim
 * \endcond
 */

#ifndef FG_VEC3_H
#define FG_VEC3_H

#include <ostream>

#include <vcg/space/point3.h>

namespace fg {
	
	/**
	 * \brief A 3D vector class
	 *
	 * Currently it subclasses vcg::Point3d, and provides an adjusted interface, 
	 * both for the fg C++ api and for the lua bindings.
	 */
	class Vec3: public vcg::Point3d {
		public:
			Vec3(const vcg::Point3d& p){
				vcg::Point3d();
				X() = p.X();
				Y() = p.Y();
				Z() = p.Z();
			}

			Vec3();
			Vec3(double x, double y, double z);

		// interface for lua bindings
		public:
			double getX() const {return X();}
			void setX(double x){X() = x;}
			double getY() const {return Y();}
			void setY(double y){Y() = y;}
			double getZ() const {return Z();}
			void setZ(double z){Z() = z;}

			void normalise();
			Vec3 normalised() const;
			double length() const { return vcg::Norm(*this); }
			double lengthSquared() const { return vcg::SquaredNorm(*this); }

			Vec3 cross(const Vec3 &other) const { return vcg::Point3d::operator^(other); }
			double dot(const Vec3 &other) const { return vcg::Point3d::operator*(other); }

			Vec3 operator+(const Vec3& b) const;
			Vec3 operator-(const Vec3& b) const;
			Vec3 operator*(double d) const;
			Vec3 operator/(double d) const;
			Vec3 & operator=(const Vec3& other);

			bool operator==(const Vec3& other) const;

			Vec3 operator- () const;

			static Vec3 Zero(){return Vec3(0,0,0);}
	};

	// free functions that operate on Vec3
	// These more or less conform to the GLSL
	// Geometric Functions (S8.4 in the spec)
	double length(const Vec3& v); ///< Returns the length of the vector
	double distance(const Vec3& a, const Vec3& b); ///< Returns the distance between two points a and b
	double dot(const Vec3& a, const Vec3& b); ///< Returns the dot product of a and b
	Vec3 cross(const Vec3& a, const Vec3& b); ///< Returns the cross product of a and b
	Vec3 normalise(const Vec3& v); ///< Returns a vector in the same dir as v but with length 1
}



// For basic printing
std::ostream& operator<<(std::ostream&, const fg::Vec3&);

#endif
