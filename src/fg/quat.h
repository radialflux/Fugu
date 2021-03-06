/**
 * \file
 * \brief A class to store rotation as quaternion.
 * \author jwetter
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
 *   Copyright (c) 2012 Centre for Electronic Media Art (CEMA)
 *   Monash University, Australia. All rights reserved.
 *
 *   Use of this software is governed by the terms outlined in
 *   the LICENSE file.
 *
 * --------------------------------------------------------------
 * \endverbatim
 * \endcond
 */

#ifndef FG_QUAT
#define FG_QUAT

#include "fg/fg.h"
#include "fg/mat4.h"
#include "fg/vec3.h"

namespace fg {
    /**
     * A class to store rotation as quaternion.
     */
    class Quat {
        public:
            Vec3          v;
            double        w;
            Quat();
            Quat( const Quat &other );
            Quat &operator=( const Quat &other );
            Quat( double aW, double x, double y, double z );
            Quat( const Vec3 &axis, double radians );
            Quat( const Vec3 &from, const Vec3 &to );
            Quat( double xRotation, double yRotation, double zRotation );
            Quat( const Mat4 &m );
            Quat( const Vec3 &xaxis, const Vec3 &yaxis, const Vec3 &zaxis );

            void set( double aW, double x, double y, double z );
            void set( const Vec3 &from, const Vec3 &to );
            void set( const Vec3 &axis, double radians );
            void set( double xRotation, double yRotation, double zRotation );
            void set( const Mat4 &m );
            void set( const Vec3 &xaxis, const Vec3 &yaxis, const Vec3 &zaxis );

            Vec3 rotate( const Vec3 &point ) const;
            Vec3 getAxis() const;
            double getAngle() const;

            Quat& normalise();
            Quat normalised() const;

            double length() const;
            double lengthSquared() const;

            Quat lerp( double t, const Quat &end ) const;
            Quat slerp( double t, const Quat &end ) const;

            double dot( const Quat &quat ) const;

            const Quat operator*( const Quat &rhs ) const;
            const Quat operator*( double rhs ) const;
            Vec3 operator*( const Vec3 &vec ) const;
            const Quat operator-( const Quat &rhs ) const;
            const Quat operator+( const Quat &rhs ) const;
            Quat &operator+=( const Quat &rhs );

            Quat inverted() const; // whats this? as opposed to inverse? (BP) 
			                       // good question. (JW)
            						// lol (BP)
            void invert();
            Quat inverse() const;

            /**
             * /brief Convert a unit quaternion to a Mat4
             * @author ben
             */
            Mat4 toMat4() const;

        private:
            static const double EPSILON = 4.37114e-05;
    };
}

std::ostream &operator <<( std::ostream &oss, const fg::Quat &q );
#endif
