function [] = create_draw_hist( draws, folder, prefix )
%CREATE_DRAW_HIST Make histograms for the draws within a structure

    if exist([folder, '/', prefix, '.ps'], 'file')
        delete([folder, '/', prefix, '.ps']);
    end
    
    if exist([folder, '/', prefix, '.pdf'], 'file')
        delete([folder, '/', prefix, '.pdf']);
    end
    
    nbin = 25;
    
    % get the number of draw categories and loop through 
    categories = fields(draws);
    for ii = 1:numel(categories)
        
        % get the number of parameters in this category and loop through
        parameters = fields(draws.(categories{ii}));
        for jj = 1:numel(parameters)
            
            % pull out stats on the draws to add to plot
            sigma = std(draws.(categories{ii}).(parameters{jj}).draws(2:end));
            mean_ = mean(draws.(categories{ii}).(parameters{jj}).draws(2:end));
            max_ = max(draws.(categories{ii}).(parameters{jj}).draws(2:end));
            min_ = min(draws.(categories{ii}).(parameters{jj}).draws(2:end));
            
            figure
            hold on
            fith = histfit(draws.(categories{ii}).(parameters{jj}).draws(2:end), nbin);
            ax = axis;
            nomh = plot([draws.(categories{ii}).(parameters{jj}).draws(1), draws.(categories{ii}).(parameters{jj}).draws(1)], ...
                       [ax(3) ax(4)], '-k', 'LineWidth', 1.25);
            meanh = plot([mean_ mean_], [ax(3) ax(4)], '--k', 'LineWidth', 1.25);
            sigh = plot([mean_+3*sigma mean_+3*sigma], [ax(3) ax(4)], '-.k', 'LineWidth', 1.25);
            sigh = plot([mean_-3*sigma mean_-3*sigma], [ax(3) ax(4)], '-.k', 'LineWidth', 1.25);
            maxh = plot([max_ max_], [ax(3) ax(4)], ':k', 'LineWidth', 1.25);
            minh = plot([min_ min_], [ax(3) ax(4)], ':k', 'LineWidth', 1.25);
            parameterString = insertBefore(parameters{jj}, '_', '\');
%             title(sprintf('Histogram of %s', parameterString))
            grid on
            ylabel('Count')
            xlabel(sprintf('%s (%s)', parameterString, draws.(categories{ii}).(parameters{jj}).units))
            legend([fith(2) nomh, meanh, sigh maxh], 'Normal Fit', 'Nominal', 'Mean', 'Mean\pm3\sigma', 'Max / Min')
            print([folder, '/', prefix], '-dpsc', '-append')
            
        end
        
    end
    
%     ps2pdf(
    
    
end

