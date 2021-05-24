function displaydisplacement(mymodel,mymodel2)

    figure()
    gplot(mymodel.connectivity,mymodel.position)
    hold on
    gplot(mymodel.connectivity,mymodel2.position)
    axis equal
    
    
    
    figure()
    quiver(mymodel.position(:,1),mymodel.position(:,2),mymodel2.position(:,1)-mymodel.position(:,1),mymodel2.position(:,2)-mymodel.position(:,2)) %maybe?

end