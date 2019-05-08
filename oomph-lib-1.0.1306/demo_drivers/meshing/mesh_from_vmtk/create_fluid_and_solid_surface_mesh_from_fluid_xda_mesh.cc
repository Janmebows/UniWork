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
// ============================================================================
/// This driver code takes as input the mesh generated by VMTK in '.xda' format
/// and the wall thickness. The outputs are the fluid and solid domain surfaces
///============================================================================
/**
    the original Boundary Ids assigned by VMTK:
                                                  Boundary 3
                                                 ______
                                                /     /                     
                                               /     /                     
                                              /     /                  
                             ----------------/     /                       
                            |                     /                        
           Boundary 2       |                    /                         
                            |                    \
                            |                     \
                             ----------------\     \
                              Boundary 1      \     \
                                               \     \
                                                \_____\
                                                Boundary 4
  
 In this code, we kept the same boundary numbers for the fluid surface. 
 The boundary numbers for the Solid mesh are as follow :
  
                                                  Boundary 3
                                                __      __
                                               / /     / /  
                                  Boundary 5  / /     / /
                             |---------------/ /     / /
             Boundary 2      |----------------/     / /
                                                   / /
                                                  / /
                                                  \ \                   .
                                   Boundary 1      \ \
                             |----------------\     \ \
                             |---------------\ \     \ \
                                              \ \     \ \
                                               \ \     \ \
                                                --      --
                                                  Boundary 4

 Then we assigned to each face in the fluid mesh and in the solid mesh 
 its own boubdary ID if the input bool do_multi_boundary_ids is true
 (because some functions in oomph-lib require that all faces with the 
 same boundary ID should be planar). Find the boundary IDs informations
 in the end of the output '.poly' files. 
**/
//=============================================================================
//#include "generic.h"
//using namespace oomph;

#include<iostream>
#include<string>
#include<fstream>
#include<vector>
#include<map>
#include<cmath>
#include<cstdlib>

