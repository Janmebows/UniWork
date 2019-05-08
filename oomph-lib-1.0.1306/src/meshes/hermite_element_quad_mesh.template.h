//LIC// ====================================================================
//LIC// This file forms part of oomph-lib, the object-oriented, 
//LIC// multi-physics finite-element library, available 
//LIC// at http://www.oomph-lib.org.
//LIC// 
//LIC//    Version 1.0; svn revision $LastChangedRevision: 1097 $
//LIC//
//LIC// $LastChangedDate: 2015-12-17 11:53:17 +0000 (Thu, 17 Dec 2015) $
//LIC// 
//LIC// Copyright (C) 2006-2016 Matthias Heil and Andrew Hazel
//LIC// 
//LIC// This library is free software; you can redistribute it and/or
//LIC// modify it under the terms of the GNU Lesser General Public
//LIC// License as published by the Free Software Foundation; either
//LIC// version 2.1 of the License, or (at your option) any later version.
//LIC// 
//LIC// This library is distributed in the hope that it will be useful,
//LIC// but WITHOUT ANY WARRANTY; without even the implied warranty of
//LIC// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
//LIC// Lesser General Public License for more details.
//LIC// 
//LIC// You should have received a copy of the GNU Lesser General Public
//LIC// License along with this library; if not, write to the Free Software
//LIC// Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
//LIC// 02110-1301  USA.
//LIC// 
//LIC// The authors may be contacted at oomph-lib@maths.man.ac.uk.
//LIC// 
//LIC//====================================================================
//This header defines a class for hermite element quad mesh

//Include guards
#ifndef OOMPH_HERMITE_ELEMENT_QUAD_MESH_HEADER
#define OOMPH_HERMITE_ELEMENT_QUAD_MESH_HEADER


// Config header generated by autoconfig
#ifdef HAVE_CONFIG_H
  #include <oomph-lib-config.h>
#endif

//oomph-lib headers
#include "../generic/hermite_elements.h"
#include "../generic/mesh.h"
#include "topologically_rectangular_domain.h"

