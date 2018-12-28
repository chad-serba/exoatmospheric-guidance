function create_timehistory_plots( results, folder, prefix )
%CREATE_TIMEHISTORY_PLOTS Summary of this function goes here
%   Detailed explanation goes here

    if exist([folder, '/', prefix, '.ps'], 'file')
        delete([folder, '/', prefix, '.ps']);
    end
    
    if exist([folder, '/', prefix, '.pdf'], 'file')
        delete([folder, '/', prefix, '.pdf']);
    end
    
    %%%%%%%%%%%%%%%%%%%%%
    % time history of A %
    %%%%%%%%%%%%%%%%%%%%%
    figure
    for ii = 2:length(results) 
        subplot(3,1,1)
            hold on
            plot(results{ii}.timeVarying.guidanceUpdateTimes, results{ii}.timeVarying.A(:,1), 'k')
        subplot(3,1,2)
            hold on
            plot(results{ii}.timeVarying.guidanceUpdateTimes, results{ii}.timeVarying.A(:,2), 'k')
        subplot(3,1,3)
            hold on
            plot(results{ii}.timeVarying.guidanceUpdateTimes, results{ii}.timeVarying.A(:,3), 'k')
    end
    subplot(3,1,1)
        plot(results{1}.timeVarying.guidanceUpdateTimes, results{1}.timeVarying.A(:,1), 'b', 'LineWidth', 1.5)
        ylabel('A(1)')
        xlabel('Time in Burn (sec)')
        grid on
    subplot(3,1,2)
        plot(results{1}.timeVarying.guidanceUpdateTimes, results{1}.timeVarying.A(:,2), 'b', 'LineWidth', 1.5)
        ylabel('A(2)')
        xlabel('Time in Burn (sec)')
        grid on
    subplot(3,1,3)
        nom = plot(results{1}.timeVarying.guidanceUpdateTimes, results{1}.timeVarying.A(:,3), 'b', 'LineWidth', 1.5);
        ylabel('A(3)')
        xlabel('Time in Burn (sec)')
        grid on
        legend(nom, 'Nominal', 'location', 'best')
    print([folder, '/', prefix], '-dpsc', '-append')
        
    %%%%%%%%%%%%%%%%%%%%%
    % time history of B %
    %%%%%%%%%%%%%%%%%%%%%
    figure
    for ii = 2:length(results) 
        subplot(3,1,1)
            hold on
            plot(results{ii}.timeVarying.guidanceUpdateTimes, results{ii}.timeVarying.B(:,1), 'k')
        subplot(3,1,2)
            hold on
            plot(results{ii}.timeVarying.guidanceUpdateTimes, results{ii}.timeVarying.B(:,2), 'k')
        subplot(3,1,3)
            hold on
            plot(results{ii}.timeVarying.guidanceUpdateTimes, results{ii}.timeVarying.B(:,3), 'k')
    end
    subplot(3,1,1)
        plot(results{1}.timeVarying.guidanceUpdateTimes, results{1}.timeVarying.B(:,1), 'b', 'LineWidth', 1.5)
        ylabel('B(1)')
        xlabel('Time in Burn (sec)')
        grid on
    subplot(3,1,2)
        plot(results{1}.timeVarying.guidanceUpdateTimes, results{1}.timeVarying.B(:,2), 'b', 'LineWidth', 1.5)
        ylabel('B(2)')
        xlabel('Time in Burn (sec)')
        grid on
    subplot(3,1,3)
        nom = plot(results{1}.timeVarying.guidanceUpdateTimes, results{1}.timeVarying.B(:,3), 'b', 'LineWidth', 1.5);
        ylabel('B(3)')
        xlabel('Time in Burn (sec)')
        grid on
        legend(nom, 'Nominal', 'location', 'best')
    print([folder, '/', prefix], '-dpsc', '-append')
        
    %%%%%%%%%%%%%%%%%%%%%%
    % time history of tf %
    %%%%%%%%%%%%%%%%%%%%%%
    figure
    hold on
    for ii = 2:length(results) 
        plot(results{ii}.timeVarying.guidanceUpdateTimes, results{ii}.timeVarying.tf, 'k')
    end
    nom = plot(results{1}.timeVarying.guidanceUpdateTimes, results{1}.timeVarying.tf, 'b', 'LineWidth', 1.5);
    ylabel('tf')
    xlabel('Time in Burn (sec)')
    grid on
    legend(nom, 'Nominal', 'location', 'best')
    print([folder, '/', prefix], '-dpsc', '-append')
    
    %%%%%%%%%%%%%%%%%%%%%%
    % time history of E0 %
    %%%%%%%%%%%%%%%%%%%%%%
    figure
    hold on
    for ii = 2:length(results) 
        plot(results{ii}.timeVarying.guidanceUpdateTimes, results{ii}.timeVarying.E0, 'k')
    end
    nom = plot(results{1}.timeVarying.guidanceUpdateTimes, results{1}.timeVarying.E0, 'b', 'LineWidth', 1.5);
    ylabel('E0')
    xlabel('Time in Burn (sec)')
    grid on
    legend(nom, 'Nominal', 'location', 'best')
    print([folder, '/', prefix], '-dpsc', '-append')
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % time history of eci thrust direction %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    figure
    for ii = 2:length(results) 
        subplot(3,1,1)
            hold on
            plot(results{ii}.timeVarying.state(1:end-1,end), results{ii}.timeVarying.eciThrustDirection(:,1), 'k')
        subplot(3,1,2)
            hold on
            plot(results{ii}.timeVarying.state(1:end-1,end), results{ii}.timeVarying.eciThrustDirection(:,2), 'k')
        subplot(3,1,3)
            hold on
            plot(results{ii}.timeVarying.state(1:end-1,end), results{ii}.timeVarying.eciThrustDirection(:,3), 'k')
    end
    subplot(3,1,1)
        plot(results{1}.timeVarying.state(1:end-1,end), results{1}.timeVarying.eciThrustDirection(:,1), 'b', 'LineWidth', 1.5)
        ylabel('X thrust Direction')
        xlabel('Time in Burn (sec)')
        grid on
    subplot(3,1,2)
        plot(results{1}.timeVarying.state(1:end-1,end), results{1}.timeVarying.eciThrustDirection(:,2), 'b', 'LineWidth', 1.5)
        ylabel('Y thrust Direction')
        xlabel('Time in Burn (sec)')
        grid on
    subplot(3,1,3)
        nom = plot(results{1}.timeVarying.state(1:end-1,end), results{1}.timeVarying.eciThrustDirection(:,3), 'b', 'LineWidth', 1.5);
        ylabel('Z thrust Direction')
        xlabel('Time in Burn (sec)')
        grid on
        legend(nom, 'Nominal', 'location', 'best')
    print([folder, '/', prefix], '-dpsc', '-append')
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % time history of position %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    figure
    for ii = 2:length(results) 
        subplot(3,1,1)
            hold on
            plot(results{ii}.timeVarying.state(:,end), results{ii}.timeVarying.state(:,1)/1000, 'k')
        subplot(3,1,2)
            hold on
            plot(results{ii}.timeVarying.state(:,end), results{ii}.timeVarying.state(:,2)/1000, 'k')
        subplot(3,1,3)
            hold on
            plot(results{ii}.timeVarying.state(:,end), results{ii}.timeVarying.state(:,3)/1000, 'k')
    end
    subplot(3,1,1)
        plot(results{1}.timeVarying.state(:,end), results{1}.timeVarying.state(:,1)/1000, 'b', 'LineWidth', 1.5)
        ylabel('X Position (km)')
        xlabel('Time in Burn (sec)')
        grid on
    subplot(3,1,2)
        plot(results{1}.timeVarying.state(:,end), results{1}.timeVarying.state(:,2)/1000, 'b', 'LineWidth', 1.5)
        ylabel('Y Position (km)')
        xlabel('Time in Burn (sec)')
        grid on
    subplot(3,1,3)
        nom = plot(results{1}.timeVarying.state(:,end), results{1}.timeVarying.state(:,3)/1000, 'b', 'LineWidth', 1.5);
        ylabel('Z Position (km)')
        xlabel('Time in Burn (sec)')
        grid on
        legend(nom, 'Nominal', 'location', 'best')
    print([folder, '/', prefix], '-dpsc', '-append')
        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % time history of velocity %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    figure
    for ii = 2:length(results) 
        subplot(3,1,1)
            hold on
            plot(results{ii}.timeVarying.state(:,end), results{ii}.timeVarying.state(:,4)/1000, 'k')
        subplot(3,1,2)
            hold on
            plot(results{ii}.timeVarying.state(:,end), results{ii}.timeVarying.state(:,5)/1000, 'k')
        subplot(3,1,3)
            hold on
            plot(results{ii}.timeVarying.state(:,end), results{ii}.timeVarying.state(:,6)/1000, 'k')
    end
    subplot(3,1,1)
        plot(results{1}.timeVarying.state(:,end), results{1}.timeVarying.state(:,4)/1000, 'b', 'LineWidth', 1.5)
        ylabel('X Velocity (km/s)')
        xlabel('Time in Burn (sec)')
        grid on
    subplot(3,1,2)
        plot(results{1}.timeVarying.state(:,end), results{1}.timeVarying.state(:,5)/1000, 'b', 'LineWidth', 1.5)
        ylabel('Y Velocity (km/s)')
        xlabel('Time in Burn (sec)')
        grid on
    subplot(3,1,3)
        nom = plot(results{1}.timeVarying.state(:,end), results{1}.timeVarying.state(:,6)/1000, 'b', 'LineWidth', 1.5);
        ylabel('Z Velocity (km/s)')
        xlabel('Time in Burn (sec)')
        grid on
        legend(nom, 'Nominal', 'location', 'best')
    print([folder, '/', prefix], '-dpsc', '-append')
        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % time history of vehicle mass %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    figure
    hold on
    for ii = 2:length(results) 
        plot(results{ii}.timeVarying.state(:,end), results{ii}.timeVarying.state(:,7), 'k')
    end
    nom = plot(results{1}.timeVarying.state(:,end), results{1}.timeVarying.state(:,7), 'b', 'LineWidth', 1.5);
    ylabel('Vehicle Mass (kg)')
    xlabel('Time in Burn (sec)')
    grid on
    legend(nom, 'Nominal', 'location', 'best')
    print([folder, '/', prefix], '-dpsc', '-append')

end

