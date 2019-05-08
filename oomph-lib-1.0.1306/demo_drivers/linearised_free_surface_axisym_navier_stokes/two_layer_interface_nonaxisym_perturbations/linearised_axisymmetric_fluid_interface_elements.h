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
//Header file for (one-dimensional) free surface elements
//Include guards, to prevent multiple includes
#ifndef OOMPH_PATRICKLINEARISED_INTERFACE_ELEMENTS_HEADER
#define OOMPH_PATRICKLINEARISED_INTERFACE_ELEMENTS_HEADER

// Config header generated by autoconfig
#ifdef HAVE_CONFIG_H
  #include <oomph-lib-config.h>
#endif

// oomph-lib includes
#include "generic.h"
#include "perturbed_spines.h"

namespace oomph
{

 //========================================================================
 /// Base class establishing common interfaces and functions for all
 /// linearised axisymmetric fluid interface elements.
 //========================================================================
 class LinearisedAxisymmetricFluidInterfaceElement
  : public virtual FaceElement
 {
   private:
  
  /// Pointer to the Capillary number 
  double *Ca_pt;
  
  /// Pointer to the Strouhal number
  double *St_pt;
  
  /// Pointer to azimuthal mode number k in e^ik(theta) decomposition
  int *Azimuthal_Mode_Number_pt;
  
  /// Static default value for the physical constants (zero)
  static double Default_Physical_Constant_Value;
  
  /// Static default value for the azimuthal mode number (zero)
  static int Default_Azimuthal_Mode_Number_Value;
  
  
   protected:
  
  /// Index at which the i-th velocity component is stored.
  Vector<unsigned> U_index_interface;
  
  /// \short Index at which the i-th component of the perturbation
  /// to the nodal coordinate is stored.
  Vector<unsigned> Xhat_index_interface;
  
  /// \short Access function that returns the local equation number
  /// for the i-th kinematic equation (i=1,2) that corresponds to the n-th
  /// local node. This must be overloaded by specific interface elements
  /// and depends on the method for handing the free-surface deformation.
  virtual int kinematic_local_eqn(const unsigned &n,const unsigned &i)=0;
  
   public:

  /// \short Hijack the kinematic condition at the nodes passed in the vector
  /// This is required so that contact-angle conditions can be applied
  /// by the LinearisedAxisymmetricFluidInterfaceEdgeElements.
  virtual void hijack_kinematic_conditions(const Vector<unsigned> 
                                           &bulk_node_number)=0;


   protected:
  
  /// \short Helper function to calculate the residuals and (if flag==true)
  /// the Jacobian -- this function only deals with part of the Jacobian.
  virtual void fill_in_generic_residual_contribution_interface(
   Vector<double> &residuals, 
   DenseMatrix<double> &jacobian, 
   unsigned flag);
  
  /// \short Helper function to calculate the additional contributions
  /// to the jacobian. This will be overloaded by elements that
  /// require contributions to their underlying equations from surface
  /// integrals. The only example at the moment are elements that
  /// use the equations of elasticity to handle the deformation of the
  /// bulk elements. The shape functions, normal, integral weight,
  /// and jacobian are passed so that they do not have to be recalculated.
  virtual void add_additional_residual_contributions(
   Vector<double> &residuals, DenseMatrix<double> &jacobian,
   const unsigned &flag,
   const Shape &psif, const DShape &dpsifds,
   const Vector<double> &interpolated_n, 
   const double &r, const double &W,
   const double &J) {}
  
  /// \short i-th component of dXhat/dt at local node n. 
  /// Uses suitably interpolated value for hanging nodes.
  double dXhat_dt(const unsigned &n, const unsigned &i) const
  {
   // Get the data's positional timestepper
   TimeStepper* position_time_stepper_pt
    = this->node_pt(n)->position_time_stepper_pt();
   
   // Get the value
   const double xhat_value = this->node_pt(n)->value(Xhat_index_interface[i]);
   
   // Initialise dXhat/dt
   double dXhatdt = 0.0;

   // Loop over the timesteps, if there is a non Steady timestepper
   if(!position_time_stepper_pt->is_steady())
    {
     // Number of timsteps (past & present)
     const unsigned n_time = position_time_stepper_pt->ntstorage();
     
     // Add the contributions to the time derivative
     for(unsigned t=0;t<n_time;t++)
      {
       dXhatdt += position_time_stepper_pt->weight(1,t)*xhat_value;
      }
    }
   
   return dXhatdt;
  }
  

   public:
  
  /// Constructor, set the default values of the booleans and pointers (null)
  LinearisedAxisymmetricFluidInterfaceElement()//: Pext_data_pt(0) 
   {
    // Set all the physical parameter pointers to the default value of zero
    Ca_pt = &Default_Physical_Constant_Value;
    St_pt = &Default_Physical_Constant_Value;
    
    // Set the azimuthal mode number to default (zero)
    Azimuthal_Mode_Number_pt = &Default_Azimuthal_Mode_Number_Value;
   }
  
  /// \short Virtual function that specifies the surface tension as 
  /// a function of local position within the element
  /// The default behaviour is a constant surface tension of value 1.0
  /// It is expected that this function will be overloaded in more
  /// specialised elements to incorporate variations in surface tension.
  virtual double sigma(const Vector<double> &s_local) { return 1.0; }
  
  /// Calculate the residuals by calling the generic residual contribution.
  void fill_in_contribution_to_residuals(Vector<double> &residuals)
  {
   // Add the residual contributions
   fill_in_generic_residual_contribution_interface(
    residuals,GeneralisedElement::Dummy_matrix,0);
  }
  
  /// Return the value of the Capillary number
  const double &ca() const { return *Ca_pt; }
  
  /// Return a pointer to the Capillary number
  double* &ca_pt() { return Ca_pt; }
  
  /// Return the value of the Strouhal number
  const double &st() const { return *St_pt; }
  
  /// Return a pointer to the Strouhal number
  double* &st_pt() { return St_pt; }
  
  /// Azimuthal mode number k in e^ik(theta) decomposition
  const int &azimuthal_mode_number() const
   { return *Azimuthal_Mode_Number_pt; }
  
  /// Pointer to azimuthal mode number k in e^ik(theta) decomposition
  int* &azimuthal_mode_number_pt() { return Azimuthal_Mode_Number_pt; }
  
  /// \short Return the i-th velocity component at local node n 
  /// The use of the array U_index_interface allows the velocity
  /// components to be stored in any location at the node.
  double u(const unsigned &n, const unsigned &i)
  {
   return node_pt(n)->value(U_index_interface[i]);
  }

  /// Calculate the i-th velocity component at the local coordinate s
  double interpolated_u(const Vector<double> &s, const unsigned &i)
  {
   // Find number of nodes
   const unsigned n_node = nnode();
   
   // Storage for the local shape function
   Shape psi(n_node);
   
   // Get values of shape function at local coordinate s
   this->shape(s,psi);
   
   // Initialise value of u
   double interpolated_u = 0.0;
   
   // Loop over the local nodes and sum
   for(unsigned l=0;l<n_node;l++) { interpolated_u += u(l,i)*psi(l); }
   
   return(interpolated_u);
  }
  
  /// Overload the output functions
  void output(std::ostream &outfile) { FiniteElement::output(outfile); }
  
  /// Output the element
  void output(std::ostream &outfile, const unsigned &n_plot);
  
  /// Overload the C-style output function
  void output(FILE* file_pt) { FiniteElement::output(file_pt); }
  
  /// C-style Output function: x,y,[z],u,v,[w],p in tecplot format
  void output(FILE* file_pt, const unsigned &n_plot);
 
};