void create_fluid_and_solid_surface_mesh_from_fluid_xda_mesh( 
 const std::string& file_name,
 const std::string& fluid_surface_file,
 const std::string& solid_surface_file,
 const double& wall_tickness, 
 const bool& do_multi_boundary_ids=true)
{
 std::ifstream infile(file_name.c_str(),std::ios_base::in);
 unsigned  n_node;
 unsigned n_element;
 unsigned nbound_cond;

 // Dummy storage to jump lines
 char  dummy[100];

 infile.getline(dummy, 100);
 
 // get number of elements
 infile>>n_element;
 infile.getline(dummy, 100);

 // get number of nodes
 infile>>n_node;
 infile.getline(dummy, 100);
 infile.getline(dummy, 100);
 
 // get number of boundaries
 infile>>nbound_cond;

 // jump to the first line storing element's informations
 while (dummy[0]!= 'T')
  {infile.getline(dummy, 100);}


 // storage for the global node numbers listed element-by-element
 std::vector<unsigned> global_node(n_element*4);

 unsigned k=0;
 for(unsigned i=0;i<n_element;i++)
  {
   for(unsigned j=0;j<4;j++)
    {
     infile>>global_node[k];
     k++;
    }
  }
 

 // Create storage for coordinates
 std::vector<double> x_node(n_node);
 std::vector<double> y_node(n_node);
 std::vector<double> z_node(n_node);
 
 // get nodes coordinates
 for(unsigned i=0;i<n_node;i++)
  {
   infile>>x_node[i];
   infile>>y_node[i];
   infile>>z_node[i];
  }

 // vector of bools, will tell us if we already visited a node
 std::vector<bool> done_for_fluid(n_node,false);
 std::vector<bool> done_for_solid(n_node,false);

 // A map, indexed by the old node number, gives the new node number 
 // in the fluid poly file
 std::map<unsigned,unsigned> fluid_node_nmbr;
 
 // each node in the fluid surface gives birth to two nodes in the solid 
 // surface, one in the inner surface and the other in the outer surface.
 // these maps, indexed by the old node number, give the new node number 
 // in the solid poly file
 std::map<unsigned,unsigned> solid_inner_node_nmbr;
 std::map<unsigned,unsigned> solid_outer_node_nmbr;

 // nfluid_face[i] will store the number of faces on boundary i+1
 std::vector<unsigned> nfluid_face(4);
  
 // nsolid_linking_faces[i] will store the number of faces on boundary i+2
 // NB: we don't store the number of faces in boundaries 1 and 5 because 
 // they are the same as the number of fluid faces on boundary 1
 std::vector<unsigned> nsolid_linking_faces(3); 
 
 // number of nodes in the solid surface
 unsigned  n_solid_node=0;

 // number of nodes in the fluid surface
 unsigned  n_fluid_node=0;
 
 // Create storage for outer solid nodes coordinates. Indexed by the old 
 // node number, these maps returns the nodes coordinates.
 std::map<unsigned, double> x_outer_node;
 std::map<unsigned, double> y_outer_node;
 std::map<unsigned, double> z_outer_node;
  
 // Create storage for fluid faces informations :
 // fluid_faces[i][j] will store a vector containing the three node numbers 
 // of the j-th face in the (i+1)-th boundary
 std::vector< std::vector<std::vector<unsigned> > > 
  fluid_faces(4, std::vector<std::vector<unsigned> >(nbound_cond,std::vector<unsigned>(3) ));

 // Create storage for solid faces informations :
 // As the solid inner and outer faces come from the fluid surface, 
 // we only need to store solid face informations in boundary 2,3 and 4. 
 // solid_faces[i][j] will store a vector containing the three node numbers 
 // of the j-th face in the (i+2)-th boundary
 std::vector< std::vector<std::vector<unsigned> > > 
  solid_linking_faces(3, std::vector<std::vector<unsigned> >(nbound_cond,
                                                   std::vector<unsigned>(3) ));
 
  // Create storage for boundary informations
 unsigned element_nmbr;
 unsigned side_nmbr;
 int bound_id;

 for(unsigned i=0;i<nbound_cond;i++)
  {
   infile>> element_nmbr ;
   infile>> side_nmbr ;
   infile>> bound_id ;

   if(bound_id!=1 && bound_id!=2 && bound_id!=3 && bound_id!=4 )
    {
     std::cout << "This function only takes xda type meshes with"
               << "one inflow(boundary 2) and two outflow(boundary 3"
               << "and 4), the countours must have the id 1. You have"
               << "in your input file a boundary id : " << bound_id <<".\n"
               << "Don't panic, there are only few things to change"
               << "in this well commented code, good luck ;)  \n";
     abort();
    }
        
   // get the side nodes numbers and normal_sign following the side numbering
   // conventions in '.xda' mesh files.
   std::vector<unsigned> side_node(3);
   int  normal_sign=1;  

   switch(side_nmbr)
    {
    case 0:
     side_node[0]=global_node[4*element_nmbr];
     side_node[1]=global_node[4*element_nmbr+1];
     side_node[2]=global_node[4*element_nmbr+2];
     normal_sign=-1;
     break;
       
    case 1:
     side_node[0]=global_node[4*element_nmbr];
     side_node[1]=global_node[4*element_nmbr+1];
     side_node[2]=global_node[4*element_nmbr+3];
     break;

    case 2:
     side_node[0]=global_node[4*element_nmbr+1];
     side_node[1]=global_node[4*element_nmbr+2];
     side_node[2]=global_node[4*element_nmbr+3];
     break;

    case 3:
     side_node[0]=global_node[4*element_nmbr];
     side_node[1]=global_node[4*element_nmbr+2];
     side_node[2]=global_node[4*element_nmbr+3];
     normal_sign=-1;
     break;
       
    default :
     std::cout << "unexpected side number in your '.xda' input file\n"
               <<"in create_fluid_and_solid_surface_mesh_from_fluid_xda_mesh";
     abort();
    }
      
   if(bound_id==1)
    {
     // Create storage for the normal vector to the face
     std::vector<double> normal(3,0.);
   
     // get the node's coordinates
     double x1=x_node[side_node[0] ]; 
     double x2=x_node[side_node[1] ];
     double x3=x_node[side_node[2] ];

     double y1=y_node[side_node[0] ];
     double y2=y_node[side_node[1] ];
     double y3=y_node[side_node[2] ];

     double z1=z_node[side_node[0] ];
     double z2=z_node[side_node[1] ];
     double z3=z_node[side_node[2] ];

     // compute a normal vector 
     normal[0] =(y2-y1)*(z3-z1) - (z2-z1)*(y3-y1);                 
     normal[1] =(z2-z1)*(x3-x1) - (x2-x1)*(z3-z1); 
     normal[2] =(x2-x1)*(y3-y1) - (y2-y1)*(x3-x1);
     
     // adjust the vector in order to have an external  normal vector 
     double length= sqrt((normal[0])*(normal[0]) + (normal[1])*(normal[1])
                         + (normal[2])*(normal[2]));
     for(unsigned idim=0; idim<3; idim++)
      {
       normal[idim]*=normal_sign/length;
      }
   
     // loop over the face's nodes
     for(unsigned ii=0; ii<3; ii++)
      {
       // get the node number
       unsigned inod=side_node[ii];

       if(!done_for_fluid[inod])
        {
         done_for_fluid[inod]=true;

         // this node is a fluid node
         n_fluid_node++;
        }
       if(!done_for_solid[inod])
        {
         done_for_solid[inod]=true;

         // this node is a solid node on boundary 1 and this node 
         // creates an other one on boundary 5
         n_solid_node+=2;
     
         // compute the coordinates of the new node (on boundary 5)
         x_outer_node[inod]= x_node[inod]+ wall_tickness* normal[0];
         y_outer_node[inod]= y_node[inod]+ wall_tickness* normal[1];
         z_outer_node[inod]= z_node[inod]+ wall_tickness* normal[2];
        }
      }
      
     // this is a fluid face on boundary 1
     nfluid_face[0]++;

     // store the face node numbers
     for(unsigned ii=0;ii<3; ii++)
      {
       fluid_faces[0][nfluid_face[0]-1][ii]=side_node[ii];
      }
    }
   // if we are on boundary 2,3 or 4
   else
    {
     // loop over the face's nodes
     for(unsigned ii=0; ii<3; ii++)
      {
       // get the node number
       unsigned inod=side_node[ii];

       if(!done_for_fluid[inod])
        {
         done_for_fluid[inod]=true;
         
         // this node is a fluid node
         n_fluid_node++;
        }
      }
     // this is a fluid face on boundary bound_id
     nfluid_face[bound_id-1]++;

     // store the face node numbers
     for(unsigned ii=0;ii<3; ii++)
      {
       fluid_faces[bound_id-1][nfluid_face[bound_id-1]-1][ii]=side_node[ii];
      }
    }
  }
 infile.close();


 // resize :
 for(unsigned i=0; i<4; i++)
  {
   fluid_faces[i].resize(nfluid_face[i]);
  }

 //-------------------------------------------------------------------
 // write some comments in the beginning of the fluid and solid sufaces
 //-------------------------------------------------------------------
 std::ofstream fluid_output_stream(fluid_surface_file.c_str(),std::ios::out);
 fluid_output_stream << "# this poly file is the extraction of"
                     <<" the fluid surface from the VMTK mesh ." << '\n'
                     << "# VMTK assigns for the front inflow "
                     <<"face the boundary id 2, for the  left " << '\n'
                     <<"# bifurcation face the id 3, for the right"
                     <<" bifurcation face the id 4 and for the other"
                     <<" boundaries the id 1 " << '\n'
                     << "# Oomph-lib's meshes need for each planar face  "
                     <<"it's own id, so we assign new boundary ids."<< '\n'
                     <<"# Find in the end of this poly file the information"
                     <<" of the new boundary ids :" << '\n';

 std::ofstream solid_output_stream(solid_surface_file.c_str(),std::ios::out);
 solid_output_stream << "# this poly file is the solid PLC extracted from"
                     <<" the fluid VMTK mesh." << '\n'
                     << "# Oomph-lib's meshes need for each planar face  "
                     <<"it's own id, so we assign new boundary ids."<< '\n'
                     <<"# Find in the end of this poly file the information "
                     <<"of the new boundary ids :" << '\n';

 //------------------------------------------
 // write the node list of the fluid surface 
 //------------------------------------------
 fluid_output_stream << '\n' << "# Node list : " << '\n';
 // write the node number(dimension =3 , no attributes, with boundary markers) 
 fluid_output_stream <<  n_fluid_node <<  ' ' << 3 <<  ' ' << 0 
                     <<  ' ' << 1 << '\n'<< '\n';
   
 std::vector<bool> done_fluid_node(n_node,false);
 unsigned counter=0;

 // loop over the boundaries
 for(unsigned i=0; i<4; i++)
  {
   // how many faces are on boundary 'i+1' ?
   unsigned nface=nfluid_face[i];
   // loop over the faces
   for(unsigned iface=0; iface<nface; iface++)
    {
     // get pointer to the vector storing the three nodes
     std::vector<unsigned>* face_node=&(fluid_faces[i][iface]);
     // loop over the face's nodes
     for(unsigned ii=0; ii<3; ii++)
      {
       // get the node number (in the old numbering scheme)
       unsigned inod=(*face_node)[ii];
       if(!done_fluid_node[inod])
        {
         done_fluid_node[inod]=true;
         counter++;

         // assign the new node number in the fluid surface
         fluid_node_nmbr[inod]=counter;

         // write the node coordinates (boundary marker =0 )
         fluid_output_stream <<  counter <<  ' ' 
                             << x_node[inod]  <<  ' ' 
                             << y_node[inod]  <<  ' ' 
                             << z_node[inod] << ' '
                             << 0 << '\n'; 
        }
      } 
    }
  }

 //------------------------------------------
 // write the node list of the solid surface
 //------------------------------------------
 solid_output_stream << '\n' << "# Node list : " << '\n';
 // write the node number(dimension =3 , no attributes, with boundary markers) 
 solid_output_stream <<  n_solid_node <<  ' ' << 3 <<  ' ' << 0 
                     <<  ' ' << 1 << '\n'<< '\n';
 std::vector<bool> done_solid_node(n_node,false);

 counter=0;

 // how many faces are on boundary 0
 unsigned nface=nfluid_face[0];

 // loop over the faces
 for(unsigned iface=0; iface<nface; iface++)
  {
   // get pointer to the vector storing the three nodes
   std::vector<unsigned>* face_node=&(fluid_faces[0][iface]);
   // loop over the face's nodes
   for(unsigned ii=0; ii<3; ii++)
    {
     // get the node number (in the old numbering scheme)
     unsigned inod=(*face_node)[ii];
     if(!done_solid_node[inod])
      {
       done_solid_node[inod]=true;
       counter++;

       // assign the new node number in the solid surface
       solid_inner_node_nmbr[inod]=counter;

       solid_output_stream <<  counter <<  ' ' 
                           << x_node[inod]  <<  ' ' 
                           << y_node[inod]  <<  ' ' 
                           << z_node[inod] << ' '
                           << 0 << '\n'; 
 
       // store the new nodes on boundary 5
       counter++;

       // assign the new node number in the solid surface
       solid_outer_node_nmbr[inod]=counter;

       solid_output_stream <<  counter <<  ' ' 
                           << x_outer_node[inod]  <<  ' ' 
                           << y_outer_node[inod]  <<  ' ' 
                           << z_outer_node[inod] << ' '
                           << 0   << '\n';
      }   
    } 
  }

 //-----------------------------------------
 // write the face list of the fluid surface
 //-----------------------------------------
 fluid_output_stream << '\n' << "# Face list : " << '\n';
 fluid_output_stream <<  nfluid_face[0]+nfluid_face[1]+nfluid_face[2]
  +nfluid_face[3] <<  ' ' << 1 << '\n'<< '\n'; 
 counter=0;
 for(unsigned i=0; i<4; i++)
  {
   fluid_output_stream <<'\n'
                       << "#============================="
                       <<"====================================="
                       << '\n'<<"# Faces Originally on boundary " 
                       << i+1 << '\n'
                       <<"# --------------------------------" << '\n';

   // how many faces are on boundary 'i+1' ?
   unsigned nface=nfluid_face[i];
   // loop over the all faces
   for(unsigned iface=0; iface<nface; iface++)
    {
     counter++;
     fluid_output_stream <<"# Face " << counter << '\n'; 
      
     // one polygon, zero holes
     fluid_output_stream << 1 <<  ' ' << 0 << ' ' ;

     // If we want for each planar face its own ID, the boundary ID is 
     // counter, otherwise, the boundary ID is i+1
     if(do_multi_boundary_ids)
      fluid_output_stream << counter << '\n';
     else
      fluid_output_stream << i+1 << '\n';

       
     // We have three vertices
     fluid_output_stream << 3 <<  ' ' ;
       
     // get pointer to the vector storing the three nodes
     std::vector<unsigned>* face_node=&(fluid_faces[i][iface]);

     // This vector will store the nodes that are in both boundaries 1 and 
     // another one (2,3 or 4). We only store this nodes if we have in the
     // face two or more double boundary nodes.
     std::vector< unsigned> double_boundary_nod(3);

     // storage for the size of double_boundary_nod;
     unsigned n_double_boundary_nodes=0;

     // loop over the three nodes
     for(unsigned l=0; l<3;l++)
      {
         
       // get the old node number
       unsigned inod=(*face_node)[l];
       
       // Write the vertices indices 
       fluid_output_stream <<fluid_node_nmbr[inod] << ' ';
         
       // find out how many nodes are double boundary nodes
       if(i!=0)
        {
         if(done_for_solid[inod])
          {
           double_boundary_nod[n_double_boundary_nodes]=inod;
           n_double_boundary_nodes++;
          }
        }
      }
       
     // if we have more than one double boundary node
     // create faces linking the solid faces on
     // boundary 1 and the solid faces on boundary 5
     if(n_double_boundary_nodes>1) 
      {
       for(unsigned idbn=0; idbn<n_double_boundary_nodes-1; idbn++)
        {
         // each two double boundary nodes create two faces
         for(unsigned j=0; j<2; j++)
          {    
           unsigned index=0;

           for(unsigned l=j+idbn; l<2+idbn; l++)
            {
             // *[i-1] because *[k] stores informations for the 
             // (k+2)-th boundary
             solid_linking_faces[i-1][nsolid_linking_faces[i-1]][index]= 
              solid_inner_node_nmbr[double_boundary_nod[l]];
             index++;
            }
           for(unsigned l=idbn; l<idbn+j+1; l++)
            {
             // *[i-1] because *[k] stores informations for the 
             // (k+2)-th boundary
             solid_linking_faces[i-1][nsolid_linking_faces[i-1]][index]=
              solid_outer_node_nmbr[double_boundary_nod[l]];
             index++;
            }
           nsolid_linking_faces[i-1]++;
          }           
        }
      }
     fluid_output_stream << '\n'<< '\n';
    }
  } 


 //-----------------------------------------
 // write the face list of the solid surface
 //-----------------------------------------
 solid_output_stream << '\n' << "# Face list : " << '\n';
 solid_output_stream <<  2*nfluid_face[0]+ nsolid_linking_faces[0]
  + nsolid_linking_faces[1]+ nsolid_linking_faces[2]  
                     <<  ' ' << 1 << '\n'<< '\n';
  
 counter=0;
 for(unsigned i=0; i<5; i++)
  {
   solid_output_stream <<'\n'
                       << "#====================================="
                       <<"============================="
                       << '\n'<<"# Faces Originally on boundary "
                       <<i+1 << '\n'
                       <<"# --------------------------------" << '\n';
   // get the number of faces
   unsigned nface;
   if(i==0 || i==4) nface=nfluid_face[0];
   else nface=nsolid_linking_faces[i-1];

   for(unsigned iface=0; iface<nface; iface++)
    {
     // get pointer to the vector storing the three nodes
     std::vector<unsigned>* face_node;
     if(i==0 || i==4) face_node=&(fluid_faces[0][iface]);
     // *[i-1] because *[k] stores informations for the (k+2)-th boundary
     else face_node=&(solid_linking_faces[i-1][iface]);
       
     counter++;
     solid_output_stream <<"# Face " <<  counter << '\n';  
      
     // one polygon, zero holes, boundary  counter
     solid_output_stream << 1 <<  ' ' << 0 << ' ' ;
     
     // If we want for each planar face its own ID, the boundary ID is 
     // counter, otherwise, the boundary ID is i+1
     if(do_multi_boundary_ids)
      solid_output_stream << counter << '\n';
     else
      solid_output_stream << i+1 << '\n'; 
     
     // three vertices and their indices in node list
     solid_output_stream << 3 <<  ' ' ;
       
     // loop over the three nodes
     for(unsigned l=0; l<3;l++)
      {
       // get the node number
       unsigned inod=(*face_node)[l];

       if(i==0)
        {
         // it's the old node number
         solid_output_stream << solid_inner_node_nmbr[inod] << ' ';
        }
       else if(i==4)
        {
         // it's the old node number
         solid_output_stream << solid_outer_node_nmbr[inod] << ' ';
        }
       else
        {
         // it's the new node number
         solid_output_stream <<inod << ' ';
        }

      } 
     solid_output_stream << '\n'<< '\n';
    }
  }


 //----------------------------------------------------
 // write the Hole and Region lists of the fluid
 // and solid (empty)
 //----------------------------------------------------
 fluid_output_stream << '\n' << "# Hole list : " << '\n';
 fluid_output_stream << 0 << '\n';
 fluid_output_stream << '\n' << "# Region list : " << '\n';
 fluid_output_stream << 0 << '\n';

 solid_output_stream << '\n' << "# Hole list : " << '\n';
 solid_output_stream << 0 << '\n';
 solid_output_stream << '\n' << "# Region list : " << '\n';
 solid_output_stream << 0 << '\n';

   

 //------------------------------------------------------
 // write the boundary informations for the fluid surface
 //------------------------------------------------------
 fluid_output_stream << '\n'<< '\n'<< '\n' 
                     <<"# The new boundary ids are as follow:"<< '\n' << '\n'; 

 for(unsigned i=0; i<4; i++)
  {
   fluid_output_stream << "# Boundary "<< i+1
                       << " : from boundary id " ;
   // get the first boundary id:
   unsigned id=0;
   for(unsigned j=0; j<i; j++)
    {
     id+=nfluid_face[j];
    }

   fluid_output_stream << id << " until boundary id " 
                       << id+nfluid_face[i]-1 << '\n';
  }
 fluid_output_stream.close();
        
   
 //------------------------------------------------------
 // write the boundary informations for the solid surface
 //------------------------------------------------------
 solid_output_stream << '\n'<< '\n'<< '\n' 
                     <<"# The new boundary ids are as follow:"<< '\n' << '\n';

 solid_output_stream << "# the inner surface : from boundary id "  
                     << 0 << " until boundary id "; 
 unsigned id=nfluid_face[0]-1;
 solid_output_stream << id << "\n";
  

 solid_output_stream << "# the front inflow face : from boundary id "  
                     << id+1 << " until boundary id " ;
 id+=nsolid_linking_faces[0];
 solid_output_stream <<id<< "\n";


 solid_output_stream << "# the left bifurcation face : from boundary id "  
                     << id+1 << " until boundary id " ;
 id+=nsolid_linking_faces[1];
 solid_output_stream << id<< "\n" ;
 

 solid_output_stream << "# the right bifurcation : from boundary id "  
                     << id+1 << " until boundary id " ;
 id+=nsolid_linking_faces[2];
 solid_output_stream << id << "\n";
 

 solid_output_stream << "# the outer surface : from boundary id "  
                     << id+1 << " until boundary id " ;
 id+=nfluid_face[0];
 solid_output_stream << id << "\n";
   
 solid_output_stream.close();
} 



int main()
{
 bool do_multi_boundary_ids=true;

 char multi_boundary_ids_marker;

 double d;
 std::string input_filename;

 std::cout << "Please enter the file name without the file extension '.xda': ";
 std::cin >> input_filename;
 std::cout << "\n\nEnter the (uniform) wall thickness ";
 std::cin >> d;
 std::cout << "\n\nDo you want to create a separate ID for each planar facet\n"
           << "on the fluid-structure interaction boundary?"
           << "\n" <<"Enter y or n: ";
 std::cin >> multi_boundary_ids_marker;
 
 if(multi_boundary_ids_marker=='n') do_multi_boundary_ids=false;
 
 char xda_filename[100];
 char fluid_filename[100];
 char solid_filename[100];
 
 sprintf(xda_filename,"%s.xda", input_filename.c_str());
 sprintf(fluid_filename,"fluid_%s.poly", input_filename.c_str());
 sprintf(solid_filename,"solid_%s.poly", input_filename.c_str());

 create_fluid_and_solid_surface_mesh_from_fluid_xda_mesh(
  xda_filename, fluid_filename, solid_filename, d,do_multi_boundary_ids);
return 0;
}
