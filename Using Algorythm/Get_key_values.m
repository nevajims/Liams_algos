function [return_tag   ]= Get_key_values()
   
  
load("knn machine learning algorithm.mat","Knn_alg");
    %Opening files
    [file,path]=uigetfile();

    %Setting up mode map processor 
    plot_options  = load_structure_from_file('plot_options_.dat');
    
   %Processing grid data
   dummy =  open(strcat(path,file));
   grid_data=fn_get_grid_data(dummy.rail_tester , plot_options);
        
   %Reallocating variable
   mode_map=grid_data.data_stack;

   %Setting lower bound for distance
   distance=0.8;
   
   distance_index=1;
   while grid_data.distance_vector(distance_index)<distance
       distance_index=distance_index+1;
   end
   disp(grid_data.distance_vector(distance_index))
   

   %Peak finding algorithm (bit of a bodge right now
   while   mode_map(3,3,distance_index-2) > mode_map(3,3,distance_index-1)...
   ||mode_map(3,3,distance_index-1) > mode_map(3,3,distance_index)...
   || mode_map(3,3,distance_index+1) > mode_map(3,3,distance_index)...
   || mode_map(3,3,distance_index+2) > mode_map(3,3,distance_index+1)...
   || mode_map(3,3,distance_index+3) > mode_map(3,3,distance_index+2)...
                        distance_index=distance_index+1;
   end


   plot(grid_data.distance_vector,permute(mode_map(3,3,:),[3,2,1]))
   disp(grid_data.distance_vector(distance_index))
      
   crack_mode=mode_map(:,:,distance_index);
   return_array=[crack_mode(3,1),crack_mode(2,4),crack_mode(1,2),crack_mode(4,4)]./crack_mode(4,1);
   return_tag =predict(Knn_alg,return_array);
end
