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
//Driver using simple 2D poisson problem

//Generic routines
#include "generic.h"

// The Poisson equations
#include "poisson.h"

// The mesh
#include "meshes/rectangular_quadmesh.h"

using namespace std;
using namespace oomph;


//===== start_of_namespace=============================================
/// Namespace for exact solution for Poisson equation with "sharp step"
//=====================================================================
namespace TanhSolnForPoisson
{

 /// Parameter for steepness of "step"
 double Alpha=10.0;

 /// Parameter for angle Phi of "step"
 double TanPhi=0.0;

 /// Exact solution as a Vector
 void get_exact_u(const Vector<double>& x, Vector<double>& u)
 {
  u[0]=tanh(1.0-Alpha*(TanPhi*x[0]-x[1]));
 }

 /// Source function required to make the solution above an exact solution 
 void source_function(const Vector<double>& x, double& source)
 {
  source = 2.0*tanh(-1.0+Alpha*(TanPhi*x[0]-x[1]))*
   (1.0-pow(tanh(-1.0+Alpha*(TanPhi*x[0]-x[1])),2.0))*
   Alpha*Alpha*TanPhi*TanPhi+2.0*tanh(-1.0+Alpha*(TanPhi*x[0]-x[1]))*
   (1.0-pow(tanh(-1.0+Alpha*(TanPhi*x[0]-x[1])),2.0))*Alpha*Alpha;
 }
 
} // end of namespace





//====== start_of_problem_class=======================================
/// 2D Poisson problem on rectangular domain, discretised with
/// 2D QPoisson elements. The specific type of element is
/// specified via the template parameter.
//====================================================================
template<class ELEMENT> 
class PoissonProblem : public Problem
{

public:

 /// Constructor: Pass pointer to source function
 PoissonProblem(PoissonEquations<2>::PoissonSourceFctPt source_fct_pt);

 /// Destructor 
 ~PoissonProblem()
  { 
   delete mesh_pt()->spatial_error_estimator_pt();
   delete mesh_pt();

  }

 /// \short Update the problem specs before solve: Reset boundary conditions
 /// to the values from the exact solution.
 void actions_before_newton_solve();

 /// Update the problem after solve (empty)
 void actions_after_newton_solve(){}

 /// Bump up counter for number of Newton iterations
 void actions_before_newton_convergence_check()
  {
   Newton_count++;
  }

 /// Report number of Newton iterations taken
 unsigned newton_count(){return Newton_count-1;}

 /// \short Doc the solution. DocInfo object stores flags/labels for where the
 /// output gets written to
 void doc_solution(DocInfo& doc_info);
 
 /// \short Overloaded version of the problem's access function to 
 /// the mesh. Recasts the pointer to the base Mesh object to 
 /// the actual mesh type.
 RefineableRectangularQuadMesh<ELEMENT>* mesh_pt()
  {
   return dynamic_cast<RefineableRectangularQuadMesh<ELEMENT>*>(
    Problem::mesh_pt());
  }

 
private:

 /// Pointer to source function
 PoissonEquations<2>::PoissonSourceFctPt Source_fct_pt;

 /// Number of Newton iterations
 unsigned Newton_count;

}; // end of problem class




//=====start_of_constructor===============================================
/// Constructor for Poisson problem: Pass pointer to source function.
//========================================================================
template<class ELEMENT>
PoissonProblem<ELEMENT>::
PoissonProblem(PoissonEquations<2>::PoissonSourceFctPt source_fct_pt)
 :  Source_fct_pt(source_fct_pt)
{
 // The problem is linear
 //Problem_is_nonlinear = false;

 // Setup mesh
 
 // # of elements in x-direction
 unsigned n_x=10;

 // # of elements in y-direction
 unsigned n_y=10;

 // Domain length in x-direction
 double l_x=1.0;

 // Domain length in y-direction
 double l_y=2.0;

 // Build and assign mesh
 Problem::mesh_pt() =
  new RefineableRectangularQuadMesh<ELEMENT>(n_x,n_y,l_x,l_y);

 // Create/set error estimator
 mesh_pt()->spatial_error_estimator_pt()=new Z2ErrorEstimator;

 // Set the boundary conditions for this problem: All nodes are
 // free by default -- only need to pin the ones that have Dirichlet conditions
 // here.
 unsigned n_bound = mesh_pt()->nboundary();
 for(unsigned i=0;i<n_bound;i++)
  {
   unsigned n_node = mesh_pt()->nboundary_node(i);
   for (unsigned n=0;n<n_node;n++)
    {
     mesh_pt()->boundary_node_pt(i,n)->pin(0);
    }
  }

 // Complete the build of all elements so they are fully functional

 // Loop over the elements to set up element-specific 
 // things that cannot be handled by the (argument-free!) ELEMENT 
 // constructor: Pass pointer to source function
 unsigned n_element = mesh_pt()->nelement();
 for(unsigned i=0;i<n_element;i++)
  {
   // Upcast from GeneralsedElement to the present element
   ELEMENT *el_pt = dynamic_cast<ELEMENT*>(mesh_pt()->element_pt(i));

   //Set the source function pointer
   el_pt->source_fct_pt() = Source_fct_pt;
  }


 // Setup equation numbering scheme
 cout <<"Number of equations: " << assign_eqn_numbers() << endl;

} // end of constructor