namespace oomph
{



//=============================================================================
/// \short A two dimensional Hermite bicubic element quadrilateral mesh for
/// a topologically rectangular domain. The geometry of the problem must be
/// prescribed using the TopologicallyRectangularDomain. Non uniform node
/// spacing can be prescribed using a function pointer.
//=============================================================================
template <class ELEMENT> class HermiteQuadMesh : 
 public Mesh
{
  
public:
 

 /// \short Mesh Spacing Function Pointer - an optional function pointer
 /// to prescibe the node spacing in a non-uniformly spaced mesh - takes the 
 /// position of a node (in macro element coordinates) in the uniformly spaced
 /// mesh and return the position in the non-uniformly spaced mesh 
 typedef void (*MeshSpacingFnPtr)(const Vector<double>& m_uniform_spacing, 
                                  Vector<double>& m_non_uniform_spacing);
 

 /// \short Mesh Constructor (for a uniformly spaced mesh). Takes the following
 /// arguments :  nx :              number of elements in x direction;
 ///              ny :              number of elements in y direction;
 ///              domain :          topologically rectangular domain;
 ///              periodic_in_x :   flag specifying if the mesh is periodic in 
 ///                                the x direction (default = false);
 ///              time_stepper_pt : pointer to the time stepper (default = no
 ///                                timestepper);
 HermiteQuadMesh(const unsigned &nx, const unsigned &ny,
                 TopologicallyRectangularDomain* domain, 
                 const bool &periodic_in_x = false, 
                 TimeStepper* time_stepper_pt = &Mesh::Default_TimeStepper)
  {

   // Mesh can only be built with 2D QHermiteElements.
   MeshChecker::assert_geometric_element<QHermiteElementBase,ELEMENT>(2);

   // set number of elements in each coordinate direction
   Nelement.resize(2);
   Nelement[0] = nx;
   Nelement[1] = ny;

   // set x periodicity
   Xperiodic = periodic_in_x;

   // set the domain pointer
   Domain_pt = domain;

   // set the node spacing function to zero
   Node_spacing_fn = 0;

   // builds the mesh
   build_mesh(time_stepper_pt);
  }
 
 
 /// \short Mesh Constructor (for a non-uniformly spaced mesh). Takes the 
 /// following arguments : nx :              number of elements in x direction;
 ///                       ny :              number of elements in y direction;
 ///                       domain :          topologically rectangular domain;
 ///                       spacing_fn :      spacing function prescribing a 
 ///                                         non-uniformly spaced mesh
 ///                       periodic_in_x :   flag specifying if the mesh is 
 ///                                         periodic in the x direction 
 ///                                         (default = false);
 ///                       time_stepper_pt : pointer to the time stepper 
 ///                                         (default = notimestepper);
 HermiteQuadMesh(const unsigned &nx, const unsigned &ny,
                 TopologicallyRectangularDomain* domain, 
                 const MeshSpacingFnPtr spacing_fn, 
                 const bool &periodic_in_x = false, 
                 TimeStepper* time_stepper_pt = &Mesh::Default_TimeStepper)
  {
   // Mesh can only be built with 2D QHermiteElements.
   MeshChecker::assert_geometric_element<QHermiteElementBase,ELEMENT>(2);
   
   // set number of elements in each coordinate direction
   Nelement.resize(2);
   Nelement[0] = nx;
   Nelement[1] = ny;

   // set x periodicity
   Xperiodic = periodic_in_x;

   // set the domain pointer
   Domain_pt = domain;

   // set the node spacing function to zero
   Node_spacing_fn = spacing_fn;

   /// build the mesh
   build_mesh(time_stepper_pt);
  }


 /// Destructor - does nothing - handled in mesh base class
 ~HermiteQuadMesh() {};


 /// Access function for number of elements in mesh in each dimension
 unsigned& nelement_in_dim(const unsigned& d)
  {
   return Nelement[d];
  }


private :

 /// \short returns the macro element position of the node that is the x-th 
 /// node along from the LHS and the y-th node up from the lower edge
 void macro_coordinate_position(const unsigned& node_num_x,
                                const unsigned& node_num_y,
                                Vector<double>& macro_element_position)
  {  
   // compute macro element position in uniformly spaced mesh
   macro_element_position[0] = 2*node_num_x/double(Nelement[0])-1;
   macro_element_position[1] = 2*node_num_y/double(Nelement[1])-1;

   // if a non unform spacing function is provided
   if (Node_spacing_fn != 0)
    {
     Vector<double> temp(macro_element_position);
     (*Node_spacing_fn)(temp,macro_element_position);
    }
  }


 /// \short sets the generalised position of the node (i.e. - x_i, dx_i/ds_0, 
 /// dx_i/ds_1 & d2x_i/ds_0ds_1 for i = 1,2). Takes the x,y coordinates of the 
 /// node from which its position can be determined.
 void set_position_of_node(const unsigned& node_num_x,
                           const unsigned& node_num_y, Node* node_pt);


 /// \short sets the generalised position of the node (i.e. - x_i, dx_i/ds_0, 
 /// dx_i/ds_1 & d2x_i/ds_0ds_1 for i = 1,2). Takes the x,y coordinates of the 
 /// node from which its position can be determined. Also sets coordinates
 /// on boundary vector for the node to be the generalised position of the node
 /// in macro element coordinates
 void set_position_of_boundary_node(const unsigned& node_num_x,
                                    const unsigned& node_num_y, 
                                    BoundaryNode<Node>* node_pt);


 /// \short computes the generalised position of the node at position 
 /// (node_num_x, node_num_y) in the macro element coordinate scheme.
 ///     index 0 of m_gen : 0 - m_i
 ///                        1 - dm_i/ds_0
 ///                        2 - dm_i/ds_1
 ///                        3 - d2m_i/ds_0ds_1    (where i is index 1 of m_gen)
 void generalised_macro_element_position_of_node(const unsigned& node_num_x,
                                                const unsigned& node_num_y, 
                                                 DenseMatrix<double>& m_gen);


 /// \short Generic mesh construction function to build the mesh
 virtual void build_mesh(TimeStepper* time_stepper_pt);


 /// Setup lookup schemes which establish whic elements are located
 /// next to mesh's boundaries (wrapper to suppress doc).
 /// Specific version for HermiteQuadMesh to ensure that the order of the 
 /// elements in Boundary_element_pt matches the actual order along the 
 /// boundary. This is required when hijacking the BiharmonicElement to apply
 /// the BiharmonicFluidBoundaryElement in 
 /// BiharmonicFluidProblem::impose_traction_free_edge(...)
 virtual void setup_boundary_element_info()
  {
   std::ofstream outfile;
   setup_boundary_element_info(outfile);
  }


 /// \short Setup lookup schemes which establish which elements are located 
 /// next to which boundaries (Doc to outfile if it's open).
 /// Specific version for HermiteQuadMesh to ensure that the order of the 
 /// elements in Boundary_element_pt matches the actual order along the 
 /// boundary. This is required when hijacking the BiharmonicElement to apply
 /// the BiharmonicFluidBoundaryElement in 
 /// BiharmonicFluidProblem::impose_traction_free_edge(...)
 virtual void setup_boundary_element_info(std::ostream &outfile);


 /// \short number of elements in each coordinate direction
 Vector<unsigned> Nelement;
 
 /// \short boolean variable to determine whether the mesh is periodic in the  
 /// x-direction
 bool Xperiodic;
 
 /// \short Pointer to the topologically rectangular domain which prescribes 
 /// the problem domain
 TopologicallyRectangularDomain* Domain_pt;
		
 /// non uniform mesh spacing function pointer
 MeshSpacingFnPtr Node_spacing_fn;
}; 
}
#endif
