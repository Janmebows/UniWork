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
// Header file for elements that allow the imposition of a "constant volume"
// constraint in free surface problems.

//Include guards, to prevent multiple includes
#ifndef CONSTRAINED_FLUID_VOLUME_ELEMENTS_HEADER
#define CONSTRAINED_FLUID_VOLUME_ELEMENTS_HEADER

// Config header generated by autoconfig
#ifdef HAVE_CONFIG_H
  #include <oomph-lib-config.h>
#endif

//OOMPH-LIB headers
#include "../generic/Qelements.h"
#include "../generic/spines.h"
#include "../axisym_navier_stokes/axisym_navier_stokes_elements.h"

//-------------------------------------------
// NOTE: This is still work 
// in progress. Need to create versions
// for axisymmetric and cartesian 3D
// bulk equations, as well as spine
// version for all of these (resulting
// in six elements in total). These
// will gradually replace the very hacky 
// fix_*.h files that currently live in 
// various demo driver codes. 
//-------------------------------------------

namespace oomph
{

//==========================================================================
/// A class that is used to implement the constraint that the fluid volume
/// in a region bounded by associated FaceElements (attached, e.g., to the
/// mesh boundaries that enclose a bubble) must take a specific value. 
/// This GeneralisedElement is used only to store the desired volume and
/// a pointer to the (usually pressure) freedom that must be traded 
/// for the volume constraint.
//=========================================================================
 class VolumeConstraintElement : public GeneralisedElement
 {
   private:
  
  /// Pointer to the desired value of the volume
  double *Prescribed_volume_pt;
  
  /// \short The Data that contains the traded pressure is stored
  /// as external or internal Data for the element. What is its index
  /// in these containers?
  unsigned External_or_internal_data_index_of_traded_pressure;
  
  /// \short The Data that contains the traded pressure is stored
  /// as external or internal Data for the element. Which one?
  bool Traded_pressure_stored_as_internal_data;
  
  /// Index of the value in traded pressure data that corresponds to the
  /// traded pressure
  unsigned Index_of_traded_pressure_value; 
  
  /// \short The local eqn number for the traded pressure
  inline int ptraded_local_eqn()
  {
   if (Traded_pressure_stored_as_internal_data)
    { 
     return 
      this->internal_local_eqn(
       External_or_internal_data_index_of_traded_pressure,
       Index_of_traded_pressure_value);
    }
   else 
    {
     return 
      this->external_local_eqn(
       External_or_internal_data_index_of_traded_pressure,
       Index_of_traded_pressure_value);     
    }
  }
  
  
  /// \short Fill in the residuals for the volume constraint
 void fill_in_generic_contribution_to_residuals_volume_constraint(
  Vector<double> &residuals);
  
   public:
 
 /// \short Constructor: Pass pointer to target volume. "Pressure" value that
 /// "traded" for the volume contraint is created internally (as a Data
 /// item with a single pressure value)
 VolumeConstraintElement(double* prescribed_volume_pt);

 /// \short Constructor: Pass pointer to target volume, pointer to Data
 /// item whose value specified by index_of_traded_pressure represents
 /// the "Pressure" value that "traded" for the volume contraint.
 /// The Data is stored as external Data for this element.
 VolumeConstraintElement(double* prescribed_volume_pt,
                         Data* p_traded_data_pt,
                         const unsigned& index_of_traded_pressure);
 
 /// \short Empty destructor
 ~VolumeConstraintElement() {}

 /// Access to Data that contains the traded pressure
 inline Data* p_traded_data_pt()
 {
  if (Traded_pressure_stored_as_internal_data)
   { 
    return internal_data_pt(
     External_or_internal_data_index_of_traded_pressure);
   }
  else 
   {
    return external_data_pt(
     External_or_internal_data_index_of_traded_pressure);
   }
 }

 /// Return the traded pressure value
 inline double p_traded()
 {return p_traded_data_pt()->value(Index_of_traded_pressure_value);}
 
