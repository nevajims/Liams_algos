function knn_alg=create_knn_alg()    
    [modes,tags]=Mode_maps_of_nmm_crack("No_crack",0);
    
    [modes,tags]=add_data("Crack",1,modes,tags);
    [modes,tags]=add_data("Crack",2,modes,tags);
    [modes,tags]=add_data("Crack",3,modes,tags);
    [modes,tags]=add_data("Crack",4,modes,tags);
    [modes,tags]=add_data("Crack",5,modes,tags);
    
    Three_one=modes(:,1);
    Two_four=modes(:,2);
    One_two=modes(:,3);
    Four_four=modes(:,4);
    Data_table=table(Three_one,Two_four,One_two,Four_four);
    
    knn_alg = fitcknn(Data_table,tags,"Standardize",true,'NumNeighbors',3,'Distance','cityblock');
   
end
function [mode_data,tags]=add_data(new_tag,new_crack_size,mode_data,tags)
    [new_mode_data,new_tags]=Mode_maps_of_nmm_crack(new_tag,new_crack_size);
    mode_data=[mode_data;new_mode_data];
    tags=[tags;new_tags];
end

