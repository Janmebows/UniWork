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
//Header file for elements that are used to integrate fluid tractions
//This includes the guts (i.e. equations) because we want to inline them
//for faster operation, although it slows down the compilation!

#ifndef OOMPH_FLUID_TRACTION_ELEMENTS_HEADER
#define OOMPH_FLUID_TRACTION_ELEMENTS_HEADER

// Config header generated by autoconfig
#ifdef HAVE_CONFIG_H
#include <oomph-lib-config.h>
#endif


//OOMPH-LIB headers
#include "../generic/Qelements.h"
#include "../generic/Telements.h"

namespace oomph
{

//======================================================================
///A class for elements that allow the imposition of an applied traction
///to the Navier--Stokes equations 
///The geometrical information can be read from the FaceGeometry<ELEMENT> 
///class and and thus, we can be generic enough without the need to have
///a separate equations class
//======================================================================
template <class ELEMENT>
class NavierStokesTractionElement : public virtual FaceGeometry<ELEMENT>, 
 public virtual FaceElement 
{
 
private:

 ///Pointer to an imposed traction function
 void (*Traction_fct_pt)(const double& time, const Vector<double> &x, 
                         const Vector<double> &n, Vector<double> &result);

protected:


 /// \short The "global" intrinsic coordinate of the element when
 /// viewed as part of a geometric object should be given by
 /// the FaceElement representation, by default
 double zeta_nodal(const unsigned &n, const unsigned &k,           
                   const unsigned &i) const 
 {return FaceElement::zeta_nodal(n,k,i);}     

 /// \short Access function that returns the local equation numbers
 /// for velocity components.
 /// u_local_eqn(n,i) = local equation number or < 0 if pinned.
 /// The default is to asssume that n is the local node number
 /// and the i-th velocity component is the i-th unknown stored at the node.
 virtual inline int u_local_eqn(const unsigned &n, const unsigned &i)
 {return nodal_local_eqn(n,i);}
 
 ///\short Function to compute the shape and test functions and to return 
 ///the Jacobian of mapping 
 inline double shape_and_test_at_knot(const unsigned &ipt, 
                                      Shape &psi, Shape &test)
  const
  {
   //Find number of nodes
   unsigned n_node = nnode();
   //Calculate the shape functions
   shape_at_knot(ipt,psi);
   //Set the test functions to be the same as the shape functions
   for(unsigned i=0;i<n_node;i++) {test[i] = psi[i];}
   //Return the value of the jacobian
   return J_eulerian_at_knot(ipt);
  }


 ///Function to calculate the traction applied to the fluid
 void get_traction(const double& time, const Vector<double> &x, 
                   const Vector<double> &n, Vector<double> &result)
 {
  //If the function pointer is zero return zero
  if(Traction_fct_pt == 0)
   {
    //Loop over dimensions and set body forces to zero
    for(unsigned i=0;i<Dim;i++) {result[i] = 0.0;}
   }
  //Otherwise call the function
  else
   {
    (*Traction_fct_pt)(time,x,n,result);
   }
 }
 

 ///\short This function returns the residuals for the 
 /// traction function.
 ///flag=1(or 0): do (or don't) compute the Jacobian as well. 
 void fill_in_generic_residual_contribution_fluid_traction(
  Vector<double> &residuals, 
  DenseMatrix<double> &jacobian, 
  unsigned flag);

 ///The highest dimension of the problem 
 unsigned Dim;

public:

 ///Constructor, which takes a "bulk" element and the value of the index
 ///and its limit
 NavierStokesTractionElement(FiniteElement* const &element_pt, 
                             const int &face_index,
                             const bool& 
                             called_from_refineable_constructor=false) : 
  FaceGeometry<ELEMENT>(), FaceElement()
  { 

   //Attach the geometrical information to the element. N.B. This function
   //also assigns nbulk_value from the required_nvalue of the bulk element
   element_pt->build_face_element(face_index,this);
 
#ifdef PARANOID
   {
    //Check that the element is not a refineable 3d element
    if (!called_from_refineable_constructor)
     {
      //If it's three-d
      if(element_pt->dim()==3)
       {
        //Is it refineable
        RefineableElement* ref_el_pt=
         dynamic_cast<RefineableElement*>(element_pt);
        if(ref_el_pt!=0)
         {
          if (this->has_hanging_nodes())
           {
            throw OomphLibError(
             "This flux element will not work correctly if nodes are hanging\n",
             OOMPH_CURRENT_FUNCTION,
             OOMPH_EXCEPTION_LOCATION);
           }
         }
       }
     }
   }
#endif

   //Set the body force function pointer to zero
   Traction_fct_pt = 0;
 
   //Set the dimension from the dimension of the first node
   Dim = this->node_pt(0)->ndim();
 }

 /// Destructor should not delete anything
 ~NavierStokesTractionElement() { }

 //Access function for the imposed traction pointer
 void (*&traction_fct_pt())(const double& t, const Vector<double>& x, 
                            const Vector<double> &n, Vector<double>& result) 
  {return Traction_fct_pt;}
 
 ///This function returns just the residuals
 inline void fill_in_contribution_to_residuals(Vector<double> &residuals)
  {
   //Call the generic residuals function with flag set to 0
   //using a dummy matrix argument
   fill_in_generic_residual_contribution_fluid_traction(
    residuals,GeneralisedElement::Dummy_matrix,0);
  }

 ///This function returns the residuals and the jacobian
 inline void fill_in_contribution_to_jacobian(Vector<double> &residuals,
                                          DenseMatrix<double> &jacobian)
  {
   //Call the generic routine with the flag set to 1
   fill_in_generic_residual_contribution_fluid_traction(residuals,jacobian,1);
  }
 
 ///Overload the output function
 void output(std::ostream &outfile) {FiniteElement::output(outfile);}

///Output function: x,y,[z],u,v,[w],p in tecplot format
void output(std::ostream &outfile, const unsigned &nplot)
 {FiniteElement::output(outfile,nplot);}


}; 



///////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////



//============================================================================
/// Function that returns the residuals for the imposed traction Navier_Stokes
/// equations
//============================================================================
template<class ELEMENT>
void NavierStokesTractionElement<ELEMENT>::
fill_in_generic_residual_contribution_fluid_traction(
 Vector<double> &residuals, 
 DenseMatrix<double> &jacobian, 
 unsigned flag)
{
 //Find out how many nodes there are
 unsigned n_node = nnode();
 
 // Get continuous time from timestepper of first node
 double time=node_pt(0)->time_stepper_pt()->time_pt()->time();
  
 //Set up memory for the shape and test functions
 Shape psif(n_node), testf(n_node);
 
 //Set the value of n_intpt
 unsigned n_intpt = integral_pt()->nweight();
 
 //Integers to store local equation numbers
 int local_eqn=0;
  
 //Loop over the integration points
 for(unsigned ipt=0;ipt<n_intpt;ipt++)
  {
   //Get the integral weight
   double w = integral_pt()->weight(ipt);
   
   //Find the shape and test functions and return the Jacobian
   //of the mapping
   double J = shape_and_test_at_knot(ipt,psif,testf);
   
   //Premultiply the weights and the Jacobian
   double W = w*J;
   
   //Need to find position to feed into Traction function
   Vector<double> interpolated_x(Dim);
   
   //Initialise to zero
   for(unsigned i=0;i<Dim;i++) {interpolated_x[i] = 0.0;}
   
   //Calculate velocities and derivatives
   for(unsigned l=0;l<n_node;l++) 
    {
     //Loop over velocity components
     for(unsigned i=0;i<Dim;i++) {interpolated_x[i] += 
                                   nodal_position(l,i)*psif[l];}
    }
   
   // Get the outer unit normal
   Vector<double> interpolated_n(Dim);
   outer_unit_normal(ipt,interpolated_n);

   //Get the user-defined traction terms
   Vector<double> traction(Dim);
   get_traction(time,interpolated_x,interpolated_n,traction);
   
   //Now add to the appropriate equations
   
   //Loop over the test functions
   for(unsigned l=0;l<n_node;l++)
    {
     //Loop over the velocity components
     for(unsigned i=0;i<Dim;i++)
      {
       local_eqn = u_local_eqn(l,i);
       /*IF it's not a boundary condition*/
       if(local_eqn >= 0)
        {
         //Add the user-defined traction terms
         residuals[local_eqn] += traction[i]*testf[l]*W;
         
         //Assuming the the traction DOES NOT depend upon velocities
         //or pressures, the jacobian is always zero, so no jacobian
         //terms are required
        }
      } //End of loop over dimension
    } //End of loop over shape functions
   
  }
 
}



/////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////



//======================================================================
/// A class for elements that allow the imposition of an applied traction
/// to the Navier--Stokes equations 
/// The geometrical information can be read from the FaceGeometry<ELEMENT> 
/// class and and thus, we can be generic enough without the need to have
/// a separate equations class.
///
/// THIS IS THE REFINEABLE VERSION.
//======================================================================
template <class ELEMENT>
class RefineableNavierStokesTractionElement : 
public virtual NavierStokesTractionElement<ELEMENT>, 
 public virtual NonRefineableElementWithHangingNodes
{
  public:
 
 ///Constructor, which takes a "bulk" element and the face index
 RefineableNavierStokesTractionElement(FiniteElement* const &element_pt, 
                                          const int &face_index) : 
  // we're calling this from the constructor of the refineable version.
  NavierStokesTractionElement<ELEMENT>(element_pt, face_index,true)
  {}
  
 /// Destructor should not delete anything
 ~RefineableNavierStokesTractionElement() {}

 
 /// \short Number of continuously interpolated values are the
 /// same as those in the bulk element.
 unsigned ncont_interpolated_values() const
  {
   return dynamic_cast<ELEMENT*>(this->bulk_element_pt())->
    ncont_interpolated_values();
  }

 ///This function returns just the residuals
 inline void fill_in_contribution_to_residuals(Vector<double> &residuals)
  {
   //Call the generic residuals function using a dummy matrix argument
   refineable_fill_in_generic_residual_contribution_fluid_traction(
    residuals,GeneralisedElement::Dummy_matrix,0);
  }
 
 ///\short This function returns the residuals and the Jacobian 
 inline void fill_in_contribution_to_jacobian(Vector<double> &residuals,
                                              DenseMatrix<double> &jacobian)
  {
   //Call the generic routine
   refineable_fill_in_generic_residual_contribution_fluid_traction(residuals,
                                                                   jacobian,1);
  }
  

  protected:

 ///\short This function returns the residuals for the 
 /// traction function.
 ///flag=1(or 0): do (or don't) compute the Jacobian as well. 
 void refineable_fill_in_generic_residual_contribution_fluid_traction(
  Vector<double> &residuals, 
  DenseMatrix<double> &jacobian, 
  unsigned flag);

};


///////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////



//============================================================================
/// Function that returns the residuals for the imposed traction Navier_Stokes
/// equations
//============================================================================
template<class ELEMENT>
void RefineableNavierStokesTractionElement<ELEMENT>::
refineable_fill_in_generic_residual_contribution_fluid_traction(
 Vector<double> &residuals, 
 DenseMatrix<double> &jacobian, 
 unsigned flag)
{

 // Get the indices at which the velocity components are stored
 unsigned u_nodal_index[this->Dim];
 for(unsigned i=0;i<this->Dim;i++) 
  {
   u_nodal_index[i] = dynamic_cast<ELEMENT*>(
    this->bulk_element_pt())->u_index_nst(i);
  }
 
 //Find out how many nodes there are
 unsigned n_node = nnode();
 
 // Get continuous time from timestepper of first node
 double time=node_pt(0)->time_stepper_pt()->time_pt()->time();
  
 //Set up memory for the shape and test functions
 Shape psif(n_node), testf(n_node);
 
 //Set the value of n_intpt
 unsigned n_intpt = integral_pt()->nweight();
 
 //Integers to store local equation numbers
 int local_eqn=0;
  
 //Loop over the integration points
 for(unsigned ipt=0;ipt<n_intpt;ipt++)
  {
   //Get the integral weight
   double w = integral_pt()->weight(ipt);
   
   //Find the shape and test functions and return the Jacobian
   //of the mapping
   double J = this->shape_and_test_at_knot(ipt,psif,testf);
   
   //Premultiply the weights and the Jacobian
   double W = w*J;
   
   //Need to find position to feed into Traction function
   Vector<double> interpolated_x(this->Dim);
   
   //Initialise to zero
   for(unsigned i=0;i<this->Dim;i++) {interpolated_x[i] = 0.0;}
   
   //Calculate velocities and derivatives
   for(unsigned l=0;l<n_node;l++) 
    {
     //Loop over velocity components
     for(unsigned i=0;i<this->Dim;i++)
      {
       interpolated_x[i] += nodal_position(l,i)*psif[l];
      }
    }
   
   // Get the outer unit normal
   Vector<double> interpolated_n(this->Dim);
   this->outer_unit_normal(ipt,interpolated_n);

   //Get the user-defined traction terms
   Vector<double> traction(this->Dim);
   this->get_traction(time,interpolated_x,interpolated_n,traction);
   
   //Now add to the appropriate equations
   
   //Number of master nodes and storage for the weight of the shape function
   unsigned n_master=1; double hang_weight=1.0;
   
   //Pointer to hang info object
   HangInfo* hang_info_pt=0;
   
   //Loop over the nodes for the test functions/equations
   //----------------------------------------------------
   for(unsigned l=0;l<n_node;l++)
    {
     //Local boolean to indicate whether the node is hanging
     bool is_node_hanging = this->node_pt(l)->is_hanging();
     
     //If the node is hanging
     if(is_node_hanging)
      {
       hang_info_pt = this->node_pt(l)->hanging_pt();
       
       //Read out number of master nodes from hanging data
       n_master = hang_info_pt->nmaster();
      }
     //Otherwise the node is its own master
     else
      {
       n_master = 1;
      }
     
     //Loop over the master nodes
     for(unsigned m=0;m<n_master;m++)
      {
       // Loop over velocity components for equations
       for(unsigned i=0;i<this->Dim;i++)
        {
         //Get the equation number
         //If the node is hanging
         if(is_node_hanging)
          {
           //Get the equation number from the master node
           local_eqn = this->local_hang_eqn(hang_info_pt->master_node_pt(m),
                                            u_nodal_index[i]);
           //Get the hang weight from the master node
           hang_weight = hang_info_pt->master_weight(m);
          }
         //If the node is not hanging
         else
          {
           // Local equation number
           local_eqn = this->nodal_local_eqn(l,u_nodal_index[i]);
           
           // Node contributes with full weight
           hang_weight = 1.0;
          }
         
         //If it's not a boundary condition...
         if(local_eqn>= 0)
          {     
           
/*    //Loop over the test functions */
/*    for(unsigned l=0;l<n_node;l++) */
/*     { */
/*      //Loop over the velocity components */
/*      for(unsigned i=0;i<Dim;i++) */
/*       { */
/*        local_eqn = u_local_eqn(l,i); */
/*        /\*IF it's not a boundary condition*\/ */
/*        if(local_eqn >= 0) */
/*         { */
           
           
           
           //Add the user-defined traction terms
           residuals[local_eqn] += traction[i]*testf[l]*W*hang_weight;
           
           //Assuming the the traction DOES NOT depend upon velocities
           //or pressures, the jacobian is always zero, so no jacobian
           //terms are required
          }
        }
      } //End of loop over dimension
    } //End of loop over shape functions
   
  }
}
 

}

#endif