 /// Return the index of Data object  at which the traded pressure is stored
 inline unsigned index_of_traded_pressure()
 {return Index_of_traded_pressure_value;}
 
 
 /// \short Fill in the residuals for the volume constraint
 void fill_in_contribution_to_residuals( Vector<double> &residuals)
 {
  this->fill_in_generic_contribution_to_residuals_volume_constraint(
   residuals);
 }
  
 /// \short Fill in the residuals and jacobian for the volume constraint
 void fill_in_contribution_to_jacobian(Vector<double> &residuals,
                                       DenseMatrix<double> &jacobian)
 {
  //No contribution to jacobian; see comment in that function
  this->fill_in_generic_contribution_to_residuals_volume_constraint(
   residuals);
 }
 
 /// \short Fill in the residuals, jacobian and mass matrix for the volume
 /// constraint.
 void fill_in_contribution_to_jacobian_and_mass_matrix(
  Vector<double> &residuals,
  DenseMatrix<double> &jacobian,
  DenseMatrix<double> &mass_matrix)
 {
  //No contribution to jacobian or mass matrix; see comment in that function
  this->fill_in_generic_contribution_to_residuals_volume_constraint(
   residuals);
 }

}; 

/////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////


//=======================================================================
/// Base class for interface elements that allow the application of 
/// a volume constraint on the region bounded by these elements. The
/// elements must be used together with the associated
/// VolumeConstraintElement which stores the value of the
/// target volume. Common functionality is provided in this base 
/// for storing the external "pressure" value
/// that is traded for the volume constraint.
//=======================================================================
 class VolumeConstraintBoundingElement : public virtual FaceElement
 {

  protected:
  
  /// \short The Data that contains the traded pressure is usually stored
  /// as external Data for this element, but may also be nodal Data
  /// Which Data item is it?
  unsigned Data_number_of_traded_pressure;
  
  /// Index of the value in traded pressure data that corresponds to the
  /// traded pressure
  unsigned Index_of_traded_pressure_value;

  /// \short Boolean to indicate whether the traded pressure is
  /// stored externally or at a node (this can happen in Taylor-Hood
  /// elements)
  bool Traded_pressure_stored_at_node;
  
  /// \short The local eqn number for the traded pressure
  inline int ptraded_local_eqn()
  {
   //Return the appropriate nodal value if required
   if(Traded_pressure_stored_at_node)
    {
     return this->nodal_local_eqn(Data_number_of_traded_pressure,
                                  Index_of_traded_pressure_value);
    }
   else
    {
     return this->external_local_eqn(Data_number_of_traded_pressure,
                                     Index_of_traded_pressure_value);
    }
  }
  
  /// \short Helper function to fill in contributions to residuals
  /// (remember that part of the residual is added by the the 
  /// associated VolumeConstraintElement). This is dimension/geometry
  /// specific and must be implemented in derived classes for
  /// 1D line, 2D surface and axisymmetric fluid boundaries
  virtual void fill_in_generic_residual_contribution_volume_constraint(
   Vector<double> &residuals)=0;
 
  public:
 
  /// \short Constructor initialise the boolean flag
  /// We expect the traded pressure data to be stored externally
   VolumeConstraintBoundingElement() : Traded_pressure_stored_at_node(false)
   {}
 
  /// \short Empty Destructor
  ~VolumeConstraintBoundingElement() {}

 /// Fill in contribution to residuals and Jacobian
 void fill_in_contribution_to_residuals(Vector<double> &residuals)
 {
  //Call the generic routine
  this->fill_in_generic_residual_contribution_volume_constraint(residuals);
 }