 //========================================================================
 /// Linearised axisymmetric interface elements that are used with a
 /// spine mesh, i.e. the mesh deformation is handled by Kistler &
 /// Scriven's "method of spines". These elements are FaceElements of bulk
 /// Fluid elements and the particular type of fluid element is passed 
 /// as a template parameter to the element. It 
 /// shouldn't matter whether the passed 
 /// element is the underlying (fixed) element or the templated 
 /// SpineElement<Element>.
 /// In the case of steady problems, an additional volume constaint 
 /// must be imposed to select a particular solution from an otherwise
 /// inifinte number. This constraint is associated with an external
 /// pressure degree of freedom, which must be passed to the element as
 /// external data. If the element is a free surface, Free_surface = true,
 /// then the external pressure is the pressure in the inviscid external
 /// fluid; otherwise, the pressure degree of freedom must be passed from
 /// an element in the adjoining fluid.
 //========================================================================
 template<class ELEMENT>
  class PerturbedSpineLinearisedAxisymmetricFluidInterfaceElement : 
 public virtual Hijacked<PerturbedSpineElement<FaceGeometry<ELEMENT> > >,
  public virtual LinearisedAxisymmetricFluidInterfaceElement 
  {
    private:
   
   /// \short In these elements, the kinematic condition is the equation 
   /// used to determine the "order epsilon" contributions to the free surface
   /// "height". We have two sets of unknowns, HC and HS, and we therefore have
   /// two kinematic conditions. Overload the function accordingly.
   int kinematic_local_eqn(const unsigned &n, const unsigned &i)
   {
    return this->spine_local_eqn(n,i);
   }
   
   
   /// \short Hijacking the kinematic condition corresponds to hijacking the
   /// spine heights.
   void hijack_kinematic_conditions(const Vector<unsigned> &bulk_node_number)
   {
    // Loop over all the passed nodes
    for(Vector<unsigned>::const_iterator it=bulk_node_number.begin();
        it!=bulk_node_number.end();++it)
     {
      // Hijack the spine heights and delete the returned data objects
      delete this->hijack_nodal_spine_value(*it,0);
     }
   }
   
   /// \short i-th component of dH/dt at local node n. 
   /// Uses suitably interpolated value for hanging nodes.
   double dH_dt(const unsigned &n, const unsigned &i) const
   {
    // Get the data's timestepper
    TimeStepper* time_stepper_pt = this->node_pt(n)->time_stepper_pt();
    
    // Upcast from general node to PerturbedSpineNode
    PerturbedSpineNode* perturbed_spine_node_pt =
     dynamic_cast<PerturbedSpineNode*>(this->node_pt(n));
    
    // Initialise dH/dt
    double dHdt = 0.0;
   
    // Loop over the timesteps, if there is a non Steady timestepper
    if(!time_stepper_pt->is_steady())
     {
      // Number of timsteps (past & present)
      const unsigned n_time = time_stepper_pt->ntstorage();
      
      // Add the contributions to the time derivative
      for(unsigned t=0;t<n_time;t++)
       {
        dHdt += time_stepper_pt->weight(1,t)*
         perturbed_spine_node_pt->perturbed_spine_pt()->height(t,i);
       }
     }
    
    return dHdt;
   }
   
    public:

   /// Constructor, the arguments are a pointer to the  "bulk" element 
   /// the local coordinate that is fixed on the face, and
   /// whether it is the upper or lower limit of that coordinate.
   PerturbedSpineLinearisedAxisymmetricFluidInterfaceElement(
    FiniteElement* const &bulk_element_pt, const int &face_index) : 
    Hijacked<PerturbedSpineElement<FaceGeometry<ELEMENT> > >(), 
    LinearisedAxisymmetricFluidInterfaceElement()
     {
      // Attach the geometrical information to the element
      bulk_element_pt->build_face_element(face_index,this);
      
      // Find the index at which the velocity unknowns are stored 
      // from the bulk element
      ELEMENT* cast_element_pt = dynamic_cast<ELEMENT*>(bulk_element_pt);
      
      // We must have six velocity components
      this->U_index_interface.resize(6);
      for(unsigned i=0;i<6;i++)
       {
        this->U_index_interface[i]=cast_element_pt->u_index_lin_axi_nst(i);
       }
      
      // We must have four components of the perturbations to the
      // nodal positions
      this->Xhat_index_interface.resize(4);
      for(unsigned i=0;i<4;i++)
       {
        this->Xhat_index_interface[i] = 
         cast_element_pt->xhat_index_lin_axi_nst(i);
       }
     }
    
    /// Return the jacobian
    void fill_in_contribution_to_jacobian(Vector<double> &residuals, 
                                          DenseMatrix<double> &jacobian)
    {
     // Call the generic residuals routine with the flag set to 1
     fill_in_generic_residual_contribution_interface(residuals,jacobian,1);
     // Call the generic routine to handle the spine variables
     // PerturbedSpineElement<FaceGeometry<ELEMENT> >::
     this->fill_in_jacobian_from_geometric_data(jacobian);
    }
    
    /// This function is sort-of-hacky: its purpose is to overload the
    /// fill_in_generic_residual_contribution_interface(..) function in the
    /// LinearisedAxisymmetricFluidInterfaceElement base class, since I have
    /// made the maths too general and assumed not only spines but spines
    /// which always point vertically. When this is done properly this
    /// function should be removed so that the function in the base class
    /// is used, and that function should be implemented with the proper
    /// general maths which does not assume spines or anything.
    void fill_in_generic_residual_contribution_interface(
     Vector<double> &residuals, 
     DenseMatrix<double> &jacobian, 
     unsigned flag);
    
    /// Overload the output function
    void output(std::ostream &outfile) {FiniteElement::output(outfile);}
    
    /// Output the element
    void output(std::ostream &outfile, const unsigned &n_plot)
    {LinearisedAxisymmetricFluidInterfaceElement::output(outfile,n_plot);}
    
    /// Overload the C-style output function
    void output(FILE* file_pt) {FiniteElement::output(file_pt);}
    
    /// C-style Output function: x,y,[z],u,v,[w],p in tecplot format
    void output(FILE* file_pt, const unsigned &n_plot)
    {LinearisedAxisymmetricFluidInterfaceElement::output(file_pt,n_plot);}

    /// Output just the interface position (base + perturbation)
    void output_interface_position(std::ostream &outfile,
                                   const unsigned &nplot);
    
    /// Output the perturbation to the interface position
    void output_perturbation_to_interface(std::ostream &outfile,
                                          const unsigned &nplot);
    
    /// \short Return the i-th component of the FE interpolated perturbed
    /// surface height (i=0 is cosine part, i=1 is sine part) at local
    /// coordinate s
    double interpolated_H(const Vector<double> &s,
                          const unsigned &i) const
    {
     // Determine number of nodes in the element
     const unsigned n_node = nnode();
     
     // Provide storage for local shape functions
     Shape psi(n_node);
     
     // Find values of shape functions
     shape(s,psi);
     
     // Initialise value of H
     double interpolated_H = 0.0;
     
     // Loop over the shape functions and sum
     for(unsigned l=0;l<n_node;l++) 
      {
       // Upcast from general node to PerturbedSpineNode
       PerturbedSpineNode* perturbed_spine_node_pt =
        dynamic_cast<PerturbedSpineNode*>(this->node_pt(l));
       
       // Calculate interpolated i-th component of perturbed spine "heights"
       interpolated_H +=
        perturbed_spine_node_pt->perturbed_spine_pt()->height(i)*psi[l];
      }
     
     return(interpolated_H);
    }
    
  };
 
 


}

#endif






