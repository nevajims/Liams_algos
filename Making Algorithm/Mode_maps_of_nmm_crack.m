function [value_list,tag_list,file_names]=Mode_maps_of_nmm_crack(tag,crack_size)
    %Opening files

    E:\Liam's code\Data
    
    path="\Processed_data\Liam's data\Crack";
    
    unfiltered_files = dir(strcat(pwd,path,'\*.mat'));
   

    unfiltered_files={unfiltered_files.name};
    files=[];
  
    for index=1:length(unfiltered_files)
        file=unfiltered_files{index};
        if file(2)==num2str(crack_size)
           files=[files,{file}];
        end
    end
    numfiles=length(files);
    tag_list=repmat(string(tag),length(files),1);
    value_list=zeros(numfiles,4);
    %Setting up mode map processor 
    plot_options  = load_structure_from_file('plot_options_.dat');
    for index=1:numfiles
        %Processing grid data
        dummy =  open(strcat(pwd,path,'\',files{index}));
        grid_data=fn_get_grid_data(dummy.rail_tester , plot_options);
        
        %Reallocating variable
        mode_maps=grid_data.data_stack;

        %Setting lower bound for distance
        distance_index=690;

        %Peak finding algorythm (bit of a bodge right now)
        while   mode_maps(3,3,distance_index-2) > mode_maps(3,3,distance_index-1)...
                ||mode_maps(3,3,distance_index-1) > mode_maps(3,3,distance_index)...
                || mode_maps(3,3,distance_index+1) > mode_maps(3,3,distance_index)...
                || mode_maps(3,3,distance_index+2) > mode_maps(3,3,distance_index+1)...
                || mode_maps(3,3,distance_index+3) > mode_maps(3,3,distance_index+2)...
            
            distance_index=distance_index+1;
        end
        %{
        valuelist(:,:,index)=mode_maps(:,:,distance_index)./mode_maps(4,1,distance_index);
        mode_maps=valuelist;
         %}
        crack_mode=mode_maps(:,:,distance_index);
        value_list(index,:)=[crack_mode(3,1),crack_mode(2,4),crack_mode(1,2),crack_mode(4,4)]./crack_mode(4,1);
        file_names=files;
       
        %{
        struct.mean_matrix=sum(valuelist,3)./numfiles;
        struct.std_matrix=zeros(4,4);
        for j=1:numfiles    
            struct.std_matrix=struct.std_matrix+((valuelist(:,:,j)-struct.mean_matrix).^2);
        end
        struct.std_matrix=(struct.std_matrix./struct.numfiles).^0.5;
        %}
    end
    disp(strcat("Finished processing cracks length ",num2str(crack_size)))
end