 /// \short Set the "master" volume constraint element
 /// The setup here is a bit more complicated than one might expect because
 /// if an internal pressure on a boundary 
 /// is hijacked in TaylorHood elements then
 /// that the "traded" value may already be stored as nodal data
 /// in this element. This causes no problems apart from when running
 /// with PARANOID in which case the resulting 
 /// repeated local equation numbers are spotted and an error is thrown.
 /// The check is a finite amount of work and so can be avoided if
 /// the boolean flag check_nodal_data is set to false.
 void set_volume_constraint_element(VolumeConstraintElement* const 
                                    &vol_constraint_el_pt, 
                                    const bool &check_nodal_data=true)
 {

  //In order to buffer the case of nodal data, we (tediously) check that the 
  //traded pressure is not already nodal data of this element
  if(check_nodal_data)
   {
    //Get memory address of the equation indexed by the
    //traded pressure datum
    long* global_eqn_number = vol_constraint_el_pt->p_traded_data_pt()
     ->eqn_number_pt(vol_constraint_el_pt->index_of_traded_pressure());
    
    //Put in a check if the datum already corresponds to any other 
    //(nodal) data in the element by checking the memory addresses of
    //their global equation numbers
    const unsigned n_node = this->nnode();
    for(unsigned n=0;n<n_node;n++)
     {
      //Cache the node pointer
      Node* const nod_pt = this->node_pt(n);
      //Find all nodal data values
      unsigned n_value = nod_pt->nvalue();
      //If we already have the data, set the 
      //lookup schemes accordingly and return from the function
      for(unsigned i=0;i<n_value;i++)
       {
        if(nod_pt->eqn_number_pt(i) == global_eqn_number)
         {
          Traded_pressure_stored_at_node = true;
          Data_number_of_traded_pressure = n;
          Index_of_traded_pressure_value = i;
          //Finished so exit the function
          return;
         }
       }
     }
   }
  
  //Should only get here if the data is not nodal 
  
  // Add "traded" pressure data as external data to this element
  Data_number_of_traded_pressure=
   this->add_external_data(vol_constraint_el_pt->p_traded_data_pt());
  
  // Which value corresponds to the traded pressure
  Index_of_traded_pressure_value=vol_constraint_el_pt->
   index_of_traded_pressure();
 }
 
};

/////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////


//=======================================================================
/// One-dimensional interface elements that allow the application of 
/// a volume constraint on the region bounded by these elements. 
/// The volume is computed by integrating x.n around the boundary of 
/// the domain and then dividing by two. 
/// The sign is chosen so that the volume will be positive
/// when the elements surround a fluid domain.
///
/// These elements must be used together with the associated
/// VolumeConstraintElement, which stores the value of the
/// target volume. 
//=======================================================================
 class LineVolumeConstraintBoundingElement : 
 public VolumeConstraintBoundingElement
 {
   protected:
  
  /// \short Helper function to fill in contributions to residuals
  /// (remember that part of the residual is added by the
  /// the associated VolumeConstraintElement). This is specific for
  /// 1D line elements that bound 2D cartesian fluid elements.
  void  fill_in_generic_residual_contribution_volume_constraint(
   Vector<double> &residuals);
  
  public:
  
  /// \short Empty Contructor
  LineVolumeConstraintBoundingElement() : VolumeConstraintBoundingElement() {}

  /// \short Empty Destructor
  ~LineVolumeConstraintBoundingElement() {}
  
  /// Return this element's contribution to the total volume enclosed
  double contribution_to_enclosed_volume();

 };


//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////


//=======================================================================
/// The one-dimensional interface elements that allow imposition of a 
/// volume constraint specialised for the case when the nodal positions of
/// the bulk elements are treated as solid degrees of freedom. 
/// To enforce that a fluid volume has a
/// certain volume, attach these elements to all faces of the
/// (2D cartesian) bulk fluid elements (of type ELEMENT) that bound that region
/// and then specify the "pressure" value that is traded for the constraint.
//=======================================================================
 template<class ELEMENT>
  class ElasticLineVolumeConstraintBoundingElement : public 
   LineVolumeConstraintBoundingElement,
   public virtual FaceGeometry<ELEMENT>
 {
 
 public:
  
  /// \short Contructor: Specify bulk element and index of face to which
  /// this face element is to be attached 
   ElasticLineVolumeConstraintBoundingElement(FiniteElement* const &element_pt, 
                                            const int &face_index) : 
  FaceGeometry<ELEMENT>(),
   LineVolumeConstraintBoundingElement()
    {
     //Attach the geometrical information to the element, by
     //making the face element from the bulk element
     element_pt->build_face_element(face_index,this);
    }
  
  /// Fill in contribution to residuals and Jacobian. This is specific
  /// to solid-based elements in which derivatives w.r.t. to nodal
  /// positions are evaluated by finite differencing
  void fill_in_contribution_to_jacobian(Vector<double> &residuals, 
                                        DenseMatrix<double> &jacobian)
  {
   //Call the generic routine
   this->fill_in_generic_residual_contribution_volume_constraint(residuals);
   
   // Shape derivatives
   //Call the generic finite difference routine for the solid variables
   this->fill_in_jacobian_from_solid_position_by_fd(jacobian);
  }

  /// \short The "global" intrinsic coordinate of the element when
  /// viewed as part of a geometric object should be given by
  /// the FaceElement representation, by default
  double zeta_nodal(const unsigned &n, const unsigned &k,
                    const unsigned &i) const
  {return FaceElement::zeta_nodal(n,k,i);}

};

//=======================================================================
/// The one-dimensional interface elements that allow imposition of a 
/// volume constraint specialised for the case when the nodal positions of
/// the bulk elements are adjusted using Spines. 
/// To enforce that a fluid volume has a
/// certain volume, attach these elements to all faces of the
/// (2D cartesian) bulk fluid elements (of type ELEMENT) that bound that region
/// and then specify the "pressure" value that is traded for the constraint.
//=======================================================================
 template<class ELEMENT>
  class SpineLineVolumeConstraintBoundingElement : public
  LineVolumeConstraintBoundingElement,
  public virtual SpineElement<FaceGeometry<ELEMENT> >
  {

    public:
   
   /// \short Contructor: Specify bulk element and index of face to which
   /// this face element is to be attached.
    SpineLineVolumeConstraintBoundingElement(FiniteElement* const &element_pt, 
                                             const int &face_index) :
   SpineElement<FaceGeometry<ELEMENT> >(),
    LineVolumeConstraintBoundingElement() 
     {
      //Attach the geometrical information to the element, by
      //making the face element from the bulk element
      element_pt->build_face_element(face_index,this);
     }
   
   
   /// Fill in contribution to residuals and Jacobian. This is specific
   /// to spine based elements in which the shape derivatives are evaluated
   /// using geometric data
   void fill_in_contribution_to_jacobian(Vector<double> &residuals, 
                                         DenseMatrix<double> &jacobian)
   {
    //Call the generic routine
    this->fill_in_generic_residual_contribution_volume_constraint(residuals);
    
    //Call the generic routine to evaluate shape derivatives 
    this->fill_in_jacobian_from_geometric_data(jacobian); 
   }
   
   /// \short The "global" intrinsic coordinate of the element when
   /// viewed as part of a geometric object should be given by
   /// the FaceElement representation, by default
   double zeta_nodal(const unsigned &n, const unsigned &k,
                     const unsigned &i) const
   {return FaceElement::zeta_nodal(n,k,i);}
   
};

/////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////


//=======================================================================
/// Axisymmetric (one-dimensional) interface elements that 
/// allow the application of 
/// a volume constraint on the region bounded by these elements. 
/// The volume is computed by integrating x.n around the boundary of 
/// the domain and then dividing by three. 
/// The sign is chosen so that the volume will be positive
/// when the elements surround a fluid domain.
///
/// These elements must be used together with the associated
/// VolumeConstraintElement, which stores the value of the
/// target volume. 
//=======================================================================
 class AxisymmetricVolumeConstraintBoundingElement : public
   VolumeConstraintBoundingElement
 {
   protected:
  
  /// \short Helper function to fill in contributions to residuals
  /// (remember that part of the residual is added by the
  /// the associated VolumeConstraintElement). This is specific for
  /// 1D line elements that bound 2D cartesian fluid elements.
  void  fill_in_generic_residual_contribution_volume_constraint(
   Vector<double> &residuals);
   
  public:
  
  /// \short Empty Contructor
  AxisymmetricVolumeConstraintBoundingElement() : 
  VolumeConstraintBoundingElement() {}

  /// \short Empty Destructor
  ~AxisymmetricVolumeConstraintBoundingElement() {}

  /// Return this element's contribution to the total volume enclosed
  double contribution_to_enclosed_volume();

  /// \short Return this element's contribution to the volume flux over
  /// the boundary
  double contribution_to_volume_flux()
  {
   // Initialise
   double vol=0.0;
   
   //Find out how many nodes there are
   const unsigned n_node = this->nnode();
  
   //Set up memeory for the shape functions
   Shape psif(n_node);
   DShape dpsifds(n_node,1);
  
   //Set the value of n_intpt
   const unsigned n_intpt = this->integral_pt()->nweight();
  
   //Storage for the local cooridinate
   Vector<double> s(1);
  
   //Loop over the integration points
   for(unsigned ipt=0;ipt<n_intpt;ipt++)
    {
     //Get the local coordinate at the integration point
     s[0] = this->integral_pt()->knot(ipt,0);
    
     //Get the integral weight
     double W = this->integral_pt()->weight(ipt);
    
     //Call the derivatives of the shape function at the knot point
     this->dshape_local_at_knot(ipt,psif,dpsifds);
    
     // Get position, tangent vector and velocity vector (r and z 
     // components only)
     Vector<double> interpolated_u(2,0.0);
     Vector<double> interpolated_t1(2,0.0);
     Vector<double> interpolated_x(2,0.0);
     for(unsigned l=0;l<n_node;l++)
      {
       //Loop over directional components
       for(unsigned i=0;i<2;i++)
        {
         interpolated_x[i] += this->nodal_position(l,i)*psif(l);
         interpolated_u[i] += this->node_pt(l)->value(
          dynamic_cast<AxisymmetricNavierStokesEquations*>(bulk_element_pt())
          ->u_index_axi_nst(i))*psif(l);
         interpolated_t1[i] += this->nodal_position(l,i)*dpsifds(l,0);
        }
      }
    
     //Calculate the length of the tangent Vector
     double tlength = interpolated_t1[0]*interpolated_t1[0] + 
      interpolated_t1[1]*interpolated_t1[1];
    
     //Set the Jacobian of the line element
     double J = sqrt(tlength)*interpolated_x[0];
    
     //Now calculate the normal Vector
     Vector<double> interpolated_n(2);
     this->outer_unit_normal(ipt,interpolated_n);
    
     // Assemble dot product
     double dot = 0.0;
     for(unsigned k=0;k<2;k++) 
      {
       dot += interpolated_u[k]*interpolated_n[k];
      }
    
     // Add to volume with sign chosen so that the volume is
     // positive when the elements bound the fluid
     vol += dot*W*J;
    }

   return vol;
  }

 };

//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////


//=======================================================================
/// The axisymmetric (one-dimensional) interface elements that allow 
/// imposition of a 
/// volume constraint specialised for the case when the nodal positions of
/// the bulk elements are treated as solid degrees of freedom. 
/// To enforce that a fluid volume has a
/// certain volume, attach these elements to all faces of the
/// (2D axisymmetric) bulk fluid elements (of type ELEMENT) 
/// that bound that region
/// and then specify the "pressure" value that is traded for the constraint.
//=======================================================================
 template<class ELEMENT>
  class ElasticAxisymmetricVolumeConstraintBoundingElement : public 
   AxisymmetricVolumeConstraintBoundingElement,
   public virtual FaceGeometry<ELEMENT>
 {
 
 public:
  
  /// \short Contructor: Specify bulk element and index of face to which
  /// this face element is to be attached 
   ElasticAxisymmetricVolumeConstraintBoundingElement(
    FiniteElement* const &element_pt, 
    const int &face_index) : 
  FaceGeometry<ELEMENT>(),
   AxisymmetricVolumeConstraintBoundingElement()
    {
     //Attach the geometrical information to the element, by
     //making the face element from the bulk element
     element_pt->build_face_element(face_index,this);
    }
  
  /// Fill in contribution to residuals and Jacobian. This is specific
  /// to solid-based elements in which derivatives w.r.t. to nodal
  /// positions are evaluated by finite differencing
  void fill_in_contribution_to_jacobian(Vector<double> &residuals, 
                                        DenseMatrix<double> &jacobian)
  {
   //Call the generic routine
   this->fill_in_generic_residual_contribution_volume_constraint(residuals);
   
   // Shape derivatives
   //Call the generic finite difference routine for the solid variables
   this->fill_in_jacobian_from_solid_position_by_fd(jacobian);
  }

  /// \short The "global" intrinsic coordinate of the element when
  /// viewed as part of a geometric object should be given by
  /// the FaceElement representation, by default
  double zeta_nodal(const unsigned &n, const unsigned &k,
                    const unsigned &i) const
  {return FaceElement::zeta_nodal(n,k,i);}

};

//=======================================================================
/// The axisymmetric (one-dimensional) interface elements that 
/// allow imposition of a 
/// volume constraint specialised for the case when the nodal positions of
/// the bulk elements are adjusted using Spines. 
/// To enforce that a fluid volume has a
/// certain volume, attach these elements to all faces of the
/// (2D axisymmetric) bulk fluid elements (of type ELEMENT) that bound 
/// that region
/// and then specify the "pressure" value that is traded for the constraint.
//=======================================================================
 template<class ELEMENT>
  class SpineAxisymmetricVolumeConstraintBoundingElement : public
  AxisymmetricVolumeConstraintBoundingElement,
  public virtual SpineElement<FaceGeometry<ELEMENT> >
  {

    public:
   
   /// \short Contructor: Specify bulk element and index of face to which
   /// this face element is to be attached.
    SpineAxisymmetricVolumeConstraintBoundingElement(
     FiniteElement* const &element_pt, const int &face_index) :
   SpineElement<FaceGeometry<ELEMENT> >(),
    AxisymmetricVolumeConstraintBoundingElement() 
     {
      //Attach the geometrical information to the element, by
      //making the face element from the bulk element
      element_pt->build_face_element(face_index,this);
     }
   
   
   /// Fill in contribution to residuals and Jacobian. This is specific
   /// to spine based elements in which the shape derivatives are evaluated
   /// using geometric data
   void fill_in_contribution_to_jacobian(Vector<double> &residuals, 
                                         DenseMatrix<double> &jacobian)
   {
    //Call the generic routine
    this->fill_in_generic_residual_contribution_volume_constraint(residuals);
    
    //Call the generic routine to evaluate shape derivatives 
    this->fill_in_jacobian_from_geometric_data(jacobian); 
   }
   
   /// \short The "global" intrinsic coordinate of the element when
   /// viewed as part of a geometric object should be given by
   /// the FaceElement representation, by default
   double zeta_nodal(const unsigned &n, const unsigned &k,
                     const unsigned &i) const
   {return FaceElement::zeta_nodal(n,k,i);}
   
};



/////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////


//=======================================================================
/// Two-dimensional interface elements that allow the application of 
/// a volume constraint on the region bounded by these elements. 
/// The volume is computed by integrating x.n around the boundary of 
/// the domain and then dividing by three. 
/// The sign is chosen so that the volume will be positive
/// when the elements surround a fluid domain.
///
/// These elements must be used together with the associated
/// VolumeConstraintElement, which stores the value of the
/// target volume. 
//=======================================================================
 class SurfaceVolumeConstraintBoundingElement : public
  VolumeConstraintBoundingElement
 {
  
   protected:
  
  /// \short Helper function to fill in contributions to residuals
  /// (remember that part of the residual is added by the
  /// the associated VolumeConstraintElement). This is specific for
  /// 2D surface elements that bound 3D cartesian fluid elements.
  void  fill_in_generic_residual_contribution_volume_constraint(
   Vector<double> &residuals);
 
   public:
  
  /// \short Empty Contructor 
   SurfaceVolumeConstraintBoundingElement() : VolumeConstraintBoundingElement()
   {}
 
  /// \short Empty Desctructor
  ~SurfaceVolumeConstraintBoundingElement() {}

};


//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////


//=======================================================================
/// The Two-dimensional interface elements that allow the application of 
/// a volume constraint specialised for the case when the nodal positions
/// of the bulk elements are treated as solid degrees of freedom.
/// To enforce that a fluid volume has a
/// certain volume, attach these elements to all faces of the
/// (3D Cartesian) bulk fluid elements (of type ELEMENT) that bound that region
/// and then specify the "pressure" value that is traded for the constraint.
//=======================================================================
 template<class ELEMENT>
 class ElasticSurfaceVolumeConstraintBoundingElement : 
 public SurfaceVolumeConstraintBoundingElement,
 public virtual FaceGeometry<ELEMENT>
 {
  
   public:
  
  /// \short Contructor: Specify bulk element and index of face to which
  /// this face element is to be attached.
   ElasticSurfaceVolumeConstraintBoundingElement(
    FiniteElement* const &element_pt, const int &face_index) :
  FaceGeometry<ELEMENT>(),
   SurfaceVolumeConstraintBoundingElement()
    {
     //Attach the geometrical information to the element, by
     //making the face element from the bulk element
     element_pt->build_face_element(face_index,this);
    }
 
 
 
  /// Fill in contribution to residuals and Jacobian. This is specific
  /// to solid-based elements in which derivatives w.r.t. to nodal
  /// positions are evaluated by finite differencing
  void fill_in_contribution_to_jacobian(Vector<double> &residuals, 
                                        DenseMatrix<double> &jacobian)
  {
   //Call the generic routine
   this->fill_in_generic_residual_contribution_volume_constraint(residuals);
   
   // Shape derivatives
   //Call the generic finite difference routine for the solid variables
   this->fill_in_jacobian_from_solid_position_by_fd(jacobian);
  }
  
  
  /// \short The "global" intrinsic coordinate of the element when
  /// viewed as part of a geometric object should be given by
  /// the FaceElement representation, by default
  double zeta_nodal(const unsigned &n, const unsigned &k,
                    const unsigned &i) const
  {return FaceElement::zeta_nodal(n,k,i);}
  
 };
 
 
/////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////


//=======================================================================
/// The Two-dimensional interface elements that allow the application of 
/// a volume constraint specialised for the case when the nodal positions
/// of the bulk elements are adjusted using spines.
/// To enforce that a fluid volume has a
/// certain volume, attach these elements to all faces of the
/// (3D Cartesian) bulk fluid elements (of type ELEMENT) that bound that region
/// and then specify the "pressure" value that is traded for the constraint.
//=======================================================================
 template<class ELEMENT>
 class SpineSurfaceVolumeConstraintBoundingElement : 
 public SurfaceVolumeConstraintBoundingElement,
 public virtual SpineElement<FaceGeometry<ELEMENT> >
{

  public:

 /// \short Contructor: Specify bulk element and index of face to which
 /// this face element is to be attached.
 SpineSurfaceVolumeConstraintBoundingElement(FiniteElement* const &element_pt, 
                                             const int &face_index) :
 SpineElement<FaceGeometry<ELEMENT> >(),
  SurfaceVolumeConstraintBoundingElement()
  {
   //Attach the geometrical information to the element, by
   //making the face element from the bulk element
   element_pt->build_face_element(face_index,this);
 }
 
 
 
 /// Fill in contribution to residuals and Jacobian. This is specific
 /// to spine based elements in which the shape derivatives are evaluated
 /// using geometric data
 void fill_in_contribution_to_jacobian(Vector<double> &residuals, 
                                       DenseMatrix<double> &jacobian)
 {
  //Call the generic routine
  this->fill_in_generic_residual_contribution_volume_constraint(residuals);
 
  //Call the generic routine to evaluate shape derivatives 
  this->fill_in_jacobian_from_geometric_data(jacobian); 
 }
 
 
 /// \short The "global" intrinsic coordinate of the element when
 /// viewed as part of a geometric object should be given by
 /// the FaceElement representation, by default
 double zeta_nodal(const unsigned &n, const unsigned &k,
                   const unsigned &i) const
 {return FaceElement::zeta_nodal(n,k,i);}
 
};


}
#endif