//========================================start_of_actions_before_newton_solve===
/// Update the problem specs before solve: Set nodal values to zero and
/// (Re-)set boundary conditions to the values from the exact solution
//========================================================================
template<class ELEMENT>
void PoissonProblem<ELEMENT>::actions_before_newton_solve()
{

 // Reset counter
 Newton_count=0;

 // Loop over nodes and set values to zero
 unsigned n_node=mesh_pt()->nnode();
 for (unsigned j=0; j<n_node; j++)
  {
   Node* node_pt=mesh_pt()->node_pt(j);
   node_pt->set_value(0,0.0);
  }
  
 // How many boundaries are there?
 unsigned n_bound = mesh_pt()->nboundary();
 
 //Loop over the boundaries
 for(unsigned i=0;i<n_bound;i++)
  {
   // How many nodes are there on this boundary?
   unsigned n_node = mesh_pt()->nboundary_node(i);

   // Loop over the nodes on boundary
   for (unsigned n=0;n<n_node;n++)
    {
     // Get pointer to node
     Node* nod_pt=mesh_pt()->boundary_node_pt(i,n);

     // Extract nodal coordinates from node:
     Vector<double> x(2);
     x[0]=nod_pt->x(0);
     x[1]=nod_pt->x(1);

     // Compute the value of the exact solution at the nodal point
     Vector<double> u(1);
     TanhSolnForPoisson::get_exact_u(x,u);

     // Assign the value to the one (and only) nodal value at this node
     nod_pt->set_value(0,u[0]);
    }
  } 
}  // end of actions before solve



//===============start_of_doc=============================================
/// Doc the solution: doc_info contains labels/output directory etc.
//========================================================================
template<class ELEMENT>
void PoissonProblem<ELEMENT>::doc_solution(DocInfo& doc_info)
{ 

 ofstream some_file;
 char filename[100];

 // Number of plot points: npts x npts
 unsigned npts=5;

 // Output solution 
 //-----------------
 sprintf(filename,"%s/soln%i.dat",doc_info.directory().c_str(),
         doc_info.number());
 some_file.open(filename);
 mesh_pt()->output(some_file,npts);
 some_file.close();


 // Output exact solution 
 //----------------------
 sprintf(filename,"%s/exact_soln%i.dat",doc_info.directory().c_str(),
         doc_info.number());
 some_file.open(filename);
 mesh_pt()->output_fct(some_file,npts,TanhSolnForPoisson::get_exact_u); 
 some_file.close();

 // Doc error and return of the square of the L2 error
 //---------------------------------------------------
 double error,norm;
 sprintf(filename,"%s/error%i.dat",doc_info.directory().c_str(),
         doc_info.number());
 some_file.open(filename);
 mesh_pt()->compute_error(some_file,TanhSolnForPoisson::get_exact_u,
                          error,norm); 
 some_file.close();

 // Doc L2 error and norm of solution
 cout << "\nNorm of error   : " << sqrt(error) << endl;
 cout << "Norm of solution: " << sqrt(norm) << endl << endl;

} // end of doc






//===== start_of_main=====================================================
/// Driver code for 2D Poisson problem
//========================================================================
int main(int argc, char **argv)
{
 // Set the orientation of the "step" to 45 degrees
 TanhSolnForPoisson::TanPhi=1.0;

 // Initial value for the steepness of the "step"
 TanhSolnForPoisson::Alpha=1.0;
 
 // Create the problem with 2D nine-node elements from the
 // QPoissonElement family. Pass pointer to source function.
 PoissonProblem<RefineableQPoissonElement<2,2> >
  problem(&TanhSolnForPoisson::source_function);
    
 DocInfo doc_info;
 doc_info.set_directory("RESLT");

 // File to report the number of Newton iterations
 ofstream conv_file;
 char filename[100];
 sprintf(filename,"%s/conv.dat",doc_info.directory().c_str());
 conv_file.open(filename);
 
 // Test the Hypre linear solvers
 cout << "=====================" << endl;
 cout << "Testing Hypre solvers" << endl;
 cout << "=====================" << endl;

 // Create a new Hypre linear solver
 HypreSolver* hypre_linear_solver_pt = new HypreSolver;

 // Set the linear solver for problem
 problem.linear_solver_pt() = hypre_linear_solver_pt;

 // Set some solver parameters
 hypre_linear_solver_pt->max_iter() = 100;
 hypre_linear_solver_pt->tolerance() = 1e-10;
 hypre_linear_solver_pt->amg_simple_smoother() = 1;
 hypre_linear_solver_pt->disable_doc_time();
 hypre_linear_solver_pt->enable_hypre_error_messages();
 hypre_linear_solver_pt->amg_print_level() = 0;
 hypre_linear_solver_pt->krylov_print_level() = 0;
 
 // Loop over hypre solvers
 //------------------------
 for (unsigned s=0; s<=3; s++)
  {
   // Select the actual iterative linear solver
   switch(s)
    {
    case 0: 
     hypre_linear_solver_pt->hypre_method() = HypreSolver::BoomerAMG;
     break;
    case 1: 
     hypre_linear_solver_pt->hypre_method() = HypreSolver::CG;
     break;
    case 2:
     hypre_linear_solver_pt->hypre_method() = HypreSolver::GMRES;
     break;
    case 3:
     hypre_linear_solver_pt->hypre_method() = HypreSolver::BiCGStab;
     break;
    default: cout << "Error selecting solver" << endl;
    }


   // Loop over preconditioners (except for AMG solver which is not
   // preconditioned)
   unsigned tests;
   if (s==0)
    {
     tests = 1;
    }
   else
    {
     tests = 4;
    }
  
   for (unsigned p=0; p<tests; p++)
    {
     // set the preconditioner
     switch(p)
      {
      case 0:
       hypre_linear_solver_pt->internal_preconditioner()=HypreSolver::None;
       break;
      case 1:
       hypre_linear_solver_pt->internal_preconditioner()=HypreSolver::BoomerAMG;
       break;
      case 2:
       hypre_linear_solver_pt->internal_preconditioner()=HypreSolver::Euclid;
       break;
      case 3:
       hypre_linear_solver_pt->internal_preconditioner()=HypreSolver::ParaSails;
       break;
      default: cout << "Error selecting preconditioner" << endl;
      }
    
     // Solve the problem
     problem.newton_solve(); 
    
     // Doc
     problem.doc_solution(doc_info);
     doc_info.number()++;
     oomph_info << "Number of Newton iterations: " << problem.newton_count() 
                << std::endl << std::endl;
     conv_file << problem.newton_count() << std::endl;

    } // end of loop over preconditioner
  } // end of loop over solvers
 
 // delete the Hypre solver
 delete hypre_linear_solver_pt;
 
 


 // Test the oomph-lib iterative linear solvers with the hypre preconditioners
 //---------------------------------------------------------------------------
 
 cout
  << "=====================================================================" 
  << endl;
 cout 
  << "Testing oomph-lib iterative linear solvers with Hypre preconditioners"
  << endl;
 cout
  << "=====================================================================" 
  << endl;
 
 // Create a new Hypre preconditioner
 HyprePreconditioner* hypre_preconditioner_pt = new HyprePreconditioner;
 
 // Set preconditioner parameters
 hypre_preconditioner_pt->enable_hypre_error_messages();
 
 // Test CG
 //========

 cout << "CG iterative solver" << endl;
 cout << "-------------------" << endl;


 IterativeLinearSolver* oomph_linear_solver_pt = new CG<CRDoubleMatrix>;
 problem.linear_solver_pt() = oomph_linear_solver_pt;
 oomph_linear_solver_pt->tolerance()=1.0e-10;

 
 // Run through the different hypre solver methods suitable for preconditioning
 for (unsigned p=1; p<=3; p++)
  {
   unsigned prec_method=0;
   
   switch(p)
    {
    case 1:
     prec_method = HyprePreconditioner::BoomerAMG;
     break;
     
    case 2:
     prec_method = HyprePreconditioner::Euclid;
     break;
     
    case 3:
     prec_method = HyprePreconditioner::ParaSails;
     break;
     
    default: cout << "Error selecting preconditioner" << endl;
    }
   
   // set the preconditioning method within the hypre solver
   hypre_preconditioner_pt->hypre_method() = prec_method;
   
   // set the preconditioner in the iterative solver
   oomph_linear_solver_pt->preconditioner_pt()=hypre_preconditioner_pt;
   
   // Solve the problem
   problem.newton_solve(); 

   // Doc
   problem.doc_solution(doc_info);
   doc_info.number()++;
   oomph_info << "Number of Newton iterations: " << problem.newton_count() 
              << std::endl << std::endl;
   conv_file << problem.newton_count() << std::endl;
  }
 delete oomph_linear_solver_pt;
 

 // Test BiCGStab
 //==============

 cout << "BiCGStab iterative solver" << endl;
 cout << "-------------------------" << endl;

 // Build and instance of BiCGStab and pass it to the problem
 oomph_linear_solver_pt = new BiCGStab<CRDoubleMatrix>;

 problem.linear_solver_pt() = oomph_linear_solver_pt;

 oomph_linear_solver_pt->tolerance()=1.0e-10;


 // Run through the different hypre methods suitable for preconditioning
 for (unsigned p=1; p<=3; p++)
  {
   // set the preconditioning method 
   switch(p)
    {
    case 1:
     hypre_preconditioner_pt->hypre_method() = HyprePreconditioner::BoomerAMG;
     break;
     
    case 2:
     hypre_preconditioner_pt->hypre_method() = HyprePreconditioner::Euclid;
     break;
     
    case 3:
     hypre_preconditioner_pt->hypre_method() = HyprePreconditioner::ParaSails;
     break;
     
    default: cout << "Error selecting preconditioner" << endl;
    }


   
   // set the preconditioner in the iterative solver
   oomph_linear_solver_pt->preconditioner_pt()=hypre_preconditioner_pt;
   
   // Solve the problem
   problem.newton_solve(); 

   // Doc
   problem.doc_solution(doc_info);
   doc_info.number()++;
   oomph_info << "Number of Newton iterations: " << problem.newton_count() 
              << std::endl << std::endl;
   conv_file << problem.newton_count() << std::endl;

  }
 delete oomph_linear_solver_pt;


 // Test GMRES
 //===========

 cout << "GMRES iterative solver" << endl;
 cout << "----------------------" << endl;
 oomph_linear_solver_pt = new GMRES<CRDoubleMatrix>;
 oomph_linear_solver_pt->tolerance()=1.0e-10;
 problem.linear_solver_pt() = oomph_linear_solver_pt;


 // run through the different hypre solver methods suitable for preconditioning
 for (unsigned p=1; p<=3; p++)
  {
   unsigned prec_method=0;
  
  
   switch(p)
    {
    case 1:
     prec_method = HyprePreconditioner::BoomerAMG;
     break;
    
    case 2:
     prec_method = HyprePreconditioner::Euclid;
     break;
    
    case 3:
     prec_method = HyprePreconditioner::ParaSails;
     break;
    
    default: cout << "Error selecting preconditioner" << endl;
    }
  
   // set the preconditioning method within the hypre solver
   hypre_preconditioner_pt->hypre_method() = prec_method;
  
   // set the preconditioner in the iterative solver
   oomph_linear_solver_pt->preconditioner_pt() = hypre_preconditioner_pt;
  
   // Solve the problem
   problem.newton_solve();

   // Doc
   problem.doc_solution(doc_info);
   doc_info.number()++;
   oomph_info << "Number of Newton iterations: " << problem.newton_count() 
              << std::endl << std::endl;
   conv_file << problem.newton_count() << std::endl;
  }
 delete oomph_linear_solver_pt;
 delete hypre_preconditioner_pt;

 conv_file.close();

} //end of main









